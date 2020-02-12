#!/bin/bash
#
# SCRIPT Update scripts from NAS storage via tftp pull, clear, and replace
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
#
ScriptDate=2020-02-11
ScriptVersion=04.25.00
ScriptRevision=000
TemplateVersion=04.25.00
TemplateLevel=006
SubScriptsLevel=NA
SubScriptsVersion=NA
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=updatescripts
export BASHScriptShortName="updatescripts"
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription=="Update scripts from NAS storage via tftp pull, clear, and replace"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=.

export BASHScripttftptargetfolder="_template"


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
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# JQ and json related
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-01-03 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# points to where jq is installed
if [ -r ${CPDIR}/jq/jq ] ; then
    export JQ=${CPDIR}/jq/jq
elif [ -r ${CPDIR_PATH}/jq/jq ] ; then
    export JQ=${CPDIR_PATH}/jq/jq
elif [ -r ${MDS_CPDIR}/jq/jq ] ; then
    export JQ=${MDS_CPDIR}/jq/jq
else
    export JQ=
fi

# points to where jq 1.6 is installed, which is not generally part of Gaia, even R80.40EA (2020-01-20)
export JQ16PATH=$MYWORKFOLDER/_tools/JQ
export JQ16FILE=jq-linux64
export JQ16FQFN=$JQ16PATH$JQ16FILE
if [ -r $JQ16FQFN ] ; then
    # OK we have the easy-button alternative
    export JQ16=$JQ16FQFN
elif [ -r "./_tools/JQ/$JQ16FILE" ] ; then
    # OK we have the local folder alternative
    export JQ16=./_tools/JQ/$JQ16FILE
elif [ -r "../_tools/JQ/$JQ16FILE" ] ; then
    # OK we have the parent folder alternative
    export JQ16=../_tools/JQ/$JQ16FILE
else
    export JQ16=
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-01-03


# -------------------------------------------------------------------------------------------------
# END:  Basic Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


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


if [ ! -z $MYTFTPSERVER1 ] && [ $MYTFTPSERVER1 != $MYTFTPSERVER ]; then
    export targettftpserver=$MYTFTPSERVER1
elif [ ! -z $MYTFTPSERVER2 ] && [ $MYTFTPSERVER2 != $MYTFTPSERVER ]; then
    export targettftpserver=$MYTFTPSERVER2
elif [ ! -z $MYTFTPSERVER3 ] && [ $MYTFTPSERVER3 != $MYTFTPSERVER ]; then
    export targettftpserver=$MYTFTPSERVER3
elif [ ! -z $MYTFTPSERVER ]; then
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

    if [ ! -r "$HOME/alias_commands_for_dot_bashrc.sh" ]; then
        #
        # $HOME folder for user(s) does not have updates for standard alias configurations and root variables
        #

        export aliasupdatefile=`ls ./$targetscriptsfolder/UserConfig/add_alias_commands_all_users.all.*`
        echo "Add Alias to users $HOME folders... $aliasupdatefile" | tee -a -i $logfilepath
    
    else
        #
        # $HOME folder for user(s) has updates for standard alias configurations and root variables
        #

        export aliasupdatefile=`ls ./$targetscriptsfolder/UserConfig/update_alias_commands_all_users.all.*`
        echo "Update Alias in users $HOME folders... $aliasupdatefile" | tee -a -i $logfilepath

    fi

    echo | tee -a -i $logfilepath
    . $aliasupdatefile | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    echo 'Done!' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

fi



# -------------------------------------------------------------------------------------------------
# Closing operations and log file information
# -------------------------------------------------------------------------------------------------


if [ -r nul ] ; then
    rm nul >> $logfilepath
fi

if [ -r None ] ; then
    rm None >> $logfilepath
fi

echo | tee -a -i $logfilepath
echo 'Log File : '$logfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# End of script Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

echo 'Done!'
echo
