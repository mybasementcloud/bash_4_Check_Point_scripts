#!/bin/bash
#
# Gateway - Reset Hit Count to zero, backing up current
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.03.00
ScriptDate=2018-06-30
#

export BASHScriptVersion=v00x03x00


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


if [ ! -r $customerworkpathroot ]; then
    mkdir $customerworkpathroot
fi
if [ ! -r $changelogpathroot ]; then
    mkdir $changelogpathroot
fi

export logroot=$customerworkpathroot
export logpath=$changelogpathroot
export logfile=$logpath/reset_hit_count.$HOSTNAME.$DATEDTGS.txt

if [ ! -r $logroot ]; then
    mkdir $logroot
fi
if [ ! -r $logpath ]; then
    mkdir $logpath
fi

export workfilepath=$CPDIR/database/cpeps
export bufilepath=$workfilepath/BACKUP.$DATEDTGS

touch $logfile
echo >> $logfile
echo 'Start operation to reset hit count on '$HOSTNAME' at '$DATEDTGS >> $logfile
echo >> $logfile

cd $workfilepath/ >> $logfile
echo >> $logfile

mkdir $bufilepath >> $logfile
echo >> $logfile

echo >> $logfile
echo 'Stop gateway services again' >> $logfile
echo 'Stop gateway services again'
echo >> $logfile

cpstop > $logfile
echo >> $logfile

echo >> $logfile
echo 'Backup hit count files to '$bufilepath >> $logfile
echo 'Backup hit count files to '$bufilepath
echo >> $logfile
echo

cp *1.3.6.1.4.1.2620.1.45.5* $bufilepath/ >> $logfile
echo >> $logfile

echo >> $logfile
echo 'Remove hit count files' >> $logfile
echo 'Remove hit count files'
echo >> $logfile
echo

rm *1.3.6.1.4.1.2620.1.45.5* >> $logfile
echo >> $logfile

echo >> $logfile
echo 'Start gateway services again' >> $logfile
echo 'Start gateway services again'
echo >> $logfile

cpstart >> $logfile
echo >> $logfile

echo >> $logfile
echo 'Finished operation to reset hit count on '$HOSTNAME' at '$DATEDTGS >> $logfile
echo >> $logfile

cd %logroot

echo 'Log File : '$logfile
echo