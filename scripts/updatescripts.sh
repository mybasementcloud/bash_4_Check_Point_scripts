#!/bin/bash
#
# SCRIPT Update scripts from NAS storage via tftp pull, clear, and replace
#
# (C) 2016-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptTemplateLevel=005
ScriptVersion=01.00.00
ScriptDate=2018-10-25
#

export BASHScriptVersion=v01x00x00
export BASHScriptTemplateLevel=$ScriptTemplateLevel
export BASHScriptName="updatescripts"
export BASHScriptShortName="updatescripts"
export BASHScriptDescription="Update scripts from NAS storage via tftp pull, clear, and replace"

# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

WAITTIME=60

targetfolder=/var/log/__customer/upgrade_export

# setup initial log file for output logging
export logfilefolder=$targetfolder/Change_Log/$DATEDTGS.$BASHScriptShortName
export logfilepath=$logfilefolder/$BASHScriptName.$DATEDTGS.log

if [ ! -w $logfilefolder ]; then
    mkdir $logfilefolder
fi

touch $logfilepath

echo | tee -a -i $logfilepath
echo $BASHScriptDescription', script version '$ScriptVersion' from '$ScriptDate | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Date Time Group   :  '$DATEDTGS | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Wait until the next target folder is available : '$targetfolder; echo
echo -n '!'
until [ -r $targetfolder ]
do
    echo -n '.'
done
echo

echo 'cd to '"$targetfolder" | tee -a -i $logfilepath
cd "$targetfolder"
pwd | tee -a -i $logfilepath

echo
read -t $WAITTIME -n 1 -p "Any key to continue.  Automatic continue after $WAITTIME seconds : " anykey
echo

echo "Fetch scripts.tgz from tftp repository..." | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
tftp -v -m binary 10.69.248.60 -c get /__gaia/scripts.tgz | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo "Check that we got it." | tee -a -i $logfilepath
if [ ! -r scripts.tgz ]; then
    # Oh, oh, we didn't get the scripts.tgz file
    echo | tee -a -i $logfilepath
    echo 'Critical Error!!! Did not obtain scripts.tgz file from tftp!!!' | tee -a -i $logfilepath
    echo 'Exiting...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    # we have the scripts.tgz file and can work with it
    # first remove the existing script links
    
    echo "Remove existing script links..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    export removefile=`ls ./scripts/remove_script*`
    . $removefile | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    # next remove existing scripts folder
    echo "Remove scripts folder..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    rm -f -r -d $targetfolder/scripts | tee -a -i $logfilepath
    
    # now unzip existing scripts folder
    echo "Extract scripts.tgz file..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    gtar -zxvf scripts.tgz | tee -a -i $logfilepath
    echo;echo | tee -a -i $logfilepath
    
    pwd | tee -a -i $logfilepath
    ls -alhR ./scripts | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    echo "Generate script links..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    export generatefile=`ls ./scripts/generate_script*`
    . $generatefile | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    echo 'Done!' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
fi

echo 'Log File : '$logfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


