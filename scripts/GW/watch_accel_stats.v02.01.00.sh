#!/bin/bash
#
# Watch Firewall Acceleration Status (-s)
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=02.01.00
ScriptDate=2018-10-18
#

export BASHScriptVersion=v02x01x00


watch -d -n 1 "fwaccel stats -s;echo;echo;fwaccel stats -p;echo;echo;fwaccel templates -S"

