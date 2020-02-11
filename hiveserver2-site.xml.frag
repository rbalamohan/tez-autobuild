
    <property>
      <name>hive.security.authorization.manager</name>
      <value></value>
    </property>
    <property>
      <name>hive.security.authorization.enabled</name>
      <value>false</value>
    </property>

    <property>
      <name>hive.metastore.metrics.enabled</name>
      <value>false</value>
    </property>

    <property>
      <name>hive.server2.async.exec.threads</name>
      <value>8192</value>
    </property>

    <property>
      <name>hive.server2.async.exec.wait.queue.size</name>
      <value>8192</value>
    </property>

    <property>
      <name>hive.server2.thrift.max.worker.threads</name>
      <value>8192</value>
    </property>

    <property>
      <name>hive.async.log.enabled</name>
      <value>true</value>
    </property>
    
    <property>
      <name>hive.server2.async.exec.async.compile</name>
      <value>true</value>
    </property>
    
    <property>
      <name>hive.server2.metrics.enabled</name>
      <value>true</value>
    </property>

    <property>
      <name>hive.metastore.initial.metadata.count.enabled</name>
      <value>false</value>
    </property>

	<property>
	  <name>hive.query.results.cache.nontransactional.tables.enabled</name>
	  <value>false</value>
	</property>

    <property>
      <name>hive.metastore.fastpath</name>
      <value>true</value>
    </property>
    <property>
      <name>hive.service.metrics.reporter</name>
      <value>HADOOP2</value>
    </property>

    <property>
      <name>hive.service.metrics.codahale.reporter.classes</name>
      <value>org.apache.hadoop.hive.common.metrics.metrics2.JmxMetricsReporter</value>
    </property>

</configuration>
