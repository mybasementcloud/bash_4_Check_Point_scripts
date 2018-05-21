#!/bin/bash
#
# SCRIPT for BASH to watch cp management processes
#
ScriptVersion=00.04.00
ScriptDate=2018-05-21
#

export BASHScriptVersion=v00x04x00

if [ x"$toolsversion" = x"R80.20" ] || [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    watch -d -n 1 "$FWDIR/scripts/cpm_status.sh;echo;cpwd_admin list"
    echo
else
    watch -d -n 1 "cpwd_admin list"
    echo
fi

