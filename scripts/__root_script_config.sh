#!/bin/bash
#
# SCRIPT Root Script Configuration Parameters
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-09-28
ScriptVersion=04.11.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.11.00
SubScriptsLevel=006
SubScriptsVersion=04.01.00
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


export tftptargetfolder_root=/_GAIA_CONFIG
export tftptargetfolder_configcapture=$tftptargetfolder_root/host_data
export tftptragetforder_healthcheck=$tftptargetfolder_root/healthchecks
export tftptragetforder_interfaceinfo=$tftptargetfolder_root/host_interface_info

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
