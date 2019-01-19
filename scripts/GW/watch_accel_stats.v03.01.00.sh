#!/bin/bash
#
# Watch Firewall Acceleration Status (-s)
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-01-18
ScriptVersion=03.01.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=03.00.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}

export BASHScriptName=watch_accel_stats.v$ScriptVersion
export BASHScriptShortName=watch_accel_stats.v$ScriptVersion
export BASHScriptDescription="Watch Firewall Acceleration Status"


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Script
# -------------------------------------------------------------------------------------------------

watch -d -n 1 "fwaccel stats -s;echo;echo;fwaccel stats -p;echo;echo;fwaccel templates -S"

