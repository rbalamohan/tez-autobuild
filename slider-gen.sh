export JAVA_HOME=$(echo /usr/jdk64/* | sort -n | tail -n 1)
./dist/hive/bin/hive\
 --service llap\
 --instances 1\
 --cache 48000m\
 --executors 24\
 --iothreads 24\
 --size 180000m\
 --xmx 128000m\
 --loglevel WARN\
 --args "-XX:+UseG1GC -XX:TLABSize=64m -XX:+ResizeTLAB -XX:+UseNUMA -XX:+AggressiveOpts -XX:MetaspaceSize=1024m -XX:InitiatingHeapOccupancyPercent=80 -XX:MaxGCPauseMillis=200 -XX:+PreserveFramePointer"\
 --javaHome $JAVA_HOME
