#!/bin/bash
#
# SCRIPT for BASH to execute restart of cp processes
#
ScriptVersion=00.03.00
ScriptDate=2018-03-29
#

export BASHScriptVersion=v00x03x00

#points to where jq is installed
#export JQ=${CPDIR}/jq/jq

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEYMD=`date +%Y-%m-%d`

echo 'Date Time Group   :  '$DATE
echo 'Date (YYYY-MM-DD) :  '$DATEYMD
echo

# WAITTIME in seconds for read -t commands
export WAITTIME=60
export outputpathroot=/var/upgrade_export/dump
#export outputpathbase=$outputpathroot/$DATE
export outputpathbase=$outputpathroot/$DATEYMD

#
# shell meat
#
OPT="$1"
if [ $OPT = "--test" ]; then
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
    echo "Continueing with SMS restart..."
    echo
else
    echo "System is a gateway!"
    echo
    echo "This script is not meant for gateways, exiting!"
    exit 255
fi


export outputfilepath=$outputpathbase/
export outputfileprefix=restart_mgmt_$HOSTNAME'_'$gaiaversion
export outputfilesuffix='_'$DATE
export outputfiletype=.txt

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

export outputfile=$outputfileprefix$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

touch $outputfilefqdn

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh >> $outputfilefqdn
echo >> $outputfilefqdn
cpwd_admin list >> $outputfilefqdn
echo >> $outputfilefqdn

cpstop 2>> $outputfilefqdn

echo >> $outputfilefqdn

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh >> $outputfilefqdn
echo >> $outputfilefqdn
cpwd_admin list >> $outputfilefqdn
echo >> $outputfilefqdn

echo "Short $WAITTIME second nap..."
sleep $WAITTIME

cpstart  2>> $outputfilefqdn

echo >> $outputfilefqdn

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh >> $outputfilefqdn
echo >> $outputfilefqdn
cpwd_admin list >> $outputfilefqdn
echo >> $outputfilefqdn

watch -d -n 1 "/opt/CPsuite-R80/fw1/scripts/cpm_status.sh;echo;cpwd_admin list"

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh >> $outputfilefqdn
echo >> $outputfilefqdn
cpwd_admin list >> $outputfilefqdn
echo >> $outputfilefqdn

cpwd_admin list
echo
