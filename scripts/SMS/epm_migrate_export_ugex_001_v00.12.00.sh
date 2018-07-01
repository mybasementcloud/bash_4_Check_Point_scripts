#!/bin/bash
#
# SCRIPT for BASH to execute migrate export to /var/log/__customer/upgrade_export folder
# using /var/log/__customer/upgrade_export/migration_tools/<version>/migrate file
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.12.00
ScriptDate=2018-06-30
#

export BASHScriptVersion=v00x12x00

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

export logfilepath=$logpathbase/log_epm_migrate_export_ugex_$DATEDTGS.log
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


# -------------------------------------------------------------------------------------------------
# END: Gaia version and installatin type
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Validate we are working on a system that handles this operation
# -------------------------------------------------------------------------------------------------

if [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
    echo "System is Security Management Server!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "Continueing with SMS Migrate Export..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
    echo "System is Multi-Domain Management Server!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "This script is not meant for MDS, exiting!" | tee -a -i $logfilepath
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
# -------------------------------------------------------------------------------------------------

export outputpathbase=$customerworkpathroot
#export outputpathbase=$outputpathroot/$DATEDTGS


export outputfilepath=$outputpathbase/
export outputfileprefix=ugex_$HOSTNAME'_'$gaiaversion
export outputfilesuffix='_'$DATEDTGS
export outputfiletype=.tgz

if [ ! -r $outputpathroot ]; then
    mkdir $outputpathroot | tee -a -i $logfilepath
fi
if [ ! -r $outputpathbase ]; then
    mkdir $outputpathbase | tee -a -i $logfilepath
fi
if [ ! -r $outputfilepath ]; then
    mkdir $outputfilepath | tee -a -i $logfilepath
fi

export migratefilefolderroot=migration_tools/$toolsversion
export migratefilename=migrate

export migratefilepath=$outputpathbase/$migratefilefolderroot/
export migratefile=$migratefilepath$migratefilename

if [ ! -r $migratefilepath ]; then
    echo '!! CRITICAL ERROR!!' | tee -a -i $logfilepath
    echo '  Missing migrate file folder!' | tee -a -i $logfilepath
    echo '  Missing folder : '$migratefilepath | tee -a -i $logfilepath
    echo ' EXITING...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    exit 255
fi

if [ ! -r $migratefile ]; then
    echo '!! CRITICAL ERROR!!' | tee -a -i $logfilepath
    echo '  Missing migrate executable file !' | tee -a -i $logfilepath
    echo '  Missing executable file : '$migratefile | tee -a -i $logfilepath
    echo ' EXITING...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    exit 255
fi

echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

export command2run='export -n'
export outputfile=$outputfileprefix$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export command2run2='export -n -l --include-uepm-msi-files'
export outputfile2=$outputfileprefix'_msi_logs_'$outputfilesuffix$outputfiletype
export outputfilefqdn2=$outputfilepath$outputfile2

echo | tee -a -i $logfilepath
echo 'Execute command : '$migratefile $command2run | tee -a -i $logfilepath
echo ' with ouptut to : '$outputfilefqdn | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ $Check4EP773000 -gt 0 ]; then
    echo 'Execute command 2 : '$migratefile $command2run2 | tee -a -i $logfilepath
    echo ' with ouptut 2 to : '$outputfilefqdn2 | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
fi

read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Preparing ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ x"$toolsversion" = x"R80.20" ] || [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'cpstop ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

cpstop | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'cpstop completed' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Executing...' | tee -a -i $logfilepath
echo '-> '$migratefile $command2run $outputfilefqdn | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ $testmode -eq 0 ]; then
    # Not test mode
    $migratefile $command2run $outputfilefqdn | tee -a -i $logfilepath

    if [ $Check4EP773000 -gt 0 ]; then
        $migratefile $command2run2 $outputfilefqdn2 | tee -a -i $logfilepath
    fi
else
    # test mode
    echo Test Mode! | tee -a -i $logfilepath
fi

echo | tee -a -i $logfilepath
echo 'Done performing '$migratefile $command2run | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
ls -alh $outputfilefqdn | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ x"$toolsversion" = x"R80.20" ] || [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Clean-up, stop, and [re-]start services...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ x"$toolsversion" = x"R80.20" ] || [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'cpstop ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

cpstop | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'cpstop completed' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

echo "Short $WAITTIME second nap..." | tee -a -i $logfilepath
sleep $WAITTIME

echo | tee -a -i $logfilepath
echo 'cpstart...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

sleep $WAITTIME

cpstart | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'cpstart completed' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ x"$toolsversion" = x"R80.20" ] || [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

if [ x"$toolsversion" = x"R80.20" ] || [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

if [ $CPVer80 -gt 0 ]; then
    # R80 version so kick the API on
    echo | tee -a -i $logfilepath
    echo 'api start ...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    api start | tee -a -i $logfilepath
    
    echo | tee -a -i $logfilepath
    echo 'api start completed' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    # not R80 version so no API
    echo | tee -a -i $logfilepath
fi

#
# end shell meat
#


echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'CLI Operations Completed' | tee -a -i $logfilepath

#
# shell clean-up and log dump
#

echo | tee -a -i $logfilepath
ls -alh $outputpathroot | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Done!' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo | tee -a -i  | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Backup Folder : '$outputfilepath | tee -a -i $logfilepath
ls -alh $outputfilepath/*.tgz | tee -a -i $logfilepath
echo 'Log File      : '$logfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

