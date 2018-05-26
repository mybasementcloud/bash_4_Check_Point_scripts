#!/bin/bash
#
# SCRIPT capture configuration values for bash and clish level 002
#
# (C) 2016-2018 Eric James Beasley
#
ScriptVersion=00.09.01
ScriptDate=2018-05-25
#

export BASHScriptVersion=v00x09x01


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
# base parameters
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


export notthispath=/home/
export startpathroot=.
export alternatepathroot=/var/tmp

export expandedpath=$(cd $startpathroot ; pwd)
export startpathroot=$expandedpath
export checkthispath=`echo "${expandedpath}" | grep -i "$notthispath"`
export isitthispath=`test -z $checkthispath; echo $?`

if [ $isitthispath -eq 1 ] ; then
    #Oh, Oh, we're in the home directory executing, not good!!!
    #Configure outputpathroot for $alternatepathroot folder since we can't run in /home/
    export outputpathroot=$alternatepathroot
else
    #OK use the current folder and create host_data sub-folder
    export outputpathroot=$startpathroot
fi

if [ ! -r $outputpathroot ] ; then
    #not where we're expecting to be, since $outputpathroot is missing here
    #maybe this hasn't been run here yet.
    #OK, so make the expected folder and set permissions we need
    mkdir $outputpathroot
    chmod 775 $outputpathroot
else
    #set permissions we need
    chmod 775 $outputpathroot
fi

#Now that outputroot is not in /home/ let's work on where we are working from

export expandedpath=$(cd $outputpathroot ; pwd)
export checkthispath=`echo "${expandedpath}" | grep -i "$notthispath"`
export isitthispath=`test -z $checkthispath; echo $?`
export outputpathroot=${expandedpath}

if [ ! -r $outputpathroot ] ; then
    mkdir $outputpathroot
    chmod 775 $outputpathroot
else
    chmod 775 $outputpathroot
fi

export outputpathbase=$outputpathroot/host_data

if [ ! -r $outputpathbase ] ; then
    mkdir $outputpathbase
    chmod 775 $outputpathbase
else
    chmod 775 $outputpathbase
fi

export outputpathbase=$outputpathbase/$DATE

if [ ! -r $outputpathbase ] ; then
    mkdir $outputpathbase
    chmod 775 $outputpathbase
else
    chmod 775 $outputpathbase
fi

export outputhomepath=$outputpathbase

if [ ! -r $outputhomepath ] ; then
    mkdir $outputhomepath
    chmod 775 $outputhomepath
else
    chmod 775 $outputhomepath
fi

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
export kernelv2x06=2.6
export kernelv3x10=3.10
export checkthiskernel=`echo "${gaia_kernel_version}" | grep -i "$kernelv2x06"`
export isitoldkernel=`test -z $checkthiskernel; echo $?`
export checkthiskernel=`echo "${gaia_kernel_version}" | grep -i "$kernelv3x10"`
export isitnewkernel=`test -z $checkthiskernel; echo $?`

if [ $isitoldkernel -eq 1 ] ; then
    echo "OLD Kernel version $gaia_kernel_version"
elif [ $isitnewkernel -eq 1 ]; then
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

if [ ! -r $outputfilepath ] ; then
    mkdir $outputfilepath
    chmod 775 $outputfilepath
else
    chmod 775 $outputfilepath
fi


#----------------------------------------------------------------------------------------
# bash - backup user's home folder
#----------------------------------------------------------------------------------------

export homebackuproot=$startpathroot

export expandedpath=$(cd $homebackuproot ; pwd)
export homebackuproot=$expandedpath
export checkthispath=`echo "${expandedpath}" | grep -i "$notthispath"`
export isitthispath=`test -z $checkthispath; echo $?`

if [ $isitthispath -eq 1 ] ; then
    #Oh, Oh, we're in the home directory executing, not good!!!
    #Configure homebackuproot for $alternatepathroot folder since we can't run in /home/
    export homebackuproot=$alternatepathroot
else
    #OK use the current folder and create host_data sub-folder
    export homebackuproot=$startpathroot
fi

if [ ! -r $homebackuproot ] ; then
    #not where we're expecting to be, since $homebackuproot is missing here
    #maybe this hasn't been run here yet.
    #OK, so make the expected folder and set permissions we need
    mkdir $homebackuproot
    chmod 775 $homebackuproot
else
    #set permissions we need
    chmod 775 $homebackuproot
fi

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

echo >> "$outputfilefqdn"
echo 'Execute '$command2run' to '$outputhomepath' with output to : '$outputfilefqdn >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"

echo "Copy /home folder to $outputhomepath" >> "$outputfilefqdn"
cp -a -v "/home/" "$outputhomepath" >> "$outputfilefqdn"

echo
echo 'Execute '$command2run' to '$homebackuppath' with output to : '$outputfilefqdn
echo >> "$outputfilefqdn"

pushd /home

echo >> "$outputfilefqdn"
echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"

echo "Copy /home folder contents to $homebackuppath" >> "$outputfilefqdn"
cp -a -v "." "$homebackuppath" >> "$outputfilefqdn"

popd

echo >> "$outputfilefqdn"
echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"

echo >> "$outputfilefqdn"

echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# clish - save configuration to file
#----------------------------------------------------------------------------------------

export command2run=config
export outputfile=$command2run'_'$outputfileprefix$outputfilesuffix
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
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
echo 'Versions:' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo 'uname for kernel version : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
uname -a >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'clish : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
clish -c "show version all" >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'cpinfo -y all : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
cpinfo -y all >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'fwm ver : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
fwm ver >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'fw ver : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
fw ver >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

if [ x"$gaiaversion" = x"R80.20" ] || [ x"$gaiaversion" = x"R80.10" ] || [ x"$gaiaversion" = x"R80" ] ; then
    # installed_jumbo_take only exists in R7X
    echo >> "$outputfilefqdn"
else
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'installed_jumbo_take : ' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    installed_jumbo_take >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
fi


#----------------------------------------------------------------------------------------
# bash - gather licensing information
#----------------------------------------------------------------------------------------

export command2run=cplic
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
cplic print > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - basic information
#----------------------------------------------------------------------------------------

export command2run=basic_information
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn

touch $outputfilefqdn
echo >> "$outputfilefqdn"
echo 'Memory Utilization : free -m -t' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

free -m -t >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'Disk Utilization : df -h' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

df -h >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather route details
#----------------------------------------------------------------------------------------

export command2run=route
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
route -vn > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather arp details
#----------------------------------------------------------------------------------------

export command2run=arp
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn

touch $outputfilefqdn
arp -vn >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
arp -av >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface details
#----------------------------------------------------------------------------------------

export command2run=ifconfig
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
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
echo 'Execute '$command2run' with output to : '$outputfilefqdn
cat "$file2copypath" > "$outputfilefqdn"
cp "$file2copypath" "$outputfilepath"


#----------------------------------------------------------------------------------------
# bash - generate device and system information via dmidecode
#----------------------------------------------------------------------------------------

export command2run=dmidecode
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
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
    echo 'Execute '$command2run' with output to : '$outputfilefqdn
    
    touch $outputfilefqdn
    echo >> "$outputfilefqdn"
    echo 'fwacell stat' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stat >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwacell stats' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stats >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwacell stats -s' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stats -s >> "$outputfilefqdn"
    
fi


#----------------------------------------------------------------------------------------
# bash - Management Systems Information
#----------------------------------------------------------------------------------------

if [[ $sys_type_MDS = 'true' ]] ; then

    export command2run=cpwd_admin
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with output to : '$outputfilefqdn
    command > "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo '$FWDIR_PATH/scripts/cpm_status.sh' >> "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    
    if [ x"$gaiaversion" = x"R80.20" ] || [ x"$gaiaversion" = x"R80.10" ] || [ x"$gaiaversion" = x"R80" ] ; then
        # cpm_status.sh only exists in R8X
        $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i "$outputfilefqdn"
        echo | tee -a -i "$outputfilefqdn"
    else
        echo | tee -a -i "$outputfilefqdn"
    fi

    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'cpwd_admin list' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    cpwd_admin list >> "$outputfilefqdn"

    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'mdsstat' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    export COLUMNS=128
    mdsstat >> "$outputfilefqdn"

elif [[ $sys_type_SMS = 'true' ]] || [[ $sys_type_SmartEvent = 'true' ]] ; then

    export command2run=cpwd_admin
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with output to : '$outputfilefqdn
    command > "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo '$FWDIR/scripts/cpm_status.sh' >> "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i "$outputfilefqdn"

    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'cpwd_admin list' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    cpwd_admin list >> "$outputfilefqdn"

fi

echo | tee -a -i "$outputfilefqdn"


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
#echo 'Execute '$command2run' with output to : '$outputfilefqdn
#command > "$outputfilefqdn"

#echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
#echo >> "$outputfilefqdn"
#echo 'fwacell stats -s' >> "$outputfilefqdn"
#echo >> "$outputfilefqdn"
#
#fwaccel stats -s >> "$outputfilefqdn"
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

ls -alh $outputpathroot/config*
echo

ls -alh $outputpathroot/fw*
echo

#ls -alhR $outputpathroot
#ls -alh $outputpathroot
#echo

#ls -alhR $outputpathbase
ls -alh $outputpathbase
echo

echo
echo 'Output location for all results is here : '$outputpathroot
echo 'Host Data output for this run is here   : '$outputpathbase
echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

