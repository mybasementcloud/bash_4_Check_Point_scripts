#!/bin/bash
#
# (C) 2016-2024 Eric James Beasley, mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
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
# -#- Start Making Changes Here -#- 
#
# Fix GW missing Updatable Objects
#
#
ScriptDate=2024-06-12
ScriptVersion=05.37.00
ScriptRevision=000
ScriptSubRevision=125
TemplateVersion=05.37.00
TemplateLevel=006
SubScriptsLevel=NA
SubScriptsVersion=NA
#

export BASHScriptVersion=v${ScriptVersion}
export BASHScriptTemplateVersion=v${TemplateVersion}

export BASHScriptVersionX=v${ScriptVersion//./x}
export BASHScriptTemplateVersionX=v${TemplateVersion//./x}

export BASHScriptTemplateLevel=${TemplateLevel}.v${TemplateVersion}

export BASHSubScriptsVersion=v${SubScriptsVersion}
export BASHSubScriptTemplateVersion=v${TemplateVersion}
export BASHExpectedSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion}

export BASHSubScriptsVersionX=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersionX=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersionX=${SubScriptsLevel}.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=fix_gw_missing_updatable_objects
export BASHScriptShortName=fix_gw_missing_updatable_objects
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Fix GW missing Updatable Objects"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}

export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}
export BASHScriptHelpFileExamplesName=${BASHScriptFileNameRoot}.examples.help
export BASHScriptHelpExamplesFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileExamplesName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|scripts_tools|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=_template

export BASHScripttftptargetfolder="_template"


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Basic Configuration
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Output formating values
# -------------------------------------------------------------------------------------------------

export txtCLEAR=`tput clear`

export txtNORM=`tput sgr0`
export txtBOLD=`tput bold`
export txtDIM=`tput dim`
export txtREVERSE=`tput rev`

export txtULINEbeg=`tput smul`
export txtULINEend=`tput rmul`

export txtSTANDOUTbeg=`tput smso`
export txtSTANDOUTend=`tput rmso`

export getWindowColumns=`tput cols`
export getWindowLines=`tput lines`


#tput setab color  Set ANSI Background color
#tput setaf color  Set ANSI Foreground color
export txtBLACK=`tput setaf 0`
export txtRED=`tput setaf 1`
export txtGREEN=`tput setaf 2`
export txtYELLOW=`tput setaf 3`
export txtBLUE=`tput setaf 4`
export txtMAGENTA=`tput setaf 5`
export txtCYAN=`tput setaf 6`
export txtWHITE=`tput setaf 7`
export txtDEFAULT=`tput setaf 9`

export txtbkgBLACK=`tput setab 0`
export txtbkgRED=`tput setab 1`
export txtbkgGREEN=`tput setab 2`
export txtbkgYELLOW=`tput setab 3`
export txtbkgBLUE=`tput setab 4`
export txtbkgMAGENTA=`tput setab 5`
export txtbkgCYAN=`tput setab 6`
export txtbkgWHITE=`tput setab 7`
export txtbkgDEFAULT=`tput setab 9`


# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------


export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

export DATEUTC=`date -u +%Y-%m-%d-%H%M%Z`
export DATEUTCDTG=`date -u +%Y-%m-%d-%H%M%Z`
export DATEUTCDTGS=`date -u +%Y-%m-%d-%H%M%S%Z`
export DATEUTCYMD=`date -u +%Y-%m-%d`


# -------------------------------------------------------------------------------------------------
# Other variable configuration
# -------------------------------------------------------------------------------------------------


WAITTIME=20

B4CPSCRIPTVERBOSE=false


# -------------------------------------------------------------------------------------------------
# logfile naming control variables
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-12 -
# if we are date-time stamping the output location as a subfolder of the 
# output folder set this to true,  otherwise it needs to be false
#
# OutputEnableLogFile             : true|false : log output to log file
#
# OutputYearSubfolder             : true|false : Add a folder level with just the year (YYYY)
# OutputYMSubfolder               : true|false : Add a folder level with the year-month (YYYY-MM)
# OutputDTGSSubfolder             : true|false : Add a folder level with Date Time Group with Seconds (YYYY-MM-DD-HHmmSS)
# Append script name to output subfolder, only one of these should be true, ignored if both are false
# OutputSubfolderScriptName       : true|false : Add full script name to folder name of output folder
#                                 :: setting this value true will override OutputSubfolderScriptShortName
# OutputSubfolderScriptShortName  : true|false : Add short script name to folder name of output folder
#
# OutputDTGTZinUTC                : true|false : Instead of using the local timezone in logs use UTC timezone
#

export OutputEnableLogFile=true

export OutputYearSubfolder=true
export OutputYMSubfolder=false
export OutputDTGSSubfolder=true
export OutputSubfolderScriptName=false
export OutputSubfolderScriptShortName=true

export OutputDTGTZinUTC=false


# -------------------------------------------------------------------------------------------------
# Local logfile variables
# -------------------------------------------------------------------------------------------------


export logfilefolderroot=/var/log/__customer/upgrade_export
export logfilefoldername=Change_Log


# -------------------------------------------------------------------------------------------------
# logfile configuration
# -------------------------------------------------------------------------------------------------


# ADDED 2020-12-22
# we need the quick version of the gaiaversion
cpreleasefile=/etc/cp-release
export getgaiaquickversion=$(cat ${cpreleasefile} | cut -d " " -f 4)
export gaiaquickversion=${getgaiaquickversion}

# setup initial log file for output logging
DATEYear=`date +%Y`
DATEYM=`date +%Y-%m`
export logfilefolder=${logfilefolderroot}/${logfilefoldername}
if $OutputYearSubfolder ; then
    export logfilefolder=${logfilefolder}/${DATEYear}
fi
if $OutputYMSubfolder ; then
    export logfilefolder=${logfilefolder}/${DATEYM}
fi
if ${OutputDTGSSubfolder} ; then
    if $OutputDTGTZinUTC ; then
        export logfilefolder=${logfilefolder}/${DATEUTCDTGS}
    else
        export logfilefolder=${logfilefolder}/${DATEDTGS}
    fi
fi
if ${OutputSubfolderScriptName} ; then
    export logfilefolder=${logfilefolder}.${BASHScriptName}
elif  ${OutputSubfolderScriptShortName} ; then
    export logfilefolder=${logfilefolder}.${BASHScriptShortName}
fi
# UPDATED 2020-12-22
if $OutputDTGTZinUTC ; then
    export logfilepath=${logfilefolder}/${BASHScriptName}.${HOSTNAME}.${gaiaquickversion}.${DATEUTCDTGS}.log
    #export logfilepath=${logfilefolder}/${BASHScriptName}.${DATEUTCDTGS}.log
else
    export logfilepath=${logfilefolder}/${BASHScriptName}.${HOSTNAME}.${gaiaquickversion}.${DATEDTGS}.log
    #export logfilepath=${logfilefolder}/${BASHScriptName}.${DATEDTGS}.log
fi

if ${OutputEnableLogFile} ; then
    # We are logging, so create the initial working folder and log file
    if [ ! -w ${logfilefolder} ]; then
        mkdir -pv ${logfilefolder} > /dev/null
    fi
    
    touch ${logfilepath}
    
    echo
else
    # We are NOT logging, so don't create the initial working folder and log file
    # set the logfilepath to device null /dev/null to squelch the output
    
    export logfilepath=/dev/null
    echo
fi


# -------------------------------------------------------------------------------------------------
# CheckAndUnlockGaiaDB - Check and Unlock Gaia database
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CheckAndUnlockGaiaDB () {
    #
    # CheckAndUnlockGaiaDB - Check and Unlock Gaia database
    #
    
    echo -n 'Unlock gaia database : '
    
    export gaiadbunlocked=false
    
    until ${gaiadbunlocked} ; do
        
        export checkgaiadblocked=`clish -i -c "lock database override" | grep -i "owned"`
        export isclishowned=`test -z ${checkgaiadblocked}; echo $?`
        
        if [ ${isclishowned} -eq 1 ]; then 
            echo -n '.'
            export gaiadbunlocked=false
        else
            echo -n '!'
            export gaiadbunlocked=true
        fi
        
    done
    
    echo; echo
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

#CheckAndUnlockGaiaDB

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# Start of Script Operations
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Local Operations variables
# -------------------------------------------------------------------------------------------------


targetfolder=/var/log/__customer/upgrade_export


#==================================================================================================
# Announce Script, this should also be the first log entry!
#==================================================================================================


# MODIFIED 2023-02-17:01 -

echo | tee -a -i ${logfilepath}
echo ${txtCYAN}${BASHScriptName}${txtDEFAULT}', script version '${txtYELLOW}${ScriptVersion}${txtDEFAULT}', revision '${txtYELLOW}${ScriptRevision}${txtDEFAULT}', subrevision '${txtGREEN}${ScriptSubRevision}${txtDEFAULT}' from '${txtYELLOW}${ScriptDate}${txtDEFAULT} | tee -a -i ${logfilepath}
echo ${BASHScriptDescription} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Date Time Group   :  '${txtCYAN}${DATEDTGS}${txtDEFAULT} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# -------------------------------------------------------------------------------------------------
# script plumbing 1
# -------------------------------------------------------------------------------------------------

CheckAndUnlockGaiaDB
CheckAndUnlockGaiaDB


echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo 'Document initial state of ${CPDIR}/database/downloads/ONLINE_SERVICES/1.0/Update_Status.dat' | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

ls -alh ${CPDIR}/database/downloads/ONLINE_SERVICES/1.0/Update_Status.dat | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

ls -alh /opt/CPshrd-R81/database/downloads/ONLINE_SERVICES/1.0/ | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

cat ${CPDIR}/database/downloads/ONLINE_SERVICES/1.0/Update_Status.dat | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

cat /opt/CPshrd-R81/database/downloads/ONLINE_SERVICES/1.0/last_revision.xml | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

#export getclishprimarydns=`clish -i -c "show dns primary"`; export currentprimarydns=$getclishprimarydns; echo $currentprimarydns; echo

clish -i -c "show dns primary" | tee -a -i ${logfilepath}
export getclishprimarydns=`clish -i -c "show dns primary"`
export currentprimarydns=${getclishprimarydns}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

export settempprimarydns="set dns primary 8.8.8.8"
clish -i -c "${settempprimarydns}" | tee -a -i ${logfilepath}
clish -i -c "show dns primary" | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

unified_dl UPDATE ONLINE_SERVICES | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo 'Document updated state of ${CPDIR}/database/downloads/ONLINE_SERVICES/1.0/Update_Status.dat' | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

ls -alh ${CPDIR}/database/downloads/ONLINE_SERVICES/1.0/Update_Status.dat | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

ls -alh /opt/CPshrd-R81/database/downloads/ONLINE_SERVICES/1.0/ | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

cat ${CPDIR}/database/downloads/ONLINE_SERVICES/1.0/Update_Status.dat | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

cat /opt/CPshrd-R81/database/downloads/ONLINE_SERVICES/1.0/last_revision.xml | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

export setoriginalrimarydns="set dns primary ${currentprimarydns}"
clish -i -c "${setoriginalrimarydns}" | tee -a -i ${logfilepath}
clish -i -c "show dns primary" | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

# -------------------------------------------------------------------------------------------------
# Closing operations and log file information
# -------------------------------------------------------------------------------------------------


if [ -r nul ] ; then
    rm nul >> ${logfilepath}
fi

if [ -r None ] ; then
    rm None >> ${logfilepath}
fi

echo | tee -a -i ${logfilepath}
echo 'Log File : '${logfilepath} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# -------------------------------------------------------------------------------------------------
# End of script Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

echo
echo 'Script Completed, exiting...';echo
