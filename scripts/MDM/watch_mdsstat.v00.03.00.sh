#!/bin/bash
#
# SCRIPT for BASH to Watch mdsstat
#
ScriptVersion=00.03.00
ScriptDate=2018-05-04
#

export BASHScriptVersion=v00x03x00

if [ x"$toolsversion" = x"R80.20" ] ; then
    # cpm_status.sh moved in R80.20, and only exists in R8X
    watch -d -n 1 "/opt/CPsuite-R80.20/fw1/scripts/cpm_status.sh;echo;mdsstat"
    echo
elif [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    watch -d -n 1 "/opt/CPsuite-R80/fw1/scripts/cpm_status.sh;echo;mdsstat"
    echo
else
    watch -d -n 1 "mdsstat"
    echo
fi

