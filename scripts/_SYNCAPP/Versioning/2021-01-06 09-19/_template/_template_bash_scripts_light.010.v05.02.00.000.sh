#!/bin/bash
#
# SCRIPT Template for bash scripts, light, level - 006
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
ScriptDate=2020-12-22
ScriptVersion=05.02.00
ScriptRevision=000
TemplateVersion=05.02.00
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

export BASHScriptFileNameRoot=_template_bash_scripts_light
export BASHScriptShortName=_template_light.${TemplateLevel}.v${ScriptVersion}
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Template Light for bash scripts"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}

export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=_template

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
export OutputYMSubfolder=true
export OutputDTGSSubfolder=true
export OutputSubfolderScriptName=false
export OutputSubfolderScriptShortName=true

export OutputDTGTZinUTC=false


# -------------------------------------------------------------------------------------------------
# Local logfile variables
# -------------------------------------------------------------------------------------------------


export logfilefolderroot=/var/log/__customer/upgrade_export
export logfilefoldername=dump


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
# END: Basic Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


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


# -------------------------------------------------------------------------------------------------
# Script intro
# -------------------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo ${BASHScriptName}', script version '${ScriptVersion}', revision '${ScriptRevision}' from '${ScriptDate} | tee -a -i ${logfilepath}
echo ${BASHScriptDescription} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Date Time Group   :  '${DATEDTGS} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# -------------------------------------------------------------------------------------------------
# script plumbing 1
# -------------------------------------------------------------------------------------------------


# do something


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
