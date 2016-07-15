tez-autobuild
=============

To set up hive-tez on an HDP2 Sandbox VM, log in as root and in this repo, do

    # make dist install

That should pull tez, hive-tez, build it and install it locally in ./dist/hive.

LLAP
====

Starting LLAP, requires you to have a working install of Apache Slider and a Zookeeper instance used by the YARN registry for co-ordination between nodes.

edit slider-gen.sh to fix your JAVA_HOME, pick your Xmx, container and cache sizing (basic rule = container size > (Xmx + cache)).

Run 
     # ./slider-gen.sh

it generates a run.sh script in the local dir with the configuration for running (including date).

        ./llap-slider-<date>/run.sh

Confirm slider is running with

        slider status llap0

If that fails to startup, check whether you have JDK8 in the right location specified in JAVA_HOME.

Finally, to test this out, you can do

    # ./dist/hive/bin/hive
    hive> select count(1) from sample_07;

and it should use LLAP. Switch in and out with `hive.llap.execution.mode`, the execution will switch between `container` and `llap`.

![alt tag](http://people.apache.org/~gopalv/LLAP.gif)

And for anything you want to override in local settings (like HIVE_CONF_DIR), create a file named local.mk and add the Makefile variables to that file.
