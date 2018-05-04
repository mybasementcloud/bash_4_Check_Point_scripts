#!/bin/bash
#
# SCRIPT for BASH to execute mds_backup to /var/upgrade_export/backups folder
# using mds_backup
#
ScriptVersion=00.06.01
ScriptDate=2018-05-04
#

export BASHScriptVersion=v00x06x01

#points to where jq is installed
#export JQ=${CPDIR}/jq/jq

export DATE=`date +%Y-%m-%d-%H%M%Z`

echo 'Date Time Group   :  '$DATE
echo

# WAITTIME in seconds for read -t commands
export WAITTIME=60
export outputpathroot=/var/upgrade_export
export outputpathbase=$outputpathroot/backups
export outputpathbase=$outputpathbase/$DATE

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
    echo "Continueing with MDS Backup..."
    echo
elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
    echo "System is Security Management Server!"
    echo
    echo "This script is not meant for SMS, exiting!"
    exit 255
    echo
else
    echo "System is a gateway!"
    echo
    echo "This script is not meant for gateways, exiting!"
    exit 255
fi

export outputfilepath=$outputpathbase/
export outputfileprefix=mdsbu_$HOSTNAME'_'$gaiaversion
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

#export migratefilefolderroot=migration_tools/$toolsversion
#export migratefilename=migrate
#
#export migratefilepath=$outputpathbase/$migratefilefolderroot/
#export migratefile=$migratefilepath$migratefilename
#
#if [ ! -r $migratefilepath ]
#then
#    echo '!! CRITICAL ERROR!!'
#    echo '  Missing migrate file folder!'
#    echo '  Missing folder : '$migratefilepath
#    echo ' EXITING...'
#    echo
#
#    exit 255
#fi
#
#if [ ! -r $migratefile ]
#then
#    echo '!! CRITICAL ERROR!!'
#    echo '  Missing migrate executable file !'
#    echo '  Missing executable file : '$migratefile
#    echo ' EXITING...'
#    echo
#
#    exit 255
#fi

echo
echo '--------------------------------------------------------------------------'
echo

echo
echo 'Preparing ...'
echo

cd "$outputfilepath"
echo
pwd
echo
mdsstat
echo

echo
echo 'mdsstop ...'
echo

mdsstop

echo
echo 'mdsstop completed'
echo

mdsstat

echo
echo '--------------------------------------------------------------------------'
echo
echo 'Executing mds_backup...'
echo

if [ $testmode -eq 0 ]; then
    # Not test mode
    mds_backup -b -l -i -s -d "$outputfilepath"
else
    # test mode
    echo Test Mode!
fi

echo
echo 'Done performing mds_backup'
echo
ls -alh $outputfilepath
echo

echo
echo 'mdsstart ...'
echo

mdsstart

echo
echo 'mdsstart completed'
echo

mdsstat

echo
echo
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------'

echo
echo 'Clean-up, stop, and [re-]start services...'
echo

mdsstat


echo '--------------------------------------------------------------------------'
echo
echo 'CLI Operations Completed'

#
# shell clean-up and log dump
#

echo
ls -alh $outputpathroot

cd "$outputpathroot"
echo
pwd
echo
echo 'Done!'
echo
echo '--------------------------------------------------------------------------'
echo '--------------------------------------------------------------------------'
echo '--------------------------------------------------------------------------'
echo
echo
