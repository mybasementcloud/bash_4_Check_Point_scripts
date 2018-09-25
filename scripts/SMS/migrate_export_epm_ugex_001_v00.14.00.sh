#!/bin/bash
#
# SCRIPT for BASH to execute migrate export to /var/log/__customer/upgrade_export folder
# using /var/log/__customer/upgrade_export/migration_tools/<version>/migrate file
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.14.00
ScriptDate=2018-09-21
#

export BASHScriptVersion=v00x14x00

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

export toolsversion=$gaiaversion


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

if [ $Check4EPM -gt 0 ]; then
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

    echo | tee -a -i $logfilepath
    echo 'Done performing '$migratefile $command2run | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    if [ $Check4EPM -gt 0 ]; then
        echo | tee -a -i $logfilepath
        echo 'Executing 2...' | tee -a -i $logfilepath
        echo '-> '$migratefile $command2run2 $outputfilefqdn2 | tee -a -i $logfilepath
        $migratefile $command2run2 $outputfilefqdn2 | tee -a -i $logfilepath

        echo | tee -a -i $logfilepath
        echo 'Done performing '$migratefile $command2run2 | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
else
    # test mode
    echo Test Mode! | tee -a -i $logfilepath
fi

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

