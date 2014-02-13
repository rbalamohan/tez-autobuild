
YUM=$(shell which yum)
APT=$(shell which apt-get)
TEZ_VERSION=0.3.0
TEZ_BRANCH=master
HDFS=$(shell id hdfs 2> /dev/null)
HADOOP_VERSION=2.2.0
HADOOP_HOME=/opt/hadoop

ifneq ($(HDFS),)
	AS_HDFS=su hdfs bash
else
	AS_HDFS=bash
endif

git: 
ifneq ($(YUM),)
	yum -y install git-core \
	gcc gcc-c++ \
	pdsh \
	cmake \
	zlib-devel openssl-devel \
	mysql-connector-java
endif
ifneq ($(APT),)
	apt-get install -y git gcc g++ python man cmake zlib1g-dev libssl-dev libmysql-java 
endif

maven: 
	wget -c http://www.us.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
	-- mkdir /opt/maven/
	tar -C /opt/maven/ --strip-components=1 -xzvf apache-maven-3.0.5-bin.tar.gz

ant: 
	wget -c http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.1-bin.tar.gz
	-- mkdir /opt/ant/
	tar -C /opt/ant/ --strip-components=1 -xzvf apache-ant-1.9.1-bin.tar.gz
	-- yum -y remove ant

protobuf: git 
	wget -c http://protobuf.googlecode.com/files/protobuf-2.5.0.tar.bz2
	tar -xvf protobuf-2.5.0.tar.bz2
	test -f /opt/protoc/bin/protoc || \
	(cd protobuf-2.5.0; \
	./configure --prefix=/opt/protoc/; \
	make -j4; \
	make install -k)

tez: git maven protobuf
	test -d tez || git clone --branch $(TEZ_BRANCH) https://git-wip-us.apache.org/repos/asf/incubator-tez.git tez
	export PATH=/opt/protoc/bin:$$PATH:/opt/maven/bin/; \
	cd tez/; . /etc/profile; \
	mvn package install -Pdist -DskipTests -Dhadoop.version=$(HADOOP_VERSION);


tez-maven-register: tez
	/opt/maven/bin/mvn org.apache.maven.plugins:maven-install-plugin:2.5.1:install-file -Dfile=./tez/tez-api/target/tez-api-$(TEZ_VERSION)-incubating-SNAPSHOT.jar -DgroupId=org.apache.tez -DartifactId=tez-api -Dversion=$(TEZ_VERSION) -Dpackaging=jar -DlocalRepositoryPath=/root/.m2/repository 
	/opt/maven/bin/mvn org.apache.maven.plugins:maven-install-plugin:2.5.1:install-file -Dfile=./tez/tez-mapreduce/target/tez-mapreduce-$(TEZ_VERSION)-incubating-SNAPSHOT.jar -DgroupId=org.apache.tez -DartifactId=tez-mapreduce -Dversion=$(TEZ_VERSION) -Dpackaging=jar -DlocalRepositoryPath=/root/.m2/repository 
	/opt/maven/bin/mvn org.apache.maven.plugins:maven-install-plugin:2.5.1:install-file -Dfile=./tez/tez-runtime-library/target/tez-runtime-library-$(TEZ_VERSION)-incubating-SNAPSHOT.jar -DgroupId=org.apache.tez -DartifactId=tez-runtime-library -Dversion=$(TEZ_VERSION) -Dpackaging=jar -DlocalRepositoryPath=/root/.m2/repository 
	/opt/maven/bin/mvn org.apache.maven.plugins:maven-install-plugin:2.5.1:install-file -Dfile=./tez/tez-tests/target/tez-tests-$(TEZ_VERSION)-incubating-SNAPSHOT-tests.jar -DgroupId=org.apache.tez -DartifactId=tez-tests -Dversion=$(TEZ_VERSION) -Dclassifier=tests -Dpackaging=test-jar -DlocalRepositoryPath=/root/.m2/repository 
	/opt/maven/bin/mvn org.apache.maven.plugins:maven-install-plugin:2.5.1:install-file -Dfile=./tez/tez-common/target/tez-common-$(TEZ_VERSION)-incubating-SNAPSHOT.jar -DgroupId=org.apache.tez -DartifactId=tez-common -Dversion=$(TEZ_VERSION) -Dpackaging=jar -DlocalRepositoryPath=/root/.m2/repository


hive: tez-dist.tar.gz 
	test -d hive || git clone --branch tez https://github.com/apache/hive
	cd hive; \
	cp pom.xml.patch ./hive; \
	patch --forward -p0 < pom.xml.patch ;
	cd hive; sed -i~ "s@<tez.version>.*</tez.version>@<tez.version>$(TEZ_VERSION)</tez.version>@" pom.xml
	export PATH=/opt/protoc/bin:$$PATH:/opt/maven/bin/:/opt/ant/bin; \
	cd hive/; . /etc/profile; \
	mvn package -DskipTests=true -Pdist -Phadoop-2 -Dhadoop-0.23.version=$(HADOOP_VERSION) -Dbuild.profile=nohcat;

dist-tez: tez-maven-register
	tar -C tez/tez-dist/target/tez-*full/tez-*full -czvf tez-dist.tar.gz .

dist-hive: hive
	tar -C hive/packaging/target/apache-hive*/apache-hive*/ -czvf hive-dist.tar.gz .

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
	rm -rf /opt/tez
	mkdir -p /opt/tez/conf
	tar -C /opt/tez/ -xzvf tez-dist.tar.gz
	cp -v tez-site.xml /opt/tez/conf/
	chmod 755 -R /opt/
	$(AS_HDFS) -c "$(HADOOP_HOME)/bin/hadoop fs -rm -R -f /apps/tez/"
	$(AS_HDFS) -c "$(HADOOP_HOME)/bin/hadoop fs -mkdir -p /apps/tez/"
	$(AS_HDFS) -c "$(HADOOP_HOME)/bin/hadoop fs -copyFromLocal -f /opt/tez/*.jar /opt/tez/lib/ /apps/tez/"
	rm -rf /opt/hive
	mkdir -p /opt/hive
	tar -C /opt/hive -xzvf hive-dist.tar.gz
	rsync -avP /etc/hive/conf/ /opt/hive/conf/
	echo "export HADOOP_CLASSPATH=$$HADOOP_CLASSPATH:/opt/tez/*:/opt/tez/lib/*:/opt/tez/conf/:/usr/share/java/*" >> /opt/hive/bin/hive-config.sh
	sed -i~ "s@export HIVE_CONF_DIR=.*@export HIVE_CONF_DIR=/opt/hive/conf/@" /opt/hive/conf/hive-env.sh
	sed -i~ \
	-e "s/org.apache.hadoop.hive.ql.security.ProxyUserAuthenticator//" \
	-e "/<.configuration>/r hive-site.xml.frag" \
	-e "x;" \
	/opt/hive/conf/hive-site.xml    
	$(AS_HDFS) -c "$(HADOOP_HOME)/bin/hadoop fs -rm -f /user/hive/hive-exec-0.13.0-SNAPSHOT.jar"
	$(AS_HDFS) -c "$(HADOOP_HOME)/bin/hadoop fs -mkdir -p /user/hive/"
	$(AS_HDFS) -c "$(HADOOP_HOME)/bin/hadoop fs -copyFromLocal -f /opt/hive/lib/hive-exec-0.13.0-SNAPSHOT.jar /user/hive/"

.PHONY: hive tez protobuf ant maven
