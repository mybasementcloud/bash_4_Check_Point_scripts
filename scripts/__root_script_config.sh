#!/bin/bash
#
# SCRIPT Root Script Configuration Parameters
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
RootScriptVersion=01.04.00
RootScriptDate=2018-09-29
#

RootScriptVersion=v01x04x00
RootScriptName=__root_script_config.v$RootScriptVersion
RootScriptDescription="Template for bash scripts"


# =============================================================================
# =============================================================================
# 
# =============================================================================

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

# points to where jq is installed
if [ -r ${CPDIR}/jq/jq ] ; then
    export JQ=${CPDIR}/jq/jq
elif [ -r /opt/CPshrd-R80/jq/jq ] ; then
    export JQ=/opt/CPshrd-R80/jq/jq
else
    export JQ=
fi

# WAITTIME in seconds for read -t commands
export WAITTIME=60

export customerpathroot=/var/log/__customer
export customerworkpathroot=$customerpathroot/upgrade_export
export outputpathroot=$customerworkpathroot
export dumppathroot=$customerworkpathroot/dump
export changelogpathroot=$customerworkpathroot/Change_Log



# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
