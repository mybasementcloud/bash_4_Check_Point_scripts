#!/bin/bash
#
# SCRIPT Execute named script in CLI parameter with NOHUP
#
# (C) 2016-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptTemplateLevel=001
ScriptVersion=00.01.00
ScriptDate=2018-12-30
#

export BASHScriptVersion=v00x01x00
export BASHScriptTemplateLevel=$ScriptTemplateLevel
export BASHScriptName="do_script_nohup.v$ScriptVersion"
export BASHScriptShortName="do_script_nohup"
export BASHScriptDescription="Execute named script in CLI parameter with NOHUP"

# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

WAITTIME=20

echo
echo $BASHScriptDescription', script version '$ScriptVersion' from '$ScriptDate
echo

if [ -x $1 ]; then
    export script2nohup=$1
    export script2nohuplog=$script2nohup.nuhup.$DATEDTGS.txt
    echo 'Execute script : '$script2nohup' with NOHUP and dump to log file : '$script2nohuplog
    echo
    touch $script2nohuplog
    nohup $script2nohup >> $script2nohuplog
else
    echo 'Script file : '$1' either does not exist or is not executable!'
    echo 'Exiting!!!!!'
    echo
fi 

echo
