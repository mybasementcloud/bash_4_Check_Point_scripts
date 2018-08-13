#!/bin/bash
#
# SCRIPT for BASH to generate a dump folder based on the current time and date
# run healthcheck script, and dump result files into the dtg folder
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.04.00
ScriptDate=2018-08-12
#

export BASHScriptVersion=v00x04x00

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

# points to where jq is installed
export JQ=${CPDIR}/jq/jq
    
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


#export outputpathbase=$outputpathroot/$DATE
export outputpathbase=$outputpathroot/$DATEDTGS
#export outputpathbase=$outputpathroot/$DATEYMD

if [ ! -r $outputpathroot ] 
then
    mkdir $outputpathroot
fi
if [ ! -r $outputpathbase ] 
then
    mkdir $outputpathbase
fi

echo 'Created folder :  '$outputpathbase
echo

./healthcheck

# logfile=/var/log/$(hostname)-health_check-$(date +%Y%m%d%H%M).txt
# full_output_log=/var/log/$(hostname)-health_check_full-$(date +%Y%m%d%H%M).log
# csv_log=/var/log/$(hostname)-health_check-summary-$(date +%Y%m%d%H%M).csv
#
#export hclogfilebase=/var/log/$(hostname)-health_check-*
#
# Modified in healthcheck.sh v 05.04
# logfile=/var/log/$(hostname)_health-check_$(date +%Y%m%d%H%M).txt
# full_output_log=/var/log/$(hostname)_health-check_full_$(date +%Y%m%d%H%M).log
# csv_log=/var/log/$(hostname)_health-check_summary_$(date +%Y%m%d%H%M).csv
#
export hclogfilebase=/var/log/$(hostname)_health-check_*

echo
echo 'Moving healthcheck log files to '$outputpathbase
echo
mv $hclogfilebase $outputpathbase

echo
ls -al $outputpathbase
echo
