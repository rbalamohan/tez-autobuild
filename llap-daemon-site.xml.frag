<configuration>

  <property>
    <name>llap.daemon.work.dirs</name>
    <value>${yarn.nodemanager.local-dirs}</value>
    <description>Set to yarn.nodemanager.local-dirs</description>
  </property>

  <property>
    <name>llap.daemon.yarn.shuffle.port</name>
    <value>15551</value>
    <description>Set to the value on which the ShuffleHandler is running in YARN</description>
  </property>

  <property>
    <name>llap.daemon.num.executors</name>
    <value>4</value>
    <description>Num executors for each daemon</description>
  </property>

  <property>
    <name>hive.llap.io.threadpool.size</name>
	<value>4</value>
	<description>Number of IO threads for each daemon</description>
  </property>

  <property>
    <name>hive.llap.io.threadpool.size</name>
	<value>4</value>
  </property>

  <property>
    <name>llap.daemon.memory.per.instance.mb</name>
    <value>4096</value>
  </property>

  <property>
    <name>llap.daemon.service.hosts</name>
    <value>@llap0</value>
    <description>Comma separate list of nodes running daemons</description>
  </property>

  <property>
    <name>llap.daemon.task.scheduler.enable.preemption</name>
	<value>false</value>
	<description>disable pre-emption</description>
  </property>

  <property>
    <name>hive.llap.io.cache.orc.size</name>
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
