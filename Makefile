
YUM:=$(shell which yum)
APT:=$(shell which apt-get)
# ubuntu uses rename.ul
RENAME=$(shell which rename.ul || which rename)
HADOOP:=$(shell which hadoop)
MVN:=unset M2_HOME; ../dist/maven/bin/mvn
MVN2:=unset M2_HOME; ../../dist/maven/bin/mvn
TOOLS=git gcc #cmake pdsh
TEZ_VERSION=0.10.1-SNAPSHOT
TEZ_BRANCH=master
HIVE_VERSION=4.0.0-SNAPSHOT
HIVE_BRANCH=master
ORC_VERSION=1.5.9
ORC_BRANCH=master
GIT_BASE=https://github.com/apache/
GIT_SUFFIX=
GUAVA_VERSION=19.0
MAVEN_VERSION=3.2.5
SLF4J_LOG4J12_VERSION=1.7.30
HDFS=$(shell id hdfs 2> /dev/null)
# try to build against local hadoop always
ifneq ($(HADOOP),)
  HADOOP_VERSION=$(shell hadoop version | grep "^Hadoop" | cut -f 2 -d' ')
else
  HADOOP_VERSION=2.8.0-SNAPSHOT
endif
APP_PATH:=$(shell echo /user/$$USER/apps/llap-`date +%Y-%b-%d`/)
HISTORY_PATH:=$(shell echo /user/$$USER/tez-history/build=`date +%Y-%b-%d`/)
INSTALL_ROOT:=$(shell echo $$PWD/dist/)
HIVE_CONF_DIR:=$(shell test -d /etc/hive/conf/conf.server && echo /etc/hive/conf/conf.server || echo /etc/hive/conf/)
HIVE_CONF_SUDO:=$(shell test -r $(HIVE_CONF_DIR)/hive-site.xml || echo sudo)
OFFLINE=false
REBASE=false
CLEAN=clean
MINIMIZE=false
METASTORE=false
LOGLEVEL=WARN


ALL_NODES=$(shell yarn node -list 2> /dev/null | grep RUNNING | cut -f 1 -d: | tr "\n" ,) 
NUM_NODES=$(shell yarn node -list 2> /dev/null | grep RUNNING | wc -l)
FIRST_HOST=$(shell yarn node -list 2> /dev/null | grep RUNNING | head -n 1 | sed 's/^ *//' | cut -f 1 -d ' ')
NODE_STATUS=$(shell yarn node -status $(FIRST_HOST) 2> /dev/null)
NODE_MEM=$(shell echo '$(NODE_STATUS)' | grep "Memory-Capacity" | sed "s/.*Memory-Capacity : \([0-9]*\).*/\1/g" ) 
NODE_CORES=$(shell echo '$(NODE_STATUS)' | grep "CPU-Capacity" | sed "s/.*CPU-Capacity : \([0-9]*\).*/\1/g" ) 

-include local.mk

#ifneq ($(HDFS),)
#	AS_HDFS=sudo -u hdfs env PATH=$$PATH JAVA_HOME=$$JAVA_HOME HADOOP_HOME=$$HADOOP_HOME HADOOP_CONF_DIR=$$HADOOP_CONF_DIR bash
#else
	AS_HDFS=bash
#endif

git: 
ifneq ($(YUM),)
	which $(TOOLS) || yum -y install git-core \
	gcc gcc-c++ \
	pdsh \
	cmake \
	zlib-devel openssl-devel 
endif
ifneq ($(APT),)
	which $(TOOLS) || apt-get install -y git gcc g++ python man cmake zlib1g-dev libssl-dev 
endif

maven: 
	$(OFFLINE) || wget -c https://downloads.apache.org/maven/maven-3/$(MAVEN_VERSION)/binaries/apache-maven-$(MAVEN_VERSION)-bin.tar.gz
	-- mkdir -p $(INSTALL_ROOT)/maven/
	tar -C $(INSTALL_ROOT)/maven/ --strip-components=1 -xzvf apache-maven-$(MAVEN_VERSION)-bin.tar.gz
	-- sed -i~ -e "/<profiles>/r vendor-repos.xml" $(INSTALL_ROOT)/maven/conf/settings.xml  

ant: 
	$(OFFLINE) || wget -c https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.1-bin.tar.gz
	-- mkdir -p $(INSTALL_ROOT)/ant/
	tar -C $(INSTALL_ROOT)/ant/ --strip-components=1 -xzvf apache-ant-1.9.1-bin.tar.gz
	-- yum -y remove ant

protobuf: git 
	$(OFFLINE) || wget -c https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz
	tar -xvf protobuf-2.5.0.tar.gz
	test -f $(INSTALL_ROOT)/protoc/bin/protoc || \
	(cd protobuf-2.5.0; \
	./configure --prefix=$(INSTALL_ROOT)/protoc/; \
	make -j4; \
	make install -k)

clean-protobuf:
	rm -rf protobuf-2.5.0/

mysql: 
	$(OFFLINE) || wget -c https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.29/mysql-connector-java-5.1.29.jar

tez: git maven protobuf
	test -d tez || git clone --branch $(TEZ_BRANCH) $(GIT_BASE)/tez$(GIT_SUFFIX) tez
	sed -i~ \
	    -e "s@<hadoop.version>.*</hadoop.version>@<hadoop.version>$(HADOOP_VERSION)</hadoop.version>@" \
	    -e "s@<guava.version>.*</guava.version>@<guava.version>$(GUAVA_VERSION)</guava.version>@" \
	            tez/pom.xml
	export PATH=$(INSTALL_ROOT)/protoc/bin:$(INSTALL_ROOT)/maven/bin/:$$PATH; \
	cd tez/; . /etc/profile; \
	$(MVN) $(CLEAN) package install -pl '!tez-ui' -DskipTests -Dhadoop.version=$(HADOOP_VERSION) -Paws -Pazure -Phadoop28 $$($(OFFLINE) && echo "-o");
	# for hadoop version < 2.4.0, use -P\!hadoop24 -P\!hadoop26

clean-tez:
	rm -rf tez

hive: tez-dist.tar.gz 
	test -d hive || git clone --branch $(HIVE_BRANCH) $(GIT_BASE)/hive$(GIT_SUFFIX)
	cd hive; if $(REBASE); then (git stash; git clean -f -d; git pull --rebase;); fi
	cd hive; sed -i~ "s@<tez.version>.*</tez.version>@<tez.version>$(TEZ_VERSION)</tez.version>@" pom.xml; \
	sed -i~ "s@<orc.version>.*</orc.version>@<orc.version>$(ORC_VERSION)</orc.version>@" pom.xml
	# this was a stupid change
	if test "$(TEZ_VERSION)" != "0.8.2"; then \
	  (cd hive; patch -R -N -p0 -f -i ../hive-tez-0.8.patch --dry-run 2> /dev/null || patch -N -p0 -f -i ../hive-tez-0.8.patch) \
	fi
	export PATH=$(INSTALL_ROOT)/protoc/bin:$(INSTALL_ROOT)/maven/bin/:$(INSTALL_ROOT)/ant/bin:$$PATH; \
	cd hive/; . /etc/profile; \
	$(MVN) $(CLEAN) dependency:tree package -e -Denforcer.skip=true -DskipTests=true -Pdir -Pdist -Phadoop-2 -Dhadoop.version=$(HADOOP_VERSION) -Dhadoop-0.23.version=$(HADOOP_VERSION) -Dmaven.javadoc.skip=true -T 1C -Dbuild.profile=nohcat -Dpackaging.minimizeJar=$(MINIMIZE) $$($(OFFLINE) && echo "-o"); 

clean-hive:
	rm -rf hive

orc-java: git maven protobuf
	test -d orc || git clone --branch $(ORC_BRANCH) $(GIT_BASE)/orc$(GIT_SUFFIX) orc
	export PATH=$(INSTALL_ROOT)/protoc/bin:$(INSTALL_ROOT)/maven/bin/:$$PATH; \
	cd orc/java; . /etc/profile; \
	$(MVN2) $(CLEAN) install -DskipTests $$($(OFFLINE) && echo "-o");

clean-orc:
	rm -rf orc

dist-tez: tez 
	cp tez/tez-dist/target/tez-$(TEZ_VERSION).tar.gz tez-dist.tar.gz

dist-hive: mysql hive
	cp -t hive/packaging/target/apache-hive*/apache-hive*/lib/ mysql*.jar
	tar --exclude='hadoop-*.jar' --exclude='protobuf-*.jar' -C hive/packaging/target/apache-hive*/apache-hive*/ -czvf hive-dist.tar.gz .

tez-dist.tar.gz:
	@echo "run make dist to get tez-dist.tar.gz"

hive-dist.tar.gz:
	@echo "run make dist to get tez-dist.tar.gz"

dist: dist-tez dist-hive

tez-hiveserver-on:
	@cp scripts/startHiveserver2.sh.on /tmp/startHiveserver2.sh
	@echo "HiveServer2 will now run jobs using Tez."
	@echo "Reboot the Sandbox for changes to take effect."

tez-hiveserver-off:
	@cp scripts/startHiveserver2.sh.off /tmp/startHiveserver2.sh
	@echo "HiveServer2 will now run jobs using Map-Reduce."
	@echo "Reboot the Sandbox for changes to take effect."

install: tez-dist.tar.gz hive-dist.tar.gz
	rm -rf $(INSTALL_ROOT)/tez
	mkdir -p $(INSTALL_ROOT)/tez/conf
	tar -C $(INSTALL_ROOT)/tez/ -xzvf tez-dist.tar.gz
	cp -v tez-site.xml.frag $(INSTALL_ROOT)/tez/conf/tez-site.xml
	sed -i~ "s@/apps@$(APP_PATH)tez/tez-dist.tar.gz@g" $(INSTALL_ROOT)/tez/conf/tez-site.xml
	sed -i~ "s@/tez-history/@$(HISTORY_PATH)@g" $(INSTALL_ROOT)/tez/conf/tez-site.xml
	$(AS_HDFS) -c "hadoop fs -rm -R -f $(APP_PATH)/tez/"
	$(AS_HDFS) -c "hadoop fs -mkdir -p $(APP_PATH)/tez/"
	$(AS_HDFS) -c "hadoop fs -copyFromLocal -f tez-dist.tar.gz $(APP_PATH)/tez/"
	rm -rf $(INSTALL_ROOT)/hive
	mkdir -p $(INSTALL_ROOT)/hive
	tar -C $(INSTALL_ROOT)/hive -xzvf hive-dist.tar.gz
	(test -d $(HIVE_CONF_DIR) && $(HIVE_CONF_SUDO) rsync -avP $(HIVE_CONF_DIR)/ $(INSTALL_ROOT)/hive/conf/ && $(HIVE_CONF_SUDO) chown -Rv $$USER  $(INSTALL_ROOT)/hive/conf/) \
	    || (cp hive-site.xml.default $(INSTALL_ROOT)/hive/conf/hive-site.xml && sed -i~ -e "s@HOSTNAME@$$(hostname)@" -e "s@USER@$$USER@" $(INSTALL_ROOT)/hive/conf/hive-site.xml)
	echo "export HADOOP_CLASSPATH=$(INSTALL_ROOT)/tez/*:$(INSTALL_ROOT)/tez/lib/*:$(INSTALL_ROOT)/tez/conf/:$$HADOOP_CLASSPATH" >> $(INSTALL_ROOT)/hive/bin/hive-config.sh
	echo "export HADOOP_USER_CLASSPATH_FIRST=true" >> $(INSTALL_ROOT)/hive/bin/hive-config.sh
	echo "export IS_HIVE2=true" >> $(INSTALL_ROOT)/hive/bin/hive-config.sh
	echo "export TEZ_CONF_DIR=$(INSTALL_ROOT)/tez/conf/" >> $(INSTALL_ROOT)/hive/bin/hive-config.sh
	test -f $(INSTALL_ROOT)/tez/lib/slf4j-log4j12-$(SLF4J_LOG4J12_VERSION).jar && rm -vf $(INSTALL_ROOT)/tez/lib/slf4j-log4j12-$(SLF4J_LOG4J12_VERSION).jar
	(test -f $(INSTALL_ROOT)/hive/conf/hive-env.sh && \
	sed -i~ \
	-e "s@export HIVE_CONF_DIR=.*@export HIVE_CONF_DIR=$(INSTALL_ROOT)/hive/conf/@" \
	-e "s/-Xms10m//" \
	-e "s@/usr/hdp/current/hive-webhcat/share/hcatalog/hive-hcatalog-core.jar@@" \
	   $(INSTALL_ROOT)/hive/conf/hive-env.sh) \
		|| echo -e "export HIVE_CONF_DIR=$(INSTALL_ROOT)/hive/conf/\nexport HIVE_SKIP_SPARK_ASSEMBLY=true" > $(INSTALL_ROOT)/hive/conf/hive-env.sh
	sed -e "s@hdfs:///user/hive/@$$\{fs.default.name\}$(APP_PATH)/hive/@" \
	-e "s/__NODES__/$(ALL_NODES)/g" \
	-e "s/__NODE_MEM__/"$$(($(NODE_MEM)/2))"/g" \
	-e "s/>__NODE_CORES__</>"$$(($(NODE_CORES)/2))"</g" \
	-e "s@USER@$$USER@" hive-site.xml.frag > hive-site.xml.local
	sed -i~ \
	-e "s/org.apache.hadoop.hive.ql.security.ProxyUserAuthenticator//" \
	-e "s/org.apache.atlas.hive.hook.HiveHook//" \
	-e "s/org.apache.hadoop.hive.ql.security.authorization.AuthorizationPreEventListener//" \
	-e "s@jceks://file/usr/hdp/current/hive-server2/conf/hive-site.jceks@jceks://file/$(INSTALL_ROOT)/hive/conf/hive-site.jceks@" \
	-e "s@/tmp/hive/operation_logs@/tmp/$$USER/operation_logs@" \
	$$($(METASTORE) || echo '-e s@thrift://[^<]*@@') \
	-e "/<.configuration>/r hive-site.xml.local" \
	-e "x;" \
	$(INSTALL_ROOT)/hive/conf/hive-site.xml    
	if [ "$$(ls $(INSTALL_ROOT)/hive/conf/hiveserver2-site.xml)" != "" ]; then \
	    sed -i~ \
		-e "/<.configuration>/r hiveserver2-site.xml.frag" \
		-e "x;" \
		$(INSTALL_ROOT)/hive/conf/hiveserver2-site.xml ;\
	fi
	sed -i '/./,$$!d' $(INSTALL_ROOT)/hive/conf/hive-site.xml #remove leading empty lines
	if [ "$$(ls $(INSTALL_ROOT)/hive/conf/hiveserver2-site.xml)" != "" ]; then\
	    sed -i~ "s/org.apache.ranger.authorization.hive.authorizer.RangerHiveAuthorizerFactory//" $(INSTALL_ROOT)/hive/conf/hiveserver2-site.xml; \
	fi 
	if [ "$$(ls $(INSTALL_ROOT)/hive/conf/hivemetastore-site.xml)" != "" ]; then\
		sed -i~ "s/JSON_FILE,//" $(INSTALL_ROOT)/hive/conf/hivemetastore-site.xml; \
	fi 
	if [ "$$(ls $(INSTALL_ROOT)/hive/conf/*log4j.properties.template)" != "" ]; then\
		sed -i~ "s/INFO/$(LOGLEVEL)/" $(INSTALL_ROOT)/hive/conf/*log4j.properties.template; \
		$(RENAME) .properties.template .properties $(INSTALL_ROOT)/hive/conf/*log4j.properties.template; \
	fi
	if [ "$$(ls $(INSTALL_ROOT)/hive/conf/*log4j2.properties.template)" != "" ]; then\
		sed -i~ "s/INFO/$(LOGLEVEL)/" $(INSTALL_ROOT)/hive/conf/*log4j2.properties.template; \
		$(RENAME) .properties.template .properties $(INSTALL_ROOT)/hive/conf/*log4j2.properties.template; \
	fi
	sed -i~ -e "s/address=8000/address=$$(( $$UID - 1000 + 8000 ))/"  $(INSTALL_ROOT)/hive/bin/ext/debug.sh 
	$(AS_HDFS) -c "hadoop fs -rm -f $(APP_PATH)/hive/hive-exec-$(HIVE_VERSION).jar"
	$(AS_HDFS) -c "hadoop fs -mkdir -p $(APP_PATH)/hive/"
	$(AS_HDFS) -c "hadoop fs -copyFromLocal -f $(INSTALL_ROOT)/hive/lib/hive-exec-$(HIVE_VERSION).jar $(APP_PATH)/hive/"
	$(AS_HDFS) -c "hadoop fs -copyFromLocal -f $(INSTALL_ROOT)/hive/lib/hive-llap-server-$(HIVE_VERSION).jar $(APP_PATH)/hive/"
	$(AS_HDFS) -c "hadoop fs -chmod -R a+r $(APP_PATH)/"

run: 
	./dist/hive/bin/hive --service llap --instances $(NUM_NODES)

clean-dist:
	rm -rf $(INSTALL_ROOT)

clean-all: clean clean-tez clean-hive clean-orc clean-protobuf

clean: clean-dist

.PHONY: hive tez protobuf ant maven
