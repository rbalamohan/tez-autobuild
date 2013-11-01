
YUM=$(shell which yum)
APT=$(shell which apt-get)

git: 
ifneq ($(YUM),)
	yum -y install git-core \
	gcc gcc-c++ \
	pdsh \
	cmake \
	zlib-devel openssl-devel
endif
ifneq ($(APT),)
	apt-get install -y git gcc g++ python man cmake zlib1g-dev libssl-dev 
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
	test -d tez || git clone https://git-wip-us.apache.org/repos/asf/incubator-tez.git tez
	-- cd tez; git pull --rebase
	export PATH=/opt/protoc/bin:$$PATH:/opt/maven/bin/; \
	cd tez/; . /etc/profile; \
	mvn clean package install -Pdist -DskipTests -Dhadoop.version=2.2.0;

hive: ant tez-dist.tar.gz 
	test -d hive || git clone --branch tez https://github.com/apache/hive
	-- cd hive; git pull --rebase
	export PATH=/opt/protoc/bin:$$PATH:/opt/maven/bin/:/opt/ant/bin; \
	cd hive/; . /etc/profile; \
	ant clean package -Dresolvers=internal -Dhadoop-0.23.version=2.2.0 -Dbuild.profile=nohcat;

dist-tez: tez
	tar -C tez/tez-dist/target/tez-*full/tez-*full -czvf tez-dist.tar.gz .

dist-hive: hive
	tar -C hive/build/dist/ -czvf hive-dist.tar.gz .

tez-dist.tar.gz:
	@echo "run make dist to get tez-dist.tar.gz"

hive-dist.tar.gz:
	@echo "run make dist to get tez-dist.tar.gz"

dist: dist-tez dist-hive

install: tez-dist.tar.gz hive-dist.tar.gz
	-- mkdir -p /opt/tez/conf
	tar -C /opt/tez/ -xzvf tez-dist.tar.gz
	cp -v tez-site.xml /opt/tez/conf/
	-- hadoop fs -mkdir /apps/tez
	hadoop fs -copyFromLocal -f /opt/tez/*.jar /opt/tez/lib/ /apps/tez/
	-- mkdir /opt/hive/
	tar -C /opt/hive -xzvf hive-dist.tar.gz
	rsync -avP /etc/hive/conf/ /opt/hive/conf/
	echo "export HADOOP_CLASSPATH=$$HADOOP_CLASSPATH:/opt/tez/*:/opt/tez/lib/*:/opt/tez/conf/" >> /opt/hive/bin/hive-config.sh
	sed -i~ "s@export HIVE_CONF_DIR=.*@export HIVE_CONF_DIR=/opt/hive/conf/@" /opt/hive/conf/hive-env.sh
	sed -i~ \
	-e "s/org.apache.hadoop.hive.ql.security.ProxyUserAuthenticator//" \
	-e "/<.configuration>/r hive-site.xml.frag" \
	-e "x;" \
	/opt/hive/conf/hive-site.xml	
	hadoop fs -copyFromLocal -f /opt/hive/lib/hive-exec-0.13.0-SNAPSHOT.jar /user/hive/
	

.PHONY: hive tez protobuf ant maven
