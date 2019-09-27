#!/bin/bash
#
# SCRIPT Update scripts from NAS storage via tftp pull, clear, and replace
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-09-26
ScriptVersion=04.07.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.05.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptName="updatescripts"
export BASHScriptShortName="updatescripts"
export BASHScriptDescription="Update scripts from NAS storage via tftp pull, clear, and replace"

export BASHScriptHelpFile="$BASHScriptName.help"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=.


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Basic Configuration
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

echo 'Date Time Group   :  '$DATE $DATEDTG $DATEDTGS
echo 'Date (YYYY-MM-DD) :  '$DATEYMD
echo
    

# -------------------------------------------------------------------------------------------------
# Other variable configuration
# -------------------------------------------------------------------------------------------------


WAITTIME=20


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# Start of Script Operations
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# local scripts variables configuration
# -------------------------------------------------------------------------------------------------


if [ -n $MYTFTPSERVER ]; then
    export targettftpserver=$MYTFTPSERVER
else
    export targettftpserver=192.168.1.1
fi

export remotescriptsfolder=/__gaia

export scriptspackage=scripts.tgz
export latestupdatescript=updatescripts.sh

export targetfolder=/var/log/__customer/upgrade_export
export targetscriptsfolder=scripts

#export logfilefoldername=Change_Log
export logfilefoldername=dump


# -------------------------------------------------------------------------------------------------
# logfile configuration
# -------------------------------------------------------------------------------------------------


# setup initial log file for output logging
#export logfilefolder=$targetfolder/Change_Log/$DATEDTGS.$BASHScriptShortName
export logfilefolder=$targetfolder/$logfilefoldername/$DATEDTGS.$BASHScriptShortName
export logfilepath=$logfilefolder/$BASHScriptName.$DATEDTGS.log

if [ ! -w $logfilefolder ]; then
    mkdir -pv $logfilefolder
    chmod 775 $logfilefolder
fi

touch $logfilepath


# -------------------------------------------------------------------------------------------------
# Script intro
# -------------------------------------------------------------------------------------------------


echo | tee -a -i $logfilepath
echo $BASHScriptDescription', script version '$ScriptVersion', revision '$ScriptRevision' from '$ScriptDate | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Date Time Group   :  '$DATEDTGS | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# Check target folder availability and then cd there
# -------------------------------------------------------------------------------------------------


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


# -------------------------------------------------------------------------------------------------
# Download scripts from tftp source
# -------------------------------------------------------------------------------------------------


echo "Fetch latest $scriptspackage from tftp repository on $targettftpserver..." | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
tftp -v -m binary $targettftpserver -c get $remotescriptsfolder/$scriptspackage | tee -a -i $logfilepath
tftp -v -m binary $targettftpserver -c get $remotescriptsfolder/$latestupdatescript | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# Process scripts and if OK, execute update and re-do of links
# -------------------------------------------------------------------------------------------------


echo "Check that we got it." | tee -a -i $logfilepath
if [ ! -r $scriptspackage ]; then
    # Oh, oh, we didn't get the $scriptspackage file
    echo | tee -a -i $logfilepath
    echo 'Critical Error!!! Did not obtain '"$scriptspackage"' file from tftp!!!' | tee -a -i $logfilepath
    echo 'Exiting...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    # we have the $scriptspackage file and can work with it
    # first remove the existing script links
    
    if [ -r $targetfolder/$targetscriptsfolder ]; then    
        # scripts folder exists, so we might have scripts

        export removefile=`ls $targetfolder/$targetscriptsfolder/remove_script*`
        if [ -r $removefile ]; then    
            echo "Remove existing script links... $removefile" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            . $removefile | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        fi
        
        # next remove existing scripts folder
        echo "Remove scripts folder... $targetfolder/$targetscriptsfolder" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        rm -f -r -d $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath

        # next [re-]create scripts folder
        echo "Create/Check scripts folder... $targetfolder/$targetscriptsfolder" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        if [ -r $targetfolder/$targetscriptsfolder ]; then
            mkdir -pv $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath
            chmod 775 $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath
        else
            chmod 775 $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath
        fi
    
        export oldversionfile=`ls $targetfolder/scripts.*.version`
        if [ -r $oldversionfile ]; then    
            echo "Remove old version file from main target folder... $oldversionfile" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            rm -f $oldversionfile | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        fi
    else
        # scripts folder doesn't exists, so we might have scripts

        # next [re-]create scripts folder
        echo "Create/Check scripts folder..." | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        if [ -r $targetfolder/$targetscriptsfolder ]; then
            mkdir -pv $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath
            chmod 775 $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath
        else
            chmod 775 $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath
        fi
    fi
    echo | tee -a -i $logfilepath

    # now unzip existing scripts folder
    echo "Extract $scriptspackage file..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    gtar -zxvf $scriptspackage | tee -a -i $logfilepath
    echo;echo | tee -a -i $logfilepath
    
    pwd | tee -a -i $logfilepath
    ls -alhR ./$targetscriptsfolder | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    export generatefile=`ls ./$targetscriptsfolder/generate_script*`
    echo "Generate script links... $generatefile" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    . $generatefile | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    export versionfile=`ls $targetfolder/$targetscriptsfolder/scripts.*.version`
    if [ -r $versionfile ]; then    
        echo "Copy version file to main target folder... $versionfile" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        cp $versionfile . | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi

    echo 'Done!' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
fi



# -------------------------------------------------------------------------------------------------
# Closing operations and log file information
# -------------------------------------------------------------------------------------------------


echo | tee -a -i $logfilepath
echo 'Log File : '$logfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# End of script Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

echo 'Done!'
echo
