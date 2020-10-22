#!/bin/bash
#
# SCRIPT Setup host with basic __customer layout and scripts
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
ScriptDate=2020-10-21
ScriptVersion=04.37.00
ScriptRevision=001
TemplateVersion=04.37.00
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

export BASHScriptFileNameRoot="setuphost"
export BASHScriptShortName="setuphost"
export BASHScriptDescription="Setup host with basic __customer layout and scripts"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=_hostsetupscripts

export BASHScripttftptargetfolder="Host_Setup"


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Root Configuration
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`


# -------------------------------------------------------------------------------------------------
# Script Operations Control variable configuration
# -------------------------------------------------------------------------------------------------


WAITTIME=20


# -------------------------------------------------------------------------------------------------
# logfile naming control variables
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-10-21 -
# if we are date-time stamping the output location as a subfolder of the 
# output folder set this to true,  otherwise it needs to be false
#
# OutputYearSubfolder             : true|false : Add a folder level with just the year (YYYY)
# OutputYMSubfolder               : true|false : Add a folder level with the year-month (YYYY-MM)
# OutputDTGSSubfolder             : true|false : Add a folder level with Date Time Group with Seconds (YYYY-MM-DD-HHmmSS)
# Append script name to output subfolder, only one of these should be true, ignored if both are false
# OutputSubfolderScriptName       : true|false : Add full script name to folder name of output folder
#                                 :: setting this value true will override OutputSubfolderScriptShortName
# OutputSubfolderScriptShortName  : true|false : Add short script name to folder name of output folder
#
export OutputYearSubfolder=false
export OutputYMSubfolder=false
export OutputDTGSSubfolder=true
export OutputSubfolderScriptName=false
export OutputSubfolderScriptShortName=true


# -------------------------------------------------------------------------------------------------
# Local logfile variables
# -------------------------------------------------------------------------------------------------


export logfilefolderroot=/var/log/tmp
export logfilefoldername=dump


# -------------------------------------------------------------------------------------------------
# logfile configuration
# -------------------------------------------------------------------------------------------------


# setup initial log file for output logging
DATEYear=`date +%Y`
DATEYM=`date +%Y-%m`
export logfilefolder=$logfilefolderroot/$logfilefoldername
if $OutputYearSubfolder ; then
    export logfilefolder=$logfilefolder/$DATEYear
fi
if $OutputYMSubfolder ; then
    export logfilefolder=$logfilefolder/$DATEYM
fi
if $OutputDTGSSubfolder ; then
    export logfilefolder=$logfilefolder/$DATEDTGS
fi
if $OutputSubfolderScriptName ; then
    export logfilefolder=$logfilefolder.$BASHScriptName
elif  $OutputSubfolderScriptShortName ; then
    export logfilefolder=$logfilefolder.$BASHScriptShortName
fi
export logfilepath=$logfilefolder/$BASHScriptName.$DATEDTGS.log

if [ ! -w $logfilefolder ]; then
    mkdir -pv $logfilefolder
fi

touch $logfilepath


# -------------------------------------------------------------------------------------------------
# END:  Basic Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# Start of Script Operations
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# local scripts variables configuration
# -------------------------------------------------------------------------------------------------


export rootworkfolder=/var/log
export customerrootfolder=$rootworkfolder/__customer
export targetfolder=$customerrootfolder/upgrade_export
export targetscriptsfolder=scripts

export remotescriptsfolder=/__gaia

export scriptspackage=scripts.tgz
export latestupdatescript=updatescripts.sh

export hostssetupscriptspackage=__customer.tgz


# -------------------------------------------------------------------------------------------------
# tfpt server variable configuration
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
    export targettftpserver=10.69.248.60
fi


# -------------------------------------------------------------------------------------------------
# Script intro
# -------------------------------------------------------------------------------------------------


echo | tee -a -i $logfilepath
echo $BASHScriptDescription', script version '$ScriptVersion', revision '$ScriptRevision' from '$ScriptDate | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Date Time Group   :  '$DATEDTGS | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


#----------------------------------------------------------------------------------------
# Document working variables at start
#----------------------------------------------------------------------------------------

echo '-------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo 'Document working variables at start'  | tee -a -i $logfilepath
echo '-------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'targettftpserver                 = '$targettftpserver | tee -a -i $logfilepath

echo 'logfilefolderroot                = '$logfilefolderroot | tee -a -i $logfilepath
echo 'logfilefoldername                = '$logfilefoldername | tee -a -i $logfilepath
echo 'logfilefolder                    = '$logfilefolder | tee -a -i $logfilepath
echo 'logfilepath                      = '$logfilepath | tee -a -i $logfilepath

echo 'rootworkfolder                   = '$rootworkfolder | tee -a -i $logfilepath
echo 'customerfolderroot               = '$customerfolderroot | tee -a -i $logfilepath
echo 'targetfolder                     = '$targetfolder | tee -a -i $logfilepath
echo 'targetscriptsfolder              = '$targetscriptsfolder | tee -a -i $logfilepath
echo 'remotescriptsfolder              = '$remotescriptsfolder | tee -a -i $logfilepath
echo 'hostssetupscriptspackage         = '$hostssetupscriptspackage | tee -a -i $logfilepath
echo 'scriptspackage                   = '$scriptspackage | tee -a -i $logfilepath
echo 'latestupdatescript               = '$latestupdatescript | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo '-------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


read -t $WAITTIME -n 1 -p "Any key to continue.  Automatic continue after $WAITTIME seconds : " anykey; echo


# -------------------------------------------------------------------------------------------------
# Check target folder availability and then cd there
# -------------------------------------------------------------------------------------------------


cd $rootworkfolder | tee -a -i $logfilepath
pwd | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# Download scripts from tftp source
# -------------------------------------------------------------------------------------------------


echo | tee -a -i $logfilepath
echo "Fetch latest $hostssetupscriptspackage from tftp repository on $targettftpserver..." | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
#tftp -v -m binary $targettftpserver -c get /__gaia/__customer.tgz | tee -a -i $logfilepath
tftp -v -m binary $targettftpserver -c get $remotescriptsfolder/$hostssetupscriptspackage | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# untar scripts
# -------------------------------------------------------------------------------------------------


echo | tee -a -i $logfilepath
echo "untar the host setup scripts package..." | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

gtar -zxvf $hostssetupscriptspackage | tee -a -i $logfilepath

# -------------------------------------------------------------------------------------------------
# document and check if the required folder is ready
# -------------------------------------------------------------------------------------------------


echo | tee -a -i $logfilepath

ls -alhR $customerrootfolder | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
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
        
        echo "$targetfolder/$targetscriptsfolder found, removing..." | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
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
        
    else
        # scripts folder doesn't exists, so we might not have scripts
        
        echo "$targetfolder/$targetscriptsfolder NOT found..." | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
    fi
    
    echo "Cleanup and script version files..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    export oldversionfile=`ls $targetfolder/scripts.*.version`
    if [ -r $oldversionfile ]; then    
        echo "Remove old version file from main target folder... $oldversionfile" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        rm -f $targetfolder/scripts.*.version | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
    
    # next [re-]create scripts folder
    echo "Create/Check scripts folder..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    if [ -r $targetfolder/$targetscriptsfolder ]; then
        mkdir -pv $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath
        chmod 775 $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath
    else
        chmod 775 $targetfolder/$targetscriptsfolder | tee -a -i $logfilepath
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
