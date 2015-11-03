  <property>
    <name>hive.execution.engine</name>
    <value>tez</value>
  </property>
  <property>
    <name>hive.vectorized.execution.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.limit.pushdown.memory.usage</name>
    <value>0.04</value>
  </property>
  <property>
    <name>hive.vectorized.groupby.checkinterval</name>
    <value>4096</value>
  </property>
  <property>
    <name>hive.input.format</name>
    <value>org.apache.hadoop.hive.ql.io.HiveInputFormat</value>
  </property>
  <property>
    <name>hive.auto.convert.join.noconditionaltask.size</name>
    <value>1073741824</value>
  </property>
  <property>
    <name>hive.optimize.reducededuplication.min.reducer</name>
    <value>4</value>
  </property>
  <property>
    <name>hive.tez.auto.reducer.parallelism</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.tez.min.partition.factor</name>
    <value>0.1</value>
  </property>
  <property>
    <name>hive.optimize.index.filter</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.jar.directory</name>
    <value>hdfs:///user/hive/</value>
  </property>
  <property>
    <name>hive.server2.thrift.port</name>
    <value>10003</value>
  </property>
  <property>
    <name>hive.server2.tez.default.queues</name>
    <value>default</value>
  </property>
  <property>
    <name>hive.server2.tez.sessions.per.default.queue</name>
    <value>4</value>
  </property>
  <property>
    <name>hive.server2.tez.initialize.default.sessions</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.server2.enable.doAs</name>
    <value>false</value>
  </property>
  <property>
    <name>hive.server2.thrift.min.worker.threads</name>
    <value>24</value>
  </property>
  <property>
    <name>hive.fetch.task.conversion</name>
    <value>more</value>
  </property>
  <property>
    <name>hive.compute.query.using.stats</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.stats.fetch.column.stats</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.stats.fetch.partition.stats</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.exec.reducers.bytes.per.reducer</name>
    <value>67108864</value>
  </property>
  <property>
    <name>hive.metastore.client.socket.timeout</name>
    <value>1800</value>
  </property>
<!-- 
  <property>
    <name>hive.metastore.thrift.framed.transport.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.metastore.thrift.compact.protocol.enabled</name>
    <value>true</value>
  </property>
-->
  <!-- disable the simple optimizations -->
  <property>
    <name>hive.vectorized.execution.mapjoin.minmax.enabled</name>
    <value>false</value>
  </property>
  <property>
    <name>hive.vectorized.execution.mapjoin.native.fast.hashtable.enabled</name>
    <value>false</value>
  </property>
  <property>
    <name>hive.tez.dynamic.partition.pruning</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.optimize.dynamic.partition.hashjoin</name>
    <value>true</value>
  </property>
  <!-- llap only configs -->
  <property>
    <name>hive.execution.mode</name>
    <value>llap</value>
  </property>
  <property>
    <name>hive.llap.execution.mode</name>
    <!-- llap decider config -->
    <value>all</value>
  </property>
  <property>
    <name>hive.llap.io.enabled</name>
    <!-- cache + IO elevator -->
    <value>true</value>
  </property>
  <property>
    <name>hive.llap.object.cache.enabled</name>
    <value>true</value>
  </property>
<!--  <property>
    <name>hive.tez.java.opts</name>
    <value>-Dsun.net.inetaddr.negative.ttl=0  -Dsun.net.inetaddr.ttl=0 ${mapreduce.map.java.opts}</value>
  </property> -->
  <property>
    <name>hive.driver.parallel.compilation</name>
    <value>true</value>
  </property>
  <property> 
    <name>hive.llap.auto.allow.uber</name>
    <value>false</value>
  </property>
<!-- disable ACID -->
  <property>
    <name>hive.txn.manager</name>
    <value>org.apache.hadoop.hive.ql.lockmgr.DummyTxnManager</value>
  </property>
  <property>
    <name>hive.support.concurrency</name>
    <value>false</value>
  </property>
<!--
  this is metastore configs for ACID impl
  <property>
    <name>hive.support.concurrency</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.exec.dynamic.partition.mode</name>
    <value>nonstrict</value>
  </property>
  <property>
    <name>hive.txn.manager</name>
    <value>org.apache.hadoop.hive.ql.lockmgr.DbTxnManager</value>
  </property>
  <property>
    <name>hive.compactor.initiator.on</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.compactor.worker.threads</name>
    <value>1</value>
  </property>
-->

</configuration>
