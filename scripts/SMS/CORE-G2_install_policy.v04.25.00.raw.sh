#!/bin/bash
#
# SCRIPT Install Policy for CORE-G2
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

export BASHScriptFileNameRoot==CORE-G2_install_policy
export BASHScriptShortName=CORE-G2_install_policy.v$ScriptVersion
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription=="Install Policy for CORE-G2"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=SMS

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


WAITTIME=20


# -------------------------------------------------------------------------------------------------
# CheckAndUnlockGaiaDB - Check and Unlock Gaia database
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-01-31 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CheckAndUnlockGaiaDB () {
    #
    # CheckAndUnlockGaiaDB - Check and Unlock Gaia database
    #
    
    echo -n 'Unlock gaia database : '

    export gaiadbunlocked=false

    until $gaiadbunlocked ; do

        export checkgaiadblocked=`clish -i -c "lock database override" | grep -i "owned"`
        export isclishowned=`test -z $checkgaiadblocked; echo $?`

        if [ $isclishowned -eq 1 ]; then 
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

#CheckAndUnlockGaiaDB

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# Start of Script Operations
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# local scripts variables configuration
# -------------------------------------------------------------------------------------------------


targetfolder=/var/log/__customer/upgrade_export


# -------------------------------------------------------------------------------------------------
# logfile configuration
# -------------------------------------------------------------------------------------------------


# setup initial log file for output logging
export logfilefolder=$targetfolder/dump/$DATEDTGS.$BASHScriptShortName
export logfilepath=$logfilefolder/$BASHScriptName.$DATEDTGS.log

if [ ! -w $logfilefolder ]; then
    mkdir -pv $logfilefolder
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
# script plumbing 1
# -------------------------------------------------------------------------------------------------


mgmt_cli -r true install-policy policy-package "G2-Standard" access true threat-prevention false targets.1 "beasleysmcias01" -f json | tee -a -i $logfilepath

mgmt_cli -r true install-policy policy-package "G2-Standard" access true threat-prevention true targets.1 "beasleysmcias01" -f json | tee -a -i $logfilepath


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

echo
echo 'Script Completed, exiting...';echo


