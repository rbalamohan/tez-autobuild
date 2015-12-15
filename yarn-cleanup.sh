#!/bin/bash
yarn application -list |  awk '/^applic.*TEZ.*'$USER'/ {print $1}' | xargs -P 10 -n 1 yarn application -kill
