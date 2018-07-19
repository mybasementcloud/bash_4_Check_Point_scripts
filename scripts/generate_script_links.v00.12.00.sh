#!/bin/bash
#
# SCRIPT Configure script link files and copy versioned scripts to generics
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.12.00
ScriptDate=2018-07-18
#

export BASHScriptVersion=v00x12x00

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
# Scripts link generation and setup
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


export workingroot=$customerworkpathroot
export workingbase=$workingroot/scripts
export linksbase=$workingbase/.links


if [ ! -r $workingbase ] ; then
    echo
    echo Error!
    echo Missing folder $workingbase
    echo
    echo Exiting!
    echo
    exit 255
else
    chmod 775 $workingbase
fi


if [ ! -r $linksbase ] ; then
    mkdir $linksbase
    chmod 775 $linksbase
else
    chmod 775 $linksbase
fi


# =============================================================================
# =============================================================================
# FOLDER:  Common
# =============================================================================


export workingdir=Common
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_gaia_version=determine_gaia_version_and_installation_type.v00.08.00.sh

file_godump=go_dump_folder_now.v00.04.00.sh
file_mkdump=make_dump_folder_now.v00.04.00.sh
file_godumpdtg=go_dump_folder_now_dtg.v00.04.00.sh
file_mkdumpdtg=make_dump_folder_now_dtg.v00.04.00.sh

ln -sf $sourcefolder/$file_gaia_version $linksfolder/gaia_version_type
ln -sf $sourcefolder/$file_gaia_version $workingroot/gaia_version_type

ln -sf $sourcefolder/$file_godump $linksfolder/godump
ln -sf $sourcefolder/$file_godump $workingroot/godump
ln -sf $sourcefolder/$file_godumpdtg $linksfolder/godtgdump
ln -sf $sourcefolder/$file_godumpdtg $workingroot/godtgdump

ln -sf $sourcefolder/$file_mkdump $linksfolder/mkdump
ln -sf $sourcefolder/$file_mkdump $workingroot/mkdump
ln -sf $sourcefolder/$file_mkdumpdtg $linksfolder/mkdtgdump
ln -sf $sourcefolder/$file_mkdumpdtg $workingroot/mkdtgdump


# =============================================================================
# =============================================================================
# FOLDER:  Config
# =============================================================================


export workingdir=Config
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_configcapture=config_capture_002_v00.13.00.sh

ln -sf $sourcefolder/$file_configcapture $linksfolder/config_capture
ln -sf $sourcefolder/$file_configcapture $workingroot/config_capture


# =============================================================================
# =============================================================================
# FOLDER:  GW
# =============================================================================


export workingdir=GW
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_watch_accel_stats=watch_accel_stats.v00.01.00.sh
file_set_inf_log_implied=set_informative_logging_implied_rules_on_R8x.v00.03.00.sh
file_reset_hitcount_w_bu=reset_hit_count_with_backup_001_v00.03.00.sh


ln -sf $sourcefolder/$file_watch_accel_stats $linksfolder/watch_accel_stats
ln -sf $sourcefolder/$file_set_inf_log_implied $linksfolder/set_informative_logging_implied_rules_on_R8x

ln -sf $sourcefolder/$file_reset_hitcount_w_bu $linksfolder/reset_hit_count_with_backup

if [ "$sys_type_GW" == "true" ]; then
    
    ln -sf $sourcefolder/$file_watch_accel_stats $workingroot/watch_accel_stats
    ln -sf $sourcefolder/$file_set_inf_log_implied $workingroot/set_informative_logging_implied_rules_on_R8x
    
    ln -sf $sourcefolder/$file_reset_hitcount_w_bu $workingroot/reset_hit_count_with_backup
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  Health_Check
# =============================================================================


export workingdir=Health_Check
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi


file_healthcheck=healthcheck.sh
file_healthdump=run_healthcheck_to_dump_dtg.v00.03.00.sh
file_cpservicecheck=check_status_checkpoint_services.v00.00.00.sh

ln -sf $sourcefolder/$file_healthcheck $linksfolder/healthcheck
ln -sf $sourcefolder/$file_healthcheck $workingroot/healthcheck
ln -sf $sourcefolder/$file_healthdump $linksfolder/healthdump
ln -sf $sourcefolder/$file_healthdump $workingroot/healthdump
ln -sf $sourcefolder/$file_cpservicecheck $linksfolder/checkpoint_service_status_check
ln -sf $sourcefolder/$file_cpservicecheck $workingroot/checkpoint_service_status_check


# =============================================================================
# =============================================================================
# FOLDER:  MDM
# =============================================================================


export workingdir=MDM
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_mds_backup=mds_backup_ugex_001_v00.09.00.sh
file_report_mdsstat=report_mdsstat.v00.08.00.sh
file_watch_mdsstat=watch_mdsstat.v00.07.00.sh

ln -sf $sourcefolder/$file_mds_backup $linksfolder/mds_backup_ugex
ln -sf $sourcefolder/$file_report_mdsstat $linksfolder/report_mdsstat
ln -sf $sourcefolder/$file_watch_mdsstat $linksfolder/watch_mdsstat

if [ "$sys_type_MDS" == "true" ]; then
    
    ln -sf $sourcefolder/$file_mds_backup $workingroot/mds_backup_ugex
    ln -sf $sourcefolder/$file_report_mdsstat $workingroot/report_mdsstat
    ln -sf $sourcefolder/$file_watch_mdsstat $workingroot/watch_mdsstat
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  Patch_HotFix
# =============================================================================


export workingdir=Patch_HotFix
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_patch_fix_webui_standard=fix_gaia_webui_login_dot_js.sh
file_patch_fix_webui_generic=fix_gaia_webui_login_dot_js_generic.sh

export need_fix_webui=false

case "$gaiaversion" in
    R80.20 ) 
        export need_fix_webui=false
        ;;
    *)
        export need_fix_webui=true
        ;;
esac

if [ "$need_fix_webui" == "true" ]; then
    
    ln -sf $sourcefolder/$file_patch_fix_webui_standard $linksfolder/fix_gaia_webui_login_dot_js
    ln -sf $sourcefolder/$file_patch_fix_webui_standard $workingroot/fix_gaia_webui_login_dot_js
    
    ln -sf $sourcefolder/$file_patch_fix_webui_generic $linksfolder/fix_gaia_webui_login_dot_js_generic

fi


# =============================================================================
# =============================================================================
# FOLDER:  Session_Cleanup
# =============================================================================


export workingdir=Session_Cleanup
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_rem_zl_sessions=remove_zerolocks_sessions.v00.05.00.sh
file_rem_zl_sessions_webapi=remove_zerolocks_web_api_sessions.v00.05.00.sh
file_mdm_rem_zl_sessions=mdm_remove_zerolocks_sessions.v00.05.00.sh
file_mdm_rem_zl_sessions_webapi=mdm_remove_zerolocks_web_api_sessions.v00.05.00.sh

file_show_zl_sessions=show_zerolocks_sessions.v00.05.00.sh
file_show_zl_sessions_webapi=show_zerolocks_web_api_sessions.v00.05.00.sh
file_mdm_show_zl_sessions=mdm_show_zerolocks_sessions.v00.05.00.sh
file_mdm_show_zl_sessions_webapi=mdm_show_zerolocks_web_api_sessions.v00.05.00.sh

export do_session_cleanup=false

case "$gaiaversion" in
    R80 | R80.10 | R80.20 ) 
        export do_session_cleanup=true
        ;;
    *)
        export do_session_cleanup=false
        ;;
esac

if [ "$do_session_cleanup" == "true" ]; then
    
    ln -sf $sourcefolder/$file_show_zl_sessions $linksfolder/show_zerolocks_sessions
    ln -sf $sourcefolder/$file_show_zl_sessions_webapi $linksfolder/show_zerolocks_web_api_sessions
    ln -sf $sourcefolder/$file_rem_zl_sessions $linksfolder/remove_zerolocks_sessions
    ln -sf $sourcefolder/$file_rem_zl_sessions_webapi $linksfolder/remove_zerolocks_web_api_sessions

    ln -sf $sourcefolder/$file_mdm_show_zl_sessions $linksfolder/mdm_show_zerolocks_sessions
    ln -sf $sourcefolder/$file_mdm_show_zl_sessions_webapi $linksfolder/mdm_show_zerolocks_web_api_sessions
    ln -sf $sourcefolder/$file_mdm_rem_zl_sessions $linksfolder/mdm_remove_zerolocks_sessions
    ln -sf $sourcefolder/$file_mdm_rem_zl_sessions_webapi $linksfolder/mdm_remove_zerolocks_web_api_sessions
    
    if [ "$sys_type_GW" == "false" ]; then
        
        if [ "$sys_type_MDS" == "true" ]; then
            
            ln -sf $sourcefolder/$file_mdm_show_zl_sessions $workingroot/mdm_show_zerolocks_sessions
            ln -sf $sourcefolder/$file_mdm_show_zl_sessions_webapi $workingroot/mdm_show_zerolocks_web_api_sessions
            ln -sf $sourcefolder/$file_mdm_rem_zl_sessions $workingroot/mdm_remove_zerolocks_sessions
            ln -sf $sourcefolder/$file_mdm_rem_zl_sessions_webapi $workingroot/mdm_remove_zerolocks_web_api_sessions
            
        else
            
            ln -sf $sourcefolder/$file_show_zl_sessions $workingroot/show_zerolocks_sessions
            ln -sf $sourcefolder/$file_show_zl_sessions_webapi $workingroot/show_zerolocks_web_api_sessions
            ln -sf $sourcefolder/$file_rem_zl_sessions $workingroot/remove_zerolocks_sessions
            ln -sf $sourcefolder/$file_rem_zl_sessions_webapi $workingroot/remove_zerolocks_web_api_sessions
            
        fi
    fi
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  SmartEvent
# =============================================================================


export workingdir=SmartEvent
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_smev_backup=SmartEvent_Backup_R8X_v00.04.00.sh
file_smev_restore=SmartEvent_Restore_R8X_v00.00.06.sh

ln -sf $sourcefolder/$file_smev_backup $linksfolder/SmartEvent_backup
ln -sf $sourcefolder/$file_smev_restore $linksfolder/SmartEvent_restore

if [ "$sys_type_SmartEvent" == "true" ]; then
    
    ln -sf $sourcefolder/$file_smev_backup $workingroot/SmartEvent_backup
    #ln -sf $sourcefolder/$file_smev_restore $workingroot/SmartEvent_restore
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  SMS
# =============================================================================


export workingdir=SMS
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_migrate_export_epm=migrate_export_epm_ugex_001_v00.13.00.sh
file_migrate_export_npm=migrate_export_npm_ugex_001_v00.13.00.sh
file_mgmt_report=report_cpwd_admin_list.v00.08.00.sh
file_mgmt_restart=restart_mgmt.v00.09.00.sh
file_mgmt_watch=watch_cpwd_admin_list.v00.05.00.sh
file_reset_hitcount_sms=reset_hit_count_on_R80_SMS_commands_001_v00.01.00.sh

ln -sf $sourcefolder/$file_migrate_export_npm $linksfolder/migrate_export_npm_ugex
ln -sf $sourcefolder/$file_mgmt_restart $linksfolder/restart_mgmt
ln -sf $sourcefolder/$file_mgmt_report $linksfolder/report_cpwd_admin_list
ln -sf $sourcefolder/$file_mgmt_watch $linksfolder/watch_cpwd_admin_list

ln -sf $sourcefolder/$file_reset_hitcount_sms $linksfolder/reset_hit_count_on_R80_SMS_commands

if [ "$sys_type_SMS" == "true" ]; then
    
    ln -sf $sourcefolder/$file_migrate_export_npm $workingroot/migrate_export_npm_ugex
    ln -sf $sourcefolder/$file_mgmt_restart $workingroot/restart_mgmt
    ln -sf $sourcefolder/$file_mgmt_report $workingroot/report_cpwd_admin_list
    ln -sf $sourcefolder/$file_mgmt_watch $workingroot/watch_cpwd_admin_list
    
    ln -sf $sourcefolder/$file_reset_hitcount_sms $workingroot/reset_hit_count_on_R80_SMS_commands
    
fi

if [ $Check4EPM -gt 0 ]; then

    ln -sf $sourcefolder/$file_migrate_export_epm $linksfolder/migrate_export_epm_ugex
    ln -sf $sourcefolder/$file_migrate_export_epm $workingroot/migrate_export_epm_ugex

fi


# =============================================================================
# =============================================================================
# FOLDER:  UserConfig
# =============================================================================


export workingdir=UserConfig
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_add_allias_all=add_alias_commands.all.v00.07.00.sh

ln -sf $sourcefolder/$file_add_allias_all $linksfolder/add_alias_commands
ln -sf $sourcefolder/$file_add_allias_all $workingroot/add_alias_commands

ln -sf $sourcefolder/$file_add_allias_all $linksfolder/add_alias_commands.all


# =============================================================================
# =============================================================================
# FOLDER:  
# =============================================================================

# =============================================================================
# =============================================================================
