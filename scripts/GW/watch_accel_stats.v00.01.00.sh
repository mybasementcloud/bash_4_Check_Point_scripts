#!/bin/bash
#
# Watch Firewall Acceleration Status (-s)
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.01.00
ScriptDate=2018-03-29
#

export BASHScriptVersion=v00x01x00


watch -d -n 1 "fwaccel stats -s"

