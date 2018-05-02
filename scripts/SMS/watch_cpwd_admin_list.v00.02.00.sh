#!/bin/bash
#
# SCRIPT for BASH to watch cp management processes
#
ScriptVersion=00.02.00
ScriptDate=2018-03-29
#

watch -d -n 1 "/opt/CPsuite-R80/fw1/scripts/cpm_status.sh;echo;cpwd_admin list"
