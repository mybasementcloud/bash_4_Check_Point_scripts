#!/bin/bash
#
# SCRIPT Root Script Configuration Parameters
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
RootScriptVersion=00.02.00
RootScriptDate=2018-06-30
#

export BASHRootScriptVersion=v00x02x00

# =============================================================================
# =============================================================================
# 
# =============================================================================

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

# points to where jq is installed
export JQ=${CPDIR}/jq/jq

# WAITTIME in seconds for read -t commands
export WAITTIME=60

export customerpathroot=/var/log/__customer
export customerworkpathroot=$customerpathroot/upgrade_export
export outputpathroot=$customerworkpathroot/dump
export changelogpathroot=$customerworkpathroot/Change_Log



# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
