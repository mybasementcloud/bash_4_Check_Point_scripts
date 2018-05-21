#!/bin/bash
#
# SCRIPT capture configuration values for bash and clish level 002
#
# (C) 2016-2018 Eric James Beasley
#
ScriptVersion=00.08.00
ScriptDate=2018-05-21
#

export BASHScriptVersion=v00x08x00


echo
echo 'Script Configuration Capture script version '$ScriptVersion' from '$ScriptDate
echo

#----------------------------------------------------------------------------------------
# Setup Basic Parameters
#----------------------------------------------------------------------------------------

#points to where jq is installed
#export JQ=${CPDIR}/jq/jq

export DATE=`date +%Y-%m-%d-%H%M%S%Z`

echo 'Date Time Group   :  '$DATE
echo

export localdotpath=`echo $PWD`

export currentlocalpath=$localdotpath
export workingpath=$currentlocalpath

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# Gaia version and installation type identification
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


export gaiaversion=$(clish -c "show version product" | cut -d " " -f 6)
echo 'Gaia Version : $gaiaversion = '$gaiaversion
echo

Check4SMS=0
Check4EPM=0
Check4MDS=0
Check4GW=0

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

if [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
    echo "System is Multi-Domain Management Server!"
    Check4GW=0
elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
    echo "System is Security Management Server!"
    Check4SMS=1
    Check4GW=0
else
    echo "System is a gateway!"
    Check4GW=1
fi
echo

if [ $Check4EP773000 -gt 0 ] && [ $Check4EP773003 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.03"
    export gaiaversion=R77.30.03
    Check4EPM=1
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773002 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.02"
    export gaiaversion=R77.30.02
    Check4EPM=1
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773001 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.01"
    export gaiaversion=R77.30.01
    Check4EPM=1
elif [ $Check4EP773000 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30"
    export gaiaversion=R77.30
    Check4EPM=1
else
    echo "Not Gaia Endpoint Security Server"
    Check4EPM=0
fi

echo
echo 'Final $gaiaversion = '$gaiaversion
echo

if [ $Check4MDS -eq 1 ]; then
	echo 'Multi-Domain Management stuff...'
fi

if [ $Check4SMS -eq 1 ]; then
	echo 'Security Management Server stuff...'
fi

if [ $Check4EPM -eq 1 ]; then
	echo 'Endpoint Security Management Server stuff...'
fi

if [ $Check4GW -eq 1 ]; then
	echo 'Gateway stuff...'
fi

echo
export gaia_kernel_version=$(uname -r)
if [ "$gaia_kernel_version" == "2.6.18-92cpx86_64" ]; then
    echo "OLD Kernel version $gaia_kernel_version"
elif [ "$gaia_kernel_version" == "3.10.0-514cpx86_64" ]; then
    echo "NEW Kernel version $gaia_kernel_version"
else
    echo "Kernel version $gaia_kernel_version"
fi
echo

# Alternative approach from Health Check

sys_type="N/A"
sys_type_MDS=false
sys_type_SMS=false
sys_type_SmartEvent=false
sys_type_GW=false
sys_type_STANDALONE=false
sys_type_VSX=false

#  System Type
if [[ $(echo $MDSDIR | grep mds) ]]; then
    sys_type_MDS=true
    sys_type_SMS=false
    sys_type="MDS"
elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallMgmt 2> /dev/null) == *"1"*  ]]; then
    sys_type_SMS=true
    sys_type_MDS=false
    sys_type="SMS"
else
    sys_type_SMS=false
    sys_type_MDS=false
fi

# Updated to correctly identify if SmartEvent is active
# $CPDIR/bin/cpprod_util RtIsRt -> returns wrong result for MDM
# $CPDIR/bin/cpprod_util RtIsAnalyzerServer -> returns correct result for MDM

if [[ $($CPDIR/bin/cpprod_util RtIsAnalyzerServer 2> /dev/null) == *"1"*  ]]; then
    sys_type_SmartEvent=true
    sys_type="SmartEvent"
else
    sys_type_SmartEvent=false
fi

if [[ $($CPDIR/bin/cpprod_util FwIsVSX 2> /dev/null) == *"1"* ]]; then
	sys_type_VSX=true
	sys_type="VSX"
else
	sys_type_VSX=false
fi

if [[ $($CPDIR/bin/cpprod_util FwIsStandAlone 2> /dev/null) == *"1"* ]]; then
    sys_type_STANDALONE=true
    sys_type="STANDALONE"
else
    sys_type_STANDALONE=false
fi

if [[ $($CPDIR/bin/cpprod_util FwIsFirewallModule 2> /dev/null) == *"1"*  ]]; then
    sys_type_GW=true
    sys_type="GATEWAY"
else
    sys_type_GW=false
fi

echo "sys_type = "$sys_type
echo
echo "System Type : SMS        :"$sys_type_SMS
echo "System Type : MDS        :"$sys_type_MDS
echo "System Type : SmartEvent :"$sys_type_SmartEvent
echo "System Type : GATEWAY    :"$sys_type_GW
echo "System Type : STANDALONE :"$sys_type_STANDALONE
echo "System Type : VSX        :"$sys_type_VSX
echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# base parameters
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------



#export outputpathroot=/var/upgrade_export
export outputpathroot=./host_data
#export outputpathroot=`realpath "$outputpathroot"`
export expandedpath=$(cd $outputpathroot ; pwd)
export outputpathroot=${expandedpath}
#echo 'outputpathroot = '$outputpathroot

export outputpathbase=$outputpathroot
export outputpathbase=$outputpathroot/$DATE

#export outputhomepath=$outputpathbase/home
export outputhomepath=$outputpathbase


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# shell meat
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Configure specific parameters
#----------------------------------------------------------------------------------------

export targetversion=$gaiaversion

export outputfilepath=$outputpathbase/
export outputfileprefix=$HOSTNAME'_'$targetversion
export outputfilesuffix='_'$DATE
export outputfiletype=.txt

if [ ! -r $outputpathroot ] ; then
    mkdir $outputpathroot
    chmod 775 $outputpathroot
else
    chmod 775 $outputpathroot
fi
if [ ! -r $outputpathbase ] ; then
    mkdir $outputpathbase
    chmod 775 $outputpathbase
else
    chmod 775 $outputpathbase
fi
if [ ! -r $outputfilepath ] ; then
    mkdir $outputfilepath
    chmod 775 $outputfilepath
else
    chmod 775 $outputfilepath
fi

if [ ! -r $outputhomepath ] ; then
    mkdir $outputhomepath
    chmod 775 $outputhomepath
else
    chmod 775 $outputhomepath
fi

#----------------------------------------------------------------------------------------
# bash - backup user's home folder
#----------------------------------------------------------------------------------------

export homebackuproot=.
#export homebackuproot=`realpath "$homebackuproot"`
export expandedpath=$(cd $homebackuproot ; pwd)
export homebackuproot=${expandedpath}
export homebackuppath="$homebackuproot/home.backup"

if [ ! -r $homebackuppath ] ; then
    mkdir $homebackuppath
    chmod 775 $homebackuppath
else
    chmod 775 $homebackuppath
fi

export command2run=backup-home
export outputfile=$command2run'_'$outputfileprefix$outputfilesuffix'.txt'
export outputfilefqdn=$outputfilepath$outputfile
touch "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo 'Execute '$command2run' to '$outputhomepath' with ouptut to : '$outputfilefqdn | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo "Current path : " | tee -a -i "$outputfilefqdn"
pwd | tee -a -i "$outputfilefqdn"

echo "Copy /home folder to $outputhomepath" | tee -a -i "$outputfilefqdn"
cp -a -v "/home/" "$outputhomepath" | tee -a -i "$outputfilefqdn"

echo
echo 'Execute '$command2run' to '$homebackuppath' with ouptut to : '$outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

pushd /home

echo | tee -a -i "$outputfilefqdn"
echo "Current path : " | tee -a -i "$outputfilefqdn"
pwd | tee -a -i "$outputfilefqdn"

echo "Copy /home folder contents to $homebackuppath" | tee -a -i "$outputfilefqdn"
cp -a -v "." "$homebackuppath" | tee -a -i "$outputfilefqdn"

popd

echo | tee -a -i "$outputfilefqdn"
echo "Current path : " | tee -a -i "$outputfilefqdn"
pwd | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"

echo "Current path : " | tee -a -i "$outputfilefqdn"
pwd | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# clish - save configuration to file
#----------------------------------------------------------------------------------------

export command2run=config
export outputfile=$command2run'_'$outputfileprefix$outputfilesuffix
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
clish -c "lock database override"
clish -c "lock database override"
clish -c "save config"
clish -c "save configuration $outputfile"
clish -c "save config"
cp "$outputfile" "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# clish and bash - Gather version information from all possible methods
#----------------------------------------------------------------------------------------

export command2run=versions
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

touch $outputfilefqdn
echo 'Versions:' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo 'clish : ' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
clish -c "show version all" | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo 'cpinfo -y all : ' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
cpinfo -y all | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo 'fwm ver : ' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
fwm ver | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo 'fw ver : ' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
fw ver | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo 'installed_jumbo_take : ' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
installed_jumbo_take | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather licensing information
#----------------------------------------------------------------------------------------

export command2run=cplic
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
cplic print > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - basic information
#----------------------------------------------------------------------------------------

export command2run=basic_information
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn

touch $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"
echo 'Memory Utilization : free -m -t' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

free -m -t | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo 'Disk Utilization : df -h' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

df -h | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather route details
#----------------------------------------------------------------------------------------

export command2run=route
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
route -vn > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather arp details
#----------------------------------------------------------------------------------------

export command2run=arp
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn

touch $outputfilefqdn
arp -vn | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
arp -av | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface details
#----------------------------------------------------------------------------------------

export command2run=ifconfig
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
ifconfig > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface name rules
#----------------------------------------------------------------------------------------

export command2run=interface-naming-rules
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile
export file2copy=00-OS-XX.rules
export file2copypath="/etc/udev/rules.d/$file2copy"

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
cat "$file2copypath" > "$outputfilefqdn"
cp "$file2copypath" "$outputfilepath"


#----------------------------------------------------------------------------------------
# bash - generate device and system information via dmidecode
#----------------------------------------------------------------------------------------

export command2run=dmidecode
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
dmidecode > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/boot/modules/fwkern.conf and backup if it exists
#----------------------------------------------------------------------------------------

# $FWDIR/boot/modules/fwkern.conf
export file2copy=fwkern.conf
export file2copypath="$FWDIR/boot/modules/$file2copy"
export outputfile=$outputfileprefix'_'$file2copy$outputfilesuffix
export outputfilefqdn=$outputfilepath$outputfile

if [ ! -r $file2copypath ] ; then
    echo
    echo 'No fwkern.conf file at :  '$file2copypath
else
    echo
    echo 'copy '$file2copy' to : '"$outputfilefqdn"
    cp "$file2copypath" "$outputfilefqdn"
    cp "$file2copypath" "$outputfilepath"
    cp "$file2copypath" .
fi
echo


#----------------------------------------------------------------------------------------
# bash - GW - status of SecureXL
#----------------------------------------------------------------------------------------

if [ $Check4GW -eq 1 ]; then
    
    export command2run=fwaccel-statistics
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
    
    touch $outputfilefqdn
    echo | tee -a -i "$outputfilefqdn"
    echo 'fwacell stat' | tee -a -i "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    
    fwaccel stat | tee -a -i "$outputfilefqdn"
    
    echo | tee -a -i "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    echo 'fwacell stats' | tee -a -i "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    
    fwaccel stats | tee -a -i "$outputfilefqdn"
    
    echo | tee -a -i "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    echo 'fwacell stats -s' | tee -a -i "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    
    fwaccel stats -s | tee -a -i "$outputfilefqdn"
    
    echo | tee -a -i "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    echo '$FWDIR/scripts/cpm_status.sh' | tee -a -i "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    
    $FWDIR/scripts/cpm_status.sh | tee -a -i "$outputfilefqdn"

fi


#----------------------------------------------------------------------------------------
# bash - Management Systems
#----------------------------------------------------------------------------------------

if [ $sys_type_SMS = 'true' ] || [] || ; then
    export command2run=cpwd_admin
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
    command > "$outputfilefqdn"
    
    echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    echo 'cpwd_admin list' | tee -a -i "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    
    cpwd_admin list | tee -a "$outputfilefqdn"
    
    

fi


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#

#----------------------------------------------------------------------------------------
# bash - ?what next?
#----------------------------------------------------------------------------------------

#export command2run=command
#export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
#export outputfilefqdn=$outputfilepath$outputfile

#echo
#echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
#command > "$outputfilefqdn"

#echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
#echo | tee -a -i "$outputfilefqdn"
#echo 'fwacell stats -s' | tee -a -i "$outputfilefqdn"
#echo | tee -a -i "$outputfilefqdn"
#
#fwaccel stats -s | tee -a -i "$outputfilefqdn"
#


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# end shell meat
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------



echo 'CLI Operations Completed'

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# shell clean-up and log dump
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

echo
ls -alh $outputpathroot
#ls -alhR $outputpathroot
echo
#echo
#ls -alhR $outputpathbase
#echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

