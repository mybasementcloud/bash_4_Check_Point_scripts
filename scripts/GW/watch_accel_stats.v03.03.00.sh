#!/bin/bash
#
# Watch Firewall Acceleration Status
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-02-01
ScriptVersion=03.03.00
ScriptRevision=001
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

watchcommands="echo 'fwaccel stats -s';fwaccel stats -s"
watchcommands=$watchcommands";echo;echo;echo 'fwaccel stats -p';fwaccel stats -p"
watchcommands=$watchcommands";echo;echo;echo 'fwaccel templates -S';fwaccel templates -S"

watch -d -n 1 "$watchcommands"

