#!/bin/bash
#
# Watch Firewall Acceleration Status
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2020-01-05
ScriptVersion=04.21.00
ScriptRevision=004
TemplateLevel=006
TemplateVersion=04.20.00
SubScriptsLevel=006
SubScriptsVersion=04.05.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptName=watch_accel_stats
export BASHScriptShortName=watch_accel_stats.v$ScriptVersion
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription=="Watch Firewall Acceleration Status"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=GW

export BASHScripttftptargetfolder="_template"


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
