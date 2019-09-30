#!/bin/bash
#
# Watch Firewall Cluster[XL] Status (-s)
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-09-28
ScriptVersion=04.11.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.11.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHScriptFileNameRoot=watch_cluster_stats
export BASHScriptShortName=watch_cluster_stats.v$ScriptVersion
export BASHScriptDescription="Watch Firewall Cluster[XL] Status"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=GW


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Script
# -------------------------------------------------------------------------------------------------

if [[ $(cpconfig <<< 10 | grep cluster) == *"Disable"* ]]; then
    # is a cluster

    watchcommands="echo 'chphaprob state';cphaprob state"
    watchcommands=$watchcommands";echo;echo;echo 'cphaprob syncstat';cphaprob syncstat"
    #watchcommands=$watchcommands";echo;echo;echo 'cphaprob -a if';cphaprob -a if"

    watch -d -n 1 "$watchcommands"

    echo 'chphaprob state';cphaprob state
    echo
    echo 'cphaprob syncstat';cphaprob syncstat
    echo
    echo 'cphaprob -a if';cphaprob -a if

else

    echo 'Not a cluster!'
    echo

fi

# -------------------------------------------------------------------------------------------------
# End of script Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

echo
echo 'Script Completed, exiting...';echo
