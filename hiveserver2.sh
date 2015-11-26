export HADOOP_OPTS="-XX:+UseNUMA -XX:+UseG1GC -Xmx16g" 
export HADOOP_CLIENT_OPTS="-XX:+UseNUMA -XX:+UseG1GC -Xmx16g" 
./dist/hive/bin/hiveserver2 --hiveconf hive.metastore.uris=''
