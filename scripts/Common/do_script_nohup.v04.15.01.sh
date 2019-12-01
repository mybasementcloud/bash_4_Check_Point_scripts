#!/bin/bash
#
# SCRIPT Execute named script in CLI parameter with NOHUP and rest of CLI parameters
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-11-24
ScriptVersion=04.15.01
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.15.00
SubScriptsLevel=NA
SubScriptsVersion=NA
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHSubScriptVersion=do_script_nohup
export BASHScriptShortName="do_script_nohup"
export BASHScriptDescription="Execute named script in CLI parameter with NOHUP and rest of CLI parameters"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=Common

export BASHScripttftptargetfolder="_template"


# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

WAITTIME=20

echo
echo $BASHScriptDescription', script version '$ScriptVersion', revision '$ScriptRevision' from '$ScriptDate
echo

if [ -x $1 ]; then
    export script2nohup=$1
    export script2nohupstdoutlog=$script2nohup.nuhup.stdout.$DATEDTGS.txt
    export script2nohupstderrlog=$script2nohup.nuhup.stderr.$DATEDTGS.txt
    export script2watchnohupwork=$script2nohup.nuhup.watchme.$DATEDTGS.sh

    touch $script2nohupstdoutlog
    touch $script2nohupstderrlog

    echo >> $script2nohupstdoutlog
    echo $BASHScriptDescription', script version '$ScriptVersion' from '$ScriptDate >> $script2nohupstdoutlog
    echo >> $script2nohupstdoutlog
   
    echo 'Execute script : '$script2nohup' with NOHUP, all paramters' | tee -a -i $script2nohupstdoutlog
    echo '  and dump stdout to log file : '$script2nohupstdoutlog | tee -a -i $script2nohupstdoutlog
    echo '  and dump stderr to log file : '$script2nohupstderrlog | tee -a -i $script2nohupstdoutlog
    echo '  and watch command script    : '$script2watchnohupwork | tee -a -i $script2nohupstdoutlog
    echo | tee -a -i $script2nohupstdoutlog

    cat $script2nohupstdoutlog >> $script2nohupstderrlog

    #nohup $script2nohup >> $script2nohupstdoutlog 2>> $script2nohupstderrlog
    nohup "$@" --NOWAIT --NOHUP 2>> $script2nohupstderrlog >> $script2nohupstdoutlog &
    
    echo 'watch command string - copy to execute'
    echo
    watchtail1="tail -n 10 $script2nohupstdoutlog"
    watchtail2="tail -n 10 $script2nohupstderrlog"
    echo 'watch -d -n 2 "'$watchtail1';echo;echo;'$watchtail2'";echo'
    echo
    
    echo '#!/bin/bash' > $script2watchnohupwork
    echo '#' >> $script2watchnohupwork
    echo  >> $script2watchnohupwork
    echo 'watch -d -n 2 "'$watchtail1';echo;echo;'$watchtail2'";echo' >> $script2watchnohupwork
    echo 'echo' >> $script2watchnohupwork
    echo 'echo "Remember to remove $script2watchnohupwork"' >> $script2watchnohupwork
    echo 'echo' >> $script2watchnohupwork
    echo  >> $script2watchnohupwork
    chmod 775 $script2watchnohupwork
    echo

    ls -alh $script2nohup.nuhup.*

else
    echo 'Script file : '$1' either does not exist or is not executable!'
    echo 'Exiting!!!!!'
    echo
fi 
    echo

