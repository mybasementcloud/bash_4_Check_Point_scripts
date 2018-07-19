#!/bin/bash
#
# SCRIPT add content of alias_commands.add.all.sh to .bashrc file
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.07.00
ScriptDate=2018-07-18
#

export BASHScriptVersion=v00x07x00

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

export outputpathbase=$changelogpathroot

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

rm $gaiaversionoutputfile

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
# Execute SmartEvent, SmartReport Data Backup
#----------------------------------------------------------------------------------------

export outputfilename='add_alias_cmds_all_'$outputfileprefix$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath
export outputfile=$outputfilepath$outputfilename

export alliasAddFile=$scriptspathroot/UserConfig/alias_commands.add.all.sh
export dotbashrcmodfile=$scriptspathroot/UserConfig/alias_commands_for_dot_bashrc.v00.01.00.sh


if [ ! -r $alliasAddFile ] ; then
    echo 'Missing '"$alliasAddFile"' file !!!' | tee -a "$outputfile"
    echo 'Exiting!' | tee -a "$outputfile"
    exit 255
else
    echo 'Found '"$alliasAddFile"' file :  '$alliasAddFile
    echo | tee -a "$outputfile"
    cat $alliasAddFile | tee -a "$outputfile"
    echo | tee -a "$outputfile"
fi

if [ ! -r $dotbashrcmodfile ] ; then
    echo 'Missing '"$dotbashrcmodfile"' file !!!' | tee -a "$outputfile"
    echo 'Exiting!' | tee -a "$outputfile"
    exit 255
else
    echo 'Found '"$dotbashrcmodfile"' file :  '$alliasAddFile
    echo | tee -a "$outputfile"
    cat $dotbashrcmodfile | tee -a "$outputfile"
    echo | tee -a "$outputfile"
fi

echo | tee -a "$outputfile"
dos2unix $alliasAddFile | tee -a "$outputfile"
dos2unix $dotbashrcmodfile | tee -a "$outputfile"
cp $alliasAddFile $HOME/ | tee -a "$outputfile"
cp $dotbashrcmodfile $HOME/ | tee -a "$outputfile"

echo | tee -a "$outputfile"
echo '===============================================================================' | tee -a "$outputfile"
echo '===============================================================================' | tee -a "$outputfile"
echo | tee -a "$outputfile"
echo "Adding alias commands from $alliasAddFile to user's $HOME/.bashrc file" | tee -a "$outputfile"
echo | tee -a "$outputfile"

echo | tee -a "$outputfile"
echo "Original $HOME/.bashrc file" | tee -a "$outputfile"
echo '===============================================================================' | tee -a "$outputfile"
echo | tee -a "$outputfile"
cat $HOME/.bashrc | tee -a "$outputfile"
echo | tee -a "$outputfile"
echo '===============================================================================' | tee -a "$outputfile"
echo | tee -a "$outputfile"

cat $dotbashrcmodfile >> $HOME/.bashrc | tee -a "$outputfile"
echo | tee -a "$outputfile"

echo | tee -a "$outputfile"
echo "Updated $HOME/.bashrc file" | tee -a "$outputfile"
echo '===============================================================================' | tee -a "$outputfile"
echo | tee -a "$outputfile"
cat $HOME/.bashrc | tee -a "$outputfile"
echo | tee -a "$outputfile"
echo '===============================================================================' | tee -a "$outputfile"
echo | tee -a "$outputfile"

ls -alh $HOME/ | tee -a "$outputfile"

echo | tee -a "$outputfile"
echo '===============================================================================' | tee -a "$outputfile"
echo '===============================================================================' | tee -a "$outputfile"
echo | tee -a "$outputfile"
echo | tee -a "$outputfile"
pwd | tee -a "$outputfile"
echo | tee -a "$outputfile"

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

#ls -alhR $outputpathbase
ls -alh $outputpathbase
echo

echo
echo 'Output location for all results is here : '$outputpathbase
echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

