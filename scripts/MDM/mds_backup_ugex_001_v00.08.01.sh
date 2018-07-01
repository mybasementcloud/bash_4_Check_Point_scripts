#!/bin/bash
#
# SCRIPT for BASH to execute mds_backup to /var/log/__customer/upgrade_export/backups folder
# using mds_backup
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.08.01
ScriptDate=2018-06-30
#

export BASHScriptVersion=v00x08x01

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


if [ ! -r $outputpathroot ]; then
    mkdir $outputpathroot
fi

export logpathroot=$outputpathroot

if [ ! -r $logpathroot ]; then
    mkdir $logpathroot
fi

export logpathbase=$logpathroot/$DATEDTGS

if [ ! -r $logpathbase ]; then
    mkdir $logpathbase
fi

export logfilepath=$logpathbase/log_mds_backup_upugex_$DATEDTGS.log
touch $logfilepath

#
# shell meat
#
OPT="$1"
if [ x"$OPT" = x"--test" ]; then
    export testmode=1
    echo "Test Mode Active! testmode = $testmode" | tee -a -i $logfilepath
else
    export testmode=0
fi

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Gaia version and installatin type
# -------------------------------------------------------------------------------------------------

export gaiaversion=$(clish -c "show version product" | cut -d " " -f 6)
echo 'Gaia Version : $gaiaversion = '$gaiaversion | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

export toolsversion=$gaiaversion

workfile=/var/tmp/cpinfo_ver.txt
cpinfo -y all > $workfile 2>&1
Check4EP773003=`grep -c "Endpoint Security Management R77.30.03 " $workfile`
Check4EP773002=`grep -c "Endpoint Security Management R77.30.02 " $workfile`
Check4EP773001=`grep -c "Endpoint Security Management R77.30.01 " $workfile`
Check4EP773000=`grep -c "Endpoint Security Management R77.30 " $workfile`
Check4EP=`grep -c "Endpoint Security Management" $workfile`
Check4SMS=`grep -c "Security Management Server" $workfile`
rm $workfile

if [ "$MDSDIR" != '' ]; then
    Check4MDS=1
else 
    Check4MDS=0
fi

if [ $Check4EP773000 -gt 0 ] && [ $Check4EP773003 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.03" | tee -a -i $logfilepath
    export gaiaversion=R77.30.03
    export toolsversion=$gaiaversion'_EP'
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773002 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.02" | tee -a -i $logfilepath
    export gaiaversion=R77.30.02
    export toolsversion=$gaiaversion'_EP'
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773001 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.01" | tee -a -i $logfilepath
    export gaiaversion=R77.30.01
    export toolsversion=$gaiaversion'_EP'
elif [ $Check4EP773000 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30" | tee -a -i $logfilepath
    export gaiaversion=R77.30
    export toolsversion=$gaiaversion'_EP'
else
    echo "Not Gaia Endpoint Security Server" | tee -a -i $logfilepath
fi

echo | tee -a -i $logfilepath
echo 'Final $gaiaversion = '$gaiaversion | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

CPVer80=`echo "$gaiaversion" | grep -c "R80"`
CPVer77=`echo "$gaiaversion" | grep -c "R77"`

export targetversion=$gaiaversion


if [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
    echo "System is Multi-Domain Management Server!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "Continueing with MDS Backup..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
    echo "System is Security Management Server!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "This script is not meant for SMS, exiting!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    exit 255
else
    echo "System is a gateway!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "This script is not meant for gateways, exiting!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    exit 255
fi

# -------------------------------------------------------------------------------------------------
# END: Gaia version and installatin type
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


export outputpathbase=$customerworkpathroot/backups

if [ ! -r $outputpathbase ]; then
    mkdir $outputpathbase | tee -a -i $logfilepath
fi

export outputpathbase=$outputpathbase/$DATE

if [ ! -r $outputpathbase ]; then
    mkdir $outputpathbase | tee -a -i $logfilepath
fi

export outputfilepath=$outputpathbase/
export outputfileprefix=mdsbu_$HOSTNAME'_'$gaiaversion
export outputfilesuffix='_'$DATE
export outputfiletype=.tgz

if [ ! -r $outputfilepath ]; then
    mkdir $outputfilepath | tee -a -i $logfilepath
fi

echo | tee -a -i $logfilepath
echo 'Execute command : mds_backup -b -l -i -s -d '"$outputfilepath" | tee -a -i $logfilepath
echo ' with ouptut to : '$outputfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------'

echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Preparing ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

cd "$outputfilepath" | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
pwd | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
mdsstat | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'mdsstop ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

mdsstop | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'mdsstop completed' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

mdsstat | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Executing mds_backup to : '$outputfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ $testmode -eq 0 ]; then
    # Not test mode
    mds_backup -b -l -i -s -d "$outputfilepath" | tee -a -i $logfilepath
else
    # test mode
    echo Test Mode! | tee -a -i $logfilepath
fi

echo | tee -a -i $logfilepath
echo 'Done performing mds_backup' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
ls -alh $outputfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'mdsstart ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

mdsstart | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'mdsstart completed' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

mdsstat | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Clean-up, stop, and [re-]start services...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

mdsstat | tee -a -i $logfilepath


echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'CLI Operations Completed' | tee -a -i $logfilepath

#
# shell clean-up and log dump
#

echo | tee -a -i $logfilepath
ls -alh $outputpathroot | tee -a -i $logfilepath

cd "$outputpathroot" | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
pwd | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Done!' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i  | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Backup Folder : '$outputfilepath | tee -a -i $logfilepath
echo 'Log File      : '$logfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

