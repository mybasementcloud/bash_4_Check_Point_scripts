#!/bin/bash
#
# SCRIPT Show Interface Information
#
# (C) 2016-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.03.00
ScriptDate=2018-09-09
#

export BASHScriptVersion=v00x03x00

export ScriptName=show_interface_information_$ScriptVersion

echo
echo 'Show Interface Information, script version '$ScriptVersion' from '$ScriptDate
echo

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


#----------------------------------------------------------------------------------------
# Setup Basic Parameters
#----------------------------------------------------------------------------------------

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
export alternatepathroot=$customerworkpathroot

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

export outputpathbase=$outputpathroot/dump

if [ ! -r $outputpathbase ] ; then
    mkdir $outputpathbase
    chmod 775 $outputpathbase
else
    chmod 775 $outputpathbase
fi

export outputpathbase=$outputpathbase/$DATEDTGS

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
# Set LogFile Information
#----------------------------------------------------------------------------------------

export logpathroot=$outputpathroot/dump

if [ ! -r $logpathroot ]; then
    mkdir $logpathroot
fi

export logpathbase=$logpathroot/$DATEDTGS

if [ ! -r $logpathbase ]; then
    mkdir $logpathbase
fi

export logfilepath=$logpathbase/$ScriptName'_'$DATEDTGS.log
touch $logfilepath

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# Gaia version and installation type identification
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

export gaiaversionoutputfile=/var/tmp/gaiaversion_$DATEDTGS.txt
echo > $gaiaversionoutputfile

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Identify Gaia Version and Installation Type Details
# -------------------------------------------------------------------------------------------------


export gaiaversion=$(clish -c "show version product" | cut -d " " -f 6)
echo 'Gaia Version : $gaiaversion = '$gaiaversion | tee -a -i $gaiaversionoutputfile
echo | tee -a -i $gaiaversionoutputfile

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
Check4SMSR80x10=`grep -c "Security Management Server R80.10 " $workfile`
Check4SMSR80x20=`grep -c "Security Management Server R80.20 " $workfile`
Check4SMSR80x20xM1=`grep -c "Security Management Server R80.20.M1 " $workfile`
Check4SMSR80x20xM2=`grep -c "Security Management Server R80.20.M2 " $workfile`
rm $workfile

if [ "$MDSDIR" != '' ]; then
    Check4MDS=1
else 
    Check4MDS=0
fi

if [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
    echo "System is Multi-Domain Management Server!" | tee -a -i $gaiaversionoutputfile
    Check4GW=0
elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
    echo "System is Security Management Server!" | tee -a -i $gaiaversionoutputfile
    Check4SMS=1
    Check4GW=0
else
    echo "System is a gateway!" | tee -a -i $gaiaversionoutputfile
    Check4GW=1
fi
echo

if [ $Check4SMSR80x10 -gt 0 ]; then
    echo "Security Management Server version R80.10" | tee -a -i $gaiaversionoutputfile
    export gaiaversion=R80.10
    if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
    	Check4EPM=1
        echo "Endpoint Security Server version R80.10" | tee -a -i $gaiaversionoutputfile
    else
    	Check4EPM=0
    fi
elif [ $Check4SMSR80x20 -gt 0 ]; then
    echo "Security Management Server version R80.20" | tee -a -i $gaiaversionoutputfile
    export gaiaversion=R80.20
    if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
    	Check4EPM=1
        echo "Endpoint Security Server version R80.20" | tee -a -i $gaiaversionoutputfile
    else
    	Check4EPM=0
    fi
elif [ $Check4SMSR80x20xM1 -gt 0 ]; then
    echo "Security Management Server version R80.20.M1" | tee -a -i $gaiaversionoutputfile
    export gaiaversion=R80.20.M1
    if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
    	Check4EPM=1
        echo "Endpoint Security Server version R80.20.M1" | tee -a -i $gaiaversionoutputfile
    else
    	Check4EPM=0
    fi
elif [ $Check4SMSR80x20xM2 -gt 0 ]; then
    echo "Security Management Server version R80.20.M2" | tee -a -i $gaiaversionoutputfile
    export gaiaversion=R80.20.M2
    if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
    	Check4EPM=1
        echo "Endpoint Security Server version R80.20.M2" | tee -a -i $gaiaversionoutputfile
    else
    	Check4EPM=0
    fi
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773003 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.03" | tee -a -i $gaiaversionoutputfile
    export gaiaversion=R77.30.03
    Check4EPM=1
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773002 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.02" | tee -a -i $gaiaversionoutputfile
    export gaiaversion=R77.30.02
    Check4EPM=1
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773001 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.01" | tee -a -i $gaiaversionoutputfile
    export gaiaversion=R77.30.01
    Check4EPM=1
elif [ $Check4EP773000 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30" | tee -a -i $gaiaversionoutputfile
    export gaiaversion=R77.30
    Check4EPM=1
else
    echo "Not Gaia Endpoint Security Server R77.30" | tee -a -i $gaiaversionoutputfile
    
    if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
    	Check4EPM=1
    else
    	Check4EPM=0
    fi
    
fi

echo | tee -a -i $gaiaversionoutputfile
echo 'Final $gaiaversion = '$gaiaversion | tee -a -i $gaiaversionoutputfile
echo | tee -a -i $gaiaversionoutputfile

if [ $Check4MDS -eq 1 ]; then
	echo 'Multi-Domain Management stuff...' | tee -a -i $gaiaversionoutputfile
fi

if [ $Check4SMS -eq 1 ]; then
	echo 'Security Management Server stuff...' | tee -a -i $gaiaversionoutputfile
fi

if [ $Check4EPM -eq 1 ]; then
	echo 'Endpoint Security Management Server stuff...' | tee -a -i $gaiaversionoutputfile
fi

if [ $Check4GW -eq 1 ]; then
	echo 'Gateway stuff...' | tee -a -i $gaiaversionoutputfile
fi

#echo
#export gaia_kernel_version=$(uname -r)
#if [ "$gaia_kernel_version" == "2.6.18-92cpx86_64" ]; then
#    echo "OLD Kernel version $gaia_kernel_version" | tee -a -i $gaiaversionoutputfile
#elif [ "$gaia_kernel_version" == "3.10.0-514cpx86_64" ]; then
#    echo "NEW Kernel version $gaia_kernel_version" | tee -a -i $gaiaversionoutputfile
#else
#    echo "Kernel version $gaia_kernel_version" | tee -a -i $gaiaversionoutputfile
#fi
#echo

echo | tee -a -i $gaiaversionoutputfile
export gaia_kernel_version=$(uname -r)
export kernelv2x06=2.6
export kernelv3x10=3.10
export checkthiskernel=`echo "${gaia_kernel_version}" | grep -i "$kernelv2x06"`
export isitoldkernel=`test -z $checkthiskernel; echo $?`
export checkthiskernel=`echo "${gaia_kernel_version}" | grep -i "$kernelv3x10"`
export isitnewkernel=`test -z $checkthiskernel; echo $?`

if [ $isitoldkernel -eq 1 ] ; then
    echo "OLD Kernel version $gaia_kernel_version" | tee -a -i $gaiaversionoutputfile
elif [ $isitnewkernel -eq 1 ]; then
    echo "NEW Kernel version $gaia_kernel_version" | tee -a -i $gaiaversionoutputfile
else
    echo "Kernel version $gaia_kernel_version" | tee -a -i $gaiaversionoutputfile
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
sys_type_UEPM=false
sys_type_UEPM_EndpointServer=false
sys_type_UEPM_PolicyServer=false


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

if [[ $($CPDIR/bin/cpprod_util FwIsFirewallModule 2> /dev/null) == *"1"*  ]]; then
    sys_type_GW=true
    sys_type="GATEWAY"
else
    sys_type_GW=false
fi

if [[ $($CPDIR/bin/cpprod_util FwIsStandAlone 2> /dev/null) == *"1"* ]]; then
    sys_type_STANDALONE=true
    sys_type="STANDALONE"
else
    sys_type_STANDALONE=false
fi

if [[ $($CPDIR/bin/cpprod_util UepmIsInstalled 2> /dev/null) == *"1"* ]]; then
	sys_type_UEPM=true
	sys_type="UEPM"
else
	sys_type_UEPM=false
fi

if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
	sys_type_UEPM_EndpointServer=true
else
	sys_type_UEPM_EndpointServer=false
fi

if [[ $($CPDIR/bin/cpprod_util UepmIsPolicyServer 2> /dev/null) == *"1"* ]]; then
	sys_type_UEPM_PolicyServer=true
else
	sys_type_UEPM_PolicyServer=false
fi

echo "sys_type = "$sys_type | tee -a -i $gaiaversionoutputfile
echo | tee -a -i $gaiaversionoutputfile
echo "System Type : SMS                  :"$sys_type_SMS | tee -a -i $gaiaversionoutputfile
echo "System Type : MDS                  :"$sys_type_MDS | tee -a -i $gaiaversionoutputfile
echo "System Type : SmartEvent           :"$sys_type_SmartEvent | tee -a -i $gaiaversionoutputfile
echo "System Type : GATEWAY              :"$sys_type_GW | tee -a -i $gaiaversionoutputfile
echo "System Type : STANDALONE           :"$sys_type_STANDALONE | tee -a -i $gaiaversionoutputfile
echo "System Type : VSX                  :"$sys_type_VSX | tee -a -i $gaiaversionoutputfile
echo "System Type : UEPM                 :"$sys_type_UEPM | tee -a -i $gaiaversionoutputfile
echo "System Type : UEPM Endpoint Server :"$sys_type_UEPM_EndpointServer | tee -a -i $gaiaversionoutputfile
echo "System Type : UEPM Policy Server   :"$sys_type_UEPM_PolicyServer | tee -a -i $gaiaversionoutputfile
echo | tee -a -i $gaiaversionoutputfile

# -------------------------------------------------------------------------------------------------
# END: Identify Gaia Version and Installation Type Details
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

cat $gaiaversionoutputfile >> $logfilepath
echo >> $logfilepath
rm $gaiaversionoutputfile


# -------------------------------------------------------------------------------------------------
# Validate we are working on a system that handles this operation
# -------------------------------------------------------------------------------------------------

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
export outputfilesuffix='_'$DATEDTGS
export outputfiletype=.txt

if [ ! -r $outputfilepath ] ; then
    mkdir $outputfilepath
    chmod 775 $outputfilepath
else
    chmod 775 $outputfilepath
fi


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
# bash - collect /var/log/dmesg and copy if it exists
#----------------------------------------------------------------------------------------

# /var/log/dmesg
export file2copy=dmesg
export file2copypath="/var/log/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

dmesg > $outputfilefqdn

# Gaia should have /var/log/dmesg file
#

if [ ! -r $file2copypath ] ; then
    echo
    echo 'No '$file2copy' file at :  '$file2copypath
else
    echo
    echo 'found '$file2copy' file at :  '$file2copypath
    echo
    echo 'copy '$file2copy' to : '"$outputfilepath"
    cp "$file2copypath" "$outputfilepath"
fi
echo
    

#----------------------------------------------------------------------------------------
# bash - collect /etc/modprobe.conf and copy if it exists
#----------------------------------------------------------------------------------------

# /etc/modprobe.conf
export file2copy=modprobe.conf
export file2copypath="/etc/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2copy' and document locations' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

find / -name $file2copy | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find all file variants : '$file2copy*' and document locations' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

find / -name $file2copy* | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

# Gaia should have /etc/modprobe.conf file
#

if [ ! -r $file2copypath ] ; then
    echo | tee -a -i $outputfilefqdn
    echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
else
    echo | tee -a -i $outputfilefqdn
    echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
    cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn

    echo | tee -a -i $outputfilefqdn
    echo 'Contents of '$file2copypath' file' | tee -a -i $outputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    cat "$file2copypath" | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
fi
echo
    

#----------------------------------------------------------------------------------------
# bash - gather interface details - lspci
#----------------------------------------------------------------------------------------

export command2run=lspci
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
lspci -n -v > "$outputfilefqdn"


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
# bash - Collect Interface Information per interface
#----------------------------------------------------------------------------------------

export command2run=interfaces_details
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export dmesgfilefqdn=$outputfilepath'dmesg'
if [ ! -r $dmesgfilefqdn ] ; then
    echo
    echo 'No dmesg file at :  '$dmesgfilefqdn
    echo 'Generating dmesg file!'
    echo
    dmesg > $dmesgfilefqdn
else
    echo
    echo 'found dmesg file at :  '$dmesgfilefqdn
    echo
fi
echo

echo > $outputfilefqdn
echo 'Executing commands for '$command2run' with output to file : '$outputfilefqdn | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn

clish -c "show interfaces" | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

IFARRAY=()

GETINTERFACES="`clish -c "show interfaces"`"

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo 'Build array of interfaces : ' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

arraylength=0
while read -r line; do

    if [ $arraylength -eq 0 ]; then
    	echo -n 'Interfaces :  ' | tee -a -i $outputfilefqdn
    else
    	echo -n ', ' | tee -a -i $outputfilefqdn
    fi

    #IFARRAY+=("$line")
    if [ "$line" == 'lo' ]; then
        echo -n 'Not adding '$line | tee -a -i $outputfilefqdn
    else 
        IFARRAY+=("$line")
    	echo -n $line | tee -a -i $outputfilefqdn
    fi
	
	arraylength=${#IFARRAY[@]}
	arrayelement=$((arraylength-1))
	
done <<< "$GETINTERFACES"

echo | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

echo 'Identified Interfaces in array for detail data collection :' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

for j in "${IFARRAY[@]}"
do
    #echo "$j, ${j//\'/}"  | tee -a -i $outputfilefqdn
    echo $j | tee -a -i $outputfilefqdn
done
echo | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

export ifshortoutputfile=$outputfileprefix'_'$command2run'_short'$outputfilesuffix$outputfiletype
export ifshortoutputfilefqdn=$outputfilepath$ifshortoutputfile
touch $ifshortoutputfilefqdn
echo >> $ifshortoutputfilefqdn
echo '----------------------------------------------------------------------------------------' >> $ifshortoutputfilefqdn

for i in "${IFARRAY[@]}"
do
    
    #------------------------------------------------------------------------------------------------------------------
    # Short Information
    #------------------------------------------------------------------------------------------------------------------

    echo 'Interface : '$i >> $ifshortoutputfilefqdn
    ifconfig $i | grep -i HWaddr >> $ifshortoutputfilefqdn
    ethtool -i $i | grep -i bus >> $ifshortoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $ifshortoutputfilefqdn

    #------------------------------------------------------------------------------------------------------------------
    # Detailed Information
    #------------------------------------------------------------------------------------------------------------------

    export interfaceoutputfile=$outputfileprefix'_'$command2run'_'$i$outputfilesuffix$outputfiletype
    export interfaceoutputfilefqdn=$outputfilepath$interfaceoutputfile
    
    echo 'Executing commands for interface : '$i' with output to file : '$interfaceoutputfilefqdn | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    
    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ifconfig $i | tee -a -i $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute clish -c "show interface '$i'"' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    clish -c "show interface $i" | tee -a -i $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -i '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -i $i >> $interfaceoutputfilefqdn

    echo | tee -a -i $outputfilefqdn
    cat $interfaceoutputfilefqdn | grep bus | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -g '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -g $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -k '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -k $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -S '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -S $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute grep of dmesg for '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    cat $dmesgfilefqdn | grep -i $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    
    cat $interfaceoutputfilefqdn >> $outputfilefqdn
    echo >> $outputfilefqdn

    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
    echo >> $outputfilefqdn

   
done

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - collect /etc/sysconfig/network and backup if it exists
#----------------------------------------------------------------------------------------

# /etc/sysconfig/network
export file2copy=network
export file2copypath="/etc/sysconfig/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

# Gaia sould have /etc/sysconfig/network file
#

if [ ! -r $file2copypath ] ; then
    echo
    echo 'No '$file2copy' file at :  '$file2copypath
else
    echo
    echo 'found '$file2copy' file at :  '$file2copypath
    echo
    echo 'copy '$file2copy' to : '"$outputfilepath"
    cp "$file2copypath" "$outputfilefqdn"
    cp "$file2copypath" "$outputfilepath"
    #cp "$file2copypath" .
fi
echo
    

#----------------------------------------------------------------------------------------
# bash - gather interface details from /etc/sysconfig/networking
#----------------------------------------------------------------------------------------

#/etc/sysconfig/networking

export command2run=etc_sysconfig_networking
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export sourcepath=/etc/sysconfig/networking
export targetpath=$outputfilepath$command2run/

echo | tee -a -i "$outputfilefqdn"
echo 'Copy files from '$sourcepath' to '$targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

mkdir $targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cp -a -v $sourcepath $targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface details from /etc/sysconfig/network-scripts
#----------------------------------------------------------------------------------------

#/etc/sysconfig/network-scripts

export command2run=etc_sysconfig_networking_scripts
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export sourcepath=/etc/sysconfig/network-scripts
export targetpath=$outputfilepath$command2run/

echo | tee -a -i "$outputfilefqdn"
echo 'Copy files from '$sourcepath' to '$targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

mkdir $targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cp -a -v $sourcepath $targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface name rules
#----------------------------------------------------------------------------------------

export command2run=interfaces_naming_rules
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export file2copy=00-OS-XX.rules
export file2copypath="/etc/udev/rules.d/$file2copy"
export file2findpath="/"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2copy' and document locations' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

find / -name $file2copy* | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cat "$file2copypath" | tee -a -i "$outputfilefqdn"
cp "$file2copypath" "$outputfilepath" | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"


export file2copy=00-ANACONDA.rules
export file2copypath="/etc/sysconfig/$file2copy"
export file2findpath="/"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2copy' and document locations' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

find / -name $file2copy* | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cat "$file2copypath" | tee -a -i "$outputfilefqdn"
cp "$file2copypath" "$outputfilepath" | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - ?what next?
#----------------------------------------------------------------------------------------

#export command2run=command
#export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
#export outputfilefqdn=$outputfilepath$outputfile

#echo | tee -a -i $outputfilefqdn
#echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a -i $outputfilefqdn
#command | tee -a -i $outputfilefqdn

#echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
#echo | tee -a -i $outputfilefqdn
#echo 'fwacell stats -s' | tee -a -i $outputfilefqdn
#echo | tee -a -i $outputfilefqdn
#
#fwaccel stats -s | tee -a -i $outputfilefqdn
#


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
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

#ls -alhR $outputpathroot
#ls -alh $outputpathroot
#echo

#ls -alhR $outputpathbase
ls -alh $outputpathbase
echo

echo
echo 'Output location for all results is here : '$outputpathroot
echo 'Host Data output for this run is here   : '$outputpathbase
echo 'Results documented in this file here    : '$outputfilefqdn
#echo 'Results documented in this log file     : '$logfilepath
echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


