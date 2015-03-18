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
    <name>llap.daemon.memory.per.instance.mb</name>
    <value>4096</value>
  </property>

  <property>
    <name>llap.daemon.service.hosts</name>
    <value>@llap0</value>
    <description>Comma separate list of nodes running daemons</description>
  </property>

</configuration>
