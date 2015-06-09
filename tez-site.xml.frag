<?xml version="1.0"?>
<configuration>
  <property>
    <name>tez.lib.uris</name>
    <value>${fs.default.name}/apps</value>
  </property>
  <property>
    <name>tez.am.log.level</name>
    <value>WARN</value>
  </property>
  <property>
    <name>tez.staging-dir</name>
    <value>/tmp/${user.name}/staging</value>
  </property>
  <property>
    <name>tez.shuffle-vertex-manager.min-src-fraction</name>
    <value>0.1</value>
  </property>
  <property>
    <name>tez.shuffle-vertex-manager.max-src-fraction</name>
    <value>0.1</value>
  </property>
  <property>
    <name>tez.am.am-rm.heartbeat.interval-ms.max</name>
    <value>250</value>
  </property>
  <property>
    <name>tez.runtime.transfer.data-via-events.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>tez.runtime.transfer.data-via-events.max-size</name>
    <value>512</value>
  </property>
  <property>
    <name>tez.am.resource.memory.mb</name>
    <value>${mapreduce.map.memory.mb}</value>
  </property>
  <property>
    <name>tez.am.launch.cmd-opts</name>
    <value>-XX:+PrintGCDetails -verbose:gc -XX:+PrintGCTimeStamps -XX:+UseNUMA -XX:+UseParallelGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/</value>
  </property>
  <property>
    <name>tez.grouping.split-waves</name>
    <value>1.7</value>
  </property>
  <property>
    <name>tez.grouping.min-size</name>
    <value>4194304</value>
  </property>
  <property>
    <name>tez.am.container.reuse.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>tez.am.container.session.delay-allocation-millis</name>
    <value>1000</value>
  </property>
  <property>
    <name>tez.am.container.reuse.rack-fallback.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>tez.am.container.reuse.non-local-fallback.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>tez.am.container.reuse.locality.delay-allocation-millis</name>
    <value>250</value>
  </property>
  <property>
    <name>tez.runtime.compress</name>
    <value>true</value>
  </property>
  <property>
    <name>tez.runtime.compress.codec</name>
    <value>org.apache.hadoop.io.compress.SnappyCodec</value>
  </property>
  <property>
    <name>tez.task.get-task.sleep.interval-ms.max</name>
    <value>100</value>
  </property>
  <property>
    <name>tez.generate.debug.artifacts</name>
    <value>true</value>
  </property>
  <property>
    <name>tez.shuffle-vertex-manager.enable.auto-parallel</name>
    <value>false</value>
  </property>
  <property>
    <name>tez.task.generate.counters.per.io</name>
    <value>true</value>
  </property>
  <!-- ~4x counters due to per-io -->
  <property>
    <name>tez.runtime.job.counters.max</name>
    <value>4096</value>
  </property>
  <property>
    <name>tez.runtime.empty.partitions.info-via-events.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>tez.runtime.pipelined.sorter.sort.threads</name>
    <value>4</value>
  </property>
  <property>
    <name>tez.am.maxtaskfailures.per.node</name>
    <value>60</value>
  </property>
  <property>
    <name>tez.simple.history.logging.dir</name>
    <value>${fs.default.name}/tez-history/</value>
  </property>
  <property>
    <name>tez.history.logging.service.class</name>
    <value>org.apache.tez.dag.history.logging.ats.ATSHistoryLoggingService</value>
  </property>
  <property>
    <name>tez.allow.disabled.timeline-domains</name>
    <value>true</value>
  </property>
  <!--
  -->
  <property>
    <name>tez.am.session.min.held-containers</name>
    <value>10</value>
  </property>
  <property>
    <name>tez.am.heartbeat.counter.interval-ms.max</name>
    <value>4000</value>
  </property>
  <property>
    <name>tez.runtime.shuffle.keep-alive.enabled</name>
	<value>true</value>
  </property>
  <property>
    <name>tez.runtime.optimize.local.fetch</name>
	<value>false</value>
  </property>
  <property>
    <name>tez.runtime.optimize.shared.fetch</name>
	<value>false</value>
  </property>
  <property>
    <!-- Starting 0.7 -->
    <name>tez.runtime.pipelined-shuffle.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>tez.runtime.shuffle.use.async.http</name>
    <value>true</value>
  </property>
  <property>
    <name>tez.task.resource.calculator.process-tree.class</name>
    <value>org.apache.tez.util.TezMxBeanResourceCalculator</value>
  </property>
  <property>
    <name>tez.runtime.convert.user-payload.to.history-text</name>
    <value>true</value>
  </property>
  <!--
  <property>
    <name>tez.am.acls.enabled</name>
    <value>false</value>
  </property>
  -->
</configuration>
