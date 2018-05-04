#!/bin/bash
#
# SCRIPT Configure script link files and copy versioned scripts to generics
#
# (C) 2017-2018 Eric James Beasley
#
ScriptVersion=00.06.03
ScriptDate=2018-05-04
#

export BASHScriptVersion=v00x06x03

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
# Scripts link generation and setup
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


export workingroot=/var/upgrade_export
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

ln -sf $sourcefolder/determine_gaia_version_and_installation_type.v00.04.00.sh $linksfolder/gaia_version_type
ln -sf $sourcefolder/determine_gaia_version_and_installation_type.v00.04.00.sh $workingroot/gaia_version_type
ln -sf $sourcefolder/make_dump_folder_now.v00.01.00.sh $linksfolder/mkdump
ln -sf $sourcefolder/make_dump_folder_now.v00.01.00.sh $workingroot/mkdump
ln -sf $sourcefolder/make_dump_folder_now_dtg.v00.01.00.sh $linksfolder/mkdtgdump
ln -sf $sourcefolder/make_dump_folder_now_dtg.v00.01.00.sh $workingroot/mkdtgdump

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

ln -sf $sourcefolder/config_capture_002_v00.07.01.sh $linksfolder/config_capture
ln -sf $sourcefolder/config_capture_002_v00.07.01.sh $workingroot/config_capture


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

ln -sf $sourcefolder/watch_accel_stats.v00.01.00.sh $linksfolder/watch_accel_stats
ln -sf $sourcefolder/set_informative_logging_implied_rules_on_R8x.v00.01.00.sh $linksfolder/set_informative_logging_implied_rules_on_R8x

ln -sf $sourcefolder/reset_hit_count_with_backup_001_v00.01.00.sh $linksfolder/reset_hit_count_with_backup

if [ "$sys_type_GW" == "true" ]; then
    
    ln -sf $sourcefolder/watch_accel_stats.v00.01.00.sh $workingroot/watch_accel_stats
    ln -sf $sourcefolder/set_informative_logging_implied_rules_on_R8x.v00.01.00.sh $workingroot/set_informative_logging_implied_rules_on_R8x
    
    ln -sf $sourcefolder/reset_hit_count_with_backup_001_v00.01.00.sh $workingroot/reset_hit_count_with_backup
    
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

ln -sf $sourcefolder/healthcheck.sh $linksfolder/healthcheck
ln -sf $sourcefolder/healthcheck.sh $workingroot/healthcheck
#ln -sf $sourcefolder/run_healthcheck_to_dump_dtg.v00.01.00.sh $linksfolder/run_healthcheck_to_dump_dtg
#ln -sf $sourcefolder/run_healthcheck_to_dump_dtg.v00.01.00.sh $workingroot/run_healthcheck_to_dump_dtg
#ln -sf $sourcefolder/run_healthcheck_to_dump_dtg.v00.01.00.sh $linksfolder/healthcheck
#ln -sf $sourcefolder/run_healthcheck_to_dump_dtg.v00.01.00.sh $workingroot/healthcheck
#ln -sf $sourcefolder/run_healthcheck_to_dump_dtg.v00.01.00.sh $linksfolder/dump_healthcheck
#ln -sf $sourcefolder/run_healthcheck_to_dump_dtg.v00.01.00.sh $workingroot/dump_healthcheck
ln -sf $sourcefolder/run_healthcheck_to_dump_dtg.v00.01.00.sh $linksfolder/healthdump
ln -sf $sourcefolder/run_healthcheck_to_dump_dtg.v00.01.00.sh $workingroot/healthdump


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

ln -sf $sourcefolder/mds_backup_ugex_001_v00.06.01.sh $linksfolder/mds_backup_ugex
ln -sf $sourcefolder/report_mdsstat.v00.03.00.sh $linksfolder/report_mdsstat
ln -sf $sourcefolder/watch_mdsstat.v00.03.00.sh $linksfolder/watch_mdsstat

if [ "$sys_type_MDS" == "true" ]; then
    
    ln -sf $sourcefolder/mds_backup_ugex_001_v00.06.01.sh $workingroot/mds_backup_ugex
    ln -sf $sourcefolder/report_mdsstat.v00.03.00.sh $workingroot/report_mdsstat
    ln -sf $sourcefolder/watch_mdsstat.v00.03.00.sh $workingroot/watch_mdsstat
    
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
    
    ln -sf $sourcefolder/remove_zerolocks_sessions.v00.02.00.sh $linksfolder/remove_zerolocks_sessions
    ln -sf $sourcefolder/remove_zerolocks_web_api_sessions.v00.02.00.sh $linksfolder/remove_zerolocks_web_api_sessions
    ln -sf $sourcefolder/show_zerolocks_sessions.v00.02.00.sh $linksfolder/show_zerolocks_sessions
    ln -sf $sourcefolder/show_zerolocks_web_api_sessions.v00.02.00.sh $linksfolder/show_zerolocks_web_api_sessions

    ln -sf $sourcefolder/mdm_remove_zerolocks_sessions.v00.03.00.sh $linksfolder/mdm_remove_zerolocks_sessions
    ln -sf $sourcefolder/mdm_remove_zerolocks_web_api_sessions.v00.03.00.sh $linksfolder/mdm_remove_zerolocks_web_api_sessions
    ln -sf $sourcefolder/mdm_show_zerolocks_sessions.v00.03.00.sh $linksfolder/mdm_show_zerolocks_sessions
    ln -sf $sourcefolder/mdm_show_zerolocks_web_api_sessions.v00.03.00.sh $linksfolder/mdm_show_zerolocks_web_api_sessions
    
    if [ "$sys_type_GW" == "false" ]; then
        
        if [ "$sys_type_MDS" == "true" ]; then
            
            ln -sf $sourcefolder/mdm_show_zerolocks_sessions.v00.03.00.sh $workingroot/mdm_show_zerolocks_sessions
            ln -sf $sourcefolder/mdm_show_zerolocks_web_api_sessions.v00.03.00.sh $workingroot/mdm_show_zerolocks_web_api_sessions
            ln -sf $sourcefolder/mdm_remove_zerolocks_sessions.v00.03.00.sh $workingroot/mdm_remove_zerolocks_sessions
            ln -sf $sourcefolder/mdm_remove_zerolocks_web_api_sessions.v00.03.00.sh $workingroot/mdm_remove_zerolocks_web_api_sessions
            
        else
            
            ln -sf $sourcefolder/show_zerolocks_sessions.v00.02.00.sh $workingroot/show_zerolocks_sessions
            ln -sf $sourcefolder/show_zerolocks_web_api_sessions.v00.02.00.sh $workingroot/show_zerolocks_web_api_sessions
            ln -sf $sourcefolder/remove_zerolocks_sessions.v00.02.00.sh $workingroot/remove_zerolocks_sessions
            ln -sf $sourcefolder/remove_zerolocks_web_api_sessions.v00.02.00.sh $workingroot/remove_zerolocks_web_api_sessions
            
        fi
    fi
    
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

ln -sf $sourcefolder/migrate_export_ugex_001_v00.07.00.sh $linksfolder/migrate_export_ugex
ln -sf $sourcefolder/restart_mgmt.v00.04.00.sh $linksfolder/restart_mgmt
ln -sf $sourcefolder/report_cpwd_admin_list.v00.03.00.sh $linksfolder/report_cpwd_admin_list
ln -sf $sourcefolder/watch_cpwd_admin_list.v00.03.00.sh $linksfolder/watch_cpwd_admin_list

ln -sf $sourcefolder/reset_hit_count_on_R80_SMS_commands_001_v00.01.00.sh $linksfolder/reset_hit_count_on_R80_SMS_commands

if [ "$sys_type_SMS" == "true" ]; then
    
    ln -sf $sourcefolder/migrate_export_ugex_001_v00.07.00.sh $workingroot/migrate_export_ugex
    ln -sf $sourcefolder/restart_mgmt.v00.04.00.sh $workingroot/restart_mgmt
    ln -sf $sourcefolder/report_cpwd_admin_list.v00.03.00.sh $workingroot/report_cpwd_admin_list
    ln -sf $sourcefolder/watch_cpwd_admin_list.v00.03.00.sh $workingroot/watch_cpwd_admin_list
    
    ln -sf $sourcefolder/reset_hit_count_on_R80_SMS_commands_001_v00.01.00.sh $workingroot/reset_hit_count_on_R80_SMS_commands
    
fi

if [ $Check4EP773000 -gt 0 ]; then

    ln -sf $sourcefolder/epm_migrate_export_ugex_001_v00.07.00.sh $linksfolder/epm_migrate_export_ugex
    ln -sf $sourcefolder/epm_migrate_export_ugex_001_v00.07.00.sh $workingroot/epm_migrate_export_ugex

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

ln -sf $sourcefolder/add_alias_commands.all.v00.03.00.sh $linksfolder/add_alias_commands
ln -sf $sourcefolder/add_alias_commands.all.v00.03.00.sh $workingroot/add_alias_commands

ln -sf $sourcefolder/add_alias_commands.all.v00.03.00.sh $linksfolder/add_alias_commands.all
ln -sf $sourcefolder/add_alias_commands.000.v00.03.00.sh $linksfolder/add_alias_commands.000
ln -sf $sourcefolder/add_alias_commands.001.v00.03.00.sh $linksfolder/add_alias_commands.001

# =============================================================================
# =============================================================================
# FOLDER:  
# =============================================================================

# =============================================================================
# =============================================================================
