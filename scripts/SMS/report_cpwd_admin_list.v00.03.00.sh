#!/bin/bash
#
# SCRIPT for BASH to report on cp management processes
#
ScriptVersion=00.03.00
ScriptDate=2018-05-04
#

export BASHScriptVersion=v00x02x00

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
    echo "Continueing with report on admin processes..."
    echo
else
    echo "System is a gateway!"
    echo
    echo "This script is not meant for gateways, exiting!"
    exit 255
fi


export outputfilepath=$outputpathbase/
export outputfileprefix=report_cpwd_admin_list_$HOSTNAME'_'$gaiaversion
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

if [ x"$toolsversion" = x"R80.20" ] ; then
    # cpm_status.sh moved in R80.20, and only exists in R8X
    /opt/CPsuite-R80.20/fw1/scripts/cpm_status.sh | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
elif [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    /opt/CPsuite-R80/fw1/scripts/cpm_status.sh | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
else
    echo | tee -a -i $outputfilefqdn
fi

cpwd_admin list | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

if [ x"$toolsversion" = x"R80.20" ] ; then
    # cpm_status.sh moved in R80.20, and only exists in R8X
    watch -d -n 1 "/opt/CPsuite-R80.20/fw1/scripts/cpm_status.sh;echo;cpwd_admin list"
    echo
elif [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    watch -d -n 1 "/opt/CPsuite-R80/fw1/scripts/cpm_status.sh;echo;cpwd_admin list"
    echo
else
    watch -d -n 1 "cpwd_admin list"
    echo
fi


if [ x"$toolsversion" = x"R80.20" ] ; then
    # cpm_status.sh moved in R80.20, and only exists in R8X
    /opt/CPsuite-R80.20/fw1/scripts/cpm_status.sh | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
elif [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    /opt/CPsuite-R80/fw1/scripts/cpm_status.sh | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
else
    echo | tee -a -i $outputfilefqdn
fi

cpwd_admin list | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

/opt/CPsuite-R80/fw1/scripts/cpm_status.sh
echo
cpwd_admin list
echo