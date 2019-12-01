#!/bin/bash
#
# SCRIPT Root Script Configuration Parameters
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-11-22
ScriptVersion=04.15.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.15.00
SubScriptsLevel=006
SubScriptsVersion=04.02.00
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

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

# points to where jq is installed
export JQNotFound=false

# points to where jq is installed
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
#elif [ -r /opt/CPshrd-R80/jq/jq ] ; then
#    export JQ=/opt/CPshrd-R80/jq/jq
#    export JQNotFound=false
#    export UseJSONJQ=true
#elif [ -r /opt/CPshrd-R80.10/jq/jq ] ; then
#    export JQ=/opt/CPshrd-R80.10/jq/jq
#    export JQNotFound=false
#    export UseJSONJQ=true
#elif [ -r /opt/CPshrd-R80.20/jq/jq ] ; then
#    export JQ=/opt/CPshrd-R80.20/jq/jq
#    export JQNotFound=false
#    export UseJSONJQ=true
else
    export JQ=
    export JQNotFound=true
    export UseJSONJQ=false
fi

# WAITTIME in seconds for read -t commands
export WAITTIME=15

export customerpathroot=/var/log/__customer
export customerworkpathroot=$customerpathroot/upgrade_export
export outputpathroot=$customerworkpathroot
export dumppathroot=$customerworkpathroot/dump
export changelogpathroot=$customerworkpathroot/Change_Log


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
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
