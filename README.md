tez-autobuild
=============

To set up hive-tez on an HDP2 Sandbox VM, log in as root and in this repo, do

    # make dist install

That should pull tez, hive-tez, build it and install it locally in /opt/hive/

To test this out, you can do

    # /opt/hive/bin/hive
    hive> select count(1) from sample_07;

and it should use Tez instead of the default MR API.

FYI, disabling Tez after you run 1 query doesn't work quite right, but I gave it a perf run


To compare performance, you can disable it at the beginning

    # /opt/hive/bin/hive
    hive> set hive.optimize.tez=false;   
    hive> select count(1) from sample_07;
    ...
    Time taken: 39.176 seconds, Fetched: 1 row(s)
    hive> select count(1) from sample_07;
    Time taken: 37.782 seconds, Fetched: 1 row(s)

versus the Tez run 

    # /opt/hive/bin/hive
    hive> select count(1) from sample_07;
    Time taken: 15.517 seconds, Fetched: 1 row(s)
    hive> select count(1) from sample_07;
    Time taken: 4.207 seconds, Fetched: 1 row(s)

The tez memory settings have been tuned down to fit inside a 4Gb VM.

If you have a bigger VM/actual HDP2 cluster, it makes sense to edit the tez-site.xml where it says 512 & -Xmx400m to 8192 & -Xmx7168.
