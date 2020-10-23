#!/bin/bash
#
# SCRIPT Root Script Configuration Parameters
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
ScriptDate=2020-10-22
ScriptVersion=04.40.00
ScriptRevision=000
TemplateVersion=04.40.00
TemplateLevel=006
SubScriptsLevel=006
SubScriptsVersion=04.12.00
#

RootScriptVersion=v${RootScriptVersion//./x}
#RootScriptName=__root_script_config.v$RootScriptVersion
RootScriptName=__root_script_config
RootScriptShortName=__root_script_config
RootScriptDescription="Root Script Configuration Parameters"


# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# Date and Time related values and formulas
# =============================================================================


export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`


# WAITTIME in seconds for read -t commands
export WAITTIME=15


# =============================================================================
# Standard paths and folders
# =============================================================================

export customerpathroot=/var/log/__customer
export customerdownloadpathroot=$customerpathroot/download
export downloadpathroot=$customerdownloadpathroot
export customerscriptspathroot=$customerpathroot/_scripts
export scriptspathmain=$customerscriptspathroot
export scriptspathb4CP=$scriptspathmain/bash_4_Check_Point
export customerworkpathroot=$customerpathroot/upgrade_export
export outputpathroot=$customerworkpathroot
export dumppathroot=$customerworkpathroot/dump
export changelogpathroot=$customerworkpathroot/Change_Log


# =============================================================================
# TFTP Export values
# =============================================================================

#
# Set EXPORTRESULTSTOTFPT to:
#   true    to export results from operation to one of the following defined target folders on the identified TFTP servers
#   false   to skip export of results to identified TFTP servers
#
# This section expects definition of the following external variables.  These are usually part of the user profile setup in the $HOME folder
#  MYTFTPSERVER     default TFTP/FTP server to use for TFTP/FTP operations, usually set to one of the following
#  MYTFTPSERVER1    first TFTP/FTP server to use for TFTP/FTP operations
#  MYTFTPSERVER2    second TFTP/FTP server to use for TFTP/FTP operations
#  MYTFTPSERVER3    third TFTP/FTP server to use for TFTP/FTP operations
#
#  MYTFTPSERVER* values are assumed to be an IPv4 Address (0.0.0.0 to 255.255.255.255) that represents a valid TFTP/FTP target host.
#  Setting one of the MYTFTPSERVER* to blank ignores that host.  Future scripts may include checks to see if the host actually has a reachable TFTP/FTP server
#
export EXPORTRESULTSTOTFPT=true
export tftptargetfolder_root=/_GAIA_CONFIG


# =============================================================================
# JSON Query JQ and version specific JQ16 values
# =============================================================================

export JQNotFound=true
export UseJSONJQ=false

# JQ points to where the default jq is installed, probably version 1.4
if [ -r ${CPDIR}/jq/jq ] ; then
    export JQ=${CPDIR}/jq/jq
    export JQNotFound=false
    export UseJSONJQ=true
elif [ -r ${CPDIR_PATH}/jq/jq ] ; then
    export JQ=${CPDIR_PATH}/jq/jq
    export JQNotFound=false
    export UseJSONJQ=true
elif [ -r ${MDS_CPDIR}/jq/jq ] ; then
    export JQ=${MDS_CPDIR}/jq/jq
    export JQNotFound=false
    export UseJSONJQ=true
else
    export JQ=
    export JQNotFound=true
    export UseJSONJQ=false
fi

# JQ16 points to where jq 1.6 is installed, which is not generally part of Gaia, even R80.40EA (2020-01-20)
export JQ16NotFound=true
export UseJSONJQ16=false

# As of template version v04.21.00 we also added jq version 1.6 to the mix and it lives in the customer path root /tools/JQ folder by default
export JQ16PATH=$customerpathroot/_tools/JQ
export JQ16FILE=jq-linux64
export JQ16FQFN=$JQ16PATH/$JQ16FILE

if [ -r $JQ16FQFN ] ; then
    # OK we have the easy-button alternative
    export JQ16=$JQ16FQFN
    export JQ16NotFound=false
    export UseJSONJQ16=true
elif [ -r "./_tools/JQ/$JQ16FILE" ] ; then
    # OK we have the local folder alternative
    export JQ16=./_tools/JQ/$JQ16FILE
    export JQ16NotFound=false
    export UseJSONJQ16=true
elif [ -r "../_tools/JQ/$JQ16FILE" ] ; then
    # OK we have the parent folder alternative
    export JQ16=../_tools/JQ/$JQ16FILE
    export JQ16NotFound=false
    export UseJSONJQ16=true
else
    # nope, not part of the package, so clear the values
    export JQ16=
    export JQ16NotFound=true
    export UseJSONJQ16=false
fi


# =============================================================================
# More root script configuration values?
# =============================================================================

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
