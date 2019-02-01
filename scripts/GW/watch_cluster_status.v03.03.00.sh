#!/bin/bash
#
# Watch Firewall Cluster[XL] Status (-s)
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

export BASHScriptName=watch_cluster_stats.v$ScriptVersion
export BASHScriptShortName=watch_cluster_stats.v$ScriptVersion
export BASHScriptDescription="Watch Firewall Cluster[XL] Status"


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

else

    echo 'Not a cluster!'
    echo

fi
