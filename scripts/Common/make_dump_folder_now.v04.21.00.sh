#!/bin/bash
#
# SCRIPT for BASH to generate a dump folder based on the current time and date
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2020-01-05
ScriptVersion=04.21.00
ScriptRevision=004
TemplateLevel=006
TemplateVersion=04.20.00
SubScriptsLevel=NA
SubScriptsVersion=NA
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=make_dump_folder_now
export BASHScriptShortName="make_dump_folder_now"
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription=="Generate a dump folder based on the current time and date"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=Common

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
# -------------------------------------------------------------------------------------------------
# START: Root Script Configuration
# -------------------------------------------------------------------------------------------------

export scriptspathroot=/var/log/__customer/upgrade_export/scripts
export rootscriptconfigfile=__root_script_config.sh


# -------------------------------------------------------------------------------------------------
# localrootscriptconfiguration - Local Root Script Configuration setup
# -------------------------------------------------------------------------------------------------

localrootscriptconfiguration () {
    #
    # Local Root Script Configuration setup
    #

    # WAITTIME in seconds for read -t commands
    export WAITTIME=60
    
    export customerpathroot=/var/log/__customer
    export customerworkpathroot=$customerpathroot/upgrade_export
    export outputpathroot=$customerworkpathroot/dump
    export changelogpathroot=$customerworkpathroot/Change_Log
    
    echo
    return 0
}


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

if [ -r "$scriptspathroot/$rootscriptconfigfile" ] ; then
    # Found the Root Script Configuration File in the folder for scripts
    # So let's call that script to configure what we need

    . $scriptspathroot/$rootscriptconfigfile "$@"
    errorreturn=$?
elif [ -r "../$rootscriptconfigfile" ] ; then
    # Found the Root Script Configuration File in the folder above the executiong script
    # So let's call that script to configure what we need

    . ../$rootscriptconfigfile "$@"
    errorreturn=$?
elif [ -r "$rootscriptconfigfile" ] ; then
    # Found the Root Script Configuration File in the folder with the executiong script
    # So let's call that script to configure what we need

    . $rootscriptconfigfile "$@"
    errorreturn=$?
else
    # Did not the Root Script Configuration File
    # So let's call local configuration

    localrootscriptconfiguration "$@"
    errorreturn=$?
fi


# -------------------------------------------------------------------------------------------------
# END:  Root Script Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


export outputpathbase=$dumppathroot/$DATEYMD

if [ ! -r $outputpathroot ] ; then
    mkdir -pv $outputpathroot
fi
if [ ! -r $dumppathroot ] ; then
    mkdir -pv $dumppathroot
fi
if [ ! -r $outputpathbase ] ; then
    mkdir -pv $outputpathbase
fi

echo 'Created folder :  '$outputpathbase
echo
ls -al $outputpathbase
echo

echo 'Done...'
echo
