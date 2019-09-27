#!/bin/bash
#
# Watch Firewall Acceleration Status
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-08-24
ScriptVersion=04.05.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.05.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}

export BASHScriptName=watch_accel_stats.v$ScriptVersion
export BASHScriptShortName=watch_accel_stats.v$ScriptVersion
export BASHScriptDescription="Watch Firewall Acceleration Status"

export BASHScriptHelpFile="$BASHScriptName.help"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=GW


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Script
# -------------------------------------------------------------------------------------------------

watchcommands="echo 'fwaccel stats -s';fwaccel stats -s"
watchcommands=$watchcommands";echo;echo;echo 'fwaccel stats -p';fwaccel stats -p"
watchcommands=$watchcommands";echo;echo;echo 'fwaccel templates -S';fwaccel templates -S"

watch -d -n 1 "$watchcommands"

echo 'fwaccel stats -s';fwaccel stats -s
echo
echo 'fwaccel stats -p';fwaccel stats -p"
echo
echo 'fwaccel templates -S';fwaccel templates -S"
echo

# -------------------------------------------------------------------------------------------------
# End of script Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

echo
echo 'Script Completed, exiting...';echo
