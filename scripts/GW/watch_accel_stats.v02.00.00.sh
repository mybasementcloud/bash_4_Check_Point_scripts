#!/bin/bash
#
# Watch Firewall Acceleration Status (-s)
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=02.00.00
ScriptDate=2018-10-04
#

export BASHScriptVersion=v02x00x00


watch -d -n 1 "fwaccel stats -s"

