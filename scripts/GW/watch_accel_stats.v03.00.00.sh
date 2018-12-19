#!/bin/bash
#
# Watch Firewall Acceleration Status (-s)
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptTemplateLevel=006
ScriptVersion=03.00.00
ScriptDate=2018-12-18
#

export BASHScriptVersion=v03x00x00


watch -d -n 1 "fwaccel stats -s;echo;echo;fwaccel stats -p;echo;echo;fwaccel templates -S"

