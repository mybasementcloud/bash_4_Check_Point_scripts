#!/bin/bash
#
# SCRIPT for BASH to Watch mdsstat
#
ScriptVersion=00.02.00
ScriptDate=2018-03-29
#

export BASHScriptVersion=v00x02x00

watch -d -n 1 "/opt/CPsuite-R80/fw1/scripts/cpm_status.sh;echo;mdsstat"
