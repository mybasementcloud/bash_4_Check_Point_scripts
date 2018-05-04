#!/bin/bash
#
# SCRIPT for BASH to watch cp management processes
#
ScriptVersion=00.03.00
ScriptDate=2018-05-04
#

if [ x"$toolsversion" = x"R80.20" ] ; then
    # cpm_status.sh moved in R80.20, and only exists in R8X
    watch -d -n 1 "/opt/CPsuite-R80.20/fw1/scripts/cpm_status.sh;echo;cpwd_admin list"
    echo
elif [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    watch -d -n 1 "/opt/CPsuite-R80/fw1/scripts/cpm_status.sh;echo;cpwd_admin list"
    echo
else
    watch -d -n 1 "cpwd_admin list"
    echo
fi

