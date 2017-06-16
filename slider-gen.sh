export JAVA_HOME=$(ls -drt /usr/jdk64/jdk1.8* | tail -n 1)
# one of those should work, I think
if [ "x$JAVA_HOME" = "x" ]; then 
   export JAVA_HOME=$(ls -d /usr/lib/jvm/java-1.8.0-openjdk-*/ | head -n 1)
fi
#export HIVE_AUX_JARS_PATH=$PWD/hive/packaging/target/apache-hive-3.0.0-SNAPSHOT-bin/apache-hive-3.0.0-SNAPSHOT-bin/lib/jetty-rewrite-9.3.8.v20160314.jar
./dist/hive/bin/hive\
 --config ./dist/hive/conf/\
 --service llap\
 --instances 1\
 --cache 32000m\
 --executors 24\
 --iothreads 24\
 --size 180000m\
 --xmx 128000m\
 --loglevel INFO\
 --args "-XX:+UseG1GC -XX:TLABSize=128m -XX:+ResizeTLAB -XX:+UseNUMA -XX:+AggressiveOpts -XX:MetaspaceSize=1024m -XX:InitiatingHeapOccupancyPercent=80 -XX:MaxGCPauseMillis=200 -XX:+PreserveFramePointer -XX:AllocatePrefetchStyle=2 -Dhttp.maxConnections=10"\
 --javaHome $JAVA_HOME
 # --queue llap \
