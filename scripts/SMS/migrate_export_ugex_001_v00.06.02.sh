#!/bin/bash
#
# SCRIPT for BASH to execute migrate export to /var/upgrade_export folder
# using /var/upgrade_export/migration_tools/<version>/migrate file
#
ScriptVersion=00.06.02
ScriptDate=2018-03-29
#

export BASHScriptVersion=v00x06x02

#points to where jq is installed
#export JQ=${CPDIR}/jq/jq

export DATE=`date +%Y-%m-%d-%H%M%Z`

echo 'Date Time Group   :  '$DATE
echo

# WAITTIME in seconds for read -t commands
export WAITTIME=60
export outputpathroot=/var/upgrade_export
export outputpathbase=$outputpathroot
#export outputpathbase=$outputpathroot/$DATE

#
# shell meat
#
OPT="$1"
if [ x"$OPT" = x"--test" ]; then
    export testmode=1
    echo "Test Mode Active! testmode = $testmode"
else
    export testmode=0
fi

export gaiaversion=$(clish -c "show version product" | cut -d " " -f 6)
echo 'Gaia Version : $gaiaversion = '$gaiaversion
echo

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

#if [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
#    echo "System is Multi-Domain Management Server!"
#elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
#    echo "System is Security Management Server!"
#else
#    echo "System is a gateway!"
#fi
#echo

if [ $Check4EP773000 -gt 0 ] && [ $Check4EP773003 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.03"
    export gaiaversion=R77.30.03
    export toolsversion=$gaiaversion'_EP'
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773002 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.02"
    export gaiaversion=R77.30.02
    export toolsversion=$gaiaversion'_EP'
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773001 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.01"
    export gaiaversion=R77.30.01
    export toolsversion=$gaiaversion'_EP'
elif [ $Check4EP773000 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30"
    export gaiaversion=R77.30
    export toolsversion=$gaiaversion'_EP'
else
    echo "Not Gaia Endpoint Security Server"
fi

echo
echo 'Final $gaiaversion = '$gaiaversion
echo

CPVer80=`echo "$gaiaversion" | grep -c "R80"`
CPVer77=`echo "$gaiaversion" | grep -c "R77"`

export targetversion=$gaiaversion


if [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
    echo "System is Multi-Domain Management Server!"
    echo
    echo "This script is not meant for MDM, exiting!"
    exit 255
elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
    echo "System is Security Management Server!"
    echo
    echo "Continueing with SMS migrate export..."
    echo
else
    echo "System is a gateway!"
    echo
    echo "This script is not meant for gateways, exiting!"
    exit 255
fi

export outputfilepath=$outputpathbase/
export outputfileprefix=ugex_$HOSTNAME'_'$gaiaversion
export outputfilesuffix='_'$DATE
export outputfiletype=.tgz

if [ ! -r $outputpathroot ] 
then
    mkdir $outputpathroot
fi
if [ ! -r $outputpathbase ] 
then
    mkdir $outputpathbase
fi
if [ ! -r $outputfilepath ] 
then
    mkdir $outputfilepath
fi

export migratefilefolderroot=migration_tools/$toolsversion
export migratefilename=migrate

export migratefilepath=$outputpathbase/$migratefilefolderroot/
export migratefile=$migratefilepath$migratefilename

if [ ! -r $migratefilepath ]
then
    echo '!! CRITICAL ERROR!!'
    echo '  Missing migrate file folder!'
    echo '  Missing folder : '$migratefilepath
    echo ' EXITING...'
    echo

    exit 255
fi

if [ ! -r $migratefile ]
then
    echo '!! CRITICAL ERROR!!'
    echo '  Missing migrate executable file !'
    echo '  Missing executable file : '$migratefile
    echo ' EXITING...'
    echo

    exit 255
fi

echo
echo '--------------------------------------------------------------------------'
echo

export command2run='export -n'
export outputfile=$outputfileprefix$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute command : '$migratefile $command2run
echo ' with ouptut to : '$outputfilefqdn
echo
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------'

echo
echo 'Preparing ...'
echo

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh
echo
cpwd_admin list

echo
echo 'cpstop ...'
echo

cpstop

echo
echo 'cpstop completed'
echo

echo '--------------------------------------------------------------------------'
echo
echo 'Executing...'
echo '-> '$migratefile $command2run $outputfilefqdn
echo

if [ $testmode -eq 0 ]; then
    # Not test mode
    $migratefile $command2run $outputfilefqdn
else
    # test mode
    echo Test Mode!
fi

echo
echo 'Done performing '$migratefile $command2run
echo
ls -alh $outputfilefqdn
echo

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh
echo
cpwd_admin list

echo
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------'

echo
echo 'Clean-up, stop, and [re-]start services...'
echo

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh
echo
cpwd_admin list

echo
echo 'cpstop ...'
echo

cpstop

echo
echo 'cpstop completed'
echo

echo
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------'

echo "Short $WAITTIME second nap..."
sleep $WAITTIME

echo
echo 'cpstart...'
echo

sleep $WAITTIME

cpstart

echo
echo 'cpstart completed'
echo

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh
echo
cpwd_admin list

echo
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------'

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh
echo
cpwd_admin list

if [ $CPVer80 -gt 0 ]; then
    # R80 version so kick the API on
    echo
    echo 'api start ...'
    echo
    
    api start
    
    echo
    echo 'api start completed'
    echo
else
    # not R80 version so no API
    echo
fi

#
# end shell meat
#


echo '--------------------------------------------------------------------------'
echo
echo 'CLI Operations Completed'

#
# shell clean-up and log dump
#

echo
ls -alh $outputpathroot

echo
echo 'Done!'
echo
echo '--------------------------------------------------------------------------'
echo '--------------------------------------------------------------------------'
echo '--------------------------------------------------------------------------'
echo
echo
