  <property>
    <name>hive.mapred.mode</name>
    <value>nonstrict</value>
  </property>
  <property>
    <name>hive.execution.engine</name>
    <value>tez</value>
  </property>
  <property>
    <name>hive.vectorized.execution.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.vectorized.execution.reduce.enabled</name>
    <!-- Setting to false until HIVE-12534 is fixed-->
    <value>false</value>
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
    <value>2576980377</value>
  </property>
  <property>
    <name>hive.optimize.reducededuplication.min.reducer</name>
    <value>4</value>
  </property>
  <!-- Properties to generate consistent splits in LLAP, and cache locality. Also see tez-site.xml.frag --> 
  <!--
  <property>
    <name>hive.tez.input.generate.consistent.splits</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.llap.client.consistent.splits</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.llap.task.scheduler.locality.delay</name>
    <value>-1</value>
  </property>
  <property>
    <name>hive.exec.orc.split.strategy</name>
    <value>BI</value>
  </property>
  -->
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
    <name>hive.server2.thrift.http.port</name>
    <value>10004</value>
  </property>
  <property>
    <name>hive.server2.webui.port</name>
    <value>10005</value>
  </property>
  <property>
    <name>hive.server2.thrift.port</name>
    <value>10007</value>
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
    <!-- match max async pool -->
    <value>100</value>
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
    <value>256000000</value>
  </property>
  <property>
    <name>hive.metastore.client.socket.timeout</name>
    <value>1800</value>
  </property>
  <property>
    <name>hive.tez.exec.print.summary</name>
    <value>true</value>
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
    <value>true</value>
  </property>
  <property>
    <name>hive.vectorized.execution.mapjoin.native.fast.hashtable.enabled</name>
    <value>true</value>
  </property>
  <!-- vectorize more -->
  <property>
    <name>hive.vectorized.use.vector.serde.deserialize</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.vectorized.use.row.serde.deserialize</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.mapjoin.hybridgrace.hashtable</name>
    <value>false</value>
  </property>
  <property>
    <name>hive.tez.dynamic.partition.pruning</name>
    <value>true</value>
  </property>
  <property>
    <name>hive.tez.bucket.pruning</name>
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
  <property>
    <name>hive.vectorized.execution.mapjoin.native.enabled</name>
    <value>true</value>
  </property>

  <property>
    <name>hive.transpose.aggr.join</name>
    <value>false</value>
  </property>

  <property>
    <name>hive.cbo.costmodel.extended</name>
    <value>false</value>
  </property>
  
  <property>
    <name>hive.fetch.task.conversion.threshold</name>
    <value>640000000</value>
  </property>
  
  <property>
    <name>hive.metastore.schema.verification.record.version</name>
    <value>false</value>
  </property>
  
  <property>
    <name>hive.metastore.schema.verification</name>
    <value>false</value>
  </property>

  <property>
    <name>hive.llap.daemon.service.hosts</name>
    <value>@llap0</value>
    <description>Comma separate list of nodes running daemons</description>
  </property>

  <property>
    <name>hive.llap.daemon.allow.permanent.fns</name>
    <value>false</value>
  </property>

  <property>
    <name>hive.llap.daemon.work.dirs</name>
    <value>${yarn.nodemanager.local-dirs}</value>
    <description>Set to yarn.nodemanager.local-dirs</description>
  </property>

  <property>
    <name>hive.llap.daemon.yarn.shuffle.port</name>
    <value>15551</value>
    <description>Set to the value on which the ShuffleHandler is running in YARN</description>
  </property>

  <property>
    <name>hive.llap.daemon.num.executors</name>
    <value>4</value>
    <description>Num executors for each daemon</description>
  </property>

  <property>
    <name>hive.llap.io.threadpool.size</name>
  <value>24</value>
  <description>Number of IO threads for each daemon</description>
  </property>

  <property>
    <name>hive.llap.daemon.memory.per.instance.mb</name>
    <value>4096</value>
  </property>

  <property>
    <name>hive.llap.daemon.task.scheduler.enable.preemption</name>
    <value>false</value>
    <description>disable pre-emption</description>
  </property>

  <property>
    <name>hive.llap.io.memory.size</name>
    <value>1073741824</value>
  </property>

  <property>
    <name>mapreduce.shuffle.connection-keep-alive.enable</name>
    <value>true</value>
  </property>

  <property>
    <name>mapreduce.shuffle.connection-keep-alive.timeout</name>
    <value>60</value>
  </property>

</configuration>
