#!/bin/bash
#
# SCRIPT capture configuration values for bash and clish level 004
#
# (C) 2016-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.15.00
ScriptDate=2018-08-31
#

export BASHScriptVersion=v00x15x00


echo
echo 'Script Configuration Capture script version '$ScriptVersion' from '$ScriptDate
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

echo 'Date Time Groups  :  '$DATE $DATEDTG $DATEDTGS
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

export outputpathbase=$outputpathroot/host_data

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
# bash - Gaia Version information 
#----------------------------------------------------------------------------------------

export command2run=Gaia_version
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

# This was already collected earlier and saved in a dedicated file

cp $gaiaversionoutputfile $outputfilefqdn
rm $gaiaversionoutputfile

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
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
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
# bash - gather licensing information
#----------------------------------------------------------------------------------------

export command2run=cplic_print
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


echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'Disk Mount : mount' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

mount >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"


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
# bash - Collect Interface Information per interface
#----------------------------------------------------------------------------------------

export command2run=interfaces_details
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo > $outputfilefqdn
echo 'Executing commands for '$command2run' with output to file : '$outputfilefqdn | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

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


for i in "${IFARRAY[@]}"
do
    
    export interfaceoutputfile=$outputfileprefix'_'$command2run'_'$i$outputfilesuffix$outputfiletype
    export interfaceoutputfilefqdn=$outputfilepath$interfaceoutputfile
    
    echo 'Executing commands for interface : '$i' with output to file : '$interfaceoutputfilefqdn | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    
    ifconfig $i | tee -a -i $interfaceoutputfilefqdn

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
# bash - gather interface name rules
#----------------------------------------------------------------------------------------

export command2run=interfaces_naming_rules
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export file2copy=00-OS-XX.rules
export file2copypath="/etc/udev/rules.d/$file2copy"
export file2findpath="/"

echo | tee -a -i "$outputfilefqdn"
echo 'Find file : '$file2copy' and document locations' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

find $file2copy -name $file2find | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cat "$file2copypath" | tee -a -i "$outputfilefqdn"
cp "$file2copypath" "$outputfilepath" | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"


export file2copy=00-ANACONDA.rules
export file2copypath="/etc/sysconfig/$file2copy"
export file2findpath="/"

echo | tee -a -i "$outputfilefqdn"
echo 'Find file : '$file2copy' and document locations' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

find $file2copy -name $file2find | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cat "$file2copypath" | tee -a -i "$outputfilefqdn"
cp "$file2copypath" "$outputfilepath" | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"


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
# bash - gather interface details - lspci
#----------------------------------------------------------------------------------------

export command2run=lspci
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
lspci -n -v > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - collect /etc/sysconfig/hwconf and backup if it exists
#----------------------------------------------------------------------------------------

# /etc/sysconfig/hwconf
export file2copy=hwconf
export file2copypath="/etc/sysconfig/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

# Gaia sould have /etc/sysconfig/hwconf file
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
#----------------------------------------------------------------------------------------
# Special files to collect and backup (at some time)
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
#    user.def - sk98239 (Location of 'user.def' file on Management Server
#
#    table.def - sk98339 (Location of 'table.def' files on Management Server)
#
#    crypt.def - sk98241 (Location of 'crypt.def' files on Security Management Server)
#    crypt.def - sk108600 (VPN Site-to-Site with 3rd party)
#
#    implied_rules.def - sk92281 (Creating customized implied rules for Check Point Security Gateway - 'implied_rules.def' file)
#
#    base.def - sk95147 (Modifying definitions of packet inspection on Security Gateway for different protocols - 'base.def' file)
#
#    vpn_table.def - sk92332 (Customizing the VPN configuration for Check Point Security Gateway - 'vpn_table.def' file)
#
#    DCE RPC files - sk42402 (Legitimate DCE-RPC (MS DCOM) bind packets dropped by IPS)
#
#    rtsp.def - sk35945 (RTSP traffic is dropped when SecureXL is enabled)
#
#    ftp.def - sk61781 (FTP packet is dropped - Attack Information: The packet was modified due to a potential Bounce Attack Evasion Attempt (Telnet Options))
#


#----------------------------------------------------------------------------------------
# bash - identify user.def files - sk98239
#----------------------------------------------------------------------------------------

# $FWDIR/conf/user.def
export file2find=user.def
export file2findpath="/"
export command2run=find
export outputfile=$outputfileprefix'_'$command2run'_'$file2find$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i $outputfilefqdn
echo 'Find file : '$file2find' and document locations' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

find $file2find -name $file2find | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/conf/user.def and backup if it exists - sk98239
#----------------------------------------------------------------------------------------

# $FWDIR/conf/user.def
#export file2copy=user.def
#export file2copypath="$FWDIR/conf/$file2copy"
#export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix
#export outputfilefqdn=$outputfilepath$outputfile
#
#if [[ $sys_type_MDS = 'true' ]] ; then
#    
#    # HANDLE MDS and Domains
#    
#else
#    # System is not MDS, so no need to cycle through domains
#    
#    if [ ! -r $file2copypath ] ; then
#        echo
#        echo 'No '$file2copy' file at :  '$file2copypath
#    else
#        echo
#        echo 'found '$file2copy' file at :  '$file2copypath
#        echo
#        echo 'copy '$file2copy' to : '"$outputfilepath"
#        cp "$file2copypath" "$outputfilefqdn"
#        cp "$file2copypath" "$outputfilepath"
#        cp "$file2copypath" .
#    fi
#    echo
#    
#fi


#----------------------------------------------------------------------------------------
# bash - identify table.def files - sk98339
#----------------------------------------------------------------------------------------

# $FWDIR/lib/table.def
export file2find=table.def
export file2findpath="/"
export command2run=find
export outputfile=$outputfileprefix'_'$command2run'_'$file2find$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i $outputfilefqdn
echo 'Find file : '$file2find' and document locations' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

find $file2find -name $file2find | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/lib/table.def and backup if it exists - sk98339
#----------------------------------------------------------------------------------------

# $FWDIR/lib/table.def
#export file2copy=table.def
#export file2copypath="$FWDIR/lib/$file2copy"
#export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix
#export outputfilefqdn=$outputfilepath$outputfile
#
#if [[ $sys_type_MDS = 'true' ]] ; then
#    
#    # HANDLE MDS and Domains
#    
#else
#    # System is not MDS, so no need to cycle through domains
#    
#    if [ ! -r $file2copypath ] ; then
#        echo
#        echo 'No '$file2copy' file at :  '$file2copypath
#    else
#        echo
#        echo 'found '$file2copy' file at :  '$file2copypath
#        echo
#        echo 'copy '$file2copy' to : '"$outputfilepath"
#        cp "$file2copypath" "$outputfilefqdn"
#        cp "$file2copypath" "$outputfilepath"
#        cp "$file2copypath" .
#    fi
#    echo
#    
#fi


#----------------------------------------------------------------------------------------
# bash - identify crypt.def files - sk98241 and sk108600
#----------------------------------------------------------------------------------------

#
#    crypt.def - sk98241 (Location of 'crypt.def' files on Security Management Server)
#    crypt.def - sk108600 (VPN Site-to-Site with 3rd party)
#

export file2find=crypt.def
export file2findpath="/"
export command2run=find
export outputfile=$outputfileprefix'_'$command2run'_'$file2find$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i $outputfilefqdn
echo 'Find file : '$file2find' and document locations' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

find $file2find -name $file2find | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - identify implied_rules.def files - sk92281
#----------------------------------------------------------------------------------------

#
#    implied_rules.def - sk92281 (Creating customized implied rules for Check Point Security Gateway - 'implied_rules.def' file)
#

export file2find=implied_rules.def
export file2findpath="/"
export command2run=find
export outputfile=$outputfileprefix'_'$command2run'_'$file2find$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i $outputfilefqdn
echo 'Find file : '$file2find' and document locations' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

find $file2find -name $file2find | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/boot/modules/fwkern.conf and backup if it exists
#----------------------------------------------------------------------------------------

# $FWDIR/boot/modules/fwkern.conf
export file2copy=fwkern.conf
export file2copypath="$FWDIR/boot/modules/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

if [ $Check4GW -eq 1 ]; then
    # Gateways generally could have $FWDIR/boot/modules/fwkern.conf file
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
        cp "$file2copypath" .
    fi
    echo
    
else
    # not expecting a $FWDIR/boot/modules/fwkern.conf file, but collect if it exists
    #

    if [ -r $file2copypath ] ; then
        echo
        echo 'found '$file2copy' file at :  '$file2copypath
        echo
        echo 'copy '$file2copy' to : '"$outputfilepath"
        cp "$file2copypath" "$outputfilefqdn"
        cp "$file2copypath" "$outputfilepath"
        cp "$file2copypath" .
    fi
    echo
fi


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/boot/modules/vpnkern.conf and backup if it exists - SK101219
#----------------------------------------------------------------------------------------

# $FWDIR/boot/modules/vpnkern.conf
export file2copy=vpnkern.conf
export file2copypath="$FWDIR/boot/modules/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

if [ $Check4GW -eq 1 ]; then
    # Gateways generally could have $FWDIR/boot/modules/vpnkern.conf file
    #
    
    if [ ! -r $file2copypath ] ; then
        echo
        echo 'No '$file2copy' file at :  '$file2copypath
    else
        echo
        echo 'found '$file2copy' file at :  '$file2copypath
        echo
        echo 'copy '$file2copy' to : '"$outputfilefqdn"
        cp "$file2copypath" "$outputfilefqdn"
        cp "$file2copypath" "$outputfilepath"
        cp "$file2copypath" .
    fi
    echo
    
else
    # not expecting a $FWDIR/boot/modules/vpnkern.conf file, but collect if it exists
    #

    if [ -r $file2copypath ] ; then
        echo
        echo 'found '$file2copy' file at :  '$file2copypath
        echo
        echo 'copy '$file2copy' to : '"$outputfilefqdn"
        cp "$file2copypath" "$outputfilefqdn"
        cp "$file2copypath" "$outputfilepath"
        cp "$file2copypath" .
    fi
    echo
fi


#----------------------------------------------------------------------------------------
# bash - collect /opt/CPUserCheckPortal/phpincs/conf/TPAPI.ini and backup if it exists
#----------------------------------------------------------------------------------------

# /opt/CPUserCheckPortal/phpincs/conf/TPAPI.ini
export file2copy=TPAPI.ini
export file2copypath="/opt/CPUserCheckPortal/phpincs/conf/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

if [ $Check4GW -eq 1 ]; then
    # Gateways generally could have /opt/CPUserCheckPortal/phpincs/conf/TPAPI.ini
    #
    
    if [ ! -r $file2copypath ] ; then
        echo
        echo 'No '$file2copy'i file at :  '$file2copypath
    else
        echo
        echo 'found '$file2copy' file at :  '$file2copypath
        echo
        echo 'copy '$file2copy' to : '"$outputfilefqdn"
        cp "$file2copypath" "$outputfilefqdn"
        cp "$file2copypath" "$outputfilepath"
        #cp "$file2copypath" .
    fi
    echo
    
else
    # not expecting a /opt/CPUserCheckPortal/phpincs/conf/TPAPI.ini file, but collect if it exists
    #

    if [ -r $file2copypath ] ; then
        echo
        echo 'found '$file2copy' file at :  '$file2copypath
        echo
        echo 'copy '$file2copy' to : '"$outputfilefqdn"
        cp "$file2copypath" "$outputfilefqdn"
        cp "$file2copypath" "$outputfilepath"
        #cp "$file2copypath" .
    fi
    echo
fi


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
    echo '$MDS_FWDIR/scripts/cpm_status.sh' >> "$outputfilefqdn"
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

fi

echo | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#

#----------------------------------------------------------------------------------------
# bash - GW - status of Identity Awareness
#----------------------------------------------------------------------------------------

if [ $Check4GW -eq 1 ]; then
    
    export command2run=identity_awareness_details
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with output to : '$outputfilefqdn
    
    touch $outputfilefqdn

    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'pdp status show' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    pdp status show >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'pep show pdp all' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    pep show pdp all >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'pdp auth kerberos_encryption get' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    pdp auth kerberos_encryption get >> "$outputfilefqdn"
    
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
# clish operations - might have issues if user is in Gaia webUI
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

export command2run=clish_commands
export clishoutputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export clishoutputfilefqdn=$outputfilepath$clishoutputfile


#----------------------------------------------------------------------------------------
# clish - save configuration to file
#----------------------------------------------------------------------------------------

export command2run=clish_config
export outputfile=$command2run'_'$outputfileprefix$outputfilesuffix
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a $clishoutputfilefqdn
echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a $clishoutputfilefqdn
echo | tee -a $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "save config" >> $clishoutputfilefqdn

clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "save configuration $outputfile" >> $clishoutputfilefqdn

clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "save config" >> $clishoutputfilefqdn

cp "$outputfile" "$outputfilefqdn" >> $clishoutputfilefqdn


#----------------------------------------------------------------------------------------
# clish - show assets
#----------------------------------------------------------------------------------------

export command2run=clish_assets
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a $clishoutputfilefqdn
echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a $clishoutputfilefqdn
echo | tee -a $clishoutputfilefqdn
touch $outputfilefqdn

echo 'clish show asset all :' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "show asset all" >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo 'clish show asset system :' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "show asset system" >> "$outputfilefqdn"
echo >> "$outputfilefqdn"


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
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "show version all" >> "$outputfilefqdn"
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

