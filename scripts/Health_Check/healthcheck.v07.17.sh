#!/bin/bash
#====================================================================================================
# TITLE:                    healthcheck.sh
# USAGE:                    ./healthcheck.sh
#
# DESCRIPTION:              Checks the system for things that may adversely impact performance or reliability.
#
# AUTHOR (all versions):    Nathan Davieau (Check Point Diamond Services Manager)
# CO-AUTHOR (v0.2-v3.6):    Rosemarie Rodriguez
# CODE CONTRIBUTORS:        Brandon Pace, Russell Seifert, Joshua Hatter, Kevin Hoffman, Michael Bybee
#                           Brian Sterne, Yevgeniy Yeryomin
# SPECIAL THANKS:           Jonathan Passmore, Jamie Davieau, Corey Taylor
# VERSION:                  7.17
# SK:                       sk121447
#
# VLAN/IP overlap and Any GUI Client checks courtesy of ccc created by Danny Jung.
#====================================================================================================


#====================================================================================================
#  Check Point Sources
#====================================================================================================
source /etc/profile.d/CP.sh 2> /dev/null
source /etc/profile.d/vsenv.sh 2> /dev/null
source $MDSDIR/scripts/MDSprofile.sh 2> /dev/null
source $MDS_SYSTEM/shared/sh_utilities.sh 2> /dev/null
source $MDS_SYSTEM/shared/mds_environment_utils.sh 2> /dev/null


#====================================================================================================
#  Global Variables
#====================================================================================================
summarizedLogFile=/var/log/healthcheck.log
logfile=/var/log/$(hostname)_health-check_$(date +%Y%m%d%H%M).txt
html_file=/var/log/$(hostname)_health-check_$(date +%Y%m%d%H%M).html
csv_log=/var/log/$(hostname)_health-check_summary_$(date +%Y%m%d%H%M).csv
csv_log_history=/var/log/health-check_summary_history.csv
output_log=/var/log/hc_output_log.tmp
healthcheck_url_tmp=/var/tmp/healthcheck_download.tmp
healthcheck_download_temp=/var/tmp/healthcheck.tmp
remote_log_file_list=/var/tmp/remote_log_list.tmp
full_output_log=/var/log/$(hostname)_health-check_full_$(date +%Y%m%d%H%M).tmp
installed_script_path="/usr/local/bin/healthcheck.sh"
cpridAvailCheckResult=/var/tmp/cpridAvailCheck.tmp
executed_script_path=$(readlink -f $0)
device_manufacturer=$(dmidecode -t system 2>/dev/null | grep Manufacturer | awk '{print $2}' | tr -d ',')
summary_error=0
vs_error=0
all_checks_passed=true
script_ver="7.17 09-17-2021"
collection_mode="local"
domain_specified=false
remote_operations=false
offline_operations=false
update_requested="false"
alt_api_port=""
headerCategory=""
headerCheck=""


#====================================================================================================
#  Version Information
#====================================================================================================
r7730_ga_jumbo="351"
r8010_ga_jumbo="290"
r8020_ga_jumbo="202"
r8030_ga_jumbo="237"
r8040_ga_jumbo="120"
r81_ga_jumbo="36"
r8110_ga_jumbo="0"
latest_cpinfo_build="914000219"
latest_cpuse_build="2047"


#====================================================================================================
#  Text Color Formatting
#====================================================================================================
text_red=$(tput setaf 1)
text_green=$(tput setaf 2)
text_yellow=$(tput setaf 3)
text_pink=$(tput setaf 5)
text_blue=$(tput setaf 6)
text_reset=$(tput sgr0)


#====================================================================================================
#  Determine System Version
#====================================================================================================
if [[ -e /etc/cp-release ]]; then
    cp_version=$(cat /etc/cp-release | egrep -ow 'R[0-9\.]+')
    cp_underscore_version=$(echo $cp_version | sed 's/\./_/')

    if [[ $(echo $cp_underscore_version | grep R76) ]]; then
        current_version="7600"
    elif [[ $(echo $cp_underscore_version | grep -ow R77) ]]; then
        current_version="7700"
    elif [[ $(echo $cp_underscore_version | grep -ow R77_10) ]]; then
        current_version="7710"
    elif [[ $(echo $cp_underscore_version | grep -ow R77_20) ]]; then
        current_version="7720"
    elif [[ $(echo $cp_underscore_version | grep -ow R77_30) ]]; then
        current_version="7730"
    elif [[ $(echo $cp_underscore_version | grep -ow R80) ]]; then
        current_version="8000"
    elif [[ $(echo $cp_underscore_version | grep -ow R80_10) ]]; then
        current_version="8010"
    elif [[ $(echo $cp_underscore_version | grep -ow R80_20) ]]; then
        current_version="8020"
    elif [[ $(echo $cp_underscore_version | grep -ow R80_30) ]]; then
        current_version="8030"
    elif [[ $(echo $cp_underscore_version | grep -ow R80_40) ]]; then
        current_version="8040"
    elif [[ $(echo $cp_underscore_version | grep -ow R81) ]]; then
        current_version="8100"
    elif [[ $(echo $cp_underscore_version | grep -ow R81_10) ]]; then
        current_version="8110"
    else
        yesno_loop=1
        printf "\nSupported Versions:\n" | tee -a $output_log
        printf "\tR81.10\n" | tee -a $output_log
        printf "\tR81\n" | tee -a $output_log
        printf "\tR80.xx\n" | tee -a $output_log
        printf "\tR77.xx\n" | tee -a $output_log
        printf "\tR76.xx\n" | tee -a $output_log
        printf "\nDetected local system version:\n$current_version\n\n" | tee -a $output_log
        printf "This script has not been certified for this version and may not function properly on this system.\n" | tee -a $output_log

        while [[ $yesno_loop -eq 1 ]]; do
            printf "Do you still want to continue? [y/n]: "
            read -n1 yesno
            if [[ $yesno == "Y" || $yesno == "y" ]]; then
                printf "\nProceeding per user decision.\n" | tee -a $output_log
                current_version="0"
                yesno_loop=0
            elif [[ $yesno == "N" || $yesno == "n" ]]; then
                printf "\nAborting per user decision.\n" | tee -a $output_log
                exit 0
            else
                printf "$yesno is not a valid option.  Please try again.\n"
            fi
        done
    fi
else
    current_version=0
fi

#====================================================================================================
#  Determine System Type
#====================================================================================================
if [[ -e /etc/cp-release ]]; then
    if [[ $(cat /etc/cp-release | grep SP) ]]; then
        sys_type="SP"
    elif [[ $(echo $MDSDIR | grep mds) ]]; then
        sys_type="MDS"
        if [[ $(grep "LoginServer" $CPDIR/registry/HKLM_registry.data  | awk -F\" '{print $2}') == "[4]0" ]]; then
            sys_type="MLM"
        fi
    elif [[ $($CPDIR/bin/cpprod_util FwIsVSX 2> /dev/null) == *"1"* ]]; then
        sys_type="VSX"
        vsenv 0 > /dev/null 2>&1
    elif [[ $($CPDIR/bin/cpprod_util FwIsStandAlone 2> /dev/null) == *"1"* ]]; then
        sys_type="STANDALONE"
    elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallModule 2> /dev/null) == *"1"*  ]]; then
        sys_type="GATEWAY"
    elif [[ $($CPDIR/bin/cpprod_util FwIsLogServer 2> /dev/null) == *"1"*  ]]; then
        sys_type="LOG"
    elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallMgmt 2> /dev/null) == *"1"*  ]]; then
        sys_type="SMS"
    else
        sys_type="N/A"
    fi
else
    sys_type="N/A"
fi

#####################################################################################################
#
#  Start of Functions section
#
#####################################################################################################


#====================================================================================================
#  Put information from gateway's summary report to global summary report
#====================================================================================================
addCsvResults_to_CsvGlobalSummaryFile()
{
    local _gwSummaryReportFile=$1
    local _cpridStatus=$2
    local _status=""
    local _statusLine=""
    
    #Detect header categories
    read -r -d '' csvReportTempate << EOM
Category,Check
System,Uptime
System,OS Edition
NTP,NTP Daemon
Disk Space,Free Disk Space
Memory,Physical Memory
Memory,Swap Memory
Memory,Hash Kernel Memory (hmem)
Memory,System Kernel Memory (smem)
Memory,Kernel Memory (kmem)
Memory,Memory 30-Day Average
Memory,Memory 30-Day Peak
CPU,CPU idle%
CPU,CPU user%
CPU,CPU system%
CPU,CPU wait%
CPU,CPU interrupt%
CPU,CPU 30-Day Average
CPU,CPU 30-Day Peak
Interface Stats,RX Errors
Interface Stats,RX Drops
Interface Stats,RX Missed Errors
Interface Stats,RX Overruns
Interface Stats,TX Errors
Interface Stats,TX Drops
Interface Stats,TX Carrier Errors
Interface Stats,TX Overruns
Known Issues,Issues found in logs
Processes,Zombie Processes
Processes,Process Restarts
Core Files,Usermode Cores Present
Core Files,Kernel Cores Present
Check Point,CPInfo Build Number
Check Point,CPUSE Build Number
Check Point,CPView History Status
Check Point,Jumbo Version
Check Point,CP Version
Licensing,Licenses
Licensing,Contracts
Debugs,Active tcpdump
Debugs,Active Debug Processes
Debugs,Debug Flags Present
Debugs,TDERROR Configured
Fragments,Fragments
Connections Table,Peak Connections
Connections Table,Concurrent Connections
Connections Table,NAT Connections
ClusterXL,Cluster Status
ClusterXL,Problem Notifications
ClusterXL,Sync Status
ClusterXL,Number of Sync Interfaces
ClusterXL,Cluster Failovers
SecureXL,SecureXL Status
SecureXL,Accept Templates
SecureXL,Drop Templates
SecureXL,F2F Packets
SecureXL,PXL Packets
SecureXL,Aggressive Aging
CoreXL,CoreXL Status
CoreXL,SND/FW Core Overlap
CoreXL,SND/FW Core Distribution
CoreXL,SND Core Distribution
CoreXL,Dynamic Dispatcher
Logging,Local Logging
EOM

    headerCategory=""
    headerCheck=""

    #Set variable to later skip the first line
    i=1
    while read -r line; do
        # Skip first line (which is header)
        if [[ $i == "1" ]];then
            ((i++))
            continue
        fi

        # Put the data into lines
        #logger "line $i: $line"
        Category=$(echo $line | awk -F, '{print $1}')
        Check=$(echo $line | awk -F, '{print $2}')
        headerCategory="$headerCategory$Category,"
        headerCheck="$headerCheck$Check,"

        # Put Category, Check pair into the array
        categoryCheckArr=("${categoryCheckArr[@]}" "$Category,$Check")
    done <<< "$csvReportTempate"

    # Write header only if the file is empty doesn't exists
    if [[ ! -f $csv_log_history ]]; then
        echo "Timestamp,MGMT,Server,GW,GW,GW,$headerCategory" >> $csv_log_history
        echo "Timestamp,MGMT,Server,GW_Name,GW_IP,cpridStatus,$headerCheck," >> $csv_log_history
    fi
    
    # If cprid is Unavailable
    if [[ $_cpridStatus == "cpridUnavail" ]]; then
        echo "$(date +"%Y/%m/%d %H:%M"),$(hostname),$current_cma,$gateway_name,$device_ip,$_cpridStatus" >> $csv_log_history
    else
        # Get the checks results/status from the gateway csv report
        for categoryCheck in "${categoryCheckArr[@]}"; do
            _status=$(grep "$categoryCheck" $_gwSummaryReportFile | awk -F, '{print $3}')
            _statusLine="$_statusLine$_status,"
            
            #Prevent additional csv info from being written
            if [[ $categoryCheck == ${categoryCheckArr[-1]} ]]; then
                break
            fi
        done
        
        #Write the status for each check to the CSV
        echo "$(date +"%Y/%m/%d %H:%M"),$(hostname),$current_cma,$gateway_name,$device_ip,$_cpridStatus,$_statusLine" >> $csv_log_history
    fi
}


#====================================================================================================
#  Blades Enabled Function
#====================================================================================================
check_blades_enabled()
{
    #Check blades status
    printf "\n\n# Blades Status:\n" >> $full_output_log
    blades_enabled=$(blades_summary 2> /dev/null | grep "blade id" | awk -F\" '{print $2, $4}' | grep 1| sed 's/1//g')
    blades_disabled=$(blades_summary 2> /dev/null | grep "blade id" | awk -F\" '{print $2, $4}' | grep 0 | sed 's/0//g')

    #Log enabled blades or "N/A" if none are present
    printf "Enabled Blades:\n" >> $full_output_log
    if [[ -z $blades_enabled ]]; then
        if [[ $sys_type == "SMS" && $($CPDIR/bin/cpprod_util RtIsRt 2> /dev/null) == *"1"*  ]]; then
            printf "SmartEvent\n">> $full_output_log
        elif [[ $sys_type == "STANDALONE" || $sys_type == "SMS" || $sys_type == "MDS" ]]; then
            printf "Management\n">> $full_output_log
        elif [[ $sys_type == "LOG" ]]; then
            printf "Log Server\n">> $full_output_log
        else
            printf "Unable to detect enabled blades.\n" >> $full_output_log
        fi
    else
        echo "$blades_enabled" >> $full_output_log
    fi

    #Log disabled blades or "N/A" if none are present
    printf "\nDisabled Blades:\n" >> $full_output_log
    if [[ -z $blades_disabled ]]; then
        printf "Unable to detect disabled blades.\n" >> $full_output_log
    else
        echo "$blades_disabled" >> $full_output_log
    fi

    #Unset blades check variables
    unset blades_enabled
    unset blades_disabled
}


#====================================================================================================
#  ClusterXL Function
#====================================================================================================
check_clusterxl()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="ClusterXL\t\t"

    #====================================================================================================
    #  Cluster Status Check
    #====================================================================================================
    printf "| ClusterXL\t\t| Cluster Status\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>ClusterXL</b></span><br>\n' >> $html_file
    printf '<span><b>Cluster Status - </b></span><b>' >> $html_file
    full_cphaprob_stat=$(cphaprob stat)
    cphaprob_stat=$(echo "$full_cphaprob_stat" | grep ^[0-9])

    #If the cluster is HA, find the number of active members
    if [[ "$full_cphaprob_stat" == *"High Availability"* ]]; then
        active_active_check=$(echo "$cphaprob_stat" | grep -i "Active" | wc -l)
    else
        active_active_check=0
    fi

    #Find the overall number of cluster members
    single_member_check=$(echo "$cphaprob_stat" | wc -l)

    #Find the local cluster status
    cluster_status=$(echo "$cphaprob_stat" | head -n10 | grep local)
    if [[ $active_active_check -gt 1 ]]; then
        cluster_status="Active-Active"
    elif [[ $full_cphaprob_stat == *"HA module not started."* ]]; then
        cluster_status="HA Module Not Started"
    else
        if [[ $(echo $cluster_status | grep -i "down") ]]; then
            cluster_status="Down"
        elif [[ $(echo $cluster_status | grep -i "ready") ]]; then
            cluster_status="Ready"
        elif [[ $(echo $cluster_status | grep -i "initializing") ]]; then
            cluster_status="Initializing"
        elif [[ $(echo $cluster_status | grep -i -e "Active Attention" -e 'ACTIVE(!)') ]]; then
            cluster_status="Active Attention"
        elif [[ $(echo $cluster_status | grep -i "Standby") ]]; then
            cluster_status="Standby"
        elif [[ $(echo $cluster_status | grep -i "Active") ]]; then
            cluster_status="Active"
        fi
    fi

    #Find status of other cluster members
    other_member_status=$(echo "$cphaprob_stat" | grep ^[0-9] | grep -v local)
    if [[ $other_member_status == *"Down"* ]]; then
        other_member_status="Down"
    elif [[ $other_member_status == *"Ready"* ]]; then
        other_member_status="Ready"
    elif [[ $other_member_status == *"Initializing"* ]]; then
        other_member_status="Initializing"
    elif [[ $other_member_status == *"Active Attention"* ]]; then
        other_member_status="Active Attention"
    elif [[ $other_member_status == *"Standby"* ]]; then
        other_member_status="Standby"
    elif [[ $other_member_status == *"Active"* ]]; then
        other_member_status="Active"
    fi

    #Other member problems
    if [[ $other_member_status == "Down" || $other_member_status == "Ready" || $other_member_status == "Initializing" || $other_member_status == "Active Attention" ]]; then
        result_check_failed
        printf "ClusterXL,Cluster Status,WARNING,\n" >> $csv_log
        printf "Cluster peer is: $other_member_status.\n" >> $logfile
        printf "<span>Cluster peer is: $other_member_status.</span><br><br>\n" >> $html_file

    #Single member problem
    elif [[ $single_member_check -eq 1 && $full_cphaprob_stat != *"HA module not started"* ]]; then
        result_check_failed
        printf "ClusterXL,Cluster Status,WARNING,\n" >> $csv_log
        printf "\nUnable to find remote partner.\n" >> $logfile
        printf "This is usually due to one of the following reasons:\n" >> $logfile
        printf " -There is no network connectivity between the members of the cluster on the sync network.\n" >> $logfile
        printf " -The partner does not have state synchronization enabled.\n" >> $logfile
        printf " -One partner is using broadcast mode while the other is using multicast mode.\n" >> $logfile
        printf " -One of the monitored processes has an issue, such as no policy loaded.\n" >> $logfile
        printf " -The partner firewall is down.\n" >> $logfile
        printf "<span>Unable to find remote partner.<br>This is usually due to one of the following reasons:<br> -There is no network connectivity between the members of the cluster on the sync network.<br> -The partner does not have state synchronization enabled.<br> -One partner is using broadcast mode while the other is using multicast mode.<br> -One of the monitored processes has an issue, such as no policy loaded.<br> -The partner firewall is down.</span><br><br>\n" >> $html_file

    #Current member success
    elif [[ $cluster_status == "Active" || $cluster_status == "Standby" ]]; then
        result_check_passed
        printf "ClusterXL,Cluster Status,OK,\n" >> $csv_log

    #Current member problem
    else
        result_check_failed
        printf "ClusterXL,Cluster Status,WARNING,\n" >> $csv_log
        printf "Cluster status is: $cluster_status.\n" >> $logfile
        printf "<span>Cluster status is: $cluster_status.</span><br>\n" >> $html_file
        if [[ "$full_cphaprob_stat" == *"HA module not started."* ]]; then
            printf "Cluster membership is enabled in cpconfig but the HA module is not started.\nPlease review the configuration to determine if this device is supposed to be a member of a cluster.\n" >> $logfile
            printf "<span>Cluster membership is enabled in cpconfig but the HA module is not started.<br>Please review the configuration to determine if this device is supposed to be a member of a cluster.</span><br><br>\n" >> $html_file
        fi
    fi

    #Checks only performed if cluster is active
    test_output_error=0
    if [[ "$cphaprob_stat" != *"HA module not started."* ]]; then
        #ClusterXL interfaces statistics
        cluster_a_if=$(cphaprob -a if)
        printf "\n\nCluster Interfaces:\n$cluster_a_if\n" | sed "/^$/d" >> $full_output_log

        #====================================================================================================
        #  Cluster PNOTE Check
        #====================================================================================================
        printf "|\t\t\t| Problem Notifications\t\t|" | tee -a $output_log
        printf '<span><b>Problem Notifications - </b></span><b>' >> $html_file
        if [[ $current_version -ge 7730 ]]; then
            cluster_pnotes=$(cphaprob -l list | grep -e "Device Name" -e "Current state")
        else
            cluster_pnotes=$(cphaprob -ia list | grep -e "Device Name" -e "Current state")
        fi
        problem_state=$(echo "$cluster_pnotes" | grep -B1 "problem" | grep Device | awk '{print $3, $4, $5}')
        problem_count=$(echo "$cluster_pnotes" | grep "problem" | wc -l)
        if [[ $problem_count -ge 1 ]]; then
            result_check_failed
            printf "ClusterXL,Problem Notifications,WARNING,\n" >> $csv_log
            printf "The following pnotes were detected:\n" >> $logfile
            printf "<span>The following pnotes were detected:</span><br>\n<span>" >> $html_file
            while read -r current_pnote; do
                printf "  $current_pnote\n" >> $logfile
                printf "  $current_pnote<br>" >> $html_file
            done <<< "$problem_state"
            printf "</span><br>\n" >> $html_file
            printf "\n" >> $logfile
        else
            result_check_passed
            printf "ClusterXL,Problem Notifications,OK,\n" >> $csv_log
        fi

        #Add additional information to the full log
        printf "\n\n\nPnotes:\n$cluster_pnotes\n" >> $full_output_log
        printf "\n\nPnotes in Problem State:\n" >> $full_output_log
        if [[ problem_count -ge 1 ]]; then
            echo "$problem_state" >> $full_output_log
        else
            printf "N/A\n" >> $full_output_log
        fi
        printf "\n" >> $full_output_log

        #Collect full cluster status information
        clusterXL_HA_info=$(cpstat ha -f all 2> /dev/null | sed "/^$/d" | sed '/table/i \\')
        printf "\nCluster full status HA information:\n$clusterXL_HA_info\n" >> $full_output_log


        #====================================================================================================
        #  Cluster Sync Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Sync Status\t\t\t|" | tee -a $output_log
        printf '<span><b>Sync Status - </b></span><b>' >> $html_file
        if [[ $current_version -le 8010 ]]; then
            cluster_sync=$(fw ctl pstat | grep -A50 Sync:)
            printf "\n\nCluster Sync:\n$cluster_sync\n" >> $full_output_log

            if [[ $cluster_sync == *"off"* ]]; then
                result_check_failed
                printf "ClusterXL,Sync Status,WARNING,sk34476 and sk37029 and sk37030\n" >> $csv_log
                printf "Sync is Off!\n" >> $logfile
                printf "For more information on Sync, use sk34476: Explanation of Sync section in the output of fw ctl pstat command.\n" >> $logfile
                printf "To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.\n" >> $logfile
                printf "<span>Sync is Off!<br>For more information on Sync, use sk34476: Explanation of Sync section in the output of fw ctl pstat command.<br>To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.</span><br><br>\n" >> $html_file
            else
                result_check_passed
                printf "ClusterXL,Sync Status,OK,\n" >> $csv_log
            fi
        elif [[ $current_version -ge 8020 ]]; then
            cluster_sync=$(cphaprob syncstat | grep "Sync status")
            printf "\n\nCluster $cluster_sync\n" >> $full_output_log

            if [[ $cluster_sync == *"OK"* ]]; then
                result_check_passed
                printf "ClusterXL,Sync Status,OK,\n" >> $csv_log
            elif [[ $(echo "$cluster_sync" | grep -e "Off" -e "Problem") ]]; then
                result_check_failed
                printf "ClusterXL,Sync Status,WARNING,sk34475 and sk37029 and sk37030\n" >> $csv_log
                printf "$cluster_sync\n" >> $logfile
                printf "For more information on Sync, use sk34475: ClusterXL Sync Statistics - output of 'cphaprob syncstat' command.\n" >> $logfile
                printf "To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.\n" >> $logfile
                printf "<span>$cluster_sync<br>For more information on Sync, use sk34475: ClusterXL Sync Statistics - output of 'cphaprob syncstat' command.<br>To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.</span><br><br>\n" >> $html_file
            elif [[ $cluster_sync == *"Fullsync in progress"* ]]; then
                result_check_info
                printf "ClusterXL,Sync Status,INFO,sk34475 and sk37029 and sk37030\n" >> $csv_log
                printf "$cluster_sync\n" >> $logfile
                printf "For more information on Sync, use sk34475: ClusterXL Sync Statistics - output of 'cphaprob syncstat' command.\n" >> $logfile
                printf "To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.\n" >> $logfile
                printf "<span>$cluster_sync<br>For more information on Sync, use sk34475: ClusterXL Sync Statistics - output of 'cphaprob syncstat' command.<br>To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.</span><br><br>\n" >> $html_file
            else
                result_check_failed
                printf "ClusterXL,Sync Status,WARNING,sk34475 and sk37029 and sk37030\n" >> $csv_log
                printf "Unable to determine Sync Status.\n" >> $logfile
                printf "For more information on Sync, use sk34475: ClusterXL Sync Statistics - output of 'cphaprob syncstat' command.\n" >> $logfile
                printf "To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.\n" >> $logfile
                printf "<span>Unable to determine Sync Status.<br>For more information on Sync, use sk34475: ClusterXL Sync Statistics - output of 'cphaprob syncstat' command.<br>To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.</span><br><br>\n" >> $html_file
            fi
        fi


        #====================================================================================================
        #  Cluster Sync Interfaces Check
        #====================================================================================================
        test_output_error=0
        if [[ $sys_type == "VSX" ]]; then
            printf "|\t\t\t| Number of Sync Interfaces\t|" | tee -a $output_log
            printf '<span><b>Number of Sync Interfaces - </b></span><b>' >> $html_file
            sync_interface_list=$(echo "$cluster_a_if" | grep -A90 "vsid $vs" | sed '2d' | sed -n "/vsid $vs/,/------/p" | grep secured | grep -v non | grep -v Required | awk '{print $1}')
            sync_interface_number=$(echo "$sync_interface_list" | wc -l)

            printf "\n\nSync Interfaces:\n$sync_interface_list\n" >> $full_output_log

            if [[ $sync_interface_number -gt 1 ]]; then
                result_check_failed
                printf "ClusterXL,Number of Sync Interfaces,WARNING,sk92804\n" >> $csv_log
                printf "Multiple Sync Interfaces Detected:\n" >> $logfile
                printf "For more information on redundant sync configurations, use sk92804: Sync Redundancy in ClusterXL.\n" >> $logfile
                printf "<span>Multiple Sync Interfaces Detected:<br>For more information on redundant sync configurations, use sk92804: Sync Redundancy in ClusterXL.</span><br><br>\n" >> $html_file
            else
                result_check_passed
                printf "ClusterXL,Number of Sync Interfaces,OK,\n" >> $csv_log
            fi
        else
            printf "|\t\t\t| Number of Sync Interfaces\t|" | tee -a $output_log
            printf '<span><b>Number of Sync Interfaces - </b></span><b>' >> $html_file
            sync_interface_list=$(echo "$cluster_a_if" | grep secured | grep -v non | grep -v Required | awk '{print $1}')
            sync_interface_number=$(echo "$sync_interface_list" | wc -l)

            printf "\n\nSync Interfaces:\n$sync_interface_list\n" >> $full_output_log

            if [[ $sync_interface_number -gt 1 ]]; then
                result_check_failed
                printf "ClusterXL,Number of Sync Interfaces,WARNING,sk92804\n" >> $csv_log
                printf "Multiple Sync Interfaces Detected:\n" >> $logfile
                printf "For more information on redundant sync configurations, use sk92804: Sync Redundancy in ClusterXL.\n" >> $logfile
                printf "<span>Multiple Sync Interfaces Detected:<br>For more information on redundant sync configurations, use sk92804: Sync Redundancy in ClusterXL.</span><br><br>\n" >> $html_file
            elif [[ $sync_interface_list == *"Warning"* ]]; then
                result_check_failed
                printf "ClusterXL,Number of Sync Interfaces,WARNING,sk92804\n" >> $csv_log
                printf "No Sync Interfaces Detected.\n" >> $logfile
                printf "<span>No Sync Interfaces Detected.</span><br><br>\n" >> $html_file
            else
                result_check_passed
                printf "ClusterXL,Number of Sync Interfaces,OK,\n" >> $csv_log
            fi
        fi


        #====================================================================================================
        #  Cluster Failover Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Cluster Failovers\t\t|" | tee -a $output_log
        printf '<span><b>Cluster Failovers - </b></span><b>' >> $html_file

        #Misc. Variables
        current_day_of_the_year=$(date +%j | bc)
        failovers_in_the_last_week=0
        failover_temp_file=/var/tmp/failovers.tmp

        #Collect list of failovers
        if [[ $current_version -le 8010 ]]; then
            clish -c "show routed cluster-state detailed" | grep -A 11 "Cluster State Change History" | egrep -v 'Master to Master|Slave to Slave' | grep "[0-9]" | sort -u > $failover_temp_file

            #Log full failover text
            printf "\n\nCluster State Change History:\nTimestamp                 State Change Type\n" >> $full_output_log
            cat $failover_temp_file >> $full_output_log

            #Loop through each line of the failover list to determine the day of the year that the cluster failed over if there is valid data in the file
            if [[ $(grep -e Master -e Slave $failover_temp_file) ]]; then
                while read failover; do
                    month_days_so_far=0
                    current_month_days=$(echo $failover | awk '{print $2}')
                    if [[ $(echo $failover | grep Feb) ]]; then
                        month_days_so_far=$((month_days_so_far+31))
                    elif [[ $(echo $failover | grep Mar) ]]; then
                        month_days_so_far=$((month_days_so_far+59))
                    elif [[ $(echo $failover | grep Apr) ]]; then
                        month_days_so_far=$((month_days_so_far+90))
                    elif [[ $(echo $failover | grep May) ]]; then
                        month_days_so_far=$((month_days_so_far+120))
                    elif [[ $(echo $failover | grep Jun) ]]; then
                        month_days_so_far=$((month_days_so_far+151))
                    elif [[ $(echo $failover | grep Jul) ]]; then
                        month_days_so_far=$((month_days_so_far+181))
                    elif [[ $(echo $failover | grep Aug) ]]; then
                        month_days_so_far=$((month_days_so_far+212))
                    elif [[ $(echo $failover | grep Sep) ]]; then
                        month_days_so_far=$((month_days_so_far+243))
                    elif [[ $(echo $failover | grep Oct) ]]; then
                        month_days_so_far=$((month_days_so_far+273))
                    elif [[ $(echo $failover | grep Nov) ]]; then
                        month_days_so_far=$((month_days_so_far+304))
                    elif [[ $(echo $failover | grep Dec) ]]; then
                        month_days_so_far=$((month_days_so_far+334))
                    fi

                    #Add the number of days from all previous months to the day of the current month to get the day of the year that the cluster failed over
                    failover_day_of_the_year=$((month_days_so_far+current_month_days))

                    #Determine if the year has rolled over since the failover
                    if [[ $current_day_of_the_year -ge $failover_day_of_the_year ]]; then
                        days_since_failover=$((current_day_of_the_year-failover_day_of_the_year))
                    else
                        days_since_failover=$((365-failover_day_of_the_year+current_day_of_the_year))
                    fi

                    #Increment failover counter if 7 days or less have passed since the failover
                    if [[ $days_since_failover -le 7 ]]; then
                        ((failovers_in_the_last_week++))
                    fi
                done < $failover_temp_file
            fi

            #Remove temp file
            rm -rf $failover_temp_file > /dev/null 2>&1
        else
            failover_info=$(cphaprob show_failover)
            failover_list=$(echo "$failover_info" | egrep ^" *[0-9]")
            current_second=$(date +%s)
            week_seconds=604800
            failovers_in_the_last_week=0
            if [[ -n $failover_list ]]; then
                while read failover; do
                    failover_time=$(echo $failover | awk '{print $2, $3, $4, $5, $6}')
                    failover_second=$(date -d "$failover_time" +%s)
                    if [[ $(((failover_second+week_seconds))) -gt $current_second ]]; then
                        ((failovers_in_the_last_week++))
                        echo $failover >> /var/tmp/failovers
                    fi
                done <<< "$failover_list"
            fi
        fi

        #Report on the check result
        if [[ $failovers_in_the_last_week -ge 1 ]]; then
            result_check_failed
            printf "ClusterXL,Cluster Failovers,WARNING,\n" >> $csv_log
            printf "The cluster has failed over $failovers_in_the_last_week time(s) in the last week.\n" >> $logfile
            printf "<span>The cluster has failed over $failovers_in_the_last_week time(s) in the last week.</span><br>\n" >> $html_file
            if [[ -e /var/tmp/failovers ]]; then
                while read failover; do
                    printf "$failover\n" >> $logfile
                    printf "<span>$failover</span><br>\n" >> $html_file
                done < /var/tmp/failovers
                rm /var/tmp/failovers
            fi
            printf "<br>\n" >> $html_file
        else
            result_check_passed
            printf "ClusterXL,Cluster Failovers,OK,\n" >> $csv_log
        fi
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset ClusterXL variables
    unset cphaprob_stat
    unset active_active_check
    unset single_member_check
    unset other_member_status
    unset cluster_a_if
    unset cluster_pnotes
    unset cluster_sync
    unset sync_interface_list
    unset sync_interface_number
    unset current_day_of_the_year
    unset failovers_in_the_last_week
    unset month_days_so_far
    unset current_month_days
    unset failover_day_of_the_year
    unset days_since_failover
}


#====================================================================================================
#  Connections Function
#====================================================================================================
check_connections()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    connections_error_file=/var/tmp/connections_error
    current_check_message="Connections Table\t"

    #Collect connections information
    fw_tab_connections=$(fw tab -t connections 2> $connections_error_file)
    fw_tab_connections_s=$(fw tab -t connections -s 2> $connections_error_file)
    connections_limit=$(echo "$fw_tab_connections" | grep limit | grep -v Kernel | grep -v connections | grep -oP '(?<=limit ).*')
    connections_peak=$(echo "$fw_tab_connections_s" | grep -v Kernel | grep -v PEAK | awk '{print $5}')
    connections_current=$(echo "$fw_tab_connections_s" | grep -v Kernel | grep -v PEAK | awk '{print $4}')

    #====================================================================================================
    #  Peak Connections Check
    #====================================================================================================
    printf "| Connections Table\t| Peak Connections\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Connections Table</b></span><br>\n' >> $html_file
    printf '<span><b>Peak Connections - </b></span><b>' >> $html_file

    #Display error if there was a problem accessing the connections table
    if [[ -s $connections_error_file ]]; then
        result_check_failed
        printf "Connections Table,Peak Connections,ERROR,\n" >> $csv_log
        printf "Connections Table ERROR - Unable to open connections table.\n" >> $logfile
        printf "<span>Connections Table ERROR - Unable to open connections table.</span><br><br>\n" >> $html_file

    #Display check passed if connections table is unlimited
    elif [[ $(echo "$fw_tab_connections" | grep limit) == *"unlimited"* ]]; then
        result_check_passed
        printf "Connections Table,Peak Connections,OK,\n" >> $csv_log
        connections_limit="unlimited"

    #Check connections if table is not unlimited
    else
        #Calculate connections percent
        if [[ $connections_limit -ge 1 ]]; then
            peak_percent=$((100*$connections_peak/$connections_limit))
        else
            peak_percent=255
        fi

        #Display error if unable to determine connection limit
        if [[  $peak_percent -eq 255 ]]; then
            result_check_failed
            printf "Connections Table,Peak Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections limit.\n" >> $logfile
            printf "<span>Connections Table Warning - Unable to detect connections limit.</span><br><br>\n" >> $html_file

        #Display warning messages if peak is reached
        elif [[ $peak_percent -ge 80 ]]; then
            result_check_failed
            printf "Connections Table,Peak Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - The Peak connections is $peak_percent%% of total capacity.\n" >> $logfile
            printf "Once the connections table is full, new connections will be dropped.\n" >> $logfile
            printf "Please consider increasing the connections table limit.\n" >> $logfile
            printf "<span>Connections Table Warning - The Peak connections is $peak_percent%% of total capacity.<br>Once the connections table is full, new connections will be dropped.<br>Please consider increasing the connections table limit.</span><br><br>\n" >> $html_file

        #Display check passed if connection capacity is less than 80%
        elif  [[ $peak_percent -lt 80 ]]; then
            result_check_passed
            printf "Connections Table,Peak Connections,OK,\n" >> $csv_log

        #Catch all message if none of the other conditions match
        else
            result_check_failed
            printf "Connections Table,Peak Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections information.\n" >> $logfile
            printf "<span>Connections Table Warning - Unable to detect connections information.</span><br><br>\n" >> $html_file
        fi
    fi


    #====================================================================================================
    #  Current Connections Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Current Connections\t\t|" | tee -a $output_log
    printf '<span><b>Current Connections - </b></span><b>' >> $html_file

    #Display error if there was a problem accessing the connections table
    if [[ -s $connections_error_file ]]; then
        result_check_failed
        printf "Connections Table,Concurrent Connections,ERROR,\n" >> $csv_log
        printf "Concurrent Connections ERROR - Unable to open connections table.\n" >> $logfile
        printf "<span>Concurrent Connections ERROR - Unable to open connections table.</span><br><br>\n" >> $html_file

    #Display check passed if connections table is unlimited
    elif [[ $(echo "$fw_tab_connections" | grep limit) == *"unlimited"* ]]; then
        result_check_passed
        printf "Connections Table,Concurrent Connections,OK,\n" >> $csv_log
        connections_limit="unlimited"

    #Check connections if table is not unlimited
    else
        #Calculate connections percent
        if [[ $connections_limit -ge 1 ]]; then
            connections_percent=$((100*$connections_current/$connections_limit))
        else
            connections_percent=255
        fi

        #Display error if unable to determine connection limit
        if [[  $connections_percent -eq 255 ]]; then
            result_check_failed
            printf "Connections Table,Concurrent Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections limit.\n" >> $logfile
            printf "<span>Connections Table Warning - Unable to detect connections limit.</span><br><br>\n" >> $html_file

        #Display warning messages if peak is reached
        elif [[ $connections_percent -ge 80 ]]; then
            result_check_failed
            printf "Connections Table,Concurrent Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - The current connections table is $connections_percent%% full.\n" >> $logfile
            printf "Once the connections table is full, new connections will be dropped.\n" >> $logfile
            printf "Please consider increasing the connections table limit.\n" >> $logfile
            printf "<span>Connections Table Warning - The current connections table is $connections_percent%% full.<br>Once the connections table is full, new connections will be dropped.<br>Please consider increasing the connections table limit.</span><br><br>\n" >> $html_file

        #Display check passed if connection capacity is less than 80%
        elif  [[ $connections_percent -lt 80 ]]; then
            result_check_passed
            printf "Connections Table,Concurrent Connections,OK,\n" >> $csv_log

        #Catch all message if none of the other conditions match
        else
            result_check_failed
            printf "Connections Table,Concurrent Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections information.\n" >> $logfile
            printf "<span>Connections Table Warning - Unable to detect connections information.</span><br><br>\n" >> $html_file
        fi
    fi

    #Log current connections values
    printf "\n\nConnections information:\n" >> $full_output_log
    printf "Limit: $connections_limit\n" >> $full_output_log
    printf "Peak: $connections_peak\n" >> $full_output_log

    #Clean up temp file
    rm $connections_error_file > /dev/null 2>&1


    #====================================================================================================
    #  NAT Connections Check
    #====================================================================================================
    test_output_error=0
    nat_error_file=/var/tmp/nat_error
    printf "|\t\t\t| NAT Connections\t\t|" | tee -a $output_log
    printf '<span><b>NAT Connections - </b></span><b>' >> $html_file
    nat_connections=$(fw tab -t fwx_cache -s 2> $nat_error_file | grep -v HOST)

    #Display error if there was a problem accessing the NAT table
    if [[ -s $nat_error_file ]]; then
        result_check_failed
        printf "Connections Table,NAT Connections,ERROR,\n" >> $csv_log
        printf "NAT Table ERROR - Unable to open fwx_cache table.\n" >> $logfile
        printf "<span>NAT Table ERROR - Unable to open fwx_cache table.</span><br><br>\n" >> $html_file

    #Display error if there was any other problems accessing the connections table
    elif [[ $nat_connections == *"not a FireWall-1 module"* || $nat_connections == *"Failed to get table status"* ]]; then
        result_check_failed
        printf "Connections Table,NAT Connections,WARNING,\n" >> $csv_log
        printf "NAT Connections - Unable to get information from fwx_cache table.\n" >> $logfile
        printf "<span>NAT Connections - Unable to get information from fwx_cache table.</span><br><br>\n" >> $html_file

    #Check NAT connections info
    else
        connections_VALS=$(echo $nat_connections | awk '{print $4}')
        connections_PEAK=$(echo $nat_connections | awk '{print $5}')

        #Display warning messages if peak is reached
        if [[ $connections_PEAK -eq 10000 ]]; then
            result_check_failed
            printf "Connections Table,NAT Connections,WARNING,\n" >> $csv_log
            printf "NAT Connections:\n" >> $logfile
            printf "<span>NAT Connections:</span><br>\n" >> $html_file
            if [[ $connections_VALS -eq 10000 ]]; then
                printf "The value of VALS is equal to 10,000 which indicates that the NAT cache table is currently full.\n" >> $logfile
                printf "<span>The value of VALS is equal to 10,000 which indicates that the NAT cache table is currently full.</span><br>\n" >> $html_file
            else
                printf "The value of #PEAK is equal to 10,000 which indicates that the NAT cache table (default 10,000) was full at some time.\n" >> $logfile
                printf "<span>The value of #PEAK is equal to 10,000 which indicates that the NAT cache table (default 10,000) was full at some time.</span><br>\n" >> $html_file
            fi
            printf "For improved NAT cache performance the size of the NAT cache should be increased or the time entries are held in the table decreased.\n" >> $logfile
            printf "For further information see: sk21834: How to modify the values of the properties related to the NAT cache table.\n" >> $logfile
            printf "<span>For improved NAT cache performance the size of the NAT cache should be increased or the time entries are held in the table decreased.<br>For further information see: sk21834: How to modify the values of the properties related to the NAT cache table.</span><br><br>\n" >> $html_file

        #Display check passed if NAT connections are OK
        else
            result_check_passed
            printf "Connections Table,NAT Connections,OK,\n" >> $csv_log
        fi

        #Log NAT values
        printf "\n\nNAT VALS: $connections_VALS\n" >> $full_output_log
        printf "NAT PEAK: $connections_PEAK\n" >> $full_output_log
    fi

    #Clean up temp file
    rm $nat_error_file > /dev/null 2>&1

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset Connections variables
    unset fw_tab_connections
    unset fw_tab_connections_s
    unset connections_limit
    unset connections_peak
    unset connections_current
    unset peak_percent
    unset connections_percent
    unset nat_connections
    unset connections_VALS
    unset connections_PEAK
}


#====================================================================================================
#  CoreXL Function
#====================================================================================================
check_corexl()
{
    #====================================================================================================
    #  CoreXL stats Check
    #====================================================================================================

    #Check if CoreXL is enabled
    summary_error=0
    test_output_error=0
    current_check_message="CoreXL\t\t"

    #Check CoreXl and Affinity Status
    if [[ $offline_operations == true ]]; then
        #CoreXL Info
        core_stat=$(grep -A50 "multik stat" $cpinfo_file | grep -B50 "affinity -l -a" | head -n -2 | tail -n +3)

        #Affinity Info
        fw_ctl_affinity=$(grep -A50 "fw affinity" $cpinfo_file | grep -B50 "affinity" | grep -v "fw affinity" | grep -v '\-\-\-' | sed "s/([^)]*)/()/g" | sed "s/ ()//g")
    else
        #CoreXL Info
        core_stat=$(fw ctl multik stat 2>&1)

        #Affinity Info
        fw_ctl_affinity=$(fw ctl affinity -l -a -v 2> /dev/null | sed "s/([^)]*)/()/g" | sed "s/ ()//g")

        #Misc Interrupts info
        cpu_interrupts=$(cat /proc/interrupts | grep -E "CPU|eth")
        printf "\n\nCPU Interrupts Status:\n\n" >> $full_output_log
        echo "$cpu_interrupts" >> $full_output_log

        #Temp file cleanup
        rm -f /var/tmp/core_xl_stat > /dev/null 2>&1
    fi

    printf "\n\nCoreXL Status:\n" >> $full_output_log
    echo "$core_stat" >> $full_output_log
    printf "\n\nCoreXL Affinity Status:\n" >> $full_output_log
    echo "$fw_ctl_affinity" >> $full_output_log

    printf "| CoreXL\t\t| CoreXL Status\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>CoreXL</b></span><br>\n' >> $html_file
    printf '<span><b>CoreXL Status - </b></span><b>' >> $html_file

    #Manually pass the CoreXL check for VSX
    if [[ $sys_type == "VSX" ]]; then
        core_stat=""
    fi

    #Display status results of CoreXL checks
    if [[ $(echo $core_stat | grep -i disabled) ]]; then
        result_check_failed
        printf "CoreXL,CoreXL Status,WARNING,\n" >> $csv_log
        printf "CoreXL Notice: CoreXL is disabled.  Please confirm if it is required to be left off by your organization.\n" >> $logfile
        printf "<span> CoreXL is disabled.  Please confirm if it is required to be left off by your organization.</span><br><br>\n" >> $html_file
    else
        result_check_passed
        printf "CoreXL,CoreXL Status,OK,\n" >> $csv_log

        #If CoreXL is enabled, proceed with checks for CPU usage distribution
        if [[ $sys_type == "GATEWAY" || $sys_type == "VSX" ]]; then

            #====================================================================================================
            #  SND/FW Worker Overlap Check
            #====================================================================================================
            test_output_error=0
            printf "|\t\t\t| SND/FW Core Overlap \t\t|" | tee -a $output_log
            printf '<span><b>SND/FW Core Overlap - </b></span><b>' >> $html_file

            #SND Variables
            snd_list=$(echo "$fw_ctl_affinity" | grep Interface | awk -F'CPU ' '{print $2}' | sort -u)
            snd_count=$(echo $snd_list | wc -w)
            snd_average=0

            #Worker Variables
            worker_list=$(echo "$fw_ctl_affinity" | grep -e "fw_" -e "VS_" | awk -F'CPU ' '{print $2}' | sort -u)

            worker_count=$(echo $worker_list | wc -w)
            worker_average=0

            #Ensure SND/worker lists don't say "All"
            if [[ $(echo $snd_list | grep -i all) ]]; then
                snd_list=$all_cpu_list
            fi
            if [[ $(echo $worker_list | grep -i all) ]]; then
                worker_list=$all_cpu_list
            fi

            #If there are only two CPUs overlap is OK
            if [[ $all_cpu_count -eq 2 ]]; then
                result_check_info
                printf "CoreXL,SND/FW Core Overlap,Info,\n" >> $csv_log
                printf "SND/FW Core Overlap Info:\nThe system has two CPU cores.\nThis will cause CoreXL to use both cores as SND and FW Workers which could incur a performance impact.\nIf any interface has a high number of RX Drops, please consider upgrading to a device with more CPU cores or see if disabling CoreXL helps resolve the issue.\n" >> $logfile
                printf '<span>The system has two CPU cores.<br>This will cause CoreXL to use both cores as SND and FW Workers which could incur a performance impact.<br>If any interface has a high number of RX Drops, please consider upgrading to a device with more CPU cores or see if disabling CoreXL helps resolve the issue.</span><br><br>\n' >> $html_file

            #Compare the lists to see if they overlap
            else
                snd_worker_overlap=false
                for snd_core in $snd_list; do
                    if [[ $(echo $worker_list | grep -w $snd_core) ]]; then
                        snd_worker_overlap=true
                    fi
                done

                #Final exit status
                if [[ $snd_worker_overlap == true ]]; then
                    result_check_failed
                    printf "CoreXL,SND/FW Core Overlap,WARNING,sk98737 and sk98348\n" >> $csv_log
                    printf "CoreXL Notice: Cores detected operating as both fw workers and SNDs.  Please review sk98737 and sk98348 for more information.\n" >> $logfile
                    printf "CoreXL Settings:\n" >> $logfile
                    echo "$fw_ctl_affinity" | egrep 'Interface|VS_|Kernel' >> $logfile


                    #Log the affinity settings to the html file
                    printf "<span>Cores detected operating as both fw workers and SNDs.  Please review sk98737 and sk98348 for more information.<br>CoreXL Settings:</span><br>\n<span>" >> $html_file
                    while read -r affinity_setting; do
                        printf "$affinity_setting<br>" >> $html_file
                    done <<< "$(echo "$fw_ctl_affinity" | egrep 'Interface|VS_|Kernel')"
                    printf "</span><br>\n" >> $html_file
                else
                    result_check_passed
                    printf "CoreXL,SND/FW Core Overlap,OK,\n" >> $csv_log
                fi
            fi


            #====================================================================================================
            #  SND/FW Worker Distribution Check
            #====================================================================================================
            if [[ $offline_operations == true && ! -e $cpview_file ]]; then
                false
            else
                test_output_error=0
                printf "|\t\t\t| SND/FW Core Distribution \t|" | tee -a $output_log
                printf '<span><b>SND/FW Core Distribution - </b></span><b>' >> $html_file

                #Collect CPU info from cpview history database
                if [[ -e $cpview_file ]]; then
                    #Add CPU averages to array
                    for current_cpu in $all_cpu_list; do
                        cpu_usage[$current_cpu]=$(sqlite3 $cpview_file "select avg(cpu_usage) from UM_STAT_UM_CPU_UM_CPU_ORDERED_TABLE where name_of_cpu=$current_cpu;" 2> /dev/null | awk '{printf "%.0f", int($1+0.5)}')
                    done

                    #Add up CPU average for all SNDs
                    for snd_core in $snd_list; do
                        snd_average=$(echo $snd_average + ${cpu_usage[$snd_core]})
                    done

                    #Divide SND average by number of cores to get average of all SND cores then round the result
                    snd_average=$(echo $snd_average/$snd_count | awk '{printf "%.0f", int($1+0.5)}')

                    #Add up CPU average for all FW workers
                    for worker_core in $worker_list; do
                        worker_average=$(echo $worker_average + ${cpu_usage[$worker_core]})
                    done

                    #Divide SND average by number of cores to get average of all SND cores then round the result
                    worker_average=$(echo $worker_average/$worker_count | awk '{printf "%.0f", int($1+0.5)}')


                #Collect live CPU info if cpview history file is missing
                else
                    #Add up CPU idle for all SNDs
                    for snd_core in $snd_list; do
                        snd_core_idle=$(echo "$mpstat_p_all" | grep " $snd_core " | awk -v temp=$mpstat_idle '{print $temp}')
                        snd_average=$(echo $snd_average + $snd_core_idle | bc)
                    done

                    #Divide SND average by number of cores to get average idle
                    snd_average=$(echo $snd_average/$snd_count | bc -l)

                    #Subtract average idle from 100 to get average usage
                    snd_average=$(echo 100-$snd_average | awk '{printf "%.0f", int($1+0.5)}')


                    #Add up CPU idle for all Workers
                    for worker_core in $worker_list; do
                        worker_core_idle=$(echo "$mpstat_p_all" | grep " $worker_core " | awk -v temp=$mpstat_idle '{print $temp}')
                        worker_average=$(echo $worker_average + $worker_core_idle | bc)
                    done

                    #Divide worker average by number of cores to get average idle
                    worker_average=$(echo $worker_average/$worker_count | bc -l)

                    #Subtract average idle from 100 to get average usage
                    worker_average=$(echo 100-$worker_average | awk '{printf "%.0f", int($1+0.5)}')
                fi

                #Compare averages
                if [[ $worker_average -gt $snd_average ]]; then
                    core_difference=$(echo $worker_average-$snd_average | bc)
                    higher_usage="FW workers"
                    lower_usage="SNDs"
                else
                    core_difference=$(echo $snd_average-$worker_average | bc)
                    higher_usage="SNDs"
                    lower_usage="FW Workers"
                fi

                #Display final check info
                if [[ $core_difference -ge 20 ]]; then
                    result_check_failed
                    printf "CoreXL,SND/FW Core Distribution,WARNING,sk98348\n" >> $csv_log
                    printf "CoreXL Notice: The average core utilization for the $higher_usage is $core_difference percent higher than the $lower_usage.\nPlease review the CoreXL best practices section of sk98348 for more information on how to tune the number of SND and FW instances.\n" >> $logfile
                    printf "<span>he average core utilization for the $higher_usage is $core_difference percent higher than the $lower_usage.<br>Please review the CoreXL best practices section of sk98348 for more information on how to tune the number of SND and FW instances.</span><br><br>\n" >> $html_file
                else
                    result_check_passed
                    printf "CoreXL,SND/FW Core Distribution,OK,\n" >> $csv_log
                fi


                if [[ -n $cpu_usage ]]; then
                    #====================================================================================================
                    #  SND Core Distribution Check
                    #====================================================================================================

                    test_output_error=0
                    printf "|\t\t\t| SND Core Distribution \t|" | tee -a $output_log
                    printf '<span><b>SND Core Distribution - </b></span><b>' >> $html_file

                    #Determine most/least utilized cores
                    high_snd_usage=0
                    low_snd_usage=9999
                    core_id=0
                    for i in ${cpu_usage[@]}; do
                        if [[ $( echo "$snd_list" | grep -ow $core_id) ]]; then
                            if [[ $i -gt $high_snd_usage ]]; then
                                high_snd_usage=$i
                                high_snd_core=$core_id
                            fi
                            if [[ $i -lt $low_snd_usage ]]; then
                                low_snd_usage=$i
                                low_snd_core=$core_id
                            fi
                        fi
                        ((core_id++))
                    done

                    #Compare the lowest and highest SND
                    snd_usage_difference=$((high_snd_usage - low_snd_usage))
                    if [[ $snd_usage_difference -ge 20 ]]; then
                        result_check_failed
                        printf "CoreXL,SND Core Distribution,WARNING,sk98348\n" >> $csv_log
                        printf "CoreXL Notice: The average core utilization for CPU $high_snd_core is $snd_usage_difference percent higher than CPU $low_snd_core.\nPlease review the CoreXL best practices section of sk98348 for more information on how to tune the SNDs.\n" >> $logfile
                        printf "\nSND configuration per interface:\n" >> $logfile

                        printf "<span>The average core utilization for CPU $high_snd_core is $snd_usage_difference percent higher than CPU $low_snd_core.<br>Please review the CoreXL best practices section of sk98348 for more information on how to tune the SNDs.<br>SND configuration per interface:</span><br>\n<span>" >> $html_file

                        echo "$fw_ctl_affinity" | grep Interface >> $logfile
                        while read -r affinity_setting; do
                            printf "$affinity_setting<br>" >> $html_file
                        done <<< "$(echo "$fw_ctl_affinity" | grep Interface)"
                        printf "</span><br>\n" >> $html_file
                    else
                        result_check_passed
                        printf "CoreXL,SND Core Distribution,OK,\n" >> $csv_log
                    fi

                    #====================================================================================================
                    #  SND Interface Distribution Check
                    #====================================================================================================
                    if [[ $snd_usage_difference -ge 20 ]]; then
                        test_output_error=0
                        printf "|\t\t\t| SND Interface Distribution \t|" | tee -a $output_log
                        printf '<span><b>SND Interface Distribution - </b></span><b>' >> $html_file

                        #List of interfaces associated with highest SND core
                        high_core_interface_list=$(echo "$fw_ctl_affinity" | grep Interface | grep -w $high_snd_core | awk '{print $2}' | sed 's/.$//g')
                        low_core_interface_list=$(echo "$fw_ctl_affinity" | grep Interface | grep -w $low_snd_core | awk '{print $2}' | sed 's/.$//g')

                        #Verify if the high SND Core interface number
                        if [[ $(echo "$high_core_interface_list" | wc -l) -gt 1 ]]; then
                            result_check_failed
                            printf "CoreXL,SND Interface Distribution,WARNING,sk98348\n" >> $csv_log
                            printf "CoreXL Notice:\nCPU $high_snd_core is $high_snd_usage%% used (average) and shared across the following interfaces:\n" >> $logfile
                            echo "$high_core_interface_list" >> $logfile
                            printf "CPU $low_snd_core is $low_snd_usage%% used (average) and assigned to the following interface(s):\n" >> $logfile
                            echo "$low_core_interface_list" >> $logfile
                            printf "Please consider redistributing interfaces to better balance SND workload or using a dedicated SND for busy interfaces.\n" >> $logfile

                            #Create HTML entry for high and low lists
                            printf "<span>CPU $high_snd_core is $high_snd_usage%% used (average) and shared across the following interfaces:</span><br>\n<span>" >> $html_file
                            while read -r high_core_interface; do
                                printf "$high_core_interface<br>" >> $html_file
                            done <<< "$high_core_interface_list"
                            printf "</span><br>\n" >> $html_file
                            printf "<span>CPU $low_snd_core is $low_snd_usage%% used (average) and assigned to the following interface(s):</span><br>\n<span>" >> $html_file
                            while read -r low_core_interface; do
                                printf "$low_core_interface<br>" >> $html_file
                            done <<< "$low_core_interface_list"
                            printf "</span><br>\n" >> $html_file
                            printf "<span>Please consider redistributing interfaces to better balance SND workload or using a dedicated SND for busy interfaces.</span><br><br>\n" >> $html_file
                        else
                            result_check_passed
                            printf "CoreXL,SND Interface Distribution,OK,\n" >> $csv_log
                        fi
                    fi

                fi

                #====================================================================================================
                #  Dynamic Split Check
                #====================================================================================================

                #Only perform this check on Check Point Appliances running R80.40 or higher with 8 or more CPUs
                if [[ $current_version -ge 8040 && $(dmidecode -t System | grep CheckPoint) && $(mpstat -P ALL | egrep -iv "all|CPU" | sed '/^$/d' | wc -l) -ge 8 ]]; then
                    test_output_error=0
                    printf "|\t\t\t| Dynamic Split \t\t|" | tee -a $output_log
                    printf '<span><b>Dynamic Split - </b></span><b>' >> $html_file

                    #Add dynamic split info to full output log
                    dynamic_split_status=$(dynamic_split -p)
                    printf "Dynamic Split of CoreXL:\n------------------------\n" >> $full_output_log
                    echo "$dynamic_split_status" >> $full_output_log
                    printf "\n\n"  >> $full_output_log

                    if [[ $dynamic_split_status == *'Dynamic Split is currently off (Stopped due to State'* ]]; then
                        result_check_failed
                        printf "CoreXL,Dynamic Split,WARNING,sk163815\n" >> $csv_log
                        printf "Dynamic Split of CoreXL is currently off due to a policy verification error.\nPlease see sk163815 for more information.\n" >> $logfile

                        #Create HTML entry
                        printf "<span>Dynamic Split of CoreXL is currently off due to a policy verification error.<br>Please see sk163815 for more information.</span><br>\n<span>" >> $html_file
                    elif [[ $dynamic_split_status == *"Dynamic Split is currently off"* ]]; then
                        result_check_info
                        printf "CoreXL,Dynamic Split,INFO,\n" >> $csv_log
                        printf "Dynamic Split of CoreXL is currently off.\nPlease see the Performance Tuning Administration Guide for R80.40 or later for more information.\n" >> $logfile

                        #Create HTML entry
                        printf "<span>Dynamic Split of CoreXL is currently off.<br>Please see the Performance Tuning Administration Guide for R80.40 or later for more information.</span><br>\n<span>" >> $html_file
                    else
                        result_check_passed
                        printf "CoreXL,Dynamic Split,OK,\n" >> $csv_log
                    fi

                    unset dynamic_split_status
                fi
            fi
        fi
    fi


    #====================================================================================================
    #  Dynamic Dispatcher Check
    #====================================================================================================

    #Collect Dynamic Dispatcher settings
    if [[ $current_version -ge 7730 && $sys_type != "VSX" ]] && [[ $offline_operations == false ]]; then
        test_output_error=0
        printf "|\t\t\t| Dynamic Dispatcher\t\t|" | tee -a $output_log
        printf '<span><b>Dynamic Dispatcher - </b></span><b>' >> $html_file

        #Collect the dynamic dispatcher status based on version
        if [[ $current_version -eq 7730 ]]; then
            dispatcher_mode=$(fw ctl multik get_mode)
        elif [[ $current_version -ge 8000 ]]; then
            dispatcher_mode=$(fw ctl multik dynamic_dispatching get_mode)
        else
            dispatcher_mode=""
        fi

        #Report dynamic dispatcher settings
        if [[ $dispatcher_mode == *"Off"* ]]; then
            result_check_failed
            printf "CoreXL,Dynamic Dispatcher,WARNING,sk105261\n" >> $csv_log
            printf "CoreXL Notice: Dynamic Dispatcher is disabled.  Please review sk105261 for more information.\n" >> $logfile
            printf "<span>Dynamic Dispatcher is disabled.  Please review sk105261 for more information.</span><br><br>\n" >> $html_file
        elif [[ $dispatcher_mode == *"On"* ]]; then
            result_check_passed
            printf "CoreXL,Dynamic Dispatcher,OK,\n" >> $csv_log
        else
            result_check_failed
            printf "CoreXL,Dynamic Dispatcher,WARNING,sk105261\n" >> $csv_log
            printf "CoreXL Notice: Unable to determine Dynamic Dispatcher status.  Please review sk105261 for more information.\n" >> $logfile
            printf "<span>Unable to determine Dynamic Dispatcher status.  Please review sk105261 for more information.</span><br><br>\n" >> $html_file
        fi
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset CoreXL variables
    unset core_stat
    unset core_affinity_stat
    unset cpu_interrupts
    unset fw_ctl_affinity
    unset cpu_count
    unset snd_list
    unset snd_count
    unset snd_average
    unset worker_list
    unset worker_count
    unset worker_average
    unset snd_worker_overlap
    unset snd_core_idle
    unset worker_core_idle
    unset core_difference
    unset higher_usage
    unset lower_usage
    unset high_snd_usage
    unset low_snd_usage
    unset core_id
    unset high_snd_core
    unset low_snd_core
    unset snd_usage_difference
    unset dispatcher_mode
    unset affinity_setting
}


#====================================================================================================
#  Core File Function
#====================================================================================================
check_core_files()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Core Files\t\t"

    #Find usermode cores:
    cores_found=0
    core_found_html=0
    user_cores_found=false
    kernel_cores_found=false
    usermode_core_list=$(ls -lah /var/log/dump/usermode/ | grep -v total | grep -v drwx)
    kernel_core_list=$(ls -lah /var/log/crash/ | grep -v total | grep -v drwx)

    #====================================================================================================
    #  Usermode Core Check
    #====================================================================================================
    printf "| Core Files\t\t| Usermode Cores Present\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Core Files</b></span><br>\n' >> $html_file
    printf '<span><b>Usermode Cores Present - </b></span><b>' >> $html_file
    if [[ $(echo "$usermode_core_list" | sed "/^$/d" | wc -l) -ge 1 ]]; then
        result_check_failed
        printf "Core Files,Usermode Cores Present,WARNING,\n" >> $csv_log
        printf "Usermode Cores:\n" >> $logfile
        echo "$usermode_core_list" >> $logfile
        printf "\n" >> $logfile

        #Create HTML file
        printf "<span>Usermode Cores:<br>" >> $html_file
        while read -r user_core; do
            printf -- "$user_core<br>" >> $html_file
        done <<< "$usermode_core_list"
        printf "</span><br>\n" >> $html_file
        user_cores_found=true
        cores_found=1
        core_found_html=1
    else
        result_check_passed
        printf "Core Files,Usermode Cores Present,OK,\n" >> $csv_log
    fi

    #Log HTML output for Usermode Cores
    if [[ $core_found_html == 1 ]]; then
        printf "<span>Usermode Core files detected on this system.<br>Please upload the following to Check Point for analysis:<br> -Current cpinfo from this system</span><br>\n" >> $html_file
        printf "<span> -Usermode core files from /var/log/dump/usermode/</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  Kernel Core Check
    #====================================================================================================
    test_output_error=0
    core_found_html=0
    printf "|\t\t\t| Kernel Cores Present\t\t|" | tee -a $output_log
    printf '<span><b>Kernel Cores Present - </b></span><b>' >> $html_file
    if [[ $(echo "$kernel_core_list" | sed "/^$/d" | wc -l) -ge 1 ]]; then
        result_check_failed
        printf "Core Files,Kernel Cores Present,WARNING,\n" >> $csv_log
        printf "Kernel Cores:\n" >> $logfile
        echo "$kernel_core_list" >> $logfile
        printf "\n" >> $logfile

        #Create HTML file
        printf "<span>Kernel Cores:<br>" >> $html_file
        while read -r kernel_core; do
            printf -- "$kernel_core<br>" >> $html_file
        done <<< "$kernel_core_list"
        printf "</span><br>\n" >> $html_file
        kernel_cores_found=true
        cores_found=1
        core_found_html=1
    else
        result_check_passed
        printf "Core Files,Kernel Cores Present,OK,\n" >> $csv_log
    fi

    #Log HTML output for Kernel Cores
    if [[ $core_found_html == 1 ]]; then
        printf "<span>Core files detected on this system.<br>Please upload the following to Check Point for analysis:<br> -Current cpinfo from this system</span><br>\n" >> $html_file
        printf "<span> -Kernel core files from /var/log/crash</span><br><br>\n" >> $html_file
    fi

    #Log core instructions if any Usermode or Kernel cores are found
    if [[ $cores_found == 1 ]]; then
        printf "Core files detected on this system.\n" >> $logfile
        printf "Please upload the following to Check Point for analysis:\n"  >> $logfile
        printf " -Current cpinfo from this system\n"  >> $logfile
        if [[ $user_cores_found == true ]]; then
            printf " -Usermode core files from /var/log/dump/usermode/\n" >> $logfile
        fi
        if [[ $kernel_cores_found == true ]]; then
            printf " -Kernel core files from /var/log/crash\n" >> $logfile
        fi
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset Core File variables
    unset cores_found
    unset user_cores_found
    unset kernel_cores_found
    unset usermode_core_list
    unset kernel_core_list
}


#====================================================================================================
#  CPU Function
#====================================================================================================
check_cpu()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="CPU\t\t\t"


    #Log usage
    printf "\n\nCPU information:\n" >> $full_output_log
    echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' >> $full_output_log


    #====================================================================================================
    #  CPU Idle Check
    #====================================================================================================
    printf "| CPU\t\t\t| CPU idle%%\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>CPU</b></span><br>\n' >> $html_file
    printf '<span><b>CPU Idle%% - </b></span><b>' >> $html_file
    if [[ $offline_operations == true ]]; then
        all_cpu_idle=$(echo "$mpstat_p_all" | awk -v temp=$mpstat_idle '{print $temp}' | awk -F\% '{print $1}')
    else
        all_cpu_idle=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_idle '{print $temp}')
    fi
    current_cpu=0
    for cpu_idle in $all_cpu_idle; do
        cpu_idle=$(echo $cpu_idle | awk '{printf "%.0f", int($1+0.5)}')
        if [[ $cpu_idle -le 20 ]]; then
            result_check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_idle%% idle\n" >> $logfile
                printf "<span>top reading $current_cpu - $cpu_idle%% idle</span><br>\n" >> $html_file
            else
                printf "CPU $current_cpu - $cpu_idle%% idle\n" >> $logfile
                printf "<span>CPU $current_cpu - $cpu_idle%% idle</span><br>\n" >> $html_file
            fi
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "CPU,CPU idle%%,OK,\n" >> $csv_log
    else
        printf "CPU,CPU idle%%,WARNING,\n" >> $csv_log
        printf "CPU idle Warning:\n" >> $logfile
        printf "One or more CPUs is over 80%% utilized.\n" >> $logfile
        printf "<span>Warning: One or more CPUs is over 80%% utilized.</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  CPU User Check
    #====================================================================================================
    printf "|\t\t\t| CPU user%%\t\t\t|" | tee -a $output_log
    printf '<span><b>CPU user%% - </b></span><b>' >> $html_file
    if [[ $offline_operations == true ]]; then
        all_cpu_user=$(echo "$mpstat_p_all" | awk -v temp=$mpstat_user '{print $temp}' | awk -F\% '{print $1}')
    else
        all_cpu_user=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_user '{print $temp}')
    fi
    current_cpu=0
    test_output_error=0
    for cpu_user in $all_cpu_user; do
        cpu_user=$(echo $cpu_user | awk '{printf "%.0f", int($1+0.5)}')
        if [[ $cpu_user -ge 20 ]]; then
            result_check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_user%% user\n" >> $logfile
                printf "<span>top reading $current_cpu - $cpu_user%% user</span><br>\n" >> $html_file
            else
                printf "CPU $current_cpu - $cpu_user%% user\n" >> $logfile
                printf "<span>CPU $current_cpu - $cpu_user%% user</span><br>\n" >> $html_file
            fi
            cpu_user_warning=1
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "CPU,CPU user%%,OK,\n" >> $csv_log
    fi
    if [[ $cpu_user_warning -eq 1 ]]; then
        printf "CPU,CPU user%%,WARNING,\n" >> $csv_log
        printf "High CPU user time indicates that some process is consuming high CPU.\n" >> $logfile
        printf "Security Server processes like fwssd and in.ahttpd have been offenders in the past.\n" >> $logfile
        printf "Use \"ps\" or \"top\" to identify the offending process.\n" >> $logfile
        printf "<span>High CPU user time indicates that some process is consuming high CPU.<br>Security Server processes like fwssd and in.ahttpd have been offenders in the past.<br>Use \"ps\" or \"top\" to identify the offending process.</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  CPU System Check
    #====================================================================================================
    printf "|\t\t\t| CPU system%%\t\t\t|" | tee -a $output_log
    printf '<span><b>CPU system%% - </b></span><b>' >> $html_file
    if [[ $offline_operations == true ]]; then
        all_cpu_system=$(echo "$mpstat_p_all" | awk -v temp=$mpstat_system '{print $temp}' | awk -F\% '{print $1}')
    else
        all_cpu_system=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_system '{print $temp}')
    fi
    current_cpu=0
    test_output_error=0
    for cpu_system in $all_cpu_system; do
        cpu_system=$(echo $cpu_system | awk '{printf "%.0f", int($1+0.5)}')
        if [[ $cpu_system -ge 20 ]]; then
            result_check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_system%% system\n" >> $logfile
                printf "<span>top reading $current_cpu - $cpu_system%% system</span><br>\n" >> $html_file
            else
                printf "CPU $current_cpu - $cpu_system%% system\n" >> $logfile
                printf "<span>CPU $current_cpu - $cpu_system%% system</span><br>\n" >> $html_file
            fi
            cpu_system_warning=1
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "CPU,CPU system%%,OK,\n" >> $csv_log
    fi
    if [[ $cpu_system_warning -eq 1 ]]; then
        printf "CPU,CPU system%%,WARNING,\n" >> $csv_log
        printf "High CPU system time indicates that the Check Point kernel is consuming CPU.\n" >> $logfile
        printf "Certain configurations in SmartDefense and web-intelligence can cause this to occur by\ndisabling SecureXL templates or completely disabling SecureXL acceleration.\n" >> $logfile
        printf "<span>High CPU system time indicates that the Check Point kernel is consuming CPU.<br>Certain configurations in SmartDefense and web-intelligence can cause this to occur by<br>disabling SecureXL templates or completely disabling SecureXL acceleration.</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  CPU Wait Check
    #====================================================================================================
    printf "|\t\t\t| CPU wait%%\t\t\t|" | tee -a $output_log
    printf '<span><b>CPU wait%% - </b></span><b>' >> $html_file
    if [[ $offline_operations == true ]]; then
        all_cpu_wait=$(echo "$mpstat_p_all" | awk -v temp=$mpstat_wait '{print $temp}' | awk -F\% '{print $1}')
    else
        all_cpu_wait=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_wait '{print $temp}')
    fi
    current_cpu=0
    test_output_error=0
    for cpu_wait in $all_cpu_wait; do
        cpu_wait=$(echo $cpu_wait | awk '{printf "%.0f", int($1+0.5)}')
        if [[ $cpu_wait -ge 20 ]]; then
            result_check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_wait%% wait\n" >> $logfile
                printf "<span>top reading $current_cpu - $cpu_wait%% wait</span><br>\n" >> $html_file
            else
                printf "CPU $current_cpu - $cpu_wait%% wait\n" >> $logfile
                printf "<span>CPU $current_cpu - $cpu_wait%% wait</span><br>\n" >> $html_file
            fi
            cpu_wait_warning=1
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "CPU,CPU wait%%,OK,\n" >> $csv_log
    fi
    if [[ $cpu_wait_warning -eq 1 ]]; then
        printf "CPU,CPU wait%%,WARNING,\n" >> $csv_log
        printf "High CPU wait time occurs when the CPU is idle due to the system waiting for an outstanding disk IO request to complete.\n"  >> $logfile
        printf "This could indicate that this system is low on physical memory and is swapping out memory (paging) or that this device is currently experiencing extensive logging operations.\n" >> $logfile
        printf "The CPU is not actually busy if this number is spiking, the CPU is blocked from doing any useful work waiting for an IO event.\n" >> $logfile
        printf "<span>High CPU wait time occurs when the CPU is idle due to the system waiting for an outstanding disk IO request to complete.<br>This could indicate that this system is low on physical memory and is swapping out memory (paging) or that this device is currently experiencing extensive logging operations.<br>The CPU is not actually busy if this number is spiking, the CPU is blocked from doing any useful work waiting for an IO event.</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  CPU Interrupt Check
    #====================================================================================================
    printf "|\t\t\t| CPU interrupt%%\t\t|" | tee -a $output_log
    printf '<span><b>CPU interrupt%% - </b></span><b>' >> $html_file
    if [[ $offline_operations == true ]]; then
        all_cpu_interrupt=$(echo "$mpstat_p_all" | awk -v temp=$mpstat_soft '{print $temp}' | awk -F\% '{print $1}')
    else
        all_cpu_interrupt=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_soft '{print $temp}')
    fi
    current_cpu=0
    test_output_error=0
    for cpu_interrupt in $all_cpu_interrupt; do
        cpu_interrupt=$(echo $cpu_interrupt | awk '{printf "%.0f", int($1+0.5)}')
        if [[ $cpu_interrupt -ge 20 ]]; then
            result_check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_interrupt%% interrupt\n" >> $logfile
                printf "<span>top reading $current_cpu - $cpu_interrupt%% interrupt</span><br>\n" >> $html_file
            else
                printf "CPU $current_cpu - $cpu_interrupt%% interrupt\n" >> $logfile
                printf "<span>CPU $current_cpu - $cpu_interrupt%% interrupt</span><br>\n" >> $html_file
            fi
            cpu_interrupt_warning=1
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "CPU,CPU interrupt%%,OK,\n" >> $csv_log
    fi
    if [[ $cpu_interrupt_warning -eq 1 ]]; then
        printf "<span></span><br><br>\n" >> $html_file
        printf "CPU,CPU interrupt%%,WARNING,\n" >> $csv_log
        printf "High CPU software interrupt time indicates that there is probably a high load of traffic on the firewall.\n" >> $logfile
        printf "Use \"netstat -i\" to see if interface errors are the cause.\n" >> $logfile
        printf "<span>High CPU software interrupt time indicates that there is probably a high load of traffic on the firewall.<br>Use \"netstat -i\" to see if interface errors are the cause.</span><br><br>\n" >> $html_file
    fi


    #====================================================================================================
    #  CPView Database Checks
    #====================================================================================================
    if [[ -e $cpview_file ]] && [[ $sys_type == "VSX" ||  $sys_type == "STANDALONE" || $sys_type == "GATEWAY" ]]; then


        #====================================================================================================
        #  CPU 30-Day Average Check
        #====================================================================================================
        printf "|\t\t\t| CPU 30-Day Average\t\t|" | tee -a $output_log
        printf '<span><b>CPU 30-Day Average - </b></span><b>' >> $html_file
        current_cpu=0
        cpu_over_80=0
        test_output_error=0
        for current_cpu in $all_cpu_list; do
            current_cpu_avg=$(sqlite3 $cpview_file "select avg(cpu_usage) from UM_STAT_UM_CPU_UM_CPU_ORDERED_TABLE where name_of_cpu=$current_cpu;" 2> /dev/null | awk '{printf "%.0f", int($1+0.5)}')
            if [[ $current_cpu_avg -ge 80 ]]; then
                ((cpu_over_80++))
                result_check_failed
                printf "CPU $current_cpu Average Usage: $current_cpu_avg\n" >> $logfile
                printf "<span>CPU $current_cpu Average Usage: $current_cpu_avg</span><br>\n" >> $html_file
            fi
        done

        #Log final output
        if [[ $cpu_over_80 -ge 1 ]]; then
            printf "CPU,CPU 30-Day Average,WARNING,\n" >> $csv_log
            printf "$cpu_over_80 core(s) out of $all_cpu_count had an average over 80%% in the last month.\nPlease review the CPU usage on this device to see if a configuration change or hardware upgrade is needed.\n" >> $logfile
            printf "<span>$cpu_over_80 core(s) out of $all_cpu_count had an average over 80%% in the last month.<br>Please review the CPU usage on this device to see if a configuration change or hardware upgrade is needed.</span><br><br>\n" >> $html_file
        else
            result_check_passed
            printf "CPU,CPU 30-Day Average,OK,\n" >> $csv_log
        fi

        #====================================================================================================
        #  CPU 30-Day Max Check
        #====================================================================================================
        printf "|\t\t\t| CPU 30-Day Peak\t\t|" | tee -a $output_log
        printf '<span><b>CPU 30-Day Peak - </b></span><b>' >> $html_file
        current_cpu=0
        cpu_over_80=0
        test_output_error=0
        for current_cpu in $all_cpu_list; do
            current_cpu_peak=$(sqlite3 $cpview_file "select max(cpu_usage) from UM_STAT_UM_CPU_UM_CPU_ORDERED_TABLE where name_of_cpu=$current_cpu;" 2> /dev/null | awk '{printf "%.0f", int($1+0.5)}')
            if [[ $current_cpu_peak -ge 80 ]]; then
                ((cpu_over_80++))
                result_check_failed
                printf "CPU $current_cpu Peak Usage: $current_cpu_peak\n" >> $logfile
                printf "<span>CPU $current_cpu Peak Usage: $current_cpu_peak</span><br>\n" >> $html_file
            fi
        done

        #Log final output
        if [[ $cpu_over_80 -ge 1 ]]; then
            printf "CPU,CPU 30-Day Peak,WARNING,\n" >> $csv_log
            printf "$cpu_over_80 core(s) out of $all_cpu_count went over 80%% in the last month.\nPlease review the CPU usage on this device to see if a configuration change or hardware upgrade is needed.\n" >> $logfile
            printf "<span>$cpu_over_80 core(s) out of $all_cpu_count went over 80%% in the last month.<br>Please review the CPU usage on this device to see if a configuration change or hardware upgrade is needed.</span><br><br>\n" >> $html_file
        else
            result_check_passed
            printf "CPU,CPU 30-Day Peak,OK,\n" >> $csv_log
        fi
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset CPU variables
    unset all_cpu_idle
    unset cpu_idle
    unset all_cpu_user
    unset cpu_user
    unset cpu_user_warning
    unset all_cpu_system
    unset cpu_system
    unset cpu_system_warning
    unset all_cpu_wait
    unset cpu_wait
    unset cpu_wait_warning
    unset all_cpu_interrupt
    unset cpu_interrupt
    unset cpu_interrupt_warning
    unset cpu_over_80
    unset current_cpu_avg
    unset current_cpu_peak
}


#====================================================================================================
#  Check Point Software Function
#====================================================================================================
check_cp_software()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    script_build_date="11-13-2019"
    current_check_message="Check Point\t\t"


    #====================================================================================================
    #  CPinfo Build Check (sk92739)
    #====================================================================================================
    printf "| Check Point\t\t| CPInfo Build Number\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Check Point</b></span><br>\n' >> $html_file
    printf '<span><b>CPInfo Build Number - </b></span><b>' >> $html_file
    cpinfo_build_version=$(cpvinfo /opt/CPinfo-10/bin/cpinfo | grep Build | awk '{print $4}')
    printf "\n\ncpinfo build:\n$cpinfo_build_version\n"  >> $full_output_log
    if [[ $cpinfo_build_version -ge $latest_cpinfo_build ]]; then
        result_check_passed
        printf "Check Point,CPInfo Build Number,OK,\n" >> $csv_log
        printf "The cpinfo utility is up to date as of $script_build_date.\n" >> $full_output_log
    else
        result_check_failed
        printf "Check Point,CPInfo Build Number,WARNING,sk92739\n" >> $csv_log
        printf "An updated version of the CPInfo utility is available in sk92739 (as of $script_build_date).\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Local Build:  $cpinfo_build_version\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Latest Build: $latest_cpinfo_build\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>An updated version of the CPInfo utility is available in sk92739 (as of $script_build_date).<br>Local Build:  $cpinfo_build_version<br>Latest Build: $latest_cpinfo_build</span><br><br>\n" >> $html_file
    fi


    #====================================================================================================
    #  CPUSE Build Check (sk92449)
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| CPUSE Build Number\t\t|" | tee -a $output_log
    printf '<span><b>CPUSE Build Number - </b></span><b>' >> $html_file
    cpuse_build_version=$(cpvinfo $DADIR/bin/DAService | grep Build | awk '{print $4}')
    if [[ $cpuse_build_version -ge $latest_cpuse_build ]]; then
        result_check_passed
        printf "Check Point,CPUSE Build Number,OK,\n" >> $csv_log
        printf "CPUSE is up to date as of $script_build_date.\n" >> $full_output_log
    else
        result_check_failed
        printf "Check Point,CPUSE Build Number,WARNING,sk92449\n" >> $csv_log
        printf "An updated version of CPUSE is available in sk92449 (as of $script_build_date).\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Local Build:  $cpuse_build_version\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Latest Build: $latest_cpuse_build\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>An updated version of CPUSE is available in sk92449 (as of $script_build_date).<br>Local Build:  $cpuse_build_version<br>Latest Build: $latest_cpuse_build</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  CPView History Check
    #====================================================================================================
    if [[ -e /bin/cpview_start.sh ]] && [[ $sys_type == "VSX" || $sys_type == "STANDALONE" || $sys_type == "GATEWAY" ]]; then
        test_output_error=0
        history_stat=$(/bin/cpview_start.sh history stat)
        printf "|\t\t\t| CPView History Status\t\t|" | tee -a $output_log
        printf '<span><b>CPView History Status - </b></span><b>' >> $html_file
        if [[ $history_stat == *"history daemon is activated"* ]]; then
            result_check_passed
            printf "Check Point,CPView History Status,OK,\n" >> $csv_log
        elif [[ $history_stat == *"history daemon is not activated"* ]]; then
            result_check_failed
            printf "Check Point,CPView History Status,WARNING,sk101878\n" >> $csv_log
            printf "CPView History is not running.  Please use sk101878 for more information.\n" | tee -a $full_output_log $logfile > /dev/null
            printf "<span>CPView History is not running.  Please use sk101878 for more information.</span><br><br>\n" >> $html_file
        else
            result_check_failed
            printf "Check Point,CPView History Status,WARNING,sk101878\n" >> $csv_log
            printf "Unable to determine CPView history status.  Please use sk101878 for more information.\n" | tee -a $full_output_log $logfile > /dev/null
            printf "<span>Unable to determine CPView history status.  Please use sk101878 for more information.</span><br><br>\n" >> $html_file
        fi
    fi

    #====================================================================================================
    #  Jumbo Version Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Jumbo Version\t\t\t|" | tee -a $output_log
    printf '<span><b>Jumbo Version - </b></span><b>' >> $html_file

    #Find the jumbo version per CP release
    installed_jumbo_version=$(grep ":installed_on " /config/active | grep Bundle | grep -v bundle | grep JUMBO | egrep "$cp_version|$cp_underscore_version" | egrep -o 'T[0-9]{1,3}' | tr -d "T" | sort -n | tail -n1)
    if [[ $current_version -eq "7730" ]]; then
        latest_ga_jumbo=$r7730_ga_jumbo
        jumbo_sk="sk106162"
    elif [[ $current_version -eq "8010" ]]; then
        latest_ga_jumbo=$r8010_ga_jumbo
        jumbo_sk="sk116380"
    elif [[ $current_version -eq "8020" ]]; then
        latest_ga_jumbo=$r8020_ga_jumbo
        jumbo_sk="sk137592"
    elif [[ $current_version -eq "8030" ]]; then
        latest_ga_jumbo=$r8030_ga_jumbo
        jumbo_sk="sk153152"
    elif [[ $current_version -eq "8040" ]]; then
        latest_ga_jumbo=$r8040_ga_jumbo
        jumbo_sk="sk165456"
    elif [[ $current_version -eq "8100" ]]; then
        latest_ga_jumbo=$r81_ga_jumbo
        jumbo_sk="sk170114"
    elif [[ $current_version -eq "8110" ]]; then
        latest_ga_jumbo=$r8110_ga_jumbo
        jumbo_sk="TBD"
    else
        latest_ga_jumbo="Unsupported"
        installed_jumbo_version="Unsupported"
    fi

    #Ensure the local jumbo version isn't blank
    if [[ -z $installed_jumbo_version ]]; then
        installed_jumbo_version="0"
    fi

    #Check the results
    if [[ $latest_ga_jumbo == "Unsupported" ]]; then
        result_check_failed
        printf "Check Point,Jumbo Version,WARNING,\n" >> $csv_log
        printf "Jumbo version check is not supported on the currently installed software.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>Jumbo version check is not supported on the currently installed software</span><br><br>\n" >> $html_file
    elif [[ $installed_jumbo_version -ge $latest_ga_jumbo ]]; then
        result_check_passed
        printf "Check Point,Jumbo Version,OK,\n" >> $csv_log
    else
        result_check_failed
        printf "Check Point,Jumbo Version,WARNING,$jumbo_sk\n" >> $csv_log
        printf "An updated version of the jumbo is available in $jumbo_sk (as of $script_build_date).\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Local Jumbo take:  $installed_jumbo_version\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Latest GA Jumbo:   $latest_ga_jumbo\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>An updated version of CPUSE is available in $jumbo_sk (as of $script_build_date).<br>Local Jumbo take:  $installed_jumbo_version<br>Latest GA Jumbo: $latest_ga_jumbo</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  CP Version Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| CP Version\t\t\t|" | tee -a $output_log
    printf '<span><b>CP Version - </b></span><b>' >> $html_file

    #Current Unix epoc second
    current_second=$(date +"%s")
    one_year_out_second=$(( current_second + 31276800 ))
    
    #CP version EOS
    if [[ $current_version -eq "0" ]]; then
        eos_date=$(date +"%d %B %Y")
    elif [[ $current_version -eq "7730" ]]; then
        eos_date="30 September 2019"
    elif [[ $current_version -ge "8000" && $current_version -le "8010" ]]; then
        eos_date="31 January 2022"
    elif [[ $current_version -ge "8020" && $current_version -le "8030" ]]; then
        eos_date="30 September 2022"
    elif [[ $current_version -ge "8040" ]]; then
        eos_date="31 January 2024"
    elif [[ $current_version -ge "8100" ]]; then
        eos_date="31 October 2024"
    else
        eos_date="1 January 2000"
    fi
    
    #Convert End of Support to seconds
    eos_second=$(date -d "$eos_date" +%s)

    #Check the results
    if [[ $eos_second -ge $one_year_out_second ]]; then
        result_check_passed
        printf "Check Point,CP Version,OK,\n" >> $csv_log
    elif [[ $eos_second -ge $current_second ]]; then
        result_check_info
        printf "Check Point,CP Version,Info,sk64620\n" >> $csv_log
        printf "The current software version will be end of support in less than a year.  Please consider upgrading to a new version.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "End of Support Date:  $eos_date\nPlease see sk64620 for more information.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>The current software version will be end of support in less than a year.  Please consider upgrading to a new version.<br>End of Support Date:  $eos_date<br>Please see sk64620 for more information.</span><br><br>\n" >> $html_file
    else
        result_check_failed
        printf "Check Point,CP Version,Info,sk64620\n" >> $csv_log
        printf "The current software version has reached end of support.  Please consider upgrading to a new version.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "End of Support Date:  $eos_date\nPlease see sk64620 for more information.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>The current software version has reached end of support.  Please consider upgrading to a new version.<br>End of Support Date:  $eos_date<br>Please see sk64620 for more information.</span><br><br>\n" >> $html_file
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset CP Software check variables
    unset script_build_date
    unset cpinfo_build_version
    unset latest_cpinfo_build
    unset cpuse_build_version
    unset latest_cpuse_build
    unset history_stat
    unset r7730_ga_jumbo
    unset r8010_ga_jumbo
    unset r8020_ga_jumbo
    unset r8030_ga_jumbo
    unset r8040_ga_jumbo
    unset r81_ga_jumbo
    unset r8110_ga_jumbo
    unset jumbo_sk
    unset installed_jumbo_version
    unset latest_ga_jumbo
}


#====================================================================================================
#  Debugs Function
#====================================================================================================
check_debugs()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Debugs\t\t"


    #====================================================================================================
    #  Active tcpdumps Check
    #====================================================================================================
    printf "| Debugs\t\t| Active tcpdump\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Debugs</b></span><br>\n' >> $html_file
    printf '<span><b>Active tcpdump - </b></span><b>' >> $html_file

    tcpdumps_active=$(ps aux | grep tcpdump | grep -v grep)

    #Check if kdebug or zdebug are running.
    if [[ $(echo "$tcpdumps_active" | grep tcpdump) ]]; then
        result_check_failed
        printf "Debugs,Active tcpdump,WARNING,\n" >> $csv_log
        printf "The following tcpdumps are running:\n" >> $logfile
        printf "PID\tCOMMAND\n" >> $logfile
        printf "<span>PID<tab>COMMAND</tab></span><br>\n" >> $html_file
        while read -r current_tcpdump; do
            current_tcpdump_PID=$(echo $current_tcpdump | awk '{print $2}')
            current_tcpdump_command=$(echo $current_tcpdump | awk '{print $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25}')
            printf "$current_tcpdump_PID\t$current_tcpdump_command\n" >> $logfile
            printf "<span>$current_tcpdump_PID<tab>$current_tcpdump_command</tab></span><br>\n" >> $html_file
        done <<< "$tcpdumps_active"
        printf "Please stop these processes if these captures are no longer needed.\n" >> $logfile
        printf "<span>Please stop these processes if these captures are no longer needed.</span><br><br>\n" >> $html_file
    else
        result_check_passed
        printf "Debugs,Active tcpdump,OK,\n" >> $csv_log
    fi

    #====================================================================================================
    #  Active Debug Check
    #====================================================================================================
    printf "|\t\t\t| Active Debug Processes\t|" | tee -a $output_log
    printf '<span><b>Active Debug Processes - </b></span><b>' >> $html_file
    test_output_error=0

    debugs_active=$(ps aux | grep debug | grep -v grep)

    #Check if kdebug or zdebug are running.
    if [[ $(echo "$debugs_active" | grep debug) ]]; then
        result_check_failed
        printf "Debugs,Active Debug Processes,WARNING,\n" >> $csv_log
        printf "The following debugs were enabled:\n" >> $logfile
        printf "PID\tCOMMAND\n" >> $logfile
        printf "<span>PID<tab>COMMAND</tab></span><br>\n" >> $html_file
        while read -r current_debug; do
            current_debug_PID=$(echo $current_debug | awk '{print $2}')
            current_debug_command=$(echo $current_debug | awk '{print $11, $12, $13, $14, $15, $16, $17}')
            printf "$current_debug_PID\t$current_debug_command\n" >> $logfile
            printf "<span>$current_debug_PID<tab>$current_debug_command</tab></span><br>\n" >> $html_file
        done <<< "$debugs_active"
        printf "If these debugs are no longer needed:\nPlease stop these processes and run \"fw ctl debug 0\" to clear the debug flags.\n\n" >> $logfile
        printf "<span>If these debugs are no longer needed:\nPlease stop these processes and run \"fw ctl debug 0\" to clear the debug flags.</span><br><br>\n" >> $html_file
    else
        result_check_passed
        printf "Debugs,Active Debug Processes,OK,\n" >> $csv_log
    fi

    #====================================================================================================
    #  Firewall Debug Flag Check
    #====================================================================================================
    if [[ $sys_type == "STANDALONE" || $sys_type == "GATEWAY" || $sys_type == "VSX" ]]; then
        test_output_error=0
        debug_flag_check=0
        printf "|\t\t\t| Debug Flags Present\t\t|" | tee -a $output_log
        printf '<span><b>Debug Flags Present - </b></span><b>' >> $html_file

        #Collect list of modules and dump module settings:
        if [[ $current_version -ge 7730 ]]; then
            fw ctl debug -m > /var/tmp/debug_flag_modules.tmp 2> /dev/null
            fw ctl debug > /var/tmp/debug_flag_current.tmp 2> /dev/null
        else
            script -c "fw ctl debug -m" /var/tmp/debug_flag_modules.tmp > /dev/null 2>&1
            wait
            script -c "fw ctl debug" /var/tmp/debug_flag_current.tmp >> /dev/null 2>&1
        fi
        debug_flag_module_list=$(grep Module /var/tmp/debug_flag_modules.tmp | awk -F: '{print $2}' | awk '{print $1}')
        fwaccel_debug_flag_set=0
        sim_debug_flag_set=0


        #Check for fwaccel debug flags
        fwaccel_debugs=$(fwaccel dbg list)
        if [[ $(echo "$fwaccel_debugs" | egrep -iv 'filter|Module' | sed 's/error//g' | sed 's/err//g' | egrep '[a-zA-Z]') ]]; then
            #Loop through each line of debug flags
            while read -r fwaccel_debug; do
                #Find the last debug flag that is not a default value
                last_flag=$(echo $fwaccel_debug | awk '{print $NF}')
                #Find the module associated with that debug flag
                current_module=$(echo "$fwaccel_debugs" | grep -B1 $last_flag | head -n1)
                printf "fwaccel debug for $current_module\n" >> /var/tmp/modified_modules.tmp
                debug_flag_check=1
                fwaccel_debug_flag_set=1
            done <<< "$(echo "$fwaccel_debugs" | egrep -iv 'filter|Module' | sed 's/error//g' | sed 's/err//g' | egrep '[a-zA-Z]')"
        fi

        #Check for sim debug flags
        if [[ $current_version -le 8010 ]]; then
            sim_debugs=$(sim dbg list)
            if [[ $(echo "$sim_debugs" | egrep -iv 'filter|Module' | sed 's/error//g' | sed 's/err//g' | egrep '[a-zA-Z]') ]]; then
                #Loop through each line of debug flags
                while read -r sim_debug; do
                    #Find the last debug flag that is not a default value
                    last_flag=$(echo $sim_debug | awk '{print $NF}')
                    #Find the module associated with that debug flag
                    current_module=$(echo "$sim_debugs" | grep -B1 $last_flag | head -n1)
                    printf "sim debug for $current_module\n" >> /var/tmp/modified_modules.tmp
                    debug_flag_check=1
                    sim_debug_flag_set=1
                done <<<  "$(echo "$sim_debugs" | egrep -iv 'filter|Module' | sed 's/error//g' | sed 's/err//g' | egrep '[a-zA-Z]')"
            fi
        fi

        #Loop through and check each module
        for current_module in $debug_flag_module_list; do
            #Delete control characters from module name
            current_module=$(echo $current_module | tr -d '[:cntrl:]')

            #Find the current debug flag setting
            current_module_setting=$(grep -w -A3 $current_module /var/tmp/debug_flag_current.tmp | grep "debugging options" | awk -F: '{print $2}' | awk '{print $1,$2}' | tr -d '[:cntrl:]')

            #Check to see if it does not contain the default flags
            if [[ $current_module_setting != *"error warning"* && $current_module_setting != *"error"* && $current_module_setting != *"None"* && $current_module_setting != *"err"* && -n $current_module_setting ]]; then
                printf "fw ctl debug for $current_module\n" >> /var/tmp/modified_modules.tmp
                debug_flag_check=1
            fi
        done

        #Message to display if any modified flags are detected
        if [[ $debug_flag_check -ne 0 ]]; then
            result_check_failed
            printf "Debugs,Debug Flags Present,WARNING,\n" >> $csv_log
            printf "Detected modified debug flags for the following modules:\n" >> $logfile
            cat /var/tmp/modified_modules.tmp >> $logfile
            printf "If these debug flags are no longer needed, they can be cleared by running the following commands from Expert Mode:\nfw ctl debug 0\n" >> $logfile

            #Add debug flag info to HTML file
            printf "<span>Detected modified debug flags for the following modules:</span><br>\n<span>" >> $html_file
            while read modified_module; do
                printf "$modified_module<br>" >> $html_file
            done < /var/tmp/modified_modules.tmp
            printf "</span><br>\n" >> $html_file
            printf "<span>If these debug flags are no longer needed, they can be cleared by running the following commands from Expert Mode:<br>fw ctl debug 0<br>" >> $html_file
            if [[ $sim_debug_flag_set -eq 1 ]]; then
                printf "sim dbg resetall<br>" >> $html_file
                printf "sim dbg resetall\n" >> $logfile
            fi
            if [[ $fwaccel_debug_flag_set -eq 1 ]]; then
                printf "fwaccel dbg resetall<br>" >> $html_file
                printf "fwaccel dbg resetall\n" >> $logfile
            fi
            printf "</span><br>\n" >> $html_file
        else
            result_check_passed
            printf "Debugs,Debug Flags Present,OK,\n" >> $csv_log
        fi

        #Clean up temp files
        rm /var/tmp/debug_flag_current.tmp > /dev/null 2>&1
        rm /var/tmp/debug_flag_modules.tmp > /dev/null 2>&1
        rm /var/tmp/modified_modules.tmp > /dev/null 2>&1
    fi

    #====================================================================================================
    #  CPM Debug Check
    #====================================================================================================
    if [[ $current_version -ge 8000 ]]; then
        if [[ $sys_type == "MDS" || $sys_type == "SMS" || $sys_type == "STANDALONE" || $sys_type == "LOG" ]]; then
            test_output_error=0
            printf "|\t\t\t| CPM Debugs \t\t\t|" | tee -a $output_log
            printf '<span><b>CPM Debugs - </b></span><b>' >> $html_file

            #Check to see if CPM debugs are enabled in tdlog.cpm
            if [[ $(grep TOPIC-DEBUG $MDS_FWDIR/conf/tdlog.cpm) ]]; then
                result_check_failed
                printf "Debugs,CPM Debugs,WARNING,sk115557\n" >> $csv_log
                printf "CPM Debugs are present for the following modules:\n" >> $logfile
                grep TOPIC-DEBUG $MDS_FWDIR/conf/tdlog.cpm | awk -F: '{print $2}' >> $logfile
                printf "If these debugs are no longer needed, please follow the steps from sk115557 to disable them.\n" >> $logfile

                #Build HTML file for active CPM debugs
                printf "<span>CPM Debugs are present for the following modules:</span><br>\n<span>" >> $html_file
                while read cpm_debugs_active; do
                    printf "$cpm_debugs_active<br>"  >> $html_file
                done <<< $(grep TOPIC-DEBUG $MDS_FWDIR/conf/tdlog.cpm | awk -F: '{print $2}')
                printf "</span><br>\n" >> $html_file
                printf "<span>If these debugs are no longer needed, please follow the steps from sk115557 to disable them.</span><br>\n" >> $html_file
            else
                result_check_passed
                printf "Debugs,CPM Debugs,OK,\n" >> $csv_log
            fi
        fi
    fi


    #====================================================================================================
    #  TDERROR Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| TDERROR Configured\t\t|" | tee -a $output_log
    printf '<span><b>TDERROR Configured - </b></span><b>' >> $html_file
    if [[ $(env | grep TDERROR) ]]; then
        result_check_failed
        printf "Debugs,TDERROR Configured,WARNING,\n" >> $csv_log
        active_tderror=$(env | grep TDERROR | awk -F= '{print $1}')
        if [[ $(echo "$active_tderror" | wc -l) -eq 1 ]]; then
            printf "Detected $active_tderror environment variable.\nIf this is no longer needed, run the following command:\n    unset $active_tderror\n" >> $logfile
            printf "<span>Detected $active_tderror environment variable.<br>If this is no longer needed, run the following command:<br><tab>unset $active_tderror</tab></span><br><br>\n" >> $html_file
        else
            printf "Detected multiple \"TDERROR\" environment variables:\n" >> $logfile
            printf "These can be disabled with the respective commands below:\n" >> $logfile
            printf "<span>Detected multiple \"TDERROR\" environment variables:<br>These can be disabled with the respective commands below:</span><br>\n" >> $html_file
            for i in $(echo "$active_tderror"); do
                printf "    unset $i\n" >> $logfile
                printf "<span><tab>unset $i</tab></span><br><br>\n" >> $html_file
            done
        fi
    else
        result_check_passed
        printf "Debugs,TDERROR Configured,OK,\n" >> $csv_log
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset Debug Check variables
    unset tcpdumps_active
    unset current_tcpdump
    unset current_tcpdump_PID
    unset current_tcpdump_command
    unset debugs_active
    unset current_debug
    unset current_debug_PID
    unset current_debug_command
    unset debug_flag_check
    unset debug_flag_module_list
    unset current_module
    unset current_module_setting
    unset active_tderror
    unset modified_module
    unset cpm_debugs_active
}


#====================================================================================================
#  Disk Space Function
#====================================================================================================
check_disk_space()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Disk Space\t\t"
    disk_check_file=/var/tmp/disk_space.tmp

    #Start disk space checks
    printf "| Disk Space\t\t| Free Disk Space\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Disk Space</b></span><br>\n' >> $html_file
    printf '<span><b>Free Disk Space - </b></span><b>' >> $html_file
    printf "\n\nDisk Space Info:\n" >> $full_output_log

    #Add full output to temp log and disk_check variable
    if [[ $offline_operations == true ]]; then
        grep ext3 $cpinfo_file | grep -e M -e G | awk -F'ext3' '{print $2}' > $disk_check_file
    else
        df -Ph | awk '{print $2, $3, $4, $5, $6}' > $disk_check_file
    fi
    cat $disk_check_file >> $full_output_log

    #Loop through each partition
    while read partition; do
        partition_name=$(echo "$partition" | awk '{print $5}')
        partition_space=$(echo "$partition" | awk '{print $4}' | sed 's/%//g')
        if [[ $partition_space -ge 70 && $partition_space -le 90 ]]; then
            result_check_failed
            printf "Free Disk Space Warning - $partition_name $partition_space%% full.\n" >> $logfile
            printf "<span>Free Disk Space Warning - $partition_name $partition_space%% full.</span><br>\n" >> $html_file
            disk_space_error=1
        elif [[ $partition_space -gt 90 ]]; then
            result_check_failed
            printf "Free Disk Space Critical - $partition_name $partition_space%% full.\n" >> $logfile
            printf "<span>Free Disk Space Critical - $partition_name $partition_space%% full.</span><br>\n" >> $html_file
            disk_space_error=1
        fi
    done < $disk_check_file

    #Message to display if any errors are detected
    if [[ $disk_space_error -eq 1 ]]; then
        result_check_failed
        printf "Disk Space,Free Disk Space,WARNING,sk60080\n" >> $csv_log
        printf "Check if any partition listed above can be cleaned up to free up disk space.\n" >> $logfile
        printf "Please see sk60080 for further assistance freeing up disk space.\n" >> $logfile
        printf '<span>Check if any partition listed above can be cleaned up to free up disk space.<br>Please see sk60080 for further assistance freeing up disk space.</span><br><br>\n' >> $html_file
    else
        result_check_passed
        printf "Disk Space,Free Disk Space,OK,\n" >> $csv_log
    fi

    #Remove temp file
    rm -rf $disk_check_file > /dev/null 2>&1

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset Disk Space Variables
    unset disk_check
    unset partition_entry
    unset disk_space_error
    unset partition_space
    unset partition_name
}


#====================================================================================================
#  Fragments Function
#====================================================================================================
check_fragments()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    fragment_error_file=/var/tmp/fragment_error
    current_check_message="Fragments\t\t"

    #Collect expired and failure numbers from "fw ctl pstat"
    all_fragments=$(fw ctl pstat 2> $fragment_error_file | grep -A2 Fragments | grep -v Fragments)
    current_expired=$(echo $all_fragments | awk '{print $5}')
    current_failures=$(echo $all_fragments | awk '{print $13}')
    printf "| Fragments\t\t| Fragments\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Fragments</b></span><br>\n' >> $html_file
    printf '<span><b>Fragments - </b></span><b>' >> $html_file


    #Display ERROR if fw ctl pstat is unable to execute
    if [[ -s $fragment_error_file ]]; then
        result_check_failed
        printf "Fragments,Fragments,ERROR,\n" >> $csv_log
        printf "\"fw ctl pstat\" resulted in an error and fragment information was unable to be determined.\n" >> $logfile
        printf "<span>\"fw ctl pstat\" resulted in an error and fragment information was unable to be determined.</span><br><br>\n" >> $html_file

    #Display warning messages if failures or expired packets are detected
    elif [[ $current_failures -ne 0 || $current_expired -ne 0 ]]; then
        result_check_failed
        printf "Fragments,Fragments,WARNING,\n" >> $csv_log
        if [[ $current_failures -ne 0 ]]; then
            printf "Failures denotes the number of fragmented packets that were received that could not be successfully re-assembled.\n" >> $logfile
            printf "<span>Failures denotes the number of fragmented packets that were received that could not be successfully re-assembled.</span><br>\n" >> $html_file
        fi
        if [[ $current_expired -ne 0 ]];then
            printf "Expired denotes how many fragments were expired when the firewall failed to reassemble them in a 20 seconds time frame or when due to memory exhaustion, they could not be kept in memory anymore.\n" >> $logfile
            printf "<span>Expired denotes how many fragments were expired when the firewall failed to reassemble them in a 20 seconds time frame or when due to memory exhaustion, they could not be kept in memory anymore.</span><br>\n" >> $html_file
        fi
        printf "<br>\n" >> $html_file

    #Display OK if everything is good
    else
        result_check_passed
        printf "Fragments,Fragments,OK,\n" >> $csv_log
    fi

    #Clean up temp file
    rm $fragment_error_file > /dev/null 2>&1

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset Fragments variables
    unset all_fragments
    unset current_expired
    unset current_failures
}


#====================================================================================================
#  Hardware Info Function
#====================================================================================================
check_hardware()
{
    #Insert full log header
    printf "\n# Hardware Platform Checks:\n" >> $full_output_log

    #Collect Hardware Platform Information
    dmiparse System Product >> $full_output_log
    clish -c 'show asset system' >> $full_output_log

    #Insert full log header
    printf "\n# Hardware Sensor Info:\n" >> $full_output_log

    #Collect current hardware status
    cpstat -f sensors os | sed "/^$/d" | sed '/Voltage Sensors/i \\' | sed '/Fan Speed Sensors/i \\' >> $full_output_log
    clish -c "show sysenv all" | sed "/^$/d" >> $full_output_log
    printf "\nCurrent and Max Processor Speed:\n" >> $full_output_log
    dmidecode | grep -A15 -B5 GenuineIntel | grep -e socket -e Speed >> $full_output_log
    printf "\n\"/proc/cpuinfo\" Current Processor Speed:\n" >> $full_output_log
    grep -e processor -e MHz /proc/cpuinfo >> $full_output_log
}


#====================================================================================================
#  Interface Info Function
#====================================================================================================
check_interface_stats()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Interfaces\t\t"

    #Collect interface list for checks
    interface_list=$(ifconfig -a | grep encap | awk '{print $1}' | grep -v lo | grep -v ":" | grep -v '\.' | grep -v bond) > /dev/null 2>&1

    #Add spaces to full output log
    printf "\n\n" >> $full_output_log

    #Log full netstat output
    netstat -i >> $full_output_log

    #====================================================================================================
    #  RX Errors Check
    #====================================================================================================
    printf "| Interface Stats\t| RX Errors\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Interface Stats</b></span><br>\n' >> $html_file
    printf '<span><b>RX Errors - </b></span><b>' >> $html_file
    for current_interface in $interface_list; do
        current_errors=$(cat /sys/class/net/$current_interface/statistics/rx_errors) > /dev/null 2>&1
        if [[ $current_errors -ne 0 ]]; then
            result_check_failed
            printf "RX Errors - $current_interface has $current_errors RX errors\n" >> $logfile
            printf "<span>RX Errors - $current_interface has $current_errors RX errors</span><br>\n" >> $html_file
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Interface Stats,RX Errors,OK,\n" >> $csv_log
    fi

    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Errors,WARNING,\n" >> $csv_log
        printf "\nReceive Error Information:\nThese usually indicate a mismatch in duplex setting, mtu size, bad cabling or possibly a faulty interface card.\n" >> $logfile
        printf "Check the switch settings and fix the speed and duplex settings if there is a mismatch, check cabling and try a spare interface.\n" >> $logfile
        printf "<span>These usually indicate a mismatch in duplex setting, mtu size, bad cabling or possibly a faulty interface card.<br>Check the switch settings and fix the speed and duplex settings if there is a mismatch, check cabling and try a spare interface.</span><br><br>\n" >> $html_file
    fi


    #====================================================================================================
    #  RX Drop Check
    #====================================================================================================
    printf "|\t\t\t| RX Drops\t\t\t|" | tee -a $output_log
    printf '<span><b>RX Drops - </b></span><b>' >> $html_file
    test_output_error=0

    #Loop through each interface to collect RX-Drop and RX-OK info
    for current_interface in $interface_list; do
        current_OK=$(cat /sys/class/net/$current_interface/statistics/rx_packets) > /dev/null 2>&1
        current_drops=$(cat /sys/class/net/$current_interface/statistics/rx_dropped) > /dev/null 2>&1

        #Determine percentage of drops
        if [[ $current_drops -ge 1 ]]; then
            #Divide RX-Drop by RX-OK
            drop_percent=$(echo $current_drops/$current_OK | bc -l)

            #Multiply drop_percent by 100 to get percentage (and round one set)
            drop_percent_rounded=$(echo 100*$drop_percent | bc -l | awk '{printf "%.0f", int($1+0.5)}')
            drop_percent=$(echo 100*$drop_percent | bc -l | xargs printf "%.2f")
        else
            drop_percent_rounded=0
        fi

        #Log failures if drops are over .5%
        if [[ $drop_percent_rounded -ge 1 ]]; then
            result_check_failed
            printf "RX Drops WARNING - $current_interface has $current_drops RX drops which accounts for $drop_percent%% of traffic on this interface.\n" >> $logfile
            printf "<span>$current_interface has $current_drops RX drops which accounts for $drop_percent%% of traffic on this interface.</span><br>\n" >> $html_file
        fi
    done

    #Log success if no interfaces are over .5% drops
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Interface Stats,RX Drops,OK,\n" >> $csv_log
    fi

    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Drops,WARNING,\n" >> $csv_log
        printf "\nReceive Drop Information:\nThese imply the appliance is dropping packets at the network.\n" >> $logfile
        printf "Attention is required for the interfaces listed above if the drops account for more than 0.50%% as this is a sign that the firewall does not have enough FIFO memory buffer (descriptors) to hold the packets while waiting for a free interrupt to process them.\n" >> $logfile
        printf "<span>These imply the appliance is dropping packets at the network.<br>Attention is required for the interfaces listed above if the drops account for more than 0.50%% as this is a sign that the firewall does not have enough FIFO memory buffer (descriptors) to hold the packets while waiting for a free interrupt to process them.</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  RX Missed Check
    #====================================================================================================
    printf "|\t\t\t| RX Missed Errors\t\t|" | tee -a $output_log
    printf '<span><b>RX Missed Errors - </b></span><b>' >> $html_file
    test_output_error=0

    #Loop through each interface to collect rx_missed_errors and rx_packets
    for current_interface in $interface_list; do
        current_rx_missed_errors=$(cat /sys/class/net/$current_interface/statistics/rx_missed_errors) > /dev/null 2>&1
        current_rx_packets=$(cat /sys/class/net/$current_interface/statistics/rx_packets) > /dev/null 2>&1

        #Determine percentage of rx_missed
        if [[ $current_rx_missed_errors -ge 1 ]]; then
            #Divide rx_missed_errors by rx_packets
            missed_percent=$(echo $current_rx_missed_errors/$current_rx_packets | bc -l)

            #Multiply missed_percent by 100 to get percentage (and round one set)
            missed_percent_rounded=$(echo 100*$missed_percent | bc -l | awk '{printf "%.0f", int($1+0.5)}')
            missed_percent=$(echo 100*$missed_percent | bc -l | xargs printf "%.2f")
        else
            missed_percent_rounded=0
        fi

        #Log failures if rx_missed are over .5%
        if [[ $missed_percent_rounded -ge 1 ]]; then
            result_check_failed
            printf "RX Missed WARNING - $current_interface has $current_rx_missed_errors rx_missed_errors which accounts for $missed_percent%% of traffic on this interface.\n" >> $logfile
            printf "<span>$current_interface has $current_rx_missed_errors rx_missed_errors which accounts for $missed_percent%% of traffic on this interface.</span><br>\n" >> $html_file
        elif [[ -z $current_rx_packets || -z $current_rx_missed_errors ]]; then
            result_check_failed
            printf "RX Missed - Unable to determine RX packets or RX missed packets for $current_interface.\n" >> $logfile
            printf "<span>Unable to determine RX packets or RX missed packets for $current_interface.</span><br>\n" >> $html_file
        fi
    done

    #Log success if no interfaces are over .5% missed
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Interface Stats,RX Missed Errors,OK,\n" >> $csv_log
    fi

    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Missed Errors,WARNING,\n" >> $csv_log
        printf "\nReceive Missed Information:\nA ratio of rx_mised_errors to rx_packets greater than 0.5%% indicates the number of received packets that have been missed due to lack of capacity in the receive side which means the NIC has no resources and is actively dropping packets.\n" >> $logfile
        printf "Confirm that flow control on the switch is enabled. When flow control on the switch is disabled, we are bound to have issues for rx_missed_errors. If it is enabled, please contact Check Point Software Technologies, we need to know what the TX/RX queues are set to and we'll proceed from there.\n" >> $logfile
        printf "<span>A ratio of rx_mised_errors to rx_packets greater than 0.5%% indicates the number of received packets that have been missed due to lack of capacity in the receive side which means the NIC has no resources and is actively dropping packets.<br>Confirm that flow control on the switch is enabled. When flow control on the switch is disabled, we are bound to have issues for rx_missed_errors. If it is enabled, please contact Check Point Software Technologies, we need to know what the TX/RX queues are set to and we'll proceed from there.</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  RX Overrun Check
    #====================================================================================================
    printf "|\t\t\t| RX Overruns\t\t\t|" | tee -a $output_log
    printf '<span><b>RX Overruns - </b></span><b>' >> $html_file
    test_output_error=0
    for current_interface in $interface_list; do
        current_rx_overruns=$(cat /sys/class/net/$current_interface/statistics/rx_over_errors) > /dev/null 2>&1
        if [[ $current_rx_overruns -ne 0 ]]; then
            result_check_failed
            printf "RX Overruns - $current_interface has $current_rx_overruns RX Overruns\n" >> $logfile
            printf "<span>$current_interface has $current_rx_overruns RX Overruns</span><br>\n" >> $html_file
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Interface Stats,RX Overruns,OK,\n" >> $csv_log
    fi

    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Overruns,WARNING,\n" >> $csv_log
        printf "\nReceive Overrun Information:\nThese imply the appliance is getting overrun with traffic from the network.\n" >> $logfile
        printf "<span>These imply the appliance is getting overrun with traffic from the network.</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  TX Error Check
    #====================================================================================================
    printf "|\t\t\t| TX Errors\t\t\t|" | tee -a $output_log
    printf '<span><b>TX Errors - </b></span><b>' >> $html_file
    test_output_error=0
    for current_interface in $interface_list; do
        current_errors=$(cat /sys/class/net/$current_interface/statistics/tx_errors) > /dev/null 2>&1
        if [[ $current_errors -ne 0 ]]; then
            result_check_failed
            printf "TX Errors - $current_interface has $current_errors TX errors\n" >> $logfile
            printf "<span>$current_interface has $current_errors TX errors.</span><br><br>\n" >> $html_file
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Interface Stats,TX Errors,OK,\n" >> $csv_log
    fi

    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,TX Errors,WARNING,\n" >> $csv_log
        printf "\nTransmit Errors Information:\nThese usually indicate a mismatch in duplex setting, mtu size, bad cabling or possibly a faulty interface card.\n" >> $logfile
        printf "Check the switch settings and fix the speed and duplex settings if there is a mismatch, check cabling and try a spare interface.\n" >> $logfile
        printf "<span>These usually indicate a mismatch in duplex setting, mtu size, bad cabling or possibly a faulty interface card.<br>Check the switch settings and fix the speed and duplex settings if there is a mismatch, check cabling and try a spare interface.</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  TX Drops Check
    #====================================================================================================
    printf "|\t\t\t| TX Drops\t\t\t|" | tee -a $output_log
    printf '<span><b>TX Drops - </b></span><b>' >> $html_file
    test_output_error=0
    for current_interface in $interface_list; do
        current_drops=$(cat /sys/class/net/$current_interface/statistics/tx_dropped) > /dev/null 2>&1
        if [[ $current_drops -ne 0 ]]; then
            result_check_failed
            printf "  $current_interface has $current_drops TX drops\n" >> $logfile
            printf "<span>$current_interface has $current_drops TX drops</span><br>\n" >> $html_file
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Interface Stats,TX Drops,OK,\n" >> $csv_log
    fi

    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,TX Drops,WARNING,\n" >> $csv_log
        printf "\nTransmit Drop Information:\nThese usually indicate that there is a downstream issue and the firewall has to drop the packets as it is unable to put them on the wire fast enough.\n" >> $logfile
        printf "Increasing the bandwidth through link aggregation or introducing flow control may be a possible solution to this problem.\n" >> $logfile
        printf "<span>These usually indicate that there is a downstream issue and the firewall has to drop the packets as it is unable to put them on the wire fast enough.<br>Increasing the bandwidth through link aggregation or introducing flow control may be a possible solution to this problem.</span><br><br>\n" >> $html_file
    fi


    #====================================================================================================
    #  TX Carrier Errors Check
    #====================================================================================================
    printf "|\t\t\t| TX Carrier Errors\t\t|" | tee -a $output_log
    printf '<span><b>TX Carrier Errors - </b></span><b>' >> $html_file
    test_output_error=0
    for current_interface in $interface_list; do
        current_tx_carrier_errors=$(cat /sys/class/net/$current_interface/statistics/tx_carrier_errors) > /dev/null 2>&1
        if [[ $current_tx_carrier_errors -ne 0 ]]; then
            result_check_failed
            printf "TX Carrier Errors - $current_interface has $current_tx_carrier_errors.\n" >> $logfile
            printf "<span>$current_interface has $current_tx_carrier_errors.</span><br>\n" >> $html_file
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Interface Stats,TX Carrier Errors,OK,\n" >> $csv_log
    fi

    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,TX Carrier Errors,WARNING,sk97251\n" >> $csv_log
        printf "\nTransmit Carrier Errors Information:\nThese indicate the number of packets that could not be transmitted because of carrier errors (e.g: physical link down).\n" >> $logfile
        printf "If link is up, run Hardware Diagnostic Tool as described in sk97251. Please run network test while using loopback adapter as explained in sk97251.\n" >> $logfile
        printf "Also provide to Check Point Support an output of the command:#cat /sys/class/net/Internal/carrier. \n" >> $logfile
        printf "<span>These indicate the number of packets that could not be transmitted because of carrier errors (e.g: physical link down).<br>If link is up, run Hardware Diagnostic Tool as described in sk97251. Please run network test while using loopback adapter as explained in sk97251.<br>Also provide to Check Point Support an output of the command:#cat /sys/class/net/Internal/carrier.</span><br><br>\n" >> $html_file
    fi



    #====================================================================================================
    #  TX Overrun Check
    #====================================================================================================
    printf "|\t\t\t| TX Overruns\t\t\t|" | tee -a $output_log
    printf '<span><b>TX Overruns - </b></span><b>' >> $html_file
    test_output_error=0
    for current_interface in $interface_list; do
        current_tx_overruns=$(ifconfig $current_interface | grep TX | egrep -iow "overruns:[0-9]+" | awk -F: '{print $2}') > /dev/null 2>&1
        if [[ $current_tx_overruns -ne 0 ]]; then
            result_check_failed
            printf "TX Overruns - $current_interface has $current_tx_overruns TX Overruns.\n" >> $logfile
            printf "<span>$current_interface has $current_tx_overruns TX Overruns.</span><br>\n" >> $html_file
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Interface Stats,TX Overruns,OK,\n" >> $csv_log
    fi

    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,TX Overruns,WARNING,\n" >> $csv_log
        printf "\nReceive Overrun Information:\nThese imply the appliance is getting overrun with traffic to the network.\n" >> $logfile
        printf "<span>These imply the appliance is getting overrun with traffic to the network.</span><br><br>\n" >> $html_file
    fi


    #====================================================================================================
    #  Additional information gathering
    #====================================================================================================
    #Check Routing Table
    routing_table=$(netstat -rn)
    printf "\n\nRouting Table:\n$routing_table" >> $full_output_log 2>&1

    #Check Arp Table
    arp_table=$(arp -an)
    printf "\n\nArp Table:\n$arp_table" >> $full_output_log 2>&1

    #Check Link-Speed, Link-state, MAC Address, MTU
    printf "\n\nInterface Stats:\n" >> $full_output_log 2>&1
    for current_interface in $interface_list; do
        printf "Interface: $current_interface\n" >> $full_output_log 2>&1
        iface_stats=$(clish -c "show interface $current_interface" | sed "/^$/d")
        printf "$iface_stats\n\n" >> $full_output_log 2>&1
    done

    #Check for Interface Driver Version
    printf "\n\nInterface Driver Version:\n" >> $full_output_log 2>&1
    for current_interface in $interface_list; do
        interface_driver_info=$(ethtool -i $current_interface 2> /dev/null | grep -e driver -e version | grep -v firmware)
        printf "$current_interface:\n\n" >> $full_output_log 2>&1
        echo "$interface_driver_info" >> $full_output_log 2>&1
    done

    #Check for Ring Buffer Size
    printf "\n\nInterface Ring Buffer:\n" >> $full_output_log 2>&1
    for current_interface in $interface_list; do
        interface_ring_buffer=$(ethtool -g $current_interface 2> /dev/null)
        printf "\n$current_interface:\n" >> $full_output_log 2>&1
        echo "$interface_ring_buffer" >> $full_output_log 2>&1
    done

    #Check for Offload Information
    printf "\n\nOffload Information:" >> $full_output_log 2>&1
    for current_interface in $interface_list; do
        interface_offload_info=$(ethtool -k $current_interface 2> /dev/null)
        printf "\n$current_interface:\n" >> $full_output_log 2>&1
        echo "$interface_offload_info" >> $full_output_log 2>&1
    done

    #Check for Bond interface information
    bond_list=$(ifconfig -a | grep bond | awk '{print $1}' | grep -v ':')
    for bond_interface in $bond_list; do
        printf "\n\n$bond_interface Information:\n" >> $full_output_log 2>&1
        if [[ -e /proc/net/bonding/$bond_interface ]]; then
            cat /proc/net/bonding/$bond_interface >> $full_output_log 2>&1
        fi
        cphaconf show_bond $bond_interface >> $full_output_log 2>&1
    done

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset Interface variables
    unset interface_list
    unset current_errors
    unset current_OK
    unset current_drops
    unset drop_percent
    unset drop_percent_rounded
    unset current_rx_missed_errors
    unset current_rx_packets
    unset missed_percent
    unset missed_percent_rounded
    unset current_tx_carrier_errors
    unset current_tx_overruns
    unset current_rx_overruns
}


#====================================================================================================
#  Known Issues Function
#====================================================================================================
check_known_issues()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Known Issues\t\t"

    #====================================================================================================
    #  Issues found in logs
    #====================================================================================================
    #Combine /var/log/messages and /var/log/dmesg then start log.
    if [[ $offline_operations == true ]]; then
        messages_tmp_file="messages_check.tmp"
        grep -A5000 ^/var/log/messages $cpinfo_file | grep -B5000 /var/log/dmesg | grep -v /var/log | grep -v '\-\-\-' >> $messages_tmp_file 2> /dev/null
    else
        messages_tmp_file="/var/tmp/messages_check.tmp"
        cat /var/log/messages* /var/log/dmesg  $FWDIR/log/cloud_proxy.elg >> $messages_tmp_file 2> /dev/null
    fi

    printf "| Known Issues\t\t| Issues found in logs\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Known Issues</b></span><br>\n' >> $html_file
    printf '<span><b>Issues found in logs - </b></span><b>' >> $html_file

    #Check Neighbor table overflow
    if [[ $(grep -i "neighbour table overflow" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,Neighbor table overflow,WARNING,sk43772\n" >> $csv_log
        printf "\"neighbour table overflow\" message detected:\n" >> $logfile
        printf "For more information, refer to sk43772.\n" >> $logfile
        printf "<span>\"neighbour table overflow\" message detected:<br>For more information, refer to sk43772.</span><br><br>\n" >> $html_file
    fi

    #Check synchronization risk
    if [[ $(grep -i "State synchronization is in risk" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,State synchronization is in risk,WARNING,sk23695\n" >> $csv_log
        printf "\"State synchronization is in risk\" message detected:\n" >> $logfile
        printf "For more information, refer to sk23695.\n" >> $logfile
        printf "<span>\"State synchronization is in risk\" message detected:<br>For more information, refer to sk23695.</span><br><br>\n" >> $html_file
    fi

    #Check SecureXL Templates
    if [[ $(grep -i "Connection templates are not possible for the installed policy (network quota is active)" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,SecureXL templates are not possible for the installed policy,WARNING,sk31630\n" >> $csv_log
        printf "\"SecureXL templates are not possible for the installed policy\" message detected:\n" >> $logfile
        printf "For more information, refer to sk31630.\n" >> $logfile
        printf "<span>\"SecureXL templates are not possible for the installed policy\" message detected:<br>For more information, refer to sk31630.</span><br><br>\n" >> $html_file
    fi

    #Check Out of Memory
    if [[ $(grep -i "Out of Memory: Killed" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,Out of Memory: Killed process,WARNING,sk33219\n" >> $csv_log
        printf "\"Out of Memory: Killed process\" message detected:\n" >> $logfile
        printf "This message means there is no more memory available in the user space.\n" >> $logfile
        printf "As a result, Gaia or SecurePlatform starts to kill processes.\n" >> $logfile
        printf "For more information, refer to sk33219.\n" >> $logfile
        printf "<span>\"Out of Memory: Killed process\" message detected:<br>This message means there is no more memory available in the user space.<br>As a result, Gaia or SecurePlatform starts to kill processes.<br>For more information, refer to sk33219.</span><br><br>\n" >> $html_file
    fi

    #Check Additional Sync problem
    if [[ $(grep -i "fwlddist_adjust_buf: record too big for sync" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,Record too big for Sync,WARNING,sk35466\n" >> $csv_log
        printf "\"Record too big for Sync\" message detected:" >> $logfile
        printf "This message may indicate problems with the sync network.\n" >> $logfile
        printf "It can cause traffic loss, unsynchronized kernel tables, and connectivity problems." >> $logfile
        printf "For more information, refer to sk35466.\n" >> $logfile
        printf "<span>\"Record too big for Sync\" message detected:<br>This message may indicate problems with the sync network.<br>It can cause traffic loss, unsynchronized kernel tables, and connectivity problems.<br>For more information, refer to sk35466.</span><br><br>\n" >> $html_file
    fi

    #Check Dead loop on virtual device
    if [[ $(grep -i "Dead loop on virtual device" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,Dead Loop on virtual device,WARNING,sk32765\n" >> $csv_log
        printf "\"Dead Loop on virtual device\" message detected:\n" >> $logfile
        printf "This message is a SecureXL notification on the outbound connection that may cause the gateway to lose sync traffic.\n" >> $logfile
        printf "For more information, refer to sk32765.\n" >> $logfile
        printf "<span>\"Dead Loop on virtual device\" message detected:<br>This message is a SecureXL notification on the outbound connection that may cause the gateway to lose sync traffic.<br>For more information, refer to sk32765.</span><br><br>\n" >> $html_file
    fi

    #Check Stack Overflow
    if [[ $(grep -i "fw_runfilter_ex" $messages_tmp_file | grep -i "stack overflow") ]]; then
        result_check_failed
        printf "Known Issues,Stack Overflow,WARNING,sk99329\n" >> $csv_log
        printf "\"Stack Overflow\" message detected:\n" >> $logfile
        printf "It is possible that the number of security rules has exceeded a limit or some file became corrupted.\n" >> $logfile
        printf "For more information, refer to sk99329.\n" >> $logfile
        printf "<span>\"Stack Overflow\" message detected:<br>It is possible that the number of security rules has exceeded a limit or some file became corrupted.<br>For more information, refer to sk99329.</span><br><br>\n" >> $html_file
    fi

    #Check Log buffer full
    if [[ $(grep -i "FW-1: Log Buffer is full" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,FW-1: Log Buffer is full,WARNING,sk52100\n" >> $csv_log
        printf "\"FW-1: Log Buffer is full\" message detected:\n" >> $logfile
        printf "The kernel module maintains a cyclic buffer of waiting log messages.\n" >> $logfile
        printf "This log buffer queue was overflown (i.e., new logs are added before all the previous ones are being read - causing messages to be overwritten) resulting in the above messages.\n" >> $logfile
        printf "The most probable causes can be: high CPU utilization, high levels of logging, increased traffic, or change in logging.\n" >> $logfile
        printf "For more information, refer to sk52100.\n" >> $logfile
        printf "<span>\"FW-1: Log Buffer is full\" message detected:<br>The kernel module maintains a cyclic buffer of waiting log messages.<br>This log buffer queue was overflown (i.e., new logs are added before all the previous ones are being read - causing messages to be overwritten) resulting in the above messages.<br>The most probable causes can be: high CPU utilization, high levels of logging, increased traffic, or change in logging.<br>For more information, refer to sk52100.</span><br><br>\n" >> $html_file
    fi

    #Check Log buffer tsid 0 full
    if [[ $(grep -i "FW-1: Log buffer for tsid 0 is full" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,FW-1: Log buffer for tsid 0 is full,WARNING,sk114616\n" >> $csv_log
        printf "\"FW-1: Log buffer for tsid 0 is full\" message detected:\n" >> $logfile
        printf "Log buffer used by the FWD daemon gets full.\n" >> $logfile
        printf "As a result, FireWall log messages are not processed in time.\n" >> $logfile
        printf "For more information, refer to sk114616.\n" >> $logfile
        printf "<span>\"FW-1: Log buffer for tsid 0 is full\" message detected:<br>Log buffer used by the FWD daemon gets full.<br>As a result, FireWall log messages are not processed in time.<br>For more information, refer to sk114616.</span><br><br>\n" >> $html_file
    fi

    #Check Max entries in state on conn
    if [[ $(grep -i "number of entries in state on conn" $messages_tmp_file | grep -i "has reached maximum allowed") ]]; then
        result_check_failed
        printf "Known Issues,Number of entries in state on conn has reached maximum allowed,WARNING,sk52101\n" >> $csv_log
        printf "\"number of entries in state on conn has reached maximum allowed\" message detected:\n" >> $logfile
        printf "The \"sd_conn_state_max_entries\" kernel parameter is used by IPS.\n" >> $logfile
        printf "All connections/packets are held in this kernel table, so IPS protections can be run against them.\n" >> $logfile
        printf "If too many connections/packets are held, then the buffer will be overrun.\n" >> $logfile
        printf "For more information, refer to sk52101.\n" >> $logfile
        printf "<span>\"number of entries in state on conn has reached maximum allowed\" message detected:<br>The \"sd_conn_state_max_entries\" kernel parameter is used by IPS.<br>All connections/packets are held in this kernel table, so IPS protections can be run against them.<br>If too many connections/packets are held, then the buffer will be overrun.<br>For more information, refer to sk52101.</span><br><br>\n" >> $html_file
    fi

    #Check Connections table 80% full
    if [[ $(grep -i 'The connections table is 80% full' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,The connections table is 80% full,WARNING,sk35627\n" >> $csv_log
        printf "\"The connections table is 80% full\" message detected:\n" >> $logfile
        printf "Traffic might be dropped by Security Gateway.\n" >> $logfile
        printf "For more information, refer to sk35627.\n" >> $logfile
        printf "<span>\"The connections table is 80% full\" message detected:<br>Traffic might be dropped by Security Gateway.<br>For more information, refer to sk35627.</span><br><br>\n" >> $html_file
    fi

    #Check Different versions
    if [[ $(grep -i 'fwsync: there is a different installation of Check Point' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,there is a different installation of Check Point products on each member of this cluster,WARNING,sk41023\n" >> $csv_log
        printf "\"fwsync: there is a different installation of Check Point products on each member of this cluster\" message detected:\n" >> $logfile
        printf "This issue can be seen if some Check Point packages were manually deleted or disabled on one of cluster members, bit not on others.\n" >> $logfile
        printf "For more information, refer to sk41023.\n" >> $logfile
        printf "<span>\"fwsync: there is a different installation of Check Point products on each member of this cluster\" message detected:<br>This issue can be seen if some Check Point packages were manually deleted or disabled on one of cluster members, bit not on others.<br>For more information, refer to sk41023.</span><br><br>\n" >> $html_file
    fi

    #Check too many internal hosts
    if [[ $(grep -i 'too many internal hosts' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,too many internal hosts,WARNING,sk10200\n" >> $csv_log
        printf "\"too many internal hosts\" message detected:\n" >> $logfile
        printf "Traffic may pass through Security Gateway very slowly.\n" >> $logfile
        printf "For more information, refer to sk10200.\n" >> $logfile
        printf "<span>\"too many internal hosts\" message detected:<br>Traffic may pass through Security Gateway very slowly.<br>For more information, refer to sk10200.</span><br><br>\n" >> $html_file
    fi

    #Check Interface configured in Management
    if [[ $(grep -i 'kernel: FW-1: No interface configured in SmartCenter server with name' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,No interface configured in SmartCenter server,WARNING,sk36849\n" >> $csv_log
        printf "\"kernel: FW-1: No interface configured in SmartCenter server with name\" message detected:\n" >> $logfile
        printf "In the SmartDashboard there were no interface(s) with such name(s) - as appear on the Security Gateway machine.\n" >> $logfile
        printf "Therefore, by design, the Firewall tries to match the interface in question by IP address.\n" >> $logfile
        printf "For more information, refer to sk36849.\n" >> $logfile
        printf "<span>\"kernel: FW-1: No interface configured in SmartCenter server with name\" message detected:<br>In the SmartDashboard there were no interface(s) with such name(s) - as appear on the Security Gateway machine.<br>Therefore, by design, the Firewall tries to match the interface in question by IP address.<br>For more information, refer to sk36849.</span><br><br>\n" >> $html_file
    fi

    #Check alternate Sync in risk
    if [[ $(grep -i 'sync in risk: did not receive ack for the last' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,sync in risk: did not receive ack,WARNING,sk82080\n" >> $csv_log
        printf "\"sync in risk: did not receive ack for the last x packets\" message detected:\n" >> $logfile
        printf "Amount of outgoing Delta Sync packets is too high for the current Sending Queue size.\n" >> $logfile
        printf "For more information, refer to sk82080.\n" >> $logfile
        printf "<span>\"sync in risk: did not receive ack for the last x packets\" message detected:<br>Amount of outgoing Delta Sync packets is too high for the current Sending Queue size.<br>For more information, refer to sk82080.</span><br><br>\n" >> $html_file
    fi

    #Check OSPF messages
    if [[ $(grep -i 'cpcl_should_send' $messages_tmp_file | grep -i 'returns -3') ]]; then
        result_check_failed
        printf "Known Issues,cpcl_should_send returns -3,WARNING,sk106129\n" >> $csv_log
        printf "\"cpcl_should_send returns -3\" message detected:\n" >> $logfile
        printf "OSPF routes may not be synced between the Active member and the other cluster members.\n" >> $logfile
        printf "For more information, refer to sk106129.\n" >> $logfile
        printf "<span>\"cpcl_should_send returns -3\" message detected:<br>OSPF routes may not be synced between the Active member and the other cluster members.<br>For more information, refer to sk106129.</span><br><br>\n" >> $html_file
    fi

    #Check cphwd_pslglue_can_offload_template
    if [[ $(grep -i 'cphwd_pslglue_can_offload_template: error, psl_opaque is NULL' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,cphwd_pslglue_can_offload_template: error,WARNING,sk107258\n" >> $csv_log
        printf "\"cphwd_pslglue_can_offload_template: error, psl_opaque is NULL\" message detected:\n" >> $logfile
        printf "This issue can be resolved by either disabling SecureXL or installing the latest jumbo.\n" >> $logfile
        printf "For more information, refer to sk107258.\n" >> $logfile
        printf "<span>\"cphwd_pslglue_can_offload_template: error, psl_opaque is NULL\" message detected:<br>This issue can be resolved by either disabling SecureXL or installing the latest jumbo.<br>For more information, refer to sk107258.</span><br><br>\n" >> $html_file
    fi

    #Check RIP message
    if [[ $(grep -i 'cpcl_should_send' $messages_tmp_file | grep -i 'returns -1') ]]; then
        result_check_failed
        printf "Known Issues,cpcl_should_send returns -1,WARNING,sk106128\n" >> $csv_log
        printf "\"cpcl_should_send returns -1\" message detected:\n" >> $logfile
        printf "When RIP is configured, RouteD does not check correctly if RIP sync state should be sent to other cluster members.\n" >> $logfile
        printf "For more information, refer to sk106128.\n" >> $logfile
        printf "<span>\"cpcl_should_send returns -1\" message detected:<br>When RIP is configured, RouteD does not check correctly if RIP sync state should be sent to other cluster members.<br>For more information, refer to sk106128.</span><br><br>\n" >> $html_file
    fi

    #Check Enter/Leave cpcl_vfr_recv_from_instance_manager
    if [[ $(grep -i -e 'entering cpcl_vrf_recv_from_instance_manager' -e'leaving cpcl_vrf_recv_from_instance_manager' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,entering/leaving cpcl_vrf_recv_from_instance_manager,WARNING,sk108233\n" >> $csv_log
        printf "\"entering/leaving cpcl_vrf_recv_from_instance_manager\" message detected:\n" >> $logfile
        printf "Cluster state may be changing repeatedly.\n" >> $logfile
        printf "For more information, refer to sk108233.\n" >> $logfile
        printf "<span>\"entering/leaving cpcl_vrf_recv_from_instance_manager\" message detected:<br>Cluster state may be changing repeatedly.<br>For more information, refer to sk108233.</span><br><br>\n" >> $html_file
    fi

    #Check duplicate address detected
    if [[ $(grep -i 'if_get_address: duplicate address detected:' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,if_get_address: duplicate address detected,WARNING,sk94466\n" >> $csv_log
        printf "\"if_get_address: duplicate address detected\" message detected:\n" >> $logfile
        printf "Assigning a cluster IP address in the range of the VSX internal communication network causes an IP address conflict and causes RouteD daemon to crash.\n" >> $logfile
        printf "For more information, refer to sk94466.\n" >> $logfile
        printf "<span>\"if_get_address: duplicate address detected\" message detected:<br>Assigning a cluster IP address in the range of the VSX internal communication network causes an IP address conflict and causes RouteD daemon to crash.<br>For more information, refer to sk94466.</span><br><br>\n" >> $html_file
    fi

    #Check vmalloc
    if [[ $(grep -i 'Failed to allocate' $messages_tmp_file | grep -i 'bytes from vmalloc') ]]; then
        result_check_failed
        printf "Known Issues,Failed to allocate bytes from vmalloc,WARNING,sk90043\n" >> $csv_log
        printf "\"Failed to allocate bytes from vmalloc\" message detected:\n" >> $logfile
        printf "Linux \"vmalloc\" reserved memory area is exhausted.\n" >> $logfile
        printf "Critical allocations, which are needed for a Virtual System, can not be allocated.\n" >> $logfile
        printf "For more information, refer to sk90043.\n" >> $logfile
        printf "<span>\"Failed to allocate bytes from vmalloc\" message detected:<br>Linux \"vmalloc\" reserved memory area is exhausted.<br>Critical allocations, which are needed for a Virtual System, can not be allocated.<br>For more information, refer to sk90043.</span><br><br>\n" >> $html_file
    fi

    #Check Soft Lockup
    if [[ $(grep -i 'kernel: BUG: soft lockup - CPU' $messages_tmp_file | grep -i 'stuck for 10s') ]]; then
        result_check_failed
        printf "Known Issues,kernel: BUG: soft lockup - CPU x stuck for 10s,WARNING,sk116870 and sk105729\n" >> $csv_log
        printf "\"kernel: BUG: soft lockup - CPU x stuck for 10s\" message detected:\n" >> $logfile
        printf "A soft lockup isn't necessarily anything 'crashing', it is the symptom of a task or kernel thread using and not releasing a CPU for a longer period of time than allowed; in Check Point the default fault is 10 seconds.\n" >> $logfile
        printf "For more information, refer to sk116870 and sk105729.\n" >> $logfile
        printf "<span>\"kernel: BUG: soft lockup - CPU x stuck for 10s\" message detected:<br>A soft lockup isn't necessarily anything 'crashing', it is the symptom of a task or kernel thread using and not releasing a CPU for a longer period of time than allowed; in Check Point the default fault is 10 seconds.<br>For more information, refer to sk116870 and sk105729.</span><br><br>\n" >> $html_file
    fi

    #Check LOM not responding
    if [[ $(grep -i 'The LOM is not accepting our command' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,LOM is not accepting our command,WARNING,sk92788 or sk94639\n" >> $csv_log
        printf "\"Max retry count exceeded. The LOM is not accepting our command\" message detected:\n" >> $logfile
        printf "A delay in synchronization of hardware sensor information between Gaia OS and LOM card has occurred.\n" >> $logfile
        printf "For more information, refer to sk92788 and sk94639.\n" >> $logfile
        printf "<span>\"Max retry count exceeded. The LOM is not accepting our command\" message detected:<br>A delay in synchronization of hardware sensor information between Gaia OS and LOM card has occurred.<br>For more information, refer to sk92788 and sk94639.</span><br><br>\n" >> $html_file
    fi

    #Check IPv6
    if [[ $(grep -i 'modprobe: FATAL: Could not open' $messages_tmp_file | grep -i '/lib/modules/2.6.18-92cpx86_64/kernel/net/ipv6/ipv6.ko') ]]; then
        result_check_failed
        printf "Known Issues,Could not open ipv6.ko,WARNING,sk95222\n" >> $csv_log
        printf "\"modprobe: FATAL: Could not open /lib/modules/2.6.18-92cpx86_64/kernel/net/ipv6/ipv6.ko\" message detected:\n" >> $logfile
        printf "If IPv6 is disabled, this message can be safely ignored.\n" >> $logfile
        printf "For more information, refer to sk95222.\n" >> $logfile
        printf "<span>\"modprobe: FATAL: Could not open /lib/modules/2.6.18-92cpx86_64/kernel/net/ipv6/ipv6.ko\" message detected:<br>If IPv6 is disabled, this message can be safely ignored.<br>For more information, refer to sk95222.</span><br><br>\n" >> $html_file
    fi

    #Check syslogd sendto errors
    if [[ $(grep -i 'syslogd: sendto' $messages_tmp_file | grep -i -e 'Invalid argument' -e 'Bad File Descriptor' -e 'Connection refused') ]]; then
        result_check_failed
        printf "Known Issues,syslogd sendto errors,WARNING,sk83160\n" >> $csv_log
        printf "\"syslogd: sendto:\" failure message detected:\n" >> $logfile
        printf "Syslog messages are not forwarded from Security Gateway to Security Management Server, although \"Send Syslog messages to management server\" option is activated in Gaia Portal on Security Gateway.\n" >> $logfile
        printf "For more information, refer to sk83160.\n" >> $logfile
        printf "<span>\"syslogd: sendto:\" failure message detected:<br>Syslog messages are not forwarded from Security Gateway to Security Management Server, although \"Send Syslog messages to management server\" option is activated in Gaia Portal on Security Gateway.<br>For more information, refer to sk83160.</span><br><br>\n" >> $html_file
    fi

    #Check Incorrect validation of SNMP traps
    if [[ $(grep -i 'xpand' $messages_tmp_file | grep -i 'The value of sensor could not be read') ]]; then
        result_check_failed
        printf "Known Issues,Incorrect validation of SNMP traps,WARNING,sk101898\n" >> $csv_log
        printf "\"xpand[PID]: The value of sensor could not be read\" message detected:\n" >> $logfile
        printf "SNMP Traps may be sent due to incorrect validation of the values returned by sensors.\n" >> $logfile
        printf "For more information, refer to sk101898.\n" >> $logfile
        printf "<span>\"xpand[PID]: The value of sensor could not be read\" message detected:<br>SNMP Traps may be sent due to incorrect validation of the values returned by sensors.<br>For more information, refer to sk101898.</span><br><br>\n" >> $html_file
    fi

    #Check Open Server blank hardware sensors
    if [[ $(grep -i 'SQL error: columns time_stamp, sensor_name are not unique rc=19' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,Blank hardware sensors on open server,WARNING,sk97109\n" >> $csv_log
        printf "\"SQL error: columns time_stamp, sensor_name are not unique rc=19\" message detected:\n" >> $logfile
        printf "On Open Server, hardware sensor names are all empty causing duplicate entries appear in the SQL database of sensor data.\n" >> $logfile
        printf "For more information, refer to sk97109.\n" >> $logfile
        printf "<span>\"SQL error: columns time_stamp, sensor_name are not unique rc=19\" message detected:<br>On Open Server, hardware sensor names are all empty causing duplicate entries appear in the SQL database of sensor data.<br>For more information, refer to sk97109.</span><br><br>\n" >> $html_file
    fi

    #Check Kernel Parameters
    if [[ $(grep -i 'Global param: operation failed: Unknown parameter' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,Global param: operation failed: Unknown parameter,WARNING,sk87006 and sk146372\n" >> $csv_log
        printf "\"Global param: operation failed: Unknown parameter\" message detected:\n" >> $logfile
        printf "Either a defined kernel parameter/value combination is not valid or this message is a CPDiag false positive.\n" >> $logfile
        printf "For more information, refer to sk87006 and sk146372.\n" >> $logfile
        printf "<span>\"Global param: operation failed: Unknown parameter\" message detected:<br>Either a defined kernel parameter/value combination is not valid or this message is a CPDiag false positive.<br>For more information, refer to sk87006 and sk146372.</span><br><br>\n" >> $html_file
    fi

    #Check DHCP config
    if [[ $(grep -i 'DHCPINFORM' $messages_tmp_file | grep -i 'not authoritative for subnet') ]]; then
        result_check_failed
        printf "Known Issues,DHCP not authoritative for subnet,WARNING,sk92436\n" >> $csv_log
        printf "\"DHCP not authoritative for subnet\" message detected:\n" >> $logfile
        printf "This is not specific to Check Point Software. This is a global DHCP message.\n" >> $logfile
        printf "For more information, refer to sk92436.\n" >> $logfile
        printf "<span>\"DHCP not authoritative for subnet\" message detected:<br>This is not specific to Check Point Software. This is a global DHCP message.<br>For more information, refer to sk92436.</span><br><br>\n" >> $html_file
    fi

    #Check /var/log/db
    if [[ $(grep -i 'SQL error: database disk image is malformed' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,SQL error: database disk image is malformed,WARNING,sk98338\n" >> $csv_log
        printf "\"SQL error: database disk image is malformed\" message detected:\n" >> $logfile
        printf "Possible reason: /var/log/db database might be corrupted.\n" >> $logfile
        printf "For more information, refer to sk98338.\n" >> $logfile
        printf "<span>\"SQL error: database disk image is malformed\" message detected:<br>Possible reason: /var/log/db database might be corrupted.<br>For more information, refer to sk98338.</span><br><br>\n" >> $html_file
    fi

    #Check TSO offload
    if [[ $(grep -i 'e1000_set_tso: TSO is enabled' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,e1000_set_tso: TSO is enabled,WARNING,sk52761\n" >> $csv_log
        printf "\"e1000_set_tso: TSO is enabled\" message detected:\n" >> $logfile
        printf "TCP Segmentation Offload (TSO) is not supported by the FireWall.\n" >> $logfile
        printf "For more information, refer to sk52761.\n" >> $logfile
        printf "<span>\"e1000_set_tso: TSO is enabled\" message detected:<br>TCP Segmentation Offload (TSO) is not supported by the FireWall.<br>For more information, refer to sk52761.</span><br><br>\n" >> $html_file
    fi

    #Check CUL
    if [[ $(grep -i 'cul_load_freeze' $messages_tmp_file | grep -i 'high kernel CPU usage') ]]; then
        result_check_failed
        printf "Known Issues,Cluster Under Load,WARNING,sk92723\n" >> $csv_log
        printf "\"Cluster Under Load\" message detected:\n" >> $logfile
        printf "<span>\"Cluster Under Load\" message detected:</span><br>\n" >> $html_file
        if [[ $(grep -w 'cul_load_freeze' $messages_tmp_file | grep -i 'high kernel CPU usage') ]]; then
            printf "The local cluster member is experiencing high CPU spikes which are triggering the CUL mechanism.\nWhen under heavy load, cluster flapping may occur.\n" >> $logfile
            printf "<span>The local cluster member is experiencing high CPU spikes which are triggering the CUL mechanism.<br>When under heavy load, cluster flapping may occur.</span><br>\n" >> $html_file
        elif [[ $(grep -w 'cul_load_freeze_on_remote' $messages_tmp_file | grep -i 'high kernel CPU usage') ]]; then
            printf "A peer cluster member is experiencing high CPU spikes which are triggering the CUL mechanism.\nWhen under heavy load, cluster flapping may occur.\n" >> $logfile
            printf "<span>A peer cluster member is experiencing high CPU spikes which are triggering the CUL mechanism.<br>When under heavy load, cluster flapping may occur.</span><br>\n" >> $html_file
        else
            printf "A gateway in this cluster is experiencing high CPU spikes which are triggering the CUL mechanism.\nWhen under heavy load, cluster flapping may occur.\n" >> $logfile
            printf "<span>A gateway in this cluster is experiencing high CPU spikes which are triggering the CUL mechanism.<br>When under heavy load, cluster flapping may occur.</span><br>\n" >> $html_file
        fi
        printf "For more information, refer to sk92723.\n" >> $logfile
        printf "<span>For more information, refer to sk92723.</span><br><br>\n" >> $html_file
    fi

    #Check Too Many Hosts
    if [[ $(grep -i 'too many hosts' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,too many hosts,WARNING,sk153253\n" >> $csv_log
        printf "\"too many hosts\" message detected:\n" >> $logfile
        printf "Cluster synchronization issue may occur. A state synchronization packets will not be handled, which may result in a \"split brain\" situation.\n" >> $logfile
        printf "For more information, refer to sk153253.\n" >> $logfile
        printf "<span>\"too many hosts\" message detected:<br>Cluster synchronization issue may occur. A state synchronization packets will not be handled, which may result in a \"split brain\" situation.<br>For more information, refer to sk153253.</span><br><br>\n" >> $html_file
    fi

    #Check Double record of connection
    if [[ $(grep -i 'double record of connection' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,double record of connection,WARNING,sk110476 and sk143432\n" >> $csv_log
        printf "\"double record of connection\" message detected:\n" >> $logfile
        printf "If a connection already exists in the Connections Table, then recording on the new connection will fail.\n" >> $logfile
        printf "For more information, refer to sk110476 and sk143432.\n" >> $logfile
        printf "<span>\"double record of connection\" message detected:<br>If a connection already exists in the Connections Table, then recording on the new connection will fail.<br>For more information, refer to sk110476 and sk143432.</span><br><br>\n" >> $html_file
    fi

    #Check PIM instance 0 failed to resolve source
    if [[ $(grep -i 'PIM instance 0 failed to resolve source' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,PIM instance 0 failed to resolve source,WARNING,sk100867\n" >> $csv_log
        printf "\"PIM instance 0 failed to resolve source\" message detected:\n" >> $logfile
        printf "No RP configured for a multicast group.\n" >> $logfile
        printf "For more information, refer to sk100867.\n" >> $logfile
        printf "<span>\"PIM instance 0 failed to resolve source\" message detected:<br>No RP configured for a multicast group.<br>For more information, refer to sk100867.</span><br><br>\n" >> $html_file
    fi

    #Check CLIXact Begin Error: Cannot start a CLI transaction
    if [[ $(grep -i 'CLIXact Begin Error: Cannot start a CLI transaction' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,CLIXact Begin Error: Cannot start a CLI transaction,WARNING,sk116193\n" >> $csv_log
        printf "\"CLIXact Begin Error: Cannot start a CLI transaction\" message detected:\n" >> $logfile
        printf "The Gaia Clish processes are not running properly.\n" >> $logfile
        printf "For more information, refer to sk116193.\n" >> $logfile
        printf "<span>\"CLIXact Begin Error: Cannot start a CLI transaction\" message detected:<br>The Gaia Clish processes are not running properly.<br>For more information, refer to sk116193.</span><br><br>\n" >> $html_file
    fi

    #Check simi_reorder_enqueue_packet: reached the limit of maximum enqueued packets
    if [[ $(grep -i 'simi_reorder_enqueue_packet: reached the limit of maximum enqueued packets' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,simi_reorder_enqueue_packet: reached the limit of maximum enqueued packets,WARNING,sk148432\n" >> $csv_log
        printf "\"simi_reorder_enqueue_packet: reached the limit of maximum enqueued packets\" message detected:\n" >> $logfile
        printf "The queue is full, all the packets will be released and dropped. The main impact is for UDP packets, as TCP will never get the queue to be full.\n" >> $logfile
        printf "For more information, refer to sk148432.\n" >> $logfile
        printf "<span>\"simi_reorder_enqueue_packet: reached the limit of maximum enqueued packets\" message detected:<br>The queue is full, all the packets will be released and dropped. The main impact is for UDP packets, as TCP will never get the queue to be full.<br>For more information, refer to sk148432.</span><br><br>\n" >> $html_file
    fi

    #Check fwsam_v1_filter: matched rule is not found
    if [[ $(grep -i 'fwsam_v1_filter: matched rule is not found' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,fwsam_v1_filter: matched rule is not found,WARNING,sk105347\n" >> $csv_log
        printf "\"fwsam_v1_filter: matched rule is not found\" message detected:\n" >> $logfile
        printf "Problem with the way traffic is counted after matching a SAM rule.\n" >> $logfile
        printf "For more information, refer to sk105347.\n" >> $logfile
        printf "<span>\"fwsam_v1_filter: matched rule is not found\" message detected:<br>Problem with the way traffic is counted after matching a SAM rule.<br>For more information, refer to sk105347.</span><br><br>\n" >> $html_file
    fi

    #Check dropped by fw_runfilter_ex Reason: function does not exist
    if [[ $(grep -i 'fw_runfilter_ex' $messages_tmp_file | grep "function does not exist") ]]; then
        result_check_failed
        printf "Known Issues,fw_runfilter_ex Reason: function does not exist,WARNING,sk123040\n" >> $csv_log
        printf "\"fw_runfilter_ex Reason: function does not exist\" message detected:\n" >> $logfile
        printf "Issue occurs when installing policy on more than one gateway, where not all the gateways have the same Inspection Settings configured.\n" >> $logfile
        printf "For more information, refer to sk123040.\n" >> $logfile
        printf "<span>\"fw_runfilter_ex Reason: function does not exist\" message detected:<br>Issue occurs when installing policy on more than one gateway, where not all the gateways have the same Inspection Settings configured.<br>For more information, refer to sk123040.</span><br><br>\n" >> $html_file
    fi

    #Check CLIXact Begin Error: Cannot start a CLI transaction
    if [[ $(grep -i 'cmik_loader_fw_global_states_key_create: cmik_loader_fw_get_connkey' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,cmik_loader_fw_global_states_key_create: cmik_loader_fw_get_connkey,WARNING,sk137494\n" >> $csv_log
        printf "\"cmik_loader_fw_global_states_key_create: cmik_loader_fw_get_connkey\" message detected.\n" >> $logfile
        printf "For more information, refer to sk137494.\n" >> $logfile
        printf "<span>\"cmik_loader_fw_global_states_key_create: cmik_loader_fw_get_connkey\" message detected.<br>For more information, refer to sk137494.</span><br><br>\n" >> $html_file
    fi

    #Check unregister_netdevice: waiting for device to become free
    if [[ $(grep -i 'unregister_netdevice: waiting for' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,unregister_netdevice: waiting for device to become free,WARNING,sk106226\n" >> $csv_log
        printf "\"unregister_netdevice: waiting for device to become free\" message detected:\n" >> $logfile
        printf "When the VRRP module fails to add a PARP entry to the Passive ARP Table table (add_parp_tbl), the device reference count is not released.\n" >> $logfile
        printf "For more information, refer to sk106226.\n" >> $logfile
        printf "<span>\"unregister_netdevice: waiting for device to become free\" message detected:<br>When the VRRP module fails to add a PARP entry to the Passive ARP Table table (add_parp_tbl), the device reference count is not released.<br>For more information, refer to sk106226.</span><br><br>\n" >> $html_file
    fi

    #Check failed to execute first packet context network_classifier_get_dynobjs_for_ip
    if [[ $(grep -i 'failed to execute first packet context network_classifier_get_dynobjs_for_ip' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,failed to execute first packet context network_classifier_get_dynobjs_for_ip,WARNING,sk152392\n" >> $csv_log
        printf "\"failed to execute first packet context network_classifier_get_dynobjs_for_ip\" message detected:\n" >> $logfile
        printf "A technical limitation causes these errors appear when Dynamic Objects are used in the policy.\n" >> $logfile
        printf "For more information, refer to sk152392.\n" >> $logfile
        printf "<span>\"failed to execute first packet context network_classifier_get_dynobjs_for_ip\" message detected:<br>A technical limitation causes these errors appear when Dynamic Objects are used in the policy.<br>For more information, refer to sk152392.</span><br><br>\n" >> $html_file
    fi

    #Check httpd2: Received URL with out session information
    if [[ $(grep -i 'httpd2: Received URL with out session information' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,httpd2: Received URL with out session information,WARNING,sk121373\n" >> $csv_log
        printf "\"httpd2: Received URL with out session information\" message detected:\n" >> $logfile
        printf "Changes to Firefox and Chrome have impacted functionality of the Gaia Portal.\n" >> $logfile
        printf "For more information, refer to sk121373.\n" >> $logfile
        printf "<span>\"httpd2: Received URL with out session information\" message detected:<br>Changes to Firefox and Chrome have impacted functionality of the Gaia Portal.<br>For more information, refer to sk121373.</span><br><br>\n" >> $html_file
    fi

    #Check Assertion failed routed[PID]: file bgp/bgp_rt.c
    if [[ $(grep -i 'Assertion failed routed' $messages_tmp_file | grep "bgp/bgp_rt.c") ]]; then
        result_check_failed
        printf "Known Issues,Assertion failed routed[PID]: file bgp/bgp_rt.c,WARNING,sk105698\n" >> $csv_log
        printf "\"Assertion failed routed[PID]: file bgp/bgp_rt.c\" message detected:\n" >> $logfile
        printf "RouteD daemon crashed.\n" >> $logfile
        printf "For more information, refer to sk105698.\n" >> $logfile
        printf "<span>\"Assertion failed routed[PID]: file bgp/bgp_rt.c\" message detected:<br>RouteD daemon crashed.<br>For more information, refer to sk105698.</span><br><br>\n" >> $html_file
    fi

    #Check Cluster policy installation failed (failure event - timeout) - resume the old policy
    if [[ $(grep -i 'Cluster policy installation failed' $messages_tmp_file | grep "resume the old policy") ]]; then
        result_check_failed
        printf "Known Issues,Cluster policy installation failed (failure event - timeout) - resume the old policy,WARNING,sk148712\n" >> $csv_log
        printf "\"Cluster policy installation failed (failure event - timeout) - resume the old policy\" message detected:\n" >> $logfile
        printf "High availability ClusterXL do not fail-over when the node priority is changing.\n" >> $logfile
        printf "For more information, refer to sk148712.\n" >> $logfile
        printf "<span>\"Cluster policy installation failed (failure event - timeout) - resume the old policy\" message detected:<br>High availability ClusterXL do not fail-over when the node priority is changing.<br>For more information, refer to sk148712.</span><br><br>\n" >> $html_file
    fi

    #Check Unrecovered read error - auto reallocate failed
    if [[ $(grep -i 'Unrecovered read error - auto reallocate failed' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,Unrecovered read error - auto reallocate failed,WARNING,sk151292\n" >> $csv_log
        printf "\"Unrecovered read error - auto reallocate failed\" message detected:\n" >> $logfile
        printf "Possible Hard Drive issue.\n" >> $logfile
        printf "For more information, refer to sk151292.\n" >> $logfile
        printf "<span>\"Unrecovered read error - auto reallocate failed\" message detected:<br>Possible Hard Drive issue.<br>For more information, refer to sk151292.</span><br><br>\n" >> $html_file
    fi

    #Check ClusterXL failover when using igb driver
    if [[ $(grep -i 'NETDEV WATCHDOG' $messages_tmp_file | grep "transmit timed out") && $(grep -i 'igb_setup_mrqc: Setting Symmetric RS' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,ClusterXL failover when using igb driver,WARNING,sk144232\n" >> $csv_log
        printf "\"igb_setup_mrqc: Setting Symmetric RS\" message detected:\n" >> $logfile
        printf "Multi-Queue plus TX Q restarts are causing the fail-overs.\n" >> $logfile
        printf "For more information, refer to sk144232.\n" >> $logfile
        printf "<span>\"igb_setup_mrqc: Setting Symmetric RS\" message detected:<br>Multi-Queue plus TX Q restarts are causing the fail-overs.<br>For more information, refer to sk144232.</span><br><br>\n" >> $html_file
    fi

    #Check fwlddist_adjust_buf: record too big for sync
    if [[ $(grep -i 'fwlddist_adjust_buf: record too big for sync' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,fwlddist_adjust_buf: record too big for sync,WARNING,sk147534\n" >> $csv_log
        printf "\"fwlddist_adjust_buf: record too big for sync\" message detected:\n" >> $logfile
        printf "If machine authentication fails, the entry in pdp_super_session grows larger and larger until it causes pdpd process to crash.\n" >> $logfile
        printf "For more information, refer to sk147534.\n" >> $logfile
        printf "<span>\"fwlddist_adjust_buf: record too big for sync\" message detected:<br>If machine authentication fails, the entry in pdp_super_session grows larger and larger until it causes pdpd process to crash.<br>For more information, refer to sk147534.</span><br><br>\n" >> $html_file
    fi

    #Check fw_log_drop_ex: Packet dropped by fw_runfilter_ex Reason: kfunc not supported
    if [[ $(grep -i 'fw_log_drop_ex: Packet' $messages_tmp_file | grep "dropped by fw_runfilter_ex Reason: kfunc not supported") ]]; then
        result_check_failed
        printf "Known Issues,fw_log_drop_ex: Packet dropped by fw_runfilter_ex Reason: kfunc not supported,WARNING,sk123633\n" >> $csv_log
        printf "\"fw_log_drop_ex: Packet dropped by fw_runfilter_ex Reason: kfunc not supported\" message detected.\n" >> $logfile
        printf "For more information, refer to sk123633.\n" >> $logfile
        printf "<span>\"fw_log_drop_ex: Packet dropped by fw_runfilter_ex Reason: kfunc not supported\" message detected.<br>For more information, refer to sk123633.</span><br><br>\n" >> $html_file
    fi

    #Check api_get_member_info: failed to get memberinfo
    if [[ $(grep -i 'api_get_member_info: failed to get memberinfo' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,api_get_member_info: failed to get memberinfo. selector =,WARNING,sk97639\n" >> $csv_log
        printf "\"api_get_member_info: failed to get memberinfo. selector =\" message detected.\n" >> $logfile
        printf "For more information, refer to sk97639.\n" >> $logfile
        printf "<span>\"api_get_member_info: failed to get memberinfo. selector =\" message detected.<br>For more information, refer to sk97639.</span><br><br>\n" >> $html_file
    fi

    #Check Restarted /bin/frontstage
    if [[ $(grep -i 'Restarted /bin/frontstage' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,Restarted /bin/frontstage,WARNING,sk88283\n" >> $csv_log
        printf "\"Restarted /bin/frontstage\" message detected.\n" >> $logfile
        printf "For more information, refer to sk88283.\n" >> $logfile
        printf "<span>\"Restarted /bin/frontstage\" message detected.<br>For more information, refer to sk88283.</span><br><br>\n" >> $html_file
    fi

    #Check Raid Hardware recognition failed, Hardware is missing/not supported
    if [[ $device_manufacturer == "CheckPoint" ]]; then
        if [[ $(grep -i 'Raid Hardware recognition failed, Hardware is missing/not supported' $messages_tmp_file) ]] || [[ $(grep -i 'RAID monitoring: Failed to init raid' $messages_tmp_file) ]]; then
            result_check_failed
            printf "Known Issues,Raid Hardware recognition failed, Hardware is missing/not supported,WARNING,sk91903\n" >> $csv_log
            printf "\"Raid Hardware recognition failed, Hardware is missing/not supported\" message detected.\n" >> $logfile
            printf "For more information, refer to sk91903.\n" >> $logfile
            printf "<span>\"Raid Hardware recognition failed, Hardware is missing/not supported\" message detected.<br>For more information, refer to sk91903.</span><br><br>\n" >> $html_file
        fi
    fi

    #Check User not logged in. He has no configured role.
    if [[ $(grep -i 'User not logged in. He has no configured role.' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,User not logged in. He has no configured role.,WARNING,sk98874\n" >> $csv_log
        printf "\"User not logged in. He has no configured role.\" message detected.\n" >> $logfile
        printf "For more information, refer to sk98874.\n" >> $logfile
        printf "<span>\"User not logged in. He has no configured role.\" message detected.<br>For more information, refer to sk98874.</span><br><br>\n" >> $html_file
    fi

    #Check FW-1: internal error - invalid port allocation range
    if [[ $(grep -i 'FW-1: internal error - invalid port allocation range' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,FW-1: internal error - invalid port allocation range,WARNING,sk98828\n" >> $csv_log
        printf "\"FW-1: internal error - invalid port allocation range\" message detected.\n" >> $logfile
        printf "For more information, refer to sk98828.\n" >> $logfile
        printf "<span>\"FW-1: internal error - invalid port allocation range\" message detected.<br>For more information, refer to sk98828.</span><br><br>\n" >> $html_file
    fi

    #Check vrrp_recv: discarded unknown VRID
    if [[ $(grep -i 'vrrp_recv: discarded unknown VRID' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,vrrp_recv: discarded unknown VRID,WARNING,sk92605\n" >> $csv_log
        printf "\"vrrp_recv: discarded unknown VRID\" message detected.\n" >> $logfile
        printf "For more information, refer to sk92605.\n" >> $logfile
        printf "<span>\"vrrp_recv: discarded unknown VRID\" message detected.<br>For more information, refer to sk92605.</span><br><br>\n" >> $html_file
    fi

    #Check fwrulematch_rule_id_to_kuuid: fwloghandle_rule_id failed
    if [[ $(grep -i 'fwrulematch_rule_id_to_kuuid: fwloghandle_rule_id failed' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,fwrulematch_rule_id_to_kuuid: fwloghandle_rule_id failed,WARNING,sk78580\n" >> $csv_log
        printf "\"fwrulematch_rule_id_to_kuuid: fwloghandle_rule_id failed\" message detected.\n" >> $logfile
        printf "For more information, refer to sk78580.\n" >> $logfile
        printf "<span>\"fwrulematch_rule_id_to_kuuid: fwloghandle_rule_id failed\" message detected.<br>For more information, refer to sk78580.</span><br><br>\n" >> $html_file
    fi

    #Check if_get_address: duplicate address detected:
    if [[ $(grep -i 'if_get_address: duplicate address detected:' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,if_get_address: duplicate address detected:,WARNING,sk92948\n" >> $csv_log
        printf "\"if_get_address: duplicate address detected:\" message detected.\n" >> $logfile
        printf "For more information, refer to sk92948.\n" >> $logfile
        printf "<span>\"if_get_address: duplicate address detected:\" message detected.<br>For more information, refer to sk92948.</span><br><br>\n" >> $html_file
    fi

    #Check kernel: ACPI: Unable to turn cooling device
    if [[ $(grep -i 'kernel: ACPI: Unable to turn cooling device' $messages_tmp_file) ]] && [[ ! $(grep -i 'kernel: ACPI: Critical trip point' $messages_tmp_file) ]] && [[ ! $(grep -i 'kernel: Critical temperature reached' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,kernel: ACPI: Unable to turn cooling device,WARNING,sk68441\n" >> $csv_log
        printf "\"kernel: ACPI: Unable to turn cooling device\" message detected.\n" >> $logfile
        printf "For more information, refer to sk68441.\n" >> $logfile
        printf "<span>\"kernel: ACPI: Unable to turn cooling device\" message detected.<br>For more information, refer to sk68441.</span><br><br>\n" >> $html_file
    fi

    #Check kernel: FM: failed to insert fsc
    if [[ $(grep -i 'kernel: FM: failed to insert fsc' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,kernel: FM: failed to insert fsc,WARNING,sk103079\n" >> $csv_log
        printf "\"kernel: FM: failed to insert fsc\" message detected.\n" >> $logfile
        printf "For more information, refer to sk103079.\n" >> $logfile
        printf "<span>\"kernel: FM: failed to insert fsc\" message detected.<br>For more information, refer to sk103079.</span><br><br>\n" >> $html_file
    fi

    #Check FW-1: h_getvals: fw_kmalloc
    if [[ $(grep -i 'FW-1: h_getvals: fw_kmalloc' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,FW-1: h_getvals: fw_kmalloc,WARNING,sk56100\n" >> $csv_log
        printf "\"FW-1: h_getvals: fw_kmalloc\" message detected.\n" >> $logfile
        printf "For more information, refer to sk56100.\n" >> $logfile
        printf "<span>\"FW-1: h_getvals: fw_kmalloc\" message detected.<br>For more information, refer to sk56100.</span><br><br>\n" >> $html_file
    fi

    #Check task_block_sbrk: sbrk\([0-9]*\): Cannot allocate memory
    if [[ $(grep -Ei 'task_block_sbrk: sbrk\([0-9]*\): Cannot allocate memory' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,task_block_sbrk: Cannot allocate memory,WARNING,sk103508\n" >> $csv_log
        printf "\"task_block_sbrk: Cannot allocate memory\" message detected.\n" >> $logfile
        printf "For more information, refer to sk103508.\n" >> $logfile
        printf "<span>\"task_block_sbrk: Cannot allocate memory\" message detected.<br>For more information, refer to sk103508.</span><br><br>\n" >> $html_file
    fi

    #Check fwha_multicast_dynamic_routing_handler: packet; arrived on ifn.*which isn't vpn tunnel
    if [[ $(grep -i "fwha_multicast_dynamic_routing_handler: packet; arrived on ifn" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,fwha_multicast_dynamic_routing_handler: packet; arrived on ifn which isn't vpn tunnel,WARNING,sk55740\n" >> $csv_log
        printf "\"fwha_multicast_dynamic_routing_handler: packet; arrived on ifn which isn't vpn tunnel\" message detected.\n" >> $logfile
        printf "For more information, refer to sk55740.\n" >> $logfile
        printf "<span>\"fwha_multicast_dynamic_routing_handler: packet; arrived on ifn which isn't vpn tunnel\" message detected.<br>For more information, refer to sk55740sa.</span><br><br>\n" >> $html_file
    fi

    #Check number of loops during runtime exceeded maximum during 'CVE_2016_2208_FUNC'
    if [[ $(grep -i "number of loops during runtime exceeded maximum during \'CVE_2016_2208_FUNC\'" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,number of loops during runtime exceeded maximum during 'CVE_2016_2208_FUNC',WARNING,sk112743\n" >> $csv_log
        printf "\"number of loops during runtime exceeded maximum during 'CVE_2016_2208_FUNC'\" message detected.\n" >> $logfile
        printf "For more information, refer to sk112743.\n" >> $logfile
        printf "<span>\"number of loops during runtime exceeded maximum during 'CVE_2016_2208_FUNC'\" message detected.<br>For more information, refer to sk112743.</span><br><br>\n" >> $html_file
    fi

    #Check VRF ERROR: Illegal parameters during call to sock_setsockopt
    if [[ $(grep -i 'VRF ERROR: Illegal parameters during call to sock_setsockopt' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,VRF ERROR: Illegal parameters during call to sock_setsockopt,WARNING,sk111101\n" >> $csv_log
        printf "\"VRF ERROR: Illegal parameters during call to sock_setsockopt\" message detected.\n" >> $logfile
        printf "For more information, refer to sk111101.\n" >> $logfile
        printf "<span>\"VRF ERROR: Illegal parameters during call to sock_setsockopt\" message detected.<br>For more information, refer to sk111101.</span><br><br>\n" >> $html_file
    fi

    #Check ips_cmi_handler_match_cb_ex: signature \([0-9]*\) does not have a policy
    if [[ $(grep -Ei 'ips_cmi_handler_match_cb_ex: signature \([0-9]*\) does not have a policy' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,ips_cmi_handler_match_cb_ex: signature \([0-9]*\) does not have a policy,WARNING,sk113251\n" >> $csv_log
        printf "\"ips_cmi_handler_match_cb_ex: signature \([0-9]*\) does not have a policy\" message detected.\n" >> $logfile
        printf "For more information, refer to sk113251.\n" >> $logfile
        printf "<span>\"ips_cmi_handler_match_cb_ex: signature \([0-9]*\) does not have a policy\" message detected.<br>For more information, refer to sk113251.</span><br><br>\n" >> $html_file
    fi

    #Check allocate_port_impl: could not find a free port
    if [[ $(grep -i 'allocate_port_impl: could not find a free port' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,allocate_port_impl: could not find a free port,WARNING,sk103656\n" >> $csv_log
        printf "\"allocate_port_impl: could not find a free port\" message detected.\n" >> $logfile
        printf "For more information, refer to sk103656.\n" >> $logfile
        printf "<span>\"allocate_port_impl: could not find a free port\" message detected.<br>For more information, refer to sk103656.</span><br><br>\n" >> $html_file
    fi

    #Check fwhandle_pool_add: Table kbufs - All available pools exhausted
    if [[ $(grep -i 'fwhandle_pool_add: Table kbufs - All available pools exhausted' $messages_tmp_file) ]] || [[ $(grep -i 'spii_str_psl_stream_init: Failed to init spii psl stream' $messages_tmp_file) ]] ; then
        result_check_failed
        printf "Known Issues,fwhandle_pool_add: Table kbufs - All available pools exhausted,WARNING,sk149254\n" >> $csv_log
        printf "\"fwhandle_pool_add: Table kbufs - All available pools exhausted\" message detected.\n" >> $logfile
        printf "For more information, refer to sk149254.\n" >> $logfile
        printf "<span>\"fwhandle_pool_add: Table kbufs - All available pools exhausted\" message detected.<br>For more information, refer to sk149254.</span><br><br>\n" >> $html_file
    fi

    #Check allocate_port_impl: could not find a free port
    if [[ $(grep -i 'allocate_port_impl: could not find a free port' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,allocate_port_impl: could not find a free port,WARNING,sk103656\n" >> $csv_log
        printf "\"allocate_port_impl: could not find a free port\" message detected.\n" >> $logfile
        printf "For more information, refer to sk103656.\n" >> $logfile
        printf "<span>\"allocate_port_impl: could not find a free port\" message detected.<br>For more information, refer to sk103656.</span><br><br>\n" >> $html_file
    fi

    #Check Failed to parse response from AWS
    if [[ $(grep -i 'Failed to parse response from AWS' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,Failed to parse response from AWS,WARNING,sk112855\n" >> $csv_log
        printf "\"Failed to parse response from AWS\" message detected.\n" >> $logfile
        printf "This issue can be resolved by updating the following configurations:\n" >> $logfile
        printf "##### Global scanner config #####\n" >> $logfile
        printf "global.scannerInterval=120 <---- Updated this value --> 360\n" >> $logfile
        printf "This parameter is relevant for scanners, which work in \"polling\" mode without notifications.\n" >> $logfile
        printf "##### AWS scanner config #####\n" >> $logfile
        printf "aws.connectTimeoutInMilliseconds=60000 <----- updated this value --> 120000\n" >> $logfile
        printf "Specifies the maximum timeout when establishing a connection with a Amazon Web Services (AWS) Data Center.\n" >> $logfile
        printf "For more information, refer to sk112855.\n" >> $logfile
        printf "<span>\"Failed to parse response from AWS\" message detected.<br>This issue can be resolved by updating the following configurations:<br>##### Global scanner config #####<br>global.scannerInterval=120 <---- Updated this value --> 360<br>This parameter is relevant for scanners, which work in \"polling\" mode without notifications.<br>##### AWS scanner config #####<br>aws.connectTimeoutInMilliseconds=60000 <----- updated this value --> 120000<br>Specifies the maximum timeout when establishing a connection with a Amazon Web Services (AWS) Data Center.<br>For more information, refer to sk112855.</span><br><br>\n" >> $html_file
    fi
    
    #Check is_vsx_enabled: libdb error Couldn't connect to /tmp/xgets
    if [[ $(grep -i 'is_vsx_enabled: libdb error couldn' $messages_tmp_file | grep 'connect to /tmp/xgets' | grep 'No such file or directory') ]]; then
        result_check_failed
        printf "Known Issues,is_vsx_enabled: libdb error Couldn't connect to /tmp/xgets:  No such file or directory,WARNING,sk121764\n" >> $csv_log
        printf "\"is_vsx_enabled: libdb error Couldn't connect to /tmp/xgets:  No such file or directory\" message detected.\n" >> $logfile
        printf "For more information, refer to sk121764.\n" >> $logfile
        printf "<span>\"is_vsx_enabled: libdb error Couldn't connect to /tmp/xgets:  No such file or directory\" message detected.<br>For more information, refer to sk121764.</span><br><br>\n" >> $html_file
    fi
    
    #Check cphwd_api_q_choose_q: qid is invalid
    if [[ $(grep -i 'cphwd_api_q_choose_q: qid is invalid, qid' $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,cphwd_api_q_choose_q: qid is invalid,WARNING,sk169767\n" >> $csv_log
        printf "\"cphwd_api_q_choose_q: qid is invalid\" message detected.\n" >> $logfile
        printf "For more information, refer to sk169767.\n" >> $logfile
        printf "<span>\"cphwd_api_q_choose_q: qid is invalid\" message detected.<br>For more information, refer to sk169767.</span><br><br>\n" >> $html_file
    fi
    
    #Check up_manager_cmi_handler_match_cb
    if [[ $(grep -i "icap_client_blade_extract_user_from_ida: couldn\'t get users for src ip" $messages_tmp_file) ]]; then
        result_check_failed
        printf "Known Issues,icap_client_blade_extract_user_from_ida: couldn\'t get users for src ip,WARNING,sk173546\n" >> $csv_log
        printf "\"icap_client_blade_extract_user_from_ida: couldn\'t get users for src ip\" message detected.\n" >> $logfile
        printf "For more information, refer to sk173546.\n" >> $logfile
        printf "<span>\"icap_client_blade_extract_user_from_ida: couldn\'t get users for src ip\" message detected.<br>For more information, refer to sk173546.</span><br><br>\n" >> $html_file
    fi

    #Log check as OK if no messages are found
    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Known Issues,Issues found in logs,OK,\n" >> $csv_log
    else
        printf "Known Issues,Issues found in logs,WARNING,\n" >> $csv_log
    fi

    #Clean up temp message file
    rm $messages_tmp_file > /dev/null 2>&1

    #Sample message detection
    #Check
    #if [[ $(grep -i 'message_found_in_var_log_messages' $messages_tmp_file) ]]; then
    #    result_check_failed
    #    printf "Known Issues,message_found_in_var_log_messages,WARNING,sk000000\n" >> $csv_log
    #    printf "\"message_found_in_var_log_messages\" message detected:\n" >> $logfile
    #    printf "information_about_the_detected_message\n" >> $logfile
    #    printf "For more information, refer to sk000000.\n" >> $logfile
    #    printf "<span>\"message_found_in_var_log_messages\" message detected:<br>information_about_the_detected_message<br>For more information, refer to sk000000.</span><br><br>\n" >> $html_file
    #fi


    #SKs considered but not included
    #sk167033
    #sk125152
    #sk166363
    #sk95966
    #sk67880
    #sk137333
    #sk145673
    #sk151153
    #sk151713
    #sk102988
    #sk150153
    #sk74480
    #sk123235
    #sk142374
    #sk59023
    #sk116436

    #====================================================================================================
    #  FTW after Jumbo Check
    #====================================================================================================
    test_output_error=0
    jumbo_install_date=$(grep installed_on /config/active | grep Bundle | grep -v bundle | grep JUMBO | egrep "$cp_version|$cp_underscore_version" | tr -d '\\' | sort | tail -n1 | awk '{print $3, $4, $5, $6}')
    if [[ -n $jumbo_install_date && $sys_type != "SP" ]]; then
        ftw_completed_date=$(ls --full-time -al /etc/.wizard_accepted | awk '{print $6, $7}')
        jumbo_install_epoch=$(date -d "$jumbo_install_date" +%s)
        ftw_completed_epoch=$(date -d "$ftw_completed_date" +%s)
        printf "| \t\t\t| FTW After Jumbo\t\t|" | tee -a $output_log
        printf '<span><b>FTW After Jumbo - </b></span><b>' >> $html_file

        #Compare the jumbo install second to the ftw completed second
        if [[ $jumbo_install_epoch -gt $ftw_completed_epoch ]]; then
            result_check_passed
            printf "Known Issues,FTW After Jumbo,OK,\n" >> $csv_log
        else
            result_check_failed
            printf "Known Issues,FTW After Jumbo,WARNING,\n" >> $csv_log
            printf "Detected jumbo install prior to First Time Wizard completion.\nThe Jumbo Hotfix Accumulator has to be installed only after successful completion of Gaia First Time Configuration Wizard and reboot.\n" | tee -a $full_output_log $logfile > /dev/null
            printf "<span>Detected jumbo install prior to First Time Wizard completion.<br>The Jumbo Hotfix Accumulator has to be installed only after successful completion of Gaia First Time Configuration Wizard and reboot.</span><br><br>\n" >> $html_file
        fi
    fi

    #Unset variables
    unset jumbo_install_date
    unset ftw_completed_date
    unset jumbo_install_epoch
    unset ftw_completed_epoch


    #====================================================================================================
    #  VLAN IP Check
    #====================================================================================================
    if [[ -e /proc/net/vlan/config ]]; then
        printf "|\t\t\t| VLAN-IP overlap\t\t|" | tee -a $output_log
        printf '<span><b>VLAN-IP Overlap - </b></span><b>' >> $html_file
        test_output_error=0
        vlan_ip_overlap=0
        if [[ $(cat /proc/net/vlan/config | sed '/VLAN/d' | awk '{print $NF}' | sort -u | xargs -I {} grep interface:{}: /config/db/initial | grep ipaddr | wc -l) -gt 0 ]]; then
            vlan_ip_overlap=1
        fi
        
        if [[ $vlan_ip_overlap -eq 0 ]]; then
            result_check_passed
            printf "Known Issues,VLAN-IP overlap,OK,\n" >> $csv_log
        else
            result_check_failed
            printf "Known Issues,VLAN-IP overlap,WARNING,sk88700\n" >> $csv_log
            printf "VLAN IP Overlap -  Interface(s) detected with an IP and a VLAN.\nIt is mandatory to remove an IP address from a physical interface before creating any VLAN interfaces on that physical interface.\nPlease see sk88700 for additional information.\n" >> $logfile
            printf "<span>Interface(s) detected with an IP and a VLAN.<br>It is mandatory to remove an IP address from a physical interface before creating any VLAN interfaces on that physical interface.<br>Please see sk88700 for additional information.</span><br>\n" >> $html_file
        fi

        #Unset variables
        unset vlan_ip_overlap
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file
}


#====================================================================================================
#  License Checks Function
#====================================================================================================
check_licenses()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Licensing\t\t"

    #====================================================================================================
    #  License Check
    #====================================================================================================
    printf "| Licensing\t\t| Licenses\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Licensing</b></span><br>\n' >> $html_file
    printf '<span><b>Licenses - </b></span><b>' >> $html_file

    #Base Variables
    expired_licenses=0
    expired_contract_licenses=0
    licenses_present=false
    contracts_temp_file=/var/tmp/contracts.tmp
    expired_license_list_file=/var/tmp/expired_license_list.tmp
    expiring_license_list_file=/var/tmp/expiring_license_list.tmp
    expired_license_contract_list_file=/var/tmp/expired_license_contract_list.tmp
    missing_license_contract_list_file=/var/tmp/missing_license_contract_list.tmp
    duplicate_licenses_list_file=/var/tmp/duplicate_licenses_list.tmp

    #collect cplic print
    cplic_output=$(cplic print -x)

    #Log license information
    echo "$cplic_output" >> $full_output_log

    #Current date in seconds
    current_second=$(date +"%s")

    #Sort cplic output into licenses and contracts
    cp_licenses=$(echo "$cplic_output" | egrep '^[0-9]{0,3}\.[0-9]{1,1}')
    echo "$cplic_output" | grep -i -B2 -A100 Covers | sed 's/|/ /g' > $contracts_temp_file

    #Split the contracts into individual files
    if [[ $(cat $contracts_temp_file | wc -l) -ne 0 ]]; then
        csplit -f contract_temp $contracts_temp_file  /^[0-9]/ {*} > /dev/null 2>&1
    fi

    #Split the licenses into ones with expiration dates and "never"
    license_expires=$(echo "$cp_licenses" | grep -v never)

    #Check for no licenses
    if [[ -n $cp_licenses ]]; then
        licenses_present=true
    fi

    #Check for duplicate licenses
    ck_list=$(echo "$cp_licenses" | egrep -iow "CK-[0-9A-Z-]{1,20}" | sort -uf)
    for lic_ck in $ck_list; do
        #Check to see if any CKs show up twice
        lic_string=$(echo "$cp_licenses" | grep -i $lic_ck)
        if [[ $(echo "$lic_string" | wc -l) -gt 1 ]]; then
            lic_product=$(echo "$lic_string" | head -n1 | awk '{print $4}')

            #If duplicate CKs are detected, compare the first licensed product
            possible_duplicates=$(echo "$lic_string" | awk 'tolower($4) == tolower("'"$lic_product"'") { print $0 }')
            if [[ $(echo "$possible_duplicates" | wc -l) -gt 1 ]]; then
                echo "$possible_duplicates" >> $duplicate_licenses_list_file
            fi
        fi
    done

    #Check the licenses with expiration dates
    if [[ -n $license_expires ]]; then
        while read -r license; do
            expiration_date=$(echo $license | awk '{print $2}')
            expiration_second=$(date -d "$expiration_date" +"%s")

            #If the license is expired, add it to the list
            if [[ $current_second -gt $expiration_second ]]; then
                ((expired_licenses++))
                echo $license >> $expired_license_list_file

            #If the license is not expired, check if it will expire in the next 30 days and if it has an associated contract
            else
                #Check if the license expires in the next 30 days (2592000 seconds = 30 days)
                seconds_to_expiration=$((expiration_second-current_second))
                if [[ $seconds_to_expiration -le 2592000 ]]; then
                    echo $license >> $expiring_license_list_file
                fi
            fi
        done <<< "$license_expires"
    fi

    #Check licenes against contracts
    if [[ -n $cp_licenses ]]; then
        while read -r license; do
            license_ck=$(echo $license | egrep -iow "CK-[0-9A-Z-]{1,20}")

            #Search for the CK in each contract
            contract_found=0
            if [[ $(ls | grep contract_temp) ]]; then
                #Variable to catch CK covered under multiple expired licenses
                expired_contract_found=0

                #Loop through each contract
                for contract_file in $(ls contract_temp*); do
                    if [[ $(grep -i $license_ck $contract_file) ]]; then
                        contract_found=1
                        #Find the expiration of the contract
                        expiration_date=$(egrep '^[0-9]' $contract_file | awk '{print $3}')
                        expiration_second=$(date -d "$expiration_date" +"%s")
                        if [[ $current_second -gt $expiration_second && $expired_contract_found -eq 0 ]]; then
                            ((expired_contract_licenses++))
                            expired_contract_found=1
                            echo $license >> $expired_license_contract_list_file
                        fi
                    fi
                done
            fi

            #Add license to list of missing contracts if a contract was not found
            if  [[ $contract_found -eq 0 ]]; then
                echo $license >> $missing_license_contract_list_file
            fi
        done <<< "$cp_licenses"
    fi

    #Display the results of the license checks
    if [[ $expired_licenses -ne 0 || $expired_contract_licenses -ne 0 || -e $missing_license_contract_list_file || -e $duplicate_licenses_list_file ]]; then
        result_check_failed
        printf "Licensing,Licenses,WARNING,sk11054\n" >> $csv_log

        #Add sk notice
        printf "License Help:\n-------------\nFor information related to Check Point licensing, please see sk11054.\nFor any additional questions not covered by the sk, contact Account Services.\n\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>For information related to Check Point licensing, please see sk11054.</br>For any additional questions not covered by the sk, contact Account Services.</br></br></span>\n" >> $html_file

        #Display licenses that are expired
        if [[ $expired_licenses -ne 0 ]]; then
            #Console and log output
            printf "Expired licenses:\n" | tee -a $full_output_log $logfile > /dev/null
            cat $expired_license_list_file | tee -a $full_output_log $logfile > /dev/null
            printf "\n" | tee -a $full_output_log $logfile > /dev/null

            #HTML output
            printf "<span>Expired licenses:</br>" >> $html_file
            while read license; do
                printf "$license </br>" >> $html_file
            done < $expired_license_list_file
            printf "</span><br>\n" >> $html_file
        fi

        #Display licenses that have an expired contract
        if [[ $expired_contract_licenses -ne 0 ]]; then
            #Console and log output
            printf "Licenses with expired contracts:\n" | tee -a $full_output_log $logfile > /dev/null
            cat $expired_license_contract_list_file | tee -a $full_output_log $logfile > /dev/null
            printf "\n" | tee -a $full_output_log $logfile > /dev/null

            #HTML output
            printf "<span>Licenses with expired contracts:</br>" >> $html_file
            while read license; do
                printf "$license </br>" >> $html_file
            done < $expired_license_contract_list_file
            printf "</span><br>\n" >> $html_file
        fi

        #Display licenses do not have contracts
        if [[ -e $missing_license_contract_list_file ]]; then
            #Console and log output
            printf "Licenses without Contract:\n" | tee -a $full_output_log $logfile > /dev/null
            cat $missing_license_contract_list_file | tee -a $full_output_log $logfile > /dev/null
            printf "\n" | tee -a $full_output_log $logfile > /dev/null

            #HTML output
            printf "<span>Licenses without Contract:</br>" >> $html_file
            while read license; do
                printf "$license </br>" >> $html_file
            done < $missing_license_contract_list_file
            printf "</span><br>\n" >> $html_file
        fi

        #Display licenses that are about to expire in the next 30 days
        if [[ -e $expiring_license_list_file ]]; then
            #Console and log output
            printf "Licenses expiring within 30 days:\n" | tee -a $full_output_log $logfile > /dev/null
            cat $expiring_license_list_file | tee -a $full_output_log $logfile > /dev/null
            printf "\n" | tee -a $full_output_log $logfile > /dev/null

            #HTML output
            printf "<span>Licenses expiring within 30 days:</br>" >> $html_file
            while read license; do
                printf "$license </br>" >> $html_file
            done < $expiring_license_list_file
            printf "</span><br>\n" >> $html_file
        fi
        printf "<br>\n" >> $html_file

        #Display duplicate licenses
        if [[ -e $duplicate_licenses_list_file ]]; then
            #Console and log output
            printf "Duplicate Licenses:\n" | tee -a $full_output_log $logfile > /dev/null
            cat $duplicate_licenses_list_file | tee -a $full_output_log $logfile > /dev/null
            printf "\n" | tee -a $full_output_log $logfile > /dev/null

            #HTML output
            printf "<span>Duplicate Licenses:</br>" >> $html_file
            while read license; do
                printf "$license </br>" >> $html_file
            done < $duplicate_licenses_list_file
            printf "</span><br>\n" >> $html_file
        fi
        printf "<br>\n" >> $html_file

    elif [[ $licenses_present == false ]]; then
        result_check_failed
        printf "Licensing,Licenses,WARNING,sk11054\n" >> $csv_log

        #Add sk notice
        printf "No licenses detected:\n-------------\nFor information related to Check Point licensing, please see sk11054.\nFor any additional questions not covered by the sk, contact Account Services.\n\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>No licenses detected:</br>For information related to Check Point licensing, please see sk11054.</br>For any additional questions not covered by the sk, contact Account Services.</br></br></span>\n" >> $html_file

    elif [[ -e $expiring_license_list_file ]]; then
        result_check_info
        printf "Licensing,Licenses,INFO,sk11054\n" >> $csv_log

        #Add sk notice
        printf "License Help:\n-------------\nFor information related to Check Point licensing, please see sk11054.\nFor any additional questions not covered by the sk, contact Account Services.\n\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>For information related to Check Point licensing, please see sk11054.</br>For any additional questions not covered by the sk, contact Account Services.</br></br></span>\n" >> $html_file

        #Console and log output
        printf "Licenses expiring within 30 days:\n" | tee -a $full_output_log $logfile > /dev/null
        cat $expiring_license_list_file | tee -a $full_output_log $logfile > /dev/null
        printf "\n" | tee -a $full_output_log $logfile > /dev/null

        #HTML output
        printf "<span>Licenses expiring within 30 days:</br>" >> $html_file
        while read license; do
            printf "$license </br>" >> $html_file
        done < $expiring_license_list_file
        printf "</span><br></br>\n" >> $html_file

    else
        result_check_passed
        printf "Licensing,Licenses,OK,\n" >> $csv_log
    fi


    #====================================================================================================
    #  Contract Expiration Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Contracts\t\t\t|" | tee -a $output_log
    printf '<span><b>Contracts - </b></span><b>' >> $html_file

    expired_contracts=0
    expired_contract_list_file=/var/tmp/expired_contract_list.tmp
    expiring_contract_list_file=/var/tmp/expiring_contract_list.tmp

    #Parse through each individual contract file
    if [[ $(ls | grep contract_temp) ]]; then
        contracts_present=true
        for contract_file in $(ls contract_temp*); do
            #Ensure it contains valid contract information (some wont based on the split)
            if [[ $(cat $contract_file | grep -i Covers) ]]; then
                expiration_date=$(egrep '^[0-9]' $contract_file | awk '{print $3}')
                expiration_second=$(date -d "$expiration_date" +"%s")
                seconds_to_expiration=$((expiration_second-current_second))
                if [[ $current_second -gt $expiration_second ]]; then
                    ((expired_contracts++))
                    cat $contract_file >> $expired_contract_list_file
                elif [[ $seconds_to_expiration -le 2592000 ]]; then
                    cat $contract_file >> $expiring_contract_list_file
                fi
            fi
        done
    else
        contracts_present=false
    fi

    #Check the License results
    if [[ $expired_contracts -ne 0 || $contracts_present == false ]]; then
        result_check_failed
        printf "Licensing,Contracts,WARNING,sk33089\n" >> $csv_log

        #Add sk notice
        printf "Contract Help:\n--------------\nFor information related to Check Point contracts, please see sk33089.\nFor any additional questions not covered by the sk, contact Account Services.\n\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>For information related to Check Point contracts, please see sk33089.</br>For any additional questions not covered by the sk, contact Account Services.</br></br></span>\n" >> $html_file

        if [[ $contracts_present == false ]]; then
            #Console and log output
            printf "No contract information found.\n" | tee -a $full_output_log $logfile > /dev/null

            #HTML output
            printf "<span>No contract information found.</span><br><br>\n" >> $html_file
        fi

        if [[ $expired_contracts -ne 0 ]]; then
            #Console and log output
            printf "Expired contracts:\n #   ID          Expiration   SKU:\n===+===========+============+====================\n" | tee -a $full_output_log $logfile > /dev/null
            cat $expired_contract_list_file | tee -a $full_output_log $logfile > /dev/null
            printf "\n\n" | tee -a $full_output_log $logfile > /dev/null

            #HTML output
            printf "<span>Expired contracts:</br> # ID Expiration SKU:</br>===+===========+============+====================</br>" >> $html_file
            while read contract_line; do
                printf "$contract_line </br>" >> $html_file
            done < $expired_contract_list_file
            printf "</span><br><br>\n" >> $html_file
        fi

        #Display licenses that are about to expire in the next 30 days
        if [[ -e $expiring_contract_list_file ]]; then
            #Console and log output
            printf "Contracts expiring within 30 days:\n #   ID          Expiration   SKU:\n===+===========+============+====================\n" | tee -a $full_output_log $logfile > /dev/null
            cat $expiring_contract_list_file | tee -a $full_output_log $logfile > /dev/null
            printf "\n" | tee -a $full_output_log $logfile > /dev/null

            #HTML output
            printf "<span>Contracts expiring within 30 days:</br> # ID Expiration SKU:</br>===+===========+============+====================</br>" >> $html_file
            while read contract_info; do
                printf "$contract_info </br>" >> $html_file
            done < $expiring_contract_list_file
            printf "</span><br>\n" >> $html_file
        fi
        printf "<br>\n" >> $html_file

    elif [[ -e $expiring_contract_list_file ]]; then
        result_check_info
        printf "Licensing,Contracts,INFO,sk33089\n" >> $csv_log

        #Add sk notice
        printf "Contract Help:\n--------------\nFor information related to Check Point contracts, please see sk33089.\nFor any additional questions not covered by the sk, contact Account Services.\n\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>For information related to Check Point contracts, please see sk33089.</br>For any additional questions not covered by the sk, contact Account Services.</br></br></span>\n" >> $html_file

        #Console and log output
        printf "Contracts expiring within 30 days:\n #   ID          Expiration   SKU:\n===+===========+============+====================\n" | tee -a $full_output_log $logfile > /dev/null
        cat $expiring_contract_list_file | tee -a $full_output_log $logfile > /dev/null
        printf "\n" | tee -a $full_output_log $logfile > /dev/null

        #HTML output
        printf "<span>Contracts expiring within 30 days:</br> # ID Expiration SKU:</br>===+===========+============+====================</br>" >> $html_file
        while read contract_info; do
            printf "$contract_info </br>" >> $html_file
        done < $expiring_contract_list_file
        printf "</span><br></br>\n" >> $html_file

    else
        result_check_passed
        printf "Licensing,Contracts,OK,\n" >> $csv_log
    fi


    #Cleanup temp files
    rm -rf $contracts_temp_file > /dev/null 2>&1
    rm -rf $expired_license_list_file > /dev/null 2>&1
    rm -rf $expired_license_contract_list_file > /dev/null 2>&1
    rm -rf $expiring_license_list_file > /dev/null 2>&1
    rm -rf $missing_license_contract_list_file > /dev/null 2>&1
    rm -rf $expiring_contract_list_file > /dev/null 2>&1
    rm -rf $expired_contract_list_file > /dev/null 2>&1
    rm -rf $duplicate_licenses_list_file > /dev/null 2>&1
    rm -rf contract_temp* > /dev/null 2>&1

    #Unset variables
    unset licenses_present
    unset contracts_temp_file
    unset expired_license_list_file
    unset expired_license_contract_list_file
    unset expiring_license_list_file
    unset missing_license_contract_list_file
    unset expiring_contract_list_file
    unset expired_contract_list_file
    unset duplicate_licenses_list_file
    unset expired_licenses
    unset expired_contract_licenses
    unset cplic_output
    unset current_second
    unset cp_licenses
    unset ck_list
    unset lic_ck
    unset lic_string
    unset lic_product
    unset possible_duplicates
    unset expired_contract_found
    unset license_expires
    unset license
    unset expiration_date
    unset expiration_second
    unset seconds_to_expiration
    unset license_ck
    unset contracts_present
    unset contract_found
    unset contract_file
    unset expired_contracts

}


#====================================================================================================
#  Local Logging Function
#====================================================================================================
check_logging()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Logging\t\t"

    #Find starting size of fw.log
    log_start_size=$(ls -l $FWDIR/log/fw.log | awk '{print $5}')
    printf "| Logging\t\t| Local Logging\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Logging</b></span><br>\n' >> $html_file
    printf '<span><b>Local Logging - </b></span><b>' >> $html_file
    sleep 5

    #Find end size of fw.log
    log_stop_size=$(ls -l $FWDIR/log/fw.log | awk '{print $5}')

    #Compare sizes and log
    if [[ $log_stop_size -gt $log_start_size ]]; then
        result_check_failed
        printf "Logging,Local Logging,WARNING,\n" >> $csv_log
        printf "Local Logging Fail:\nThe /$FWDIR/log/fw.log file is increasing in size.\n" >> $logfile
        printf "<span>Local Logging Fail:<br>The /$FWDIR/log/fw.log file is increasing in size.</span><br><br>\n" >> $html_file
    else
        result_check_passed
        printf "Logging,Local Logging,OK,\n" >> $csv_log
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset local logging variables
    unset log_start_size
    unset log_stop_size
}


#====================================================================================================
#  Magic MAC Function
#====================================================================================================
check_magic_mac()
{
    printf "\n\nMAC Magic:\n" >> $full_output_log
    if [[ $current_version -le 7730 ]]; then
        magic_mac=$(fw ctl get int fwha_mac_magic 2>/dev/null)
        mac_forward_magic=$(fw ctl get int fwha_mac_forward_magic 2>/dev/null)
        printf "$magic_mac\n" >> $full_output_log
        printf "$mac_forward_magic\n" >> $full_output_log
    elif [[ $current_version -le 8030 && $(uname -r) != "3.10"* ]]; then
        magic_mac=$(cphaprob mmagic | sed "/^$/d")
        printf "$magic_mac\n" >> $full_output_log

        printf "\n\nCluster Global ID:\n" >> $full_output_log
        cphaconf cluster_id get >> $full_output_log
    fi
}


#====================================================================================================
#  Memory Function
#====================================================================================================
check_memory()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Memory\t\t"

    #====================================================================================================
    #  Physical Memory Check
    #====================================================================================================
    printf "| Memory\t\t| Physical Memory\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Memory</b></span><br>\n' >> $html_file
    printf '<span><b>Physical Memory - </b></span><b>' >> $html_file
    printf "\n\nMemory Info:\n" >> $full_output_log


    #Physical memory check
    if [[ $offline_operations == true ]]; then
        current_meminfo=$(grep -A50 '(meminfo)' $cpinfo_file | grep -B50 cpuinfo | grep -v Additional | grep -v '\-\-\-')
    else
        cat /proc/meminfo  >> $full_output_log
        current_meminfo=$(cat /proc/meminfo)
    fi
    total_mem=$(echo "$current_meminfo" | egrep '^MemTotal' | awk '{print $2}')
    free_mem=$(echo "$current_meminfo" | grep MemFree | awk '{print $2}')
    buff_mem=$(echo "$current_meminfo" | grep Buffers | awk '{print $2}')
    cache_mem=$(echo "$current_meminfo" |  grep ^'Cached' | awk '{print $2}')

    #Memory calculations
    all_free_mem=$free_mem
    all_free_mem=$((all_free_mem + buff_mem))
    all_free_mem=$((all_free_mem + cache_mem))
    free_mem_percent=$(echo "100 * $all_free_mem / $total_mem" | bc)
    (( used_mem_percent = 100 - free_mem_percent ))

    #Determine memory status
    if [[ $used_mem_percent -le 69 ]]; then
        result_check_passed
        printf "Memory,Physical Memory,OK,\n" >> $csv_log
    else
        result_check_failed
        printf "Memory,Physical Memory,WARNING,\n" >> $csv_log
        if [[ $used_mem_percent -ge 70 && $used_mem_percent -le 84 ]]; then
            printf "Physical Memory Warning:\nPhysical memory is $used_mem_percent%% used.\n" >> $logfile
            printf "<span>Warning: Physical memory is $used_mem_percent%% used.</span><br><br>\n" >> $html_file
        elif [[ $used_mem_percent -ge 85 ]]; then
            printf "Physical Memory Critical:\nPhysical memory is $used_mem_percent%% used.\n" >> $logfile
            printf "<span>Critical: Physical memory is $used_mem_percent%% used.</span><br><br>\n" >> $html_file
        else
            printf "Physical Memory Error:\nUnable to determine Physical memory usage.\n" >> $logfile
            printf '<span>Error: Unable to determine Physical memory usage.</span><br><br>\n' >> $html_file
        fi
    fi


    #====================================================================================================
    #  Swap Memory Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Swap Memory\t\t\t|" | tee -a $output_log
    printf '<span><b>Swap Memory - </b></span><b>' >> $html_file
    total_swap=$(echo "$current_meminfo" | grep SwapTotal | awk '{print $2}')
    free_swap=$(echo "$current_meminfo" | grep SwapFree | awk '{print $2}')
    (( used_swap = total_swap - free_swap ))
    used_swap_percent=$(echo "100 * $used_swap / $total_swap" | bc)
    if [[ $used_swap_percent -le 1 ]]; then
        result_check_passed
        printf "Memory,Swap Memory,OK,\n" >> $csv_log
    elif [[ $used_swap_percent -ge 2 ]]; then
        result_check_failed
        printf "Memory,Swap Memory,WARNING,\n" >> $csv_log
        printf "Swap Memory Critical:\nSwap memory is $used_swap_percent%% used.\n" >> $logfile
        printf "<span>Critical: Swap memory is $used_swap_percent%% used.</span><br><br>\n" >> $html_file
    else
        result_check_failed
        printf "Memory,Swap Memory,WARNING,\n" >> $csv_log
        printf "Swap Memory Error:\n\tUnable to determine swap memory usage.\n" >> $logfile
        printf '<span>Error: Unable to determine swap memory usage.</span><br><br>\n' >> $html_file
    fi

    #fw ctl pstat analysis
    test_output_error=0
    if [[ $sys_type == "GATEWAY" || $sys_type == "STANDALONE" || $sys_type == "VSX" ]]; then
        if [[ $offline_operations == true ]]; then
            fwctlpstat=$(grep -A 70 "(fw ctl pstat)" $cpinfo_file | grep -B70 'FireWall-1 Statistics' | grep -v "fw ctl pstat" | grep -v '\-\-\-' | grep -v '\=\=\=')
        else
            fwctlpstat=$(fw ctl pstat)
        fi

        if [[ -n $fwctlpstat ]]; then
            #====================================================================================================
            #  HMEM Check
            #====================================================================================================
            printf "|\t\t\t| Hash Kernel Memory (hmem)\t|" | tee -a $output_log
            printf '<span><b>Hash Kernel Memory (hmem)- </b></span><b>' >> $html_file
            hash_memory_failed=$(echo "$fwctlpstat" | grep -A5 "hmem" | grep Allocations | awk '{print $4}')
            if [[ $hash_memory_failed -eq 0 ]]; then
                result_check_passed
                printf "Memory,Hash Kernel Memory (hmem),OK,\n" >> $csv_log
            elif [[ $hash_memory_failed -ge 1 ]]; then
                result_check_failed
                printf "Memory,Hash Kernel Memory (hmem),WARNING,\n" >> $csv_log
                printf "\nHMEM Warning:\n\tHash memory had $hash_memory_failed failures.\n" >> $logfile
                printf "Presence of hmem failed allocations indicates that the hash kernel memory was full.\nThis is not a serious memory problem but indicates there is a configuration problem.\nThe value assigned to the hash memory pool, (either manually or automatically by changing the number concurrent connections in the capacity optimization section of a firewall) determines the size of the hash kernel memory.\nIf a low hmem limit was configured it leads to improper usage of the OS memory.\n" >> $logfile
                printf "<span>Warning: Hash memory had $hash_memory_failed failures.<br>Presence of hmem failed allocations indicates that the hash kernel memory was full.<br>This is not a serious memory problem but indicates there is a configuration problem.<br>The value assigned to the hash memory pool, (either manually or automatically by changing the number concurrent connections in the capacity optimization section of a firewall) determines the size of the hash kernel memory.<br>If a low hmem limit was configured it leads to improper usage of the OS memory.</span><br><br>\n" >> $html_file
            else
                result_check_failed
                printf "Memory,Hash Kernel Memory (hmem),WARNING,\n" >> $csv_log
                printf "\nHMEM Error:\nUnable to determine hmem failures.\n" >> $logfile
                printf '<span>Error: Unable to determine hmem failures.</span><br><br>\n' >> $html_file
            fi

            #====================================================================================================
            #  SMEM Check
            #====================================================================================================
            test_output_error=0
            printf "|\t\t\t| System Kernel Memory (smem)\t|" | tee -a $output_log
            printf '<span><b>System Kernel Memory (smem)- </b></span><b>' >> $html_file
            system_memory_failed=$(echo "$fwctlpstat" | grep -A5 "smem" | grep Allocations | awk '{print $4}')
            if [[ $system_memory_failed -eq 0 ]]; then
                result_check_passed
                printf "Memory,System Kernel Memory (smem),OK,\n" >> $csv_log
            elif [[ $system_memory_failed -ge 1 ]]; then
                result_check_failed
                printf "Memory,System Kernel Memory (smem),WARNING,\n" >> $csv_log
                printf "\nSMEM Warning:\nSystem memory had $system_memory_failed failures.\n" >> $logfile
                printf "Presence of smem failed allocations indicates that the OS memory was exhausted or there are large non-sleep allocations.\n\tThis is symptomatic of a memory shortage.\n\tIf there are failed smem allocations and the memory is less than 2 GB, upgrading to 2GB may fix the problem.\n\tDecreasing the TCP end timeout and decreasing the number of concurrent connections can also help reduce memory consumption.\n" >> $logfile
                printf "<span>Warning: System memory had $system_memory_failed failures.<br>Presence of smem failed allocations indicates that the OS memory was exhausted or there are large non-sleep allocations.<br>This is symptomatic of a memory shortage.<br>If there are failed smem allocations and the memory is less than 2 GB, upgrading to 2GB may fix the problem.<br>Decreasing the TCP end timeout and decreasing the number of concurrent connections can also help reduce memory consumption.</span><br><br>\n" >> $html_file
            else
                result_check_failed
                printf "Memory,System Kernel Memory (smem),WARNING,\n" >> $csv_log
                printf "\nSMEM Error:\nUnable to determine smem failures.\n" >> $logfile
                printf '<span>Error: Unable to determine smem failures</span><br><br>\n' >> $html_file
            fi

            #====================================================================================================
            #  KMEM Check
            #====================================================================================================
            test_output_error=0
            printf "|\t\t\t| Kernel Memory (kmem)\t\t|" | tee -a $output_log
            printf '<span><b>Kernel Memory (kmem) - </b></span><b>' >> $html_file
            kernel_memory_failed=$(echo "$fwctlpstat" | grep -A5 "kmem" | grep Allocations | grep -v External | awk '{print $4}')
            if [[ $kernel_memory_failed -eq 0 ]]; then
                result_check_passed
                printf "Memory,Kernel Memory (kmem),OK,\n" >> $csv_log
            elif [[ $kernel_memory_failed -ge 1 ]]; then
                result_check_failed
                printf "Memory,Kernel Memory (kmem),WARNING,\n" >> $csv_log
                printf "\nKMEM Warning:\n\tKernel memory had $kernel_memory_failed failures.\n" >> $logfile
                printf "Presence of kmem failed allocations means that some applications did not get memory.\nThis is usually an indication of a memory problem; most commonly a memory shortage.\n" >> $logfile
                printf "<span>Warning: Kernel memory had $kernel_memory_failed failures.<br>Presence of kmem failed allocations means that some applications did not get memory.<br>This is usually an indication of a memory problem; most commonly a memory shortage.</span><br><br>\n" >> $html_file
            else
                result_check_failed
                printf "Memory,Kernel Memory (kmem),WARNING,\n" >> $csv_log
                printf "\nKMEM Error:\nUnable to determine kmem failures.\n" >> $logfile
                printf "<span>Error: Unable to determine kmem failures.</span><br><br>\n" >> $html_file
            fi
        fi


        #Historic checks using CPViewDB.dat
        if [[ -e $cpview_file ]]; then

            #Collect CPView info
            mem_total=$(sqlite3 $cpview_file "select max(real_total) from UM_STAT_UM_MEMORY;" 2> /dev/null)
            mem_avg=$(sqlite3 $cpview_file "select avg(real_used) from UM_STAT_UM_MEMORY;" 2> /dev/null)
            mem_peak=$(sqlite3 $cpview_file "select max(real_used) from UM_STAT_UM_MEMORY;" 2> /dev/null)

            if [[ -n $mem_total && -n $mem_avg ]]; then
                #====================================================================================================
                #  Memory 30-Day Average Check
                #====================================================================================================
                printf "|\t\t\t| Memory 30-Day Average\t\t|" | tee -a $output_log
                printf '<span><b>Memory 30-day Average - </b></span><b>' >> $html_file
                test_output_error=0


                #Turn average usage into a percent
                mem_average_used=$(echo $mem_avg/$mem_total*100 | bc -l | awk '{printf "%.0f", int($1+0.5)}')

                #Log final output
                if [[ $mem_average_used -ge 70 ]]; then
                    result_check_failed
                    printf "Memory,Memory 30-Day Average,WARNING,sk98348\n" >> $csv_log
                    printf "The average memory usage over the last month was $mem_average_used percent.\nPlease check to see if there are any configuration optimizations from sk98348 that can be used or see if additional RAM can be installed in this system.\n" >> $logfile
                    printf "<span>The average memory usage over the last month was $mem_average_used percent.<br>Please check to see if there are any configuration optimizations from sk98348 that can be used or see if additional RAM can be installed in this system.</span><br><br>\n" >> $html_file
                else
                    result_check_passed
                    printf "Memory,Memory 30-Day Average,OK,\n" >> $csv_log
                fi
            fi

            if [[ -n $mem_total && -n $mem_peak ]]; then
                #====================================================================================================
                #  Memory 30-Day Max Check
                #====================================================================================================
                printf "|\t\t\t| Memory 30-Day Peak\t\t|" | tee -a $output_log
                printf '<span><b>Memory 30-Day Peak - </b></span><b>' >> $html_file
                test_output_error=0

                #Turn max usage into a percent
                mem_peak_used=$(echo $mem_peak/$mem_total*100 | bc -l | awk '{printf "%.0f", int($1+0.5)}')

                #Log final output
                if [[ $mem_peak_used -ge 70 ]]; then
                    result_check_failed
                    printf "Memory,Memory 30-Day Peak,WARNING,\n" >> $csv_log
                    printf "Peak memory usage was $mem_peak_used%% over the last month.\nPlease review the memory usage on this device to see if a configuration change or hardware upgrade is needed.\n" >> $logfile
                    printf "<span>Peak memory usage was $mem_peak_used%% over the last month.<br>Please review the memory usage on this device to see if a configuration change or hardware upgrade is needed.</span><br><br>\n" >> $html_file
                else
                    result_check_passed
                    printf "Memory,Memory 30-Day Peak,OK,\n" >> $csv_log
                fi
            fi
        fi
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset Memory Variables
    unset current_meminfo
    unset total_mem
    unset free_mem
    unset buff_mem
    unset cache_mem
    unset all_free_mem
    unset used_mem_percent
    unset free_mem_percent
    unset used_swap
    unset free_swap
    unset total_swap
    unset mem_average_used
    unset mem_peak_used
    unset mem_peak
    unset mem_total
    unset mem_avg
    unset kernel_memory_failed
    unset system_memory_failed
    unset hash_memory_failed
}


#====================================================================================================
#  Check Mgmt Config
#====================================================================================================
check_mgmt_config()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Configuration\t\t"

    #====================================================================================================
    #  Check GUI clients
    #====================================================================================================
    printf "| Configuration\t\t| GUI Clients\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Configuration</b></span><br>\n' >> $html_file
    printf '<span><b>GUI Clients - </b></span><b>' >> $html_file
    
    any_clients=0
    if [[ $(cp_conf client get 2> /dev/null) == "Any" ]]; then
        any_clients=1
    fi
    
    #Check the results
    if [[ $any_clients -eq 0 ]]; then
        result_check_passed
        printf "Configuration,GUI Clients,OK,\n" >> $csv_log
    else
        result_check_info
        printf "Configuration,GUI Clients,INFO,\n" >> $csv_log
        printf "This Management server currently has \"Any\" defined as a GUI Client.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "This could pose a security risk.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>This Management server currently has \"Any\" defined as a GUI Client.<br>This could pose a security risk.</span><br><br>\n" >> $html_file
    fi
}


#====================================================================================================
#  Check Mgmt Status
#====================================================================================================
check_mgmt_status()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Mgmt Status\t\t"

    #====================================================================================================
    #  Check API Status
    #====================================================================================================
    printf "| Mgmt Status\t\t| API\t\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Mgmt Status</b></span><br>\n' >> $html_file
    printf '<span><b>API - </b></span><b>' >> $html_file
    
    api_ready=1
    if [[ $(api status 2> /dev/null) == *"API readiness test SUCCESSFUL."* ]]; then
        api_ready=0
    fi
    
    #Check the results
    if [[ $api_ready -eq 0 ]]; then
        result_check_passed
        printf "Mgmt Status,Status,OK,\n" >> $csv_log
    elif [[ $sys_type == "MLM" ]]; then
        result_check_info
        printf "Mgmt Status,API,Info,sk163457\n" >> $csv_log
        printf "Management API readyness test was not successful but this is to be expected on a MLM per sk163457.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>Management API readyness test was not successful but this is to be expected on a MLM per sk163457.</span><br><br>\n" >> $html_file
    elif [[ $($CPDIR/bin/cpprod_util FwIsPrimary) -eq 0 ]]; then
        result_check_info
        printf "Mgmt Status,API,Info,\n" >> $csv_log
        printf "Management API readyness test was not successful but this is to be expected on Mgmt HA devices.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>Management API readyness test was not successful but this is to be expected on Mgmt HA devices.</span><br><br>\n" >> $html_file
    else
        result_check_failed
        printf "Mgmt Status,API,WARNING,\n" >> $csv_log
        printf "Management API readyness test was not successful.\n" | tee -a $full_output_log $logfile > /dev/null
        printf "To collect troubleshooting data, please run 'api status -s <comment>'\n" | tee -a $full_output_log $logfile > /dev/null
        printf "<span>Management API readyness test was not successful.<br>To collect troubleshooting data, please run 'api status -s (comment)'</span><br><br>\n" >> $html_file
    fi


    #====================================================================================================
    #  Check CPM
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| CPM\t\t\t\t|" | tee -a $output_log
    printf '<span><b>CPM - </b></span><b>' >> $html_file
    
    cpm_status=$($MDS_FWDIR/scripts/cpm_status.sh)
    if [[ $cpm_status == *"running and ready"* ]]; then
        result_check_passed
        printf "Mgmt Status,CPM,OK,\n" >> $csv_log
    else
        result_check_failed
        printf "Mgmt Status,CPM,WARNING,\n" >> $csv_log
        printf "CPM is not running.\n" | tee -a $full_output_log $logfile > /dev/null
        echo "$cpm_status" >> $full_output_log
        printf "<span>CPM is not running.</span><br><br>\n" >> $html_file
    fi
}


#====================================================================================================
#  NTP Function
#====================================================================================================
check_ntp()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    ntp_error=0
    current_check_message="NTP\t\t\t"
    #Log NTP check start
    printf "| NTP\t\t\t| NTP Daemon\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>NTP</b></span><br>\n' >> $html_file
    printf '<span><b>NTP Daemon - </b></span><b>' >> $html_file

    #Check to see if the ntpstat binary is present
    if [[ -e /usr/bin/ntpstat ]]; then

        #Collect NTP status from ntpstat
        tmp_ntp=/var/tmp/ntp_stat.tmp
        ntpstat >> $tmp_ntp 2>&1
        if [[ $(grep -i "synchronised to NTP server" $tmp_ntp) ]]; then
            result_check_passed
            printf "NTP,NTP Daemon,OK,\n" >> $csv_log
        elif [[ $(grep "Unable to talk" $tmp_ntp) ]]; then
            result_check_failed
            printf "NTP,NTP Daemon,WARNING,sk92602 and sk83820\n" >> $csv_log
            ntp_error=1
            printf "NTP Daemon: Unable to talk to the NTP daemon.\n" >> $logfile
            printf '<span>Unable to talk to the NTP daemon.</span><br>\n' >> $html_file
        elif [[ $(grep -i "unsynchronised" $tmp_ntp) ]]; then
            result_check_failed
            printf "NTP,NTP Daemon,WARNING,sk92602 and sk83820\n" >> $csv_log
            ntp_error=1
            printf "NTP Daemon: NTP is not synchronized.\n" >> $logfile
            printf '<span>NTP is not synchronized.</span><br>\n' >> $html_file
        else
            result_check_failed
            printf "NTP,NTP Daemon,WARNING,sk92602 and sk83820\n" >> $csv_log
            ntp_error=1
            printf "NTP Daemon: Unable to determine NTP daemon status.\n" >> $logfile
            printf '<span>Unable to determine NTP daemon status.</span><br>\n' >> $html_file
        fi

        #Clean up temp file
        rm $tmp_ntp > /dev/null 2>&1

    #Display warning if ntpstat binary is not present
    else
        result_check_failed
        printf "NTP,NTP Daemon,WARNING,sk92602 and sk83820\n" >> $csv_log
        ntp_error=1
        printf "NTP Daemon: Unable to find ntpstat binary.\n" >> $logfile
        printf '<span>Unable to find ntpstat binary.</span><br>\n' >> $html_file
    fi

    #Log final NTP error
    if [[ $ntp_error -eq 1 ]]; then
        printf "\nNTP Information:\nPlease use sk92602 and sk83820 for assistance with verifying NTP is configured and functioning properly.\n" >> $logfile
        printf '<span>Please use sk92602 and sk83820 for assistance with verifying NTP is configured and functioning properly.</span><br><br>\n' >> $html_file
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset NTP Variables
    unset ntp_error
    unset tmp_ntp
}


#====================================================================================================
#  Application Processes Function
#====================================================================================================
check_processes()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Processes\t\t"

    #Collect application process information
    app_all_procs=$(ps aux)

    printf "\n\n\nTop Processes:\n" >> $full_output_log
    top -b -c -n1 >> $full_output_log

    #====================================================================================================
    #  Zombie Processes Check
    #====================================================================================================
    printf "| Processes\t\t| Zombie Processes\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Processes</b></span><br>\n' >> $html_file
    printf '<span><b>Zombie Processes - </b></span><b>' >> $html_file
    zombie_procs_list=$(echo "$app_all_procs" | grep defunct | grep -v grep | grep -v USER)
    zombie_procs_count=$(echo "$app_all_procs" | grep defunct | grep -v grep | grep -v USER | wc -l)
    if [[ $zombie_procs_count -gt 0 ]]; then
        result_check_failed
        printf "Processes,Zombie Processes,WARNING,\n" >> $csv_log
        printf "$zombie_procs_count zombie processes found.\n" >> $logfile
        printf "PID\tCOMMAND\n" >> $logfile
        printf "<span>$zombie_procs_count zombie processes found.<br>PID<tab>COMMAND</tab></span><br><br>\n<span>" >> $html_file
        while read -r i; do
            zpid=$(echo $i | awk '{print $2}')
            zcom=$(echo $i | awk '{print $11,$12,$13,$14,$15,$16,$17,$18,$19}')
            printf "$zpid\t$zcom\n" >> $logfile
            printf "$zpid<tab>$zcom</tab><br>" >> $html_file
        done <<< "$zombie_procs_list"
        printf "</span><br>\n" >> $html_file
        printf "\n" >> $logfile
    else
        result_check_passed
        printf "Processes,Zombie Processes,OK,\n" >> $csv_log
    fi

    #====================================================================================================
    #  Process Restarts Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Process Restarts\t\t|" | tee -a $output_log
    printf '<span><b>Process Restarts - </b></span><b>' >> $html_file

    #Store "cpwd_admin list" output
    cpwd_admin list > /var/tmp/proc_start_list.tmp 2> /dev/null
    printf "\nCPWD Admin List:\n" >> $full_output_log
    cat /var/tmp/proc_start_list.tmp >> $full_output_log
    restarted_procs=$(cat /var/tmp/proc_start_list.tmp | egrep -v 'APP|DASERVICE|LPD'  | awk -F] '{print $2}' | awk '{print $1}' | sort -u | wc -l)
    rm /var/tmp/proc_start_list.tmp > /dev/null 2>&1

    #Report results of the process check
    if [[ $restarted_procs -gt 1 ]]; then
        result_check_failed
        printf "Processes,Process Restarts,WARNING,\n" >> $csv_log
        printf "Restarted Process Warning: $restarted_procs different processes start times found.\n" >> $logfile
        printf "Review \"cpwd_admin list\" to locate the restarted processes.\n\n" >> $logfile
        printf "<span>Restarted Process Warning: $restarted_procs different processes start times found.<br>Review \"cpwd_admin list\" to locate the restarted processes.</span><br><br>\n" >> $html_file
    elif [[ $restarted_procs -eq 0 ]]; then
        result_check_failed
        printf "Processes,Process Restarts,WARNING,\n" >> $csv_log
        printf "Restated Process Fail:\n" >> $logfile
        printf "Unable to obtain list of process start times.\n" >> $logfile
        printf "Make sure the Check Point Processes are started and try again.\n" >> $logfile
        printf "<span>Restated Process Fail:<br>Unable to obtain list of process start times.<br>Make sure the Check Point Processes are started and try again.</span><br><br>\n" >> $html_file
    else
        result_check_passed
        printf "Processes,Process Restarts,OK,\n" >> $csv_log
    fi

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset Application Process variables
    unset app_all_procs
    unset zombie_procs_list
    unset zombie_procs_count
    unset zpid
    unset zcom
}


#====================================================================================================
#  RAID Function
#====================================================================================================
check_raid()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="RAID\t\t\t"

    #Log the full raid summary
    raid_summary=$(clish -c "raid_diagnostic")
    printf "\n\nRAID Drive Summary:\n" >> $full_output_log
    echo "$raid_summary" >> $full_output_log

    #Proceed with checks if there wasn't a failure collecting RAID status info
    if [[ ! $(echo "$raid_summary" | grep "Failed to get RAID status") ]]; then
        #====================================================================================================
        #  Volume State
        #====================================================================================================
        printf "| RAID\t\t\t| Volumes\t\t\t|" | tee -a $output_log
        printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>RAID</b></span><br>\n' >> $html_file
        printf '<span><b>Volumes - </b></span><b>' >> $html_file

        all_volume_state=$(echo "$raid_summary" | grep VolumeID | egrep -ow "State:[A-Z]*" | awk -F: '{print $NF}')
        raid_optimal=true
        for volume_state in $all_volume_state; do
            if [[ $volume_state != "OPTIMAL" ]]; then
                raid_optimal=false
            fi
        done

        if [[ $raid_optimal == true ]]; then
            result_check_passed
            printf "RAID,Volumes,OK,\n" >> $csv_log
        else
            result_check_failed
            printf "RAID,Volumes,WARNING,\n" >> $csv_log
            printf "RAID Volumes are not optimal.\n" >> $logfile
            printf "<span>RAID Volumes are not optimal.</span><br><br>\n" >> $html_file
        fi


        #====================================================================================================
        #  Physical Drives State
        #====================================================================================================
        printf "|\t\t\t| Physical Drives\t\t|" | tee -a $output_log
        printf '<span><b>Physical Drives - </b></span><b>' >> $html_file
        test_output_error=0

        #Loop through each drive slot
        raid_drives=$(echo "$raid_summary" | grep DiskID)
        while read raid_drive; do
            drive_state=$(echo "$raid_drive" | egrep -ow "State:[A-Z]*" | awk -F: '{print $NF}')
            drive_id=$(echo "$raid_drive" | egrep -ow "DiskID:[0-9]*" | awk -F: '{print $NF}')
            if [[ $drive_state != "ONLINE" ]];then
                result_check_failed
                printf "Physical Drive Error - Hard drive in slot $drive_id is $drive_state.\n" >> $logfile
                printf "<span>Physical Drive Error - Hard drive in slot $drive_id is $drive_state.</span><br>\n" >> $html_file
            fi
        done <<< "$raid_drives"

        if [[ $test_output_error -eq 0 ]]; then
            result_check_passed
            printf "RAID,Physical Drives,OK,\n" >> $csv_log
        else
            printf "RAID,Physical Drives,WARNING,\n" >> $csv_log
        fi

        #Clean up variables
        unset raid_drives
        unset drive_id
        unset drive_state
    fi
    unset raid_summary
}


#====================================================================================================
#  Smart-1 RAID Function
#====================================================================================================
check_raid_smart1()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Smart-1 RAID\t"

    #====================================================================================================
    #  Virtual Disk State
    #====================================================================================================
    printf "| Smart-1 RAID\t\t| Virtual Drives\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>Smart-1 RAID</b></span><br>\n' >> $html_file
    printf '<span><b>Virtual Drives - </b></span><b>' >> $html_file
    all_virtual_drives_state=$(/opt/MegaRAID/MegaCli/MegaCli -LDInfo -Lall -aALL | egrep ^State | awk '{print $NF}')
    raid_optimal=true
    for virtual_drive_state in $all_virtual_drives_state; do
        if [[ $virtual_drive_state != "Optimal" ]]; then
            raid_optimal=false
        fi
    done

    if [[ $raid_optimal == true ]]; then
        result_check_passed
        printf "Smart-1 RAID,Virtual Drives,OK,\n" >> $csv_log
    else
        result_check_failed
        printf "Smart-1 RAID,Virtual Drives,WARNING,\n" >> $csv_log
        printf "Virtual Drives in RAID Array are not optimal.\n" >> $logfile
        printf "<span>Virtual Drives in RAID Array are not optimal.</span><br><br>\n" >> $html_file
    fi


    #====================================================================================================
    #  Physical Drives State
    #====================================================================================================
    printf "|\t\t\t| Physical Drives\t\t|" | tee -a $output_log
    printf '<span><b>Physical Drives - </b></span><b>' >> $html_file
    test_output_error=0

    #Log the full raid summary
    raid_summary=$(/opt/MegaRAID/MegaCli/MegaCli  -ShowSummary -aAll)
    printf "\n\nSmart-1 RAID Drive Summary:\n" >> $full_output_log
    echo "$raid_summary" >> $full_output_log

    #Loop through each drive slot
    raid_slots=$(echo "$raid_summary" | egrep "Slot [0-9]{1,2}" | awk '{print $NF}')
    for physical_raid_slot in $raid_slots; do
        drive_state=$(echo "$raid_summary" | grep -A3 "Slot $physical_raid_slot" | grep State | awk '{print $NF}')
        if [[ $drive_state != "Online" ]];then
            result_check_failed
            printf "Physical Drive Error - Hard drive in slot $physical_raid_slot is $drive_state.\n" >> $logfile
            printf "<span>Physical Drive Error - Hard drive in slot $physical_raid_slot is $drive_state.</span><br>\n" >> $html_file
        fi
    done

    if [[ $test_output_error -eq 0 ]]; then
        result_check_passed
        printf "Smart-1 RAID,Physical Drives,OK,\n" >> $csv_log
    else
        printf "Smart-1 RAID,Physical Drives,WARNING,\n" >> $csv_log
    fi


    #====================================================================================================
    #  Backup Battery State
    #====================================================================================================
    printf "|\t\t\t| Backup Battery\t\t|" | tee -a $output_log
    printf '<span><b>Backup Battery - </b></span><b>' >> $html_file
    test_output_error=0

    #Log the full raid battery info
    battery_info=$(/opt/MegaRAID/MegaCli/MegaCli -AdpBbuCmd -aALL)
    printf "\n\nSmart-1 Battery Backup Info:\n" >> $full_output_log
    echo "$battery_info" >> $full_output_log

    #Loop through each drive slot
    battery_state=$(echo "$battery_info" | egrep "Battery State" | awk '{print $NF}')
    battery_charge_status=$(echo "$battery_info" | egrep "Charger Status" | awk '{print $NF}')
    battery_state_of_charge=$(echo "$battery_info" | egrep ^"Relative State of Charge" | awk '{print $(NF-1)}')
    if [[ $battery_state == "Optimal" ]]; then
        result_check_passed
        printf "Smart-1 RAID,Battery Backup,OK,\n" >> $csv_log
    elif [[ $(echo "$battery_info" | egrep "The required hardware component is not present.") ]]; then
        result_check_info
        printf "Smart-1 RAID,Battery Backup,Info,\n" >> $csv_log
        printf "Battery Backup Info - RAID battery is not present.\n" >> $logfile
        printf "<span>Battery Backup Info - RAID battery is not present.</span><br>\n" >> $html_file
    else
        result_check_failed
        printf "Smart-1 RAID,Battery Backup,WARNING,\n" >> $csv_log
        printf "Battery Backup Error - RAID battery is in $battery_state state.\n\tBattery charge status is $battery_charge_status with a charge state of $battery_state_of_charge.\n" >> $logfile
        printf "<span>Battery Backup Error - RAID battery is in $battery_state state.<br>Battery charge status is $battery_charge_status with a charge state of $battery_state_of_charge.</span><br>\n" >> $html_file
    fi

    #Clean up variables
    unset raid_summary
    unset raid_slots
    unset physical_raid_slot
    unset drive_state
    unset battery_info
    unset battery_state
    unset battery_charge_status
    unset battery_state_of_charge

    #Clean up temp files
    if [[ -e MegaSAS.log ]]; then
        rm MegaSAS.log
    fi
}


#====================================================================================================
#  SAR Data Function
#====================================================================================================
check_sar()
{
    #Start logging SAR section of the output
    printf "\n\n\n# SAR data:\n###########\n" >> $full_output_log
    sar_timestamp=$(date +%H:%M:%S)

    #Historical Processor Stats
    printf "#sar -P ALL -e $sar_timestamp:\n" >> $full_output_log
    sar -P ALL -e $sar_timestamp >> $full_output_log 2>&1

    #SWAP Stats
    printf "\n#sar -W 1 1:\n" >> $full_output_log
    sar -W 1 1 >> $full_output_log 2>&1
    printf "\nsar -W -e $sar_timestamp:\n" >> $full_output_log
    sar -W -e $sar_timestamp >> $full_output_log 2>&1

    #Disk Stats
    printf "\n#sar -p -d 1 1:\n" >> $full_output_log
    sar -p -d 1 1 >> $full_output_log 2>&1
    printf "\n#sar -p -d 1 1 -e $sar_timestamp:\n" >> $full_output_log
    sar -p -d -e $sar_timestamp >> $full_output_log 2>&1
}


#====================================================================================================
#  SecureXL stats Function
#====================================================================================================
check_securexl()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    fw_accel_error=/var/tmp/fw_accel_error
    current_check_message="SecureXL\t\t"

    #====================================================================================================
    #  SecureXL stats Check
    #====================================================================================================
    if [[ $offline_operations == true ]]; then
        fwaccel_stat=$(grep -A20 "FW-1 Accelerator status" $cpinfo_file)
        fwaccel_stats_s=$(grep -A15 "fwaccel stats -s" $cpinfo_file)
    else
        fwaccel_stat=$(fwaccel stat 2> $fw_accel_error)
        fwaccel_stats_s=$(fwaccel stats -s)
    fi
    accelerator_status=$(echo "$fwaccel_stat" | grep "Accelerator Status" | grep -Eo 'on|off')
    if [[ -z $accelerator_status ]]; then
        accelerator_status=$(echo "$fwaccel_stat" | sed 's/|//g' | grep ^0 | grep -Eo 'enabled|disabled')
    fi

    printf "| SecureXL\t\t| SecureXL Status\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>SecureXL</b></span><br>\n' >> $html_file
    printf '<span><b>SecureXL Status - </b></span><b>' >> $html_file

    #Display error if fwaccel stat is not able to be run
    if [[ -s $fw_accel_error ]]; then
        result_check_failed
        printf "SecureXL,SecureXL Status,ERROR,\n" >> $csv_log
        printf "SecureXL ERROR:\nThe \"fwaccel stat\" command resulted in an error.\n" >> $logfile
        printf "<span>The \"fwaccel stat\" command resulted in an error.</span><br><br>\n" >> $html_file
        rm $fw_accel_error > /dev/null 2>&1

    #Display warning if fwaccel is off
    elif [[ $accelerator_status == "off" ||  $accelerator_status == "disabled" ]]; then
        result_check_failed
        printf "\nSecureXL Information:\nAccelerator Status: Off\n" >> $full_output_log
        printf "SecureXL,SecureXL Status,WARNING,sk98722\n" >> $csv_log
        printf "SecureXL Notice:\nAccelerator is off. Please confirm if it is required to be left off by your organization.\n" >> $logfile
        printf "If Accelerator was not manually turned off for debugging purposes, use sk98722-ATRG:SecureXL.\n" >> $logfile
        printf "<span>Accelerator is off. Please confirm if it is required to be left off by your organization.<br>If Accelerator was not manually turned off for debugging purposes, use sk98722-ATRG:SecureXL.</span><br><br>\n" >> $html_file

    #Display check passed if fwaccel is on then perform additional checks
    elif [[ $accelerator_status == "on" ||  $accelerator_status == "enabled" ]]; then
        result_check_passed
        printf "SecureXL,SecureXL Status,OK,\n" >> $csv_log
        printf "\nSecureXL Information:\n" >> $full_output_log
        echo "$fwaccel_stat" >> $full_output_log 2>&1


        #====================================================================================================
        #  Accept Templates Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Accept Templates\t\t|" | tee -a $output_log
        printf '<span><b>Accept Templates - </b></span><b>' >> $html_file
        accept_templated_status=$(echo "$fwaccel_stat" | grep "Accept Templates" | grep -Eo 'disabled|enabled')
        if [[ $accept_templated_status == "enabled" ]]; then
            result_check_passed
            printf "SecureXL,Accept Templates,OK,\n" >> $csv_log
        elif [[ $accept_templated_status == "disabled" ]]; then
            result_check_failed

            #Check to see if accept templates were disabled by a specific rule
            if [[ $current_version -ge 8000 ]]; then
                accept_templated_disabled=$(echo "$fwaccel_stat" | sed -n '/Accept Templates/,/Drop Templates/p' | grep "disables template offloads from rule")
                if [[ $(echo accept_templated_disabled | wc -l) -ge 1 ]]; then
                    printf "SecureXL,Accept Templates,WARNING,sk32578\n" >> $csv_log
                    printf "SecureXL Notice:\nAccept Templates are disabled by the following rules:\n" >> $logfile
                    printf "<span>Accept Templates are disabled by the following rules:<br>" >> $html_file
                    while read rule; do
                        printf "$rule\n" >> $logfile
                        printf "$rule<br>" >> $html_file
                    done <<< "$accept_templated_disabled"
                    printf "Please review sk32578 to see what is causing these to be disabled.\n" >> $logfile
                    printf "Please review sk32578 to see what is causing these to be disabled.</span><br><br>\n" >> $html_file
                else
                    printf "SecureXL,Accept Templates,WARNING,sk98722\n" >> $csv_log
                    printf "SecureXL Notice:\nAccept Templates are disabled.\n" >> $logfile
                    printf "<span>Accept Templates are disabled.</span><br><br>\n" >> $html_file
                fi
            else
                accept_templated_disabled=$(echo "$fwaccel_stat" | grep -A1 "Accept Templates" | tail -n1 | grep disable | awk -F'from ' '{print $2}')
                if [[ $(echo $accept_templated_disabled | grep "rule") ]]; then
                    printf "SecureXL,Accept Templates,WARNING,sk32578\n" >> $csv_log
                    printf "SecureXL Notice:\nAccept Templates are disabled from $accept_templated_disabled.\nPlease review sk32578 to see what is causing these to be disabled.\n" >> $logfile
                    printf "<span>Accept Templates are disabled from $accept_templated_disabled.<br>Please review sk32578 to see what is causing these to be disabled.</span><br><br>\n" >> $html_file
                else
                    printf "SecureXL,Accept Templates,WARNING,sk98722\n" >> $csv_log
                    printf "SecureXL Notice:\nAccept Templates are disabled.\n" >> $logfile
                    printf "<span>Accept Templates are disabled.</span><br><br>\n" >> $html_file
                fi
            fi
        else
            result_check_failed
            printf "SecureXL,Accept Templates,WARNING,sk98722\n" >> $csv_log
            printf "SecureXL ERROR:\nUnable to determine if Accept Templates are enabled or disabled.\n" >> $logfile
            printf "<span>Unable to determine if Accept Templates are enabled or disabled.</span><br><br>\n" >> $html_file
        fi


        #====================================================================================================
        #  Drop Templates Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Drop Templates\t\t|" | tee -a $output_log
        printf '<span><b>Drop Templates - </b></span><b>' >> $html_file
        drop_templated_status=$(echo "$fwaccel_stat" | grep "Drop Templates")
        if [[ $drop_templated_status == *"enabled"* || $drop_templated_status == *"disabled by Firewall"*  ]]; then
            result_check_passed
            printf "SecureXL,Drop Templates,OK,\n" >> $csv_log
        elif [[ $drop_templated_status == *"disabled"* ]]; then
            result_check_info
            printf "SecureXL,Drop Templates,INFO,sk90861 and sk90941\n" >> $csv_log
            printf "SecureXL Notice:\nDrop Templates are disabled.\nAccelerated Drop Rules feature protects the Security Gateway and site from Denial of Service attacks by dropping packets at the acceleration layer.\nPlease review sk90861 and sk90941 for more information.\n" >> $logfile
            printf "<span>Drop Templates are disabled.<br>Accelerated Drop Rules feature protects the Security Gateway and site from Denial of Service attacks by dropping packets at the acceleration layer.<br>Please review sk90861 and sk90941 for more information.</span><br><br>\n" >> $html_file
        else
            result_check_failed
            printf "SecureXL,Drop Templates,WARNING,sk90861 and sk90941\n" >> $csv_log
            printf "SecureXL Notice:\nUnable to determine if Drop Templates are enabled or disabled.\n" >> $logfile
            printf "<span>Unable to determine if Drop Templates are enabled or disabled.</span><br><br>\n" >> $html_file
        fi


        #====================================================================================================
        #  F2F Check
        #====================================================================================================

        #Set cluster status to "Active" if the variable is blank (in the case of GW that is not part of a cluster)
        if [[ -z $cluster_status ]]; then
            cluster_status="Active"
        fi

        if [[ $(echo "$fwaccel_stats_s" | grep F2F) ]] && [[ $cluster_status == "Active" || $cluster_status == "Active Attention" || $cluster_status == "HA Module Not Started" ]]; then
            test_output_error=0
            printf "|\t\t\t| F2F Packets\t\t\t|" | tee -a $output_log
            printf '<span><b>F2F Packets - </b></span><b>' >> $html_file
            f2f_percent=$(echo "$fwaccel_stats_s" | grep F2F | awk -F\( '{print $2}' | awk -F\% '{print $1}')
            if [[ $f2f_percent -le 40  ]]; then
                result_check_passed
                printf "SecureXL,F2F Packets,OK,\n" >> $csv_log
            elif [[ $f2f_percent -ge 41 && $f2f_percent -le 60  ]]; then
                result_check_info
                printf "SecureXL,F2F Packets,INFO,sk98348\n" >> $csv_log
                printf "SecureXL Notice:\nF2F (firewall/slow path) packets account for $f2f_percent%% of all traffic.\n" >> $logfile
                printf "For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance\n" >> $logfile
                printf "<span>F2F (firewall/slow path) packets account for $f2f_percent%% of all traffic.<br>For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance</span><br><br>\n" >> $html_file
            else
                result_check_failed
                printf "SecureXL,F2F Packets,WARNING,sk98348\n" >> $csv_log
                printf "SecureXL WARNING:\nF2F (firewall/slow path) packets account for $f2f_percent%% of all traffic.\n" >> $logfile
                printf "For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance\n" >> $logfile
                printf "<span>F2F (firewall/slow path) packets account for $f2f_percent%% of all traffic.<br>For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance</span><br><br>\n" >> $html_file
            fi
        fi

        #====================================================================================================
        #  PXL Check
        #====================================================================================================
        if [[ $(echo "$fwaccel_stats_s" | grep PXL | grep -v Delayed) ]] && [[ $cluster_status == "Active" || $cluster_status == "Active Attention" ]]; then
            test_output_error=0
            printf "|\t\t\t| PXL Packets\t\t\t|" | tee -a $output_log
            printf '<span><b>PXL Packets - </b></span><b>' >> $html_file
            pxl_percent=$(echo "$fwaccel_stats_s" | grep PXL | grep -v Delayed | awk -F\( '{print $2}' | awk -F\% '{print $1}')
            if [[ $pxl_percent -le 40  ]]; then
                result_check_passed
                printf "SecureXL,PXL Packets,OK,\n" >> $csv_log
            elif [[ $pxl_percent -ge 41 && $pxl_percent -le 60  ]]; then
                result_check_info
                printf "SecureXL,PXL Packets,INFO,sk98348\n" >> $csv_log
                printf "SecureXL Notice:\nPXL (medium path) packets account for $pxl_percent%% of all traffic.\n" >> $logfile
                printf "For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance\n" >> $logfile
                printf "<span>PXL (medium path) packets account for $pxl_percent%% of all traffic.<br>For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance</span><br><br>\n" >> $html_file
            else
                result_check_failed
                printf "SecureXL,PXL Packets,WARNING,sk98348\n" >> $csv_log
                printf "SecureXL WARNING:\nPXL (medium path) packets account for $pxl_percent%% of all traffic.\n" >> $logfile
                printf "For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance\n" >> $logfile
                printf "<span>PXL (medium path) packets account for $pxl_percent%% of all traffic.<br>For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance</span><br><br>\n" >> $html_file
            fi
        fi

    else
        result_check_failed
        printf "SecureXL,SecureXL Status,WARNING,sk98722\n" >> $csv_log
        printf "SecureXL Information:\nUnable to determine accelerator status.\n\tPlease run \"fwaccel stat\" for further details.\n\n" >> $logfile
        printf "\nAccelerator Status: Unable to determine status.  Use sk98722-ATRG:SecureXL\n" >> $full_output_log
        printf "<span>An error has occurred and this script is unable to determine the accelerator status.<br><tab>Please run \"fwaccel stat\" for further details.</tab></span><br><br>\n" >> $html_file
    fi

    #Collect performance information of fwaccel
    if [[ $remote_operations == false ]]; then
        accelerator_table_status=$(fwaccel stats 2> /dev/null)
        printf "\n\nAcceleration Statistics:\n$accelerator_table_status\n" >> $full_output_log
    fi

    #====================================================================================================
    #  Aggressive Aging Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Aggressive Aging\t\t|" | tee -a $output_log
    printf '<span><b>Aggressive Aging - </b></span><b>' >> $html_file
    if [[ $offline_operations == true ]]; then
        agg_aging=$(grep -A50 '(fw ctl pstat)' $cpinfo_file | grep "Aggressive")
    else
        fw_ctl_pstat_error=/var/tmp/fw_ctl_pstat_error
        agg_aging=$(fw ctl pstat 2> $fw_ctl_pstat_error | grep Aggressive)
    fi
    printf "\nAggressive Aging:\n$agg_aging\n" >> $full_output_log

    #Display error if fw ctl pstat is unable to run
    if [[ -s $fw_ctl_pstat_error ]]; then
        result_check_failed
        printf "SecureXL,Aggressive Aging,ERROR,\n" >> $csv_log
        printf "Aggressive Aging ERROR:\nAn error was encountered while running \"fw ctl pstat\".\n" >> $logfile
        printf "<span>An error was encountered while running \"fw ctl pstat\".</span><br><br>\n" >> $html_file

    #Display check passed if aggressive aging is not active
    elif [[ $agg_aging == *"not active"* ]]; then
        result_check_passed
        printf "SecureXL,Aggressive Aging,OK,\n" >> $csv_log

    #Display warning if aggressive aging is disabled
    elif [[ $agg_aging == *"disabled"* ]]; then
        result_check_failed
        printf "SecureXL,Aggressive Aging,WARNING,\n" >> $csv_log
        printf "Aggressive Aging Warning:\nAggressive Aging has been set to Inactive in SmartDefence or IPS.\n" >> $logfile
        printf "<span>Aggressive Aging has been set to Inactive in SmartDefence or IPS.</span><br><br>\n" >> $html_file

    #Display warning if aggressive aging is in detect mode
    elif [[ $agg_aging == *"detect"* ]]; then
        result_check_failed
        printf "SecureXL,Aggressive Aging,WARNING,\n" >> $csv_log
        printf "Aggressive Aging Info:\nAggressive Aging is in Detect Mode.\n" >> $logfile
        printf "<span>Aggressive Aging is in Detect Mode.</span><br><br>\n" >> $html_file
    fi

    #Remove temp file
    rm -rf $fw_ctl_pstat_error > /dev/null 2>&1
    rm -rf $fw_accel_error > /dev/null 2>&1

    #Finish section in HTML
    printf '</p></td></tr>\n\n' >> $html_file

    #Unset SecureXL variables
    unset fwaccel_stat
    unset fwaccel_stats_s
    unset accelerator_status
    unset accept_templated_status
    unset accept_templated_disabled
    unset drop_templated_status
    unset accelerator_table_status
    unset agg_aging
    unset f2f_percent
    unset pxl_percent
}


#====================================================================================================
#  OS Version Info Function
#====================================================================================================
check_software()
{
    #Check OS version
    printf "\n\nVersion Information:\n" >> $full_output_log

    #Collect OS version
    operating_system=$(cat /etc/cp-release)
    printf "$operating_system\n" >> $full_output_log

    #Start hotfix information (Add a pause to ensure the hotfix info isn't empty)
    sleep 2
    printf "\n\nInstalled Hotfixes:\n" >> $full_output_log

    #Collect jumbo take version
    which installed_jumbo_take > /var/tmp/jumbo.tmp 2> /dev/null
    if [[ -n $(cat /var/tmp/jumbo.tmp) ]]; then
        installed_jumbo_take >> $full_output_log
    fi

    #Collect and clean up hotfix info
    script -c "cpinfo -y all" /var/tmp/cpinfo_script.tmp >> /dev/null
    sed -i "/^\s*$/d" /var/tmp/cpinfo_script.tmp
    sed -i "/------------------------/d" /var/tmp/cpinfo_script.tmp
    sed -i "/Hotfix versions/d" /var/tmp/cpinfo_script.tmp

    #Add hotfix info to the temp log then remove temp files
    cat /var/tmp/cpinfo_script.tmp | grep -v "Script " | grep -v Failed >> $full_output_log
    rm /var/tmp/cpinfo_script.tmp > /dev/null 2>&1
    rm /var/tmp/jumbo.tmp > /dev/null 2>&1

}


#====================================================================================================
#  System Info Function
#====================================================================================================
check_system()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="System\t\t"

    #====================================================================================================
    #  Uptime check
    #====================================================================================================
    printf "| System\t\t| Uptime\t\t\t|" | tee -a $output_log
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>System</b></span><br>\n' >> $html_file
    printf '<span><b>Uptime - </b></span><b>' >> $html_file
    up_time=$(uptime | awk '{print $3, $4}')
    echo $up_time  >> $full_output_log

    #Review days up
    if [[ $up_time == *"days"* ]]; then
        up_days=$(echo $up_time | awk '{print $1}')

        #Log OK if uptime is between 8 and 365 days
        if [[ $up_days -ge 8 && $up_days -lt 365 ]]; then
            result_check_passed
            printf "System,Uptime,OK,\n" >> $csv_log
        else
            #Display info if uptime is less than 7 days
            if [[ $up_days -le 7 ]]; then
                result_check_info
                printf "System,Uptime,INFO,\n" >> $csv_log
                printf "Uptime Info:\nThe system has been rebooted within the last week.\nPlease review \"/var/log/messages\" files (if they have not rolled over) if the system was not manually rebooted.\n" >> $logfile
                printf '<span>The system has been rebooted within the last week.<br>Please review "/var/log/messages" files (if they have not rolled over) if the system was not manually rebooted</span><br><br>\n' >> $html_file

            #Display WARNING if uptime is 1y+ or undetermined
            elif [[ $up_days -ge 365 ]]; then
                result_check_failed
                printf "System,Uptime,WARNING,\n" >> $csv_log
                printf "Uptime Warning:\nThe system has NOT been rebooted for over a year.\n" >> $logfile
                printf '<span>The system has NOT been rebooted for over a year.</span><br><br>\n' >> $html_file
            else
                result_check_failed
                printf "System,Uptime,WARNING,\n" >> $csv_log
                printf "Uptime Error:\nUnable to determine time since reboot.\n" >> $logfile
                printf '<span>Unable to determine time since reboot.</span><br><br>\n' >> $html_file
            fi
        fi
    else
        result_check_info
        printf "System,Uptime,INFO,\n" >> $csv_log
        printf "Uptime Check Info:\nThe system has been rebooted within the last week.\nPlease review \"/var/log/messages\" files (if they have not rolled over) if the system was not manually rebooted.\n" >> $logfile
        printf '<span>The system has been rebooted within the last week.<br>Please review "/var/log/messages" files (if they have not rolled over) if the system was not manually rebooted.</span><br><br>\n' >> $html_file
    fi


    #====================================================================================================
    #  OS Edition Check
    #====================================================================================================
    test_output_error=0
    cp_os_edition=$(clish -c 'show version os edition' | grep OS | awk '{print $3}')
    printf "|\t\t\t| OS Edition\t\t\t|" | tee -a $output_log
    printf '<span><b>OS Edition - </b></span><b>' >> $html_file

    #Review OS edition
    if [[ $cp_os_edition == "32-bit" ]]; then
        result_check_info
        printf "System,OS Edition,INFO,sk94627\n" >> $csv_log
        printf "OS Edition INFO:\nOperating System Edition is 32-bit.\n" >> $logfile
        printf "If we need to change OS edition to 64-bit, use sk94627.\n" >> $logfile
        printf '<span>Operating System Edition is 32-bit.<br>If we need to change OS edition to 64-bit, use sk94627.</span><br><br>\n' >> $html_file
    else
        result_check_passed
        printf "System,OS Edition,OK,\n" >> $csv_log
    fi
    printf "" >> $logfile

    #Check HostName
    host_name=$(hostname)
    printf "\n\nHost Name:\n$host_name\n" >> $full_output_log

    #Collect License Information
    cp_license=$(cplic print -x)
    printf "\n\nLicence Information:\n$cp_license\n" >> $full_output_log

    #Unset System Variables
    unset up_days
    unset up_time
    unset cp_os_edition
    unset host_name
    unset cp_license
}


#====================================================================================================
#  Function to Check for Updated script
#====================================================================================================
check_updates()
{
    #Check connectivity to the internet
    nc -z -w 3 supportcenter.checkpoint.com 443
    if [[ $? -eq 0 ]]; then
        #Set curl command
        if [[ -e /etc/cp-release ]]; then
            curl_cmd=$(which curl_cli)
        else
            curl_cmd=$(which curl)
        fi

        #Ensure curl command is present
        if [[ -n $curl_cmd ]]; then
            echo "Checking for script updates."
            #  Script Update
            #====================================================================================================
            #Pull down the download html page
            $curl_cmd -o $healthcheck_url_tmp 'https://supportcenter.checkpoint.com/supportcenter/portal/role/supportcenterUser/page/default.psml/media-type/html?action=portlets.DCFileAction&eventSubmit_doGetdcdetails=&fileid=59369' --insecure > /dev/null 2>&1

            #Find the version info for the local script and the latest one on the site
            latest_public_version=$(grep -A1 "File Revision" $healthcheck_url_tmp | grep "downloadDetailsItem" | awk '{print $3}' | awk -F'>' '{print $2}' | awk -F'<' '{print $1}')
            latest_public_major=$(echo $latest_public_version | awk -F'.' '{print $1}' | bc)
            latest_public_minor=$(echo $latest_public_version | awk -F'.' '{print $2}' | bc)
            local_major=$(echo $script_ver | awk '{print $1}' | awk -F'.' '{print $1}' | tr -dc '[:alnum:]\n\r' | sed 's\[a-zA-Z]\\' | bc)
            local_minor=$(echo $script_ver | awk '{print $1}' | awk -F'.' '{print $2}' | tr -dc '[:alnum:]\n\r' | sed 's\[a-zA-Z]\\' | bc)

            #Ensure the major and minor version is not blank
            if [[ -n $latest_public_major && -n $latest_public_minor ]]; then
                #Update the script if the latest major or minor version is higher.
                if [[ $latest_public_minor -gt $local_minor && $latest_public_major -eq $local_major ]] || [[ $latest_public_major -gt $local_major ]]; then
                    if [[ $update_requested == "true" ]];then
                        #Find the updated URL and MD5 hash for the latest script download
                        latest_url=$(grep "HashKey" $healthcheck_url_tmp | head -n1 | awk '{print $3}' | sed 's/href="//' | sed 's/">//')
                        latest_hash=$(echo $latest_url | awk -F/ '{print $6}')

                        #Download the latest script
                        $curl_cmd -o $healthcheck_download_temp $latest_url --insecure

                        #Ensure the md5 hash for the downloaded script is correct
                        if [[ $(md5sum $healthcheck_download_temp | cut -d " " -f1) == $latest_hash ]]; then
                            cp $healthcheck_download_temp $executed_script_path
                            chmod +x $executed_script_path
                            echo "The script has been updated successfully from SupportCenter."
                        else
                            echo "MD5 hash mismatch.  Failed to update the script."
                        fi
                    else
                        printf "The script is out of date:\n"
                        printf "Latest Script Version:  $latest_public_version\n"
                    fi
                else
                    #Only show script up to date if the -u flag was specified
                    if [[ $update_requested == "true" ]];then
                        echo "This script is already up to date."
                    fi
                fi
            else
                #Only show online check failed if -u flag was specified
                if [[ $update_requested == "true" ]];then
                    echo "Failed to determine latest online verison."
                fi
            fi


            #  Jumbo Version Update
            #====================================================================================================
            echo "Checking for CP software version updates."
            #Temp files
            r77_30_temp=/var/tmp/r77_30.tmp
            r80_10_temp=/var/tmp/r80_10.tmp
            r80_20_temp=/var/tmp/r80_20.tmp
            r80_30_temp=/var/tmp/r80_30.tmp
            r80_40_temp=/var/tmp/r80_40.tmp
            r81_temp=/var/tmp/r81.tmp
            r81_10_temp=/var/tmp/r81_10.tmp

            #Pull down each jumbo SK
            $curl_cmd -o $r77_30_temp 'https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk106162' --insecure > /dev/null 2>&1
            $curl_cmd -o $r80_10_temp 'https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk116380' --insecure > /dev/null 2>&1
            $curl_cmd -o $r80_20_temp 'https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk137592' --insecure > /dev/null 2>&1
            $curl_cmd -o $r80_30_temp 'https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk153152' --insecure > /dev/null 2>&1
            $curl_cmd -o $r80_40_temp 'https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk165456' --insecure > /dev/null 2>&1
            $curl_cmd -o $r81_temp 'https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk170114' --insecure > /dev/null 2>&1
            $curl_cmd -o $r81_10_temp 'https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk175186' --insecure > /dev/null 2>&1

            #Find the jumbo versions
            online_latest_R77_30=$(grep -i latest $r77_30_temp | grep -Eiow 'take_[0-9]{1,3}' | head -n1 | grep -Eo '[0-9]{1,3}')
            online_latest_R80_10=$(grep -i latest $r80_10_temp | grep -Eiow 'take_[0-9]{1,3}' | head -n1 | grep -Eo '[0-9]{1,3}')
            online_latest_R80_20=$(grep -i latest $r80_20_temp | grep -Eiow 'take_[0-9]{1,3}' | head -n1 | grep -Eo '[0-9]{1,3}')
            online_latest_R80_30=$(grep -i latest $r80_30_temp | grep -Eiow 'take_[0-9]{1,3}' | head -n1 | grep -Eo '[0-9]{1,3}')
            online_latest_R80_40=$(grep -i latest $r80_40_temp | grep -Eiow 'take_[0-9]{1,3}' | head -n1 | grep -Eo '[0-9]{1,3}')
            online_latest_R81=$(grep -i latest $r81_temp | grep -Eiow 'take_[0-9]{1,3}' | head -n1 | grep -Eo '[0-9]{1,3}')
            online_latest_R81_10=$(grep -i latest $r81_10_temp | grep -Eiow 'take_[0-9]{1,3}' | head -n1 | grep -Eo '[0-9]{1,3}')
            if [[ -z $online_latest_R81_10 ]]; then
                online_latest_R81_10="0"
            fi

            #Remove temp files
            rm -rf $r77_30_temp 2>/dev/null
            rm -rf $r80_10_temp 2>/dev/null
            rm -rf $r80_20_temp 2>/dev/null
            rm -rf $r80_30_temp 2>/dev/null
            rm -rf $r80_40_temp 2>/dev/null
            rm -rf $r81_temp 2>/dev/null
            rm -rf $r81_10_temp 2>/dev/null

            #Set versions
            if [[ $online_latest_R77_30 -gt $r7730_ga_jumbo ]]; then
                sed -i "s/r7730_ga_jumbo=\"${r7730_ga_jumbo}\"/r7730_ga_jumbo=\"${online_latest_R77_30}\"/" $executed_script_path
                r7730_ga_jumbo=$online_latest_R77_30
                echo "GA jumbo for R77.30 updated."
            fi
            if [[ $online_latest_R80_10 -gt $r8010_ga_jumbo ]]; then
                sed -i "s/r8010_ga_jumbo=\"${r8010_ga_jumbo}\"/r8010_ga_jumbo=\"${online_latest_R80_10}\"/" $executed_script_path
                r8010_ga_jumbo=$online_latest_R80_10
                echo "GA jumbo for R80.10 updated."
            fi
            if [[ $online_latest_R80_20 -gt $r8020_ga_jumbo ]]; then
                sed -i "s/r8020_ga_jumbo=\"${r8020_ga_jumbo}\"/r8020_ga_jumbo=\"${online_latest_R80_20}\"/" $executed_script_path
                r8020_ga_jumbo=$online_latest_R80_20
                echo "GA jumbo for R80.20 updated."
            fi
            if [[ $online_latest_R80_30 -gt $r8030_ga_jumbo ]]; then
                sed -i "s/r8030_ga_jumbo=\"${r8030_ga_jumbo}\"/r8030_ga_jumbo=\"${online_latest_R80_30}\"/" $executed_script_path
                r8030_ga_jumbo=$online_latest_R80_30
                echo "GA jumbo for R80.30 updated."
            fi
            if [[ $online_latest_R80_40 -gt $r8040_ga_jumbo ]]; then
                sed -i "s/r8040_ga_jumbo=\"${r8040_ga_jumbo}\"/r8040_ga_jumbo=\"${online_latest_R80_40}\"/" $executed_script_path
                r8040_ga_jumbo=$online_latest_R80_40
                echo "GA jumbo for R80.40 updated."
            fi
            if [[ $online_latest_R81 -gt $r81_ga_jumbo ]]; then
                sed -i "s/r81_ga_jumbo=\"${r81_ga_jumbo}\"/r81_ga_jumbo=\"${online_latest_R81}\"/" $executed_script_path
                r81_ga_jumbo=$online_latest_R81
                echo "GA jumbo for R81 updated."
            fi
            if [[ $online_latest_R81_10 -gt $r8110_ga_jumbo ]]; then
                sed -i "s/r8110_ga_jumbo=\"${r8110_ga_jumbo}\"/r8110_ga_jumbo=\"${online_latest_R81_10}\"/" $executed_script_path
                r8110_ga_jumbo=$online_latest_R81_10
                echo "GA jumbo for R81.10 updated."
            fi


            #  CPInfo Version Update
            #====================================================================================================
            #Temp file
            cpinfo_temp=/var/tmp/cpinfo_latest.tmp

            #Pull down cpinfo SK
            $curl_cmd -o $cpinfo_temp 'https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk92739' --insecure > /dev/null 2>&1

            #Find the latest version
            online_latest_cpinfo=$(grep -i "cpinfo package was replaced" $cpinfo_temp | sed 's/<strong>//g' | grep -Eow "build [0-9]{1,9}" | grep -Eow "[0-9]{1,9}" | sort -n | tail -n1)

            #Remove temp files
            rm -rf $cpinfo_temp 2>/dev/null

            #Set versions
            if [[ $online_latest_cpinfo -gt $latest_cpinfo_build ]]; then
                sed -i "s/latest_cpinfo_build=\"${latest_cpinfo_build}\"/latest_cpinfo_build=\"${online_latest_cpinfo}\"/" $executed_script_path
                latest_cpinfo_build=$online_latest_cpinfo
                echo "CPInfo version updated."
            fi


            #  CPUSE Version Update
            #====================================================================================================
            #Temp file
            cpuse_temp=/var/tmp/cpuse_temp.tmp

            #Pull down cpuse SK
            $curl_cmd -o $cpuse_temp 'https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk92449' --insecure > /dev/null 2>&1

            #Find the latest version
            online_latest_cpuse=$(grep "Latest build of CPUSE" $cpuse_temp | sed 's/\&nbsp;/ /g' | grep -Eiow 'Build [0-9]{1,5}' | grep -Eiow '[0-9]{1,5}' | sort -n | tail -n1)

            #Remove temp files
            rm -rf $cpuse_temp 2>/dev/null

            #Set versions
            if [[ $online_latest_cpuse -gt $latest_cpuse_build ]]; then
                sed -i "s/latest_cpuse_build=\"${latest_cpuse_build}\"/latest_cpuse_build=\"${online_latest_cpuse}\"/" $executed_script_path
                latest_cpuse_build=$online_latest_cpuse
                echo "CPUSE version updated."
            fi
        else
            echo "Unable to contact Check Point servers for updates."
            echo "Please check your internet connectivity and try again."
        fi

        #File cleanup
        rm $healthcheck_url_tmp > /dev/null 2>&1
        rm $healthcheck_download_temp > /dev/null 2>&1

        #Exit the script if -u flag was specified
        if [[ $update_requested == "true" ]];then
            #Update the installed script
            script_install
            
            #Exit the script
            temp_file_cleanup
        fi
    fi
}


#====================================================================================================
#  VSX Stuff
#====================================================================================================
check_vsx()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    vsx_error_file=/var/tmp/vsx_error
    current_check_message="VSX\t\t\t"
    printf '<tr class="sectionTableBorder"><td class="sectionTableBorder"><p class="paragraphSpacing"><span class="checkNameBlue"><b>VSX</b></span><br>\n' >> $html_file

    #VS specific information
    vsx_stat=$(vsx stat $vs)
    vsx_type=$(echo "$vsx_stat" | grep Type: | awk '{print $3}') # Gateway, Switch, System, or Router
    vsx_policy=$(echo "$vsx_stat" | grep "Security Policy:" | awk '{print $3, $4}') #Policy name, <No Policy>, <Not Applicable>, or <Default Policy>
    vsx_sic=$(echo "$vsx_stat" | grep "SIC Status:" | awk '{print $3, $4}') #Trust or "No Trust"

    #====================================================================================================
    #  VS0 Checks
    #====================================================================================================
    if [[ $vs -eq 0 ]]; then
        #VSX information
        vs0_info=$(vsx stat)
        vs_allowed=$(echo "$vs0_info" | grep "allowed by license" | awk '{print $8}')
        vs_active=$(echo "$vs0_info" | grep 'Virtual Systems \[active' | awk '{print $6}')
        vs_configured=$(echo "$vs0_info" | grep 'Virtual Systems \[active' | awk '{print $8}')
        vrs_active=$(echo "$vs0_info" | grep 'Virtual Routers and Switches' | awk '{print $8}')
        vrs_configured=$(echo "$vs0_info" | grep 'Virtual Routers and Switches' | awk '{print $10}')
        vsx_configured=$(( vs_configured + vrs_configured ))

        #====================================================================================================
        #  VS License Check
        #====================================================================================================
        printf "| VSX\t\t\t| VSX Licenses\t\t\t|" | tee -a $output_log
        printf '<span><b>VSX Licenses - </b></span><b>' >> $html_file

        #Check the number of configured VSs vs the licensed limit
        if [[ $vs_allowed -gt $vs_configured ]]; then
            result_check_passed
            printf "VSX,VSX Licenses,OK,\n" >> $csv_log
        elif [[ $vs_allowed -eq $vs_configured ]]; then
            result_check_info
            printf "VSX,VSX Licenses,INFO,\n" >> $csv_log
            printf "VS Licenses - The number of configured Virtual Devices has reached the licensed limit.\nPlease contact your sales team to get additional licenses if more virtual devices are planned.\n" >> $logfile
            printf "<span>The number of configured Virtual Devices has reached the licensed limit</br>Please contact your sales team to get additional licenses if more virtual devices are planned.</span><br><br>\n" >> $html_file
        else
            result_check_failed
            printf "VSX,VS Licenses,ERROR,\n" >> $csv_log
            printf "VS Licenses - The number of configured Virtual Devices has exceeded the licensed limit.\nPlease contact your sales team to get additional licenses.\n" >> $logfile
            printf "<span>The number of configured Virtual Devices has exceeded the licensed limit.</br>Please contact your sales team to get additional licenses.</span><br><br>\n" >> $html_file
        fi

        #====================================================================================================
        #  VS Configured Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Virtual Systems\t\t|" | tee -a $output_log
        printf '<span><b>Virtual Systems - </b></span><b>' >> $html_file

        #Display error if the SIC state is something other than "Trust"
        if [[ $vs_active -eq $vs_configured ]]; then
            result_check_passed
            printf "VSX,Virtual Systems,OK,\n" >> $csv_log
        else
            result_check_failed
            printf "VSX,Virtual Systems,ERROR,\n" >> $csv_log
            printf "Virtual Systems - The number of active Virtual Systems is less than the number configured.\n" >> $logfile
            printf "<span>The number of active Virtual Systems is less than the number configured.</span><br><br>\n" >> $html_file
        fi

        #====================================================================================================
        #  Virtual Swiches and Routers Configured Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Routers and Switches\t\t|" | tee -a $output_log
        printf '<span><b>Routers and Switches - </b></span><b>' >> $html_file

        #Display error if the SIC state is something other than "Trust"
        if [[ $vrs_active -eq $vrs_configured ]]; then
            result_check_passed
            printf "VSX,Routers and Switches,OK,\n" >> $csv_log
        else
            result_check_failed
            printf "VSX,Routers and Switches,ERROR,\n" >> $csv_log
            printf "Virtual Routers and Switches - The number of active Virtual Routers and Switches is less than the number configured.\n" >> $logfile
            printf "<span>The number of active Virtual Systems is less than the number configured.</span><br><br>\n" >> $html_file
        fi
    fi

    #====================================================================================================
    #  SIC Status Check
    #====================================================================================================
    test_output_error=0
    if [[ $vs -eq 0 ]]; then
        printf "|\t\t\t| SIC Status\t\t\t|" | tee -a $output_log
    else
        printf "| VSX\t\t\t| SIC Status\t\t\t|" | tee -a $output_log
    fi
    printf '<span><b>SIC Status - </b></span><b>' >> $html_file

    #Display error if the SIC state is something other than "Trust"
    if [[ $vsx_sic == "Trust"* ]]; then
        result_check_passed
        printf "VSX,SIC Status,OK,\n" >> $csv_log
    else
        result_check_failed
        printf "VSX,SIC Status,ERROR,sk34098\n" >> $csv_log
        printf "SIC status -  VS $vs is $vsx_sic.\n" >> $logfile
        printf "For information on how to reset VSX SIC, use sk34098: How to reset SIC on a VSX Gateway for a specific Virtual System\n" >> $logfile
        printf "<span>VS $vs is $vsx_sic.</br>For information on how to reset VSX SIC, use sk34098: How to reset SIC on a VSX Gateway for a specific Virtual System</span><br><br>\n" >> $html_file
    fi

    #====================================================================================================
    #  Security Policy Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Security Policy\t\t|" | tee -a $output_log
    printf '<span><b>Security Policy - </b></span><b>' >> $html_file

    #Virtual System and Gateway
    if [[ $vsx_type == "System" || $vsx_type == "Gateway" ]]; then
        if [[ $vsx_policy == "InitialPolicy"* ]]; then
            result_check_failed
            printf "VSX,Security Policy,ERROR,\n" >> $csv_log
            printf "Security Policy - Initial Policy detected on VS: $vs.\nPlease install a Security Policy from the Management Server.\n" >> $logfile
            printf "<span>Initial Policy detected on VS: $vs.</br>Please install a Security Policy from the Management Server.</span><br><br>\n" >> $html_file
        elif [[ $vsx_policy == "<No Policy>" ]]; then
            result_check_failed
            printf "VSX,Security Policy,ERROR,\n" >> $csv_log
            printf "Security Policy - No Policy detected on VS: $vs.\nPlease install a Security Policy from the Management Server.\n" >> $logfile
            printf "<span>No Policy detected on VS: $vs.</br>Please install a Security Policy from the Management Server.</span><br><br>\n" >> $html_file
        else
            result_check_passed
            printf "VSX,Security Policy,OK,\n" >> $csv_log
        fi
    fi

    #Virtual Router
    if [[ $vsx_type == "Router" ]]; then
        if [[ $vsx_policy == "<Default Policy>" ]]; then
            result_check_passed
            printf "VSX,Security Policy,OK,\n" >> $csv_log
        else
            result_check_failed
            if [[ $current_version -le 7730 ]]; then
                printf "VSX,Security Policy,ERROR,sk43736\n" >> $csv_log
                printf "Security Policy - Default policy not detected on Virtual Router VSID: $vs.\nContact support for assistance to use internal sk43736: How to restore or reload the default policy on a Virtual Router\n" >> $logfile
                printf "<span>Default policy not detected on Virtual Router VSID: $vs.</br>Contact support for assistance to use internal sk43736: How to restore or reload the default policy on a Virtual Router.</span><br><br>\n" >> $html_file
            else
                printf "VSX,Security Policy,ERROR,\n" >> $csv_log
                printf "Security Policy - Default policy not detected on Virtual Router VSID: $vs.\n" >> $logfile
                printf "<span>Default policy not detected on Virtual Router VSID: $vs.</span><br><br>\n" >> $html_file
            fi
        fi
    fi

    #Virtual Switch
    if [[ $vsx_type == "Switch" ]]; then
        if [[ $vsx_policy == "<Not Applicable>" ]]; then
            result_check_passed
            printf "VSX,Security Policy,OK,\n" >> $csv_log
        else
            result_check_failed
            printf "VSX,Security Policy,ERROR,\n" >> $csv_log
            printf "Securit Policy - Somehow a policy has been detected on Virtual Switch VSID: $vs.\n" >> $logfile
            printf "<span>Somehow a policy has been detected on Virtual Switch VSID: $vs.</span><br><br>\n" >> $html_file
        fi
    fi
}


#====================================================================================================
#  Confirm Domain Name Function
#====================================================================================================
confirm_domain_name()
{
    #Loop through asking for a valid domain name until one is specified
    domain_valid=false
    until [[ $domain_valid == true ]]; do

        #Set domain_valid to true to exit the loop if domain name is valid
        if [[ $(mgmt_cli show domains -s $mds_id limit 500 --format json | jq ".objects[].name" -r | grep -w ^$domain$) == $domain ]]; then
            domain_valid=true

        #Prompt the user if the domain name is not valid
        else
            #Set Domain Names to array IDs for later selection
            domain_name_id=0
            for current_domain in $(mgmt_cli show domains -s $mds_id limit 500 --format json | jq ".objects[].name" -r); do
                domain_array[$domain_name_id]=$current_domain
                ((domain_name_id++))
            done

            #Loop through displaying the gateway array until a valid device is selected
            domain_arrayLength=${#domain_array[@]}
            domain_selection_clean=0
            error_message="\n"
            until [[ $domain_selection_clean -ge 1 && $domain_selection_clean -le $domain_arrayLength ]]; do
                domain_name_id=1
                array_id=0
                printf "Available Domains:\n"
                while [[ $domain_name_id -le $domain_arrayLength ]]; do
                    printf "$domain_name_id) ${domain_array[$array_id]}\n"
                    ((domain_name_id++))
                    ((array_id++))
                done
                printf "$error_message"
                read -e -p "Select a Domain containing the device to remotely execute a health check [1-$domain_arrayLength]: " domain_selection
                domain_selection_clean=$(echo $domain_selection |  sed 's/[^0-9]//g')
                if [[ $domain_selection_clean -ge 1 && $domain_selection_clean -le $domain_arrayLength ]]; then
                    ((domain_selection_clean--))
                    domain=${domain_array[$domain_selection_clean]}
                    ((domain_selection_clean++))
                else
                    error_message="That is not a valid option.  Please choose a number between 1 and $array_id.\n"
                    clear
                fi
            done
        fi
    done
}


#====================================================================================================
#  Function to display summary of checks
#====================================================================================================
display_summary()
{
    #Display summary
    if [[ $all_checks_passed == true ]]; then
        printf "All checks have successfully passed.\n\n" >> $logfile
        cat $logfile

    #Add color to section headers and category titles before displaying
    else
        #Create temp file
        category_list=/var/tmp/category_list
        header_list=/var/tmp/header_list

        #Duplicate logfile
        cp $logfile $logfile.tmp

        #Assign INFO or WARNING category names to an array
        category_array_id=0
        cat $logfile.tmp | grep '|' | awk -F'|' '{print $2}' 2>/dev/null | awk '{print $1, $2}' | sed '/^$/d' 2> /dev/null > $category_list
        while read category_name; do
            category_array[$category_array_id]=$category_name
            ((category_array_id++))
        done < $category_list
        category_array_Length=${#category_array[@]}

        #Parse array IDs and adding color
        category_id=1
        category_array_id=0
        while [[ $category_id -le $category_array_Length ]]; do
            sed -i "s/| ${category_array[$category_array_id]}/| ${text_blue}${category_array[$category_array_id]}${text_reset}/g" $logfile.tmp 2> /dev/null
            ((category_id++))
            ((category_array_id++))
        done

        #Assign Headers to an array
        header_array_id=0
        cat $logfile.tmp | grep '#' | awk -F'#' '{print $2}' 2>/dev/null | awk '{print $1, $2, $3, $4}' | egrep [a-zA-Z] > $header_list
        while read header_name; do
            header_array[$header_array_id]=$header_name
            ((header_array_id++))
        done < $header_list
        header_array_Length=${#header_array[@]}

        #Parse array IDs and adding color
        header_id=1
        header_array_id=0
        while [[ $header_id -le $header_array_Length ]]; do
            sed -i "s/${header_array[$header_array_id]}/${text_pink}${header_array[$header_array_id]}${text_reset}/g" $logfile.tmp 2> /dev/null
            ((header_id++))
            ((header_array_id++))
        done

        #Display logfile with colors
        wait
        cat $logfile.tmp

        #Remove temp files
        rm -rf $logfile.tmp > /dev/null 2>&1
        rm -rf $category_list > /dev/null 2>&1
        rm -rf $header_list > /dev/null 2>&1
    fi

    #Consolidate and clean up logs
    wait
    cat $output_log >> $logfile
    wait
    cat $full_output_log >> $logfile
    rm $output_log > /dev/null 2>&1
    rm $full_output_log > /dev/null 2>&1

    #Tar up files if the system is running in offline mode and a archive path is supplied
    if [[ -n $output_archive && $offline_operations == true ]]; then
        tar -czvf $output_archive $html_file $logfile $csv_log > /dev/null 2>&1
        rm -rf $html_file > /dev/null 2>&1
        rm -rf $logfile > /dev/null 2>&1
        rm -rf $csv_log > /dev/null 2>&1
    fi

    #Log completion
    printf "\n\n# Output Files:\n"
    printf "#########################\n"
    printf "A report with the above output and the results from each command run has been saved to the following log files:\n"
    printf "$logfile\n"
    printf "$html_file\n"
    printf "$csv_log\n\n"
}


#====================================================================================================
#  Finish the bottom of the HTML report
#====================================================================================================
finalize_html()
{
    echo -e '
</tbody></table>
</div>
<br><hr class="PinkBottomBorderLast">
<a class="linkColor" target="_blank" style="padding-top:11; padding-bottom:16" href="https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk121447">Get the latest version of this script from sk121447</a><br><br>
</center></center></body></html>' >> $html_file
}


#====================================================================================================
#  Create the header information for the HTML report
#====================================================================================================
initialize_html()
{
    echo -e '<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<style type="text/css">
body{padding-right:40px; padding-left:40px; font-family:sans-serif; color:#333333; font-size:14px}
.hostnameTeal {font-size:28px; color:#66CCCC; font-weight:light; margin-top:6px}
.dateGreen {font-size:28px; color:#56B40A; font-weight:light; margin-top:6px}
.Red {font-size:32px; color:#e54848; font-weight:light; margin-top:6px}
.Yellow {font-size:32px; color:#fba50f; font-weight:light; margin-top:6px}
.Green {font-size:32px; color:#56B40A; font-weight:light; margin-top:6px}
.Pink {font-size:32px; color:#fb7990; font-weight:light; margin-top:6px}
.PinkTopBorder {border-style: solid;border-width: 5px; margin-top:0 ;border-color:#e65886; width:770px}
.PinkBottomBorderLast {border-style: solid;border-width: 2px; border-color:#e65886;margin-top:7}
.transperantTableBorder {border: 1px solid #ececec; border-collapse:collapse}
.healthCheckTableBorder {margin-top:32;border: 1px solid white;border-collapse:collapse}
.sectionTable {min-width:676px;margin-right:20;float left}
.sectionRed {font-size:22px; color:#ec3939; padding-left:20; padding-bottom:15px}
.sectionYellow {font-size:22px; color:#fba50f; padding-left:20; padding-bottom:15px}
.sectionBlue {font-size:22px; color:#3b8fd6; padding-left:20; padding-bottom:15px}
.sectionPink {font-size:22px; color:#fb7990; padding-left:20; padding-bottom:15px}
.verticalRedLine {border-left: solid #ec3939; border-width:4;margin-left:40; margin-top:10}
.verticalYellowLine {border-left: solid #fba50f; border-width:4;margin-left:40; margin-top:10}
.verticalBlueLine {border-left: solid #3b8fd6; border-width:4;margin-left:40; margin-top:10}
.checkFailed {font-size:14; color:#ec3939}
.checkInfo {font-size:14; color:#fba50f}
.checkOK {font-size:14; color:#07f907}
.checkNameBlue {font-size:14; color:#3b8fd6}
.sectionTableBorder {padding-top:20; font-size:12}
.linkColor {color:#3594ff; font-size:14; text-decoration:none}
.paragraphSpacing {line-height: 160%}
#mainBodyBackground {background-color:#ececec}
#centeryBackground {background-color:white; margin-top:-8; width:780px}
#logoColumnWidth {width:400}
tab {margin-left: 5em;}
a:hover {text-decoration: underline;}
table, th, td {font-size 14px; font-weight: normal;border-collapse:collapse}
th, td {padding-top: 11px; padding-bottom: 11px;text-align:left; max-width:400; vertical-align:top; font-size:14px;font-weight: normal;border-bottom: 1px solid #cecece; border-collapse:collapse;}
table th    {color:#333333;font-size:14px;}
</style>
</head>
<body id="mainBodyBackground">
<center>
<table>
<tbody><tr class="transperantTableBorder">
<td class="transperantTableBorder"><img id="transperantTableBorder" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNTcuNjMiIGhlaWdodD0iMTMuMTU3IiB2aWV3Qm94PSIwIDAgMTU3LjYzIDEzLjE1NyI+CiAgPGRlZnM+CiAgICA8c3R5bGU+CiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogI2U0NTc4NTsKICAgICAgICBmaWxsLXJ1bGU6IGV2ZW5vZGQ7CiAgICAgIH0KICAgIDwvc3R5bGU+CiAgPC9kZWZzPgogIDxwYXRoIGlkPSJPbmVfU3RlcF9BaGVhZF8iIGRhdGEtbmFtZT0iT25lIFN0ZXAgQWhlYWQgIiBjbGFzcz0iY2xzLTEiIGQ9Ik0xMTg2LjA0LDkzLjk4MWMwLTIuMjgzLS4wNy0zLjE1Mi0xLjAxLTQuMDlhMy4zNzIsMy4zNzIsMCwwLDAtMi40OC0uOTgxLDMuNDI4LDMuNDI4LDAsMCwwLTIuNDkuOTgxYy0wLjk0LjkzOC0xLDEuODA3LTEsNC4wOXMwLjA2LDMuMTUyLDEsNC4wOWEzLjQyOSwzLjQyOSwwLDAsMCwyLjQ5Ljk4MSwzLjM3MiwzLjM3MiwwLDAsMCwyLjQ4LS45ODFDMTE4NS45Nyw5Ny4xMzMsMTE4Ni4wNCw5Ni4yNjQsMTE4Ni4wNCw5My45ODFabS0xLjA2LDBjMCwyLjA0NS0uMDcsMi43NzMtMC43LDMuNDE4YTIuNCwyLjQsMCwwLDEtMS43My43LDIuMzYxLDIuMzYxLDAsMCwxLTEuNzItLjdjLTAuNjMtLjY0NC0wLjctMS4zNzMtMC43LTMuNDE4czAuMDctMi43NzMuNy0zLjQxOGEyLjM2MSwyLjM2MSwwLDAsMSwxLjcyLS43LDIuNCwyLjQsMCwwLDEsMS43My43QzExODQuOTEsOTEuMjA4LDExODQuOTgsOTEuOTM2LDExODQuOTgsOTMuOTgxWm0xMy41Niw0Ljk4N1Y5NC41NTZhMi41NDUsMi41NDUsMCwwLDAtLjcxLTEuOTE5LDIuNDMxLDIuNDMxLDAsMCwwLTEuNzctLjY0NCwyLjQ3OCwyLjQ3OCwwLDAsMC0xLjkzLjg0MVY5Mi4wNzZoLTEuMDF2Ni44OTJoMS4wMVY5NC43MjRhMS43LDEuNywwLDEsMSwzLjQsMHY0LjI0NGgxLjAxWm0xMi40OS0zLjE4Vjk1LjM0YzAtMi4wNzMtMS4wNC0zLjM0OC0yLjgzLTMuMzQ4LTEuNzUsMC0yLjgzLDEuMjg5LTIuODMsMy41MywwLDIuNDM3LDEuMTgsMy41MywzLjAxLDMuNTNhMy4xNzcsMy4xNzcsMCwwLDAsMi41Mi0xLjA2NWwtMC42OC0uNmEyLjI3MiwyLjI3MiwwLDAsMS0xLjgxLjc4NGMtMS4zMywwLTIuMDMtLjg2OC0yLjAzLTIuMzgxaDQuNjVabS0xLS43NTZoLTMuNjVhMi42MywyLjYzLDAsMCwxLC4yMS0xLjE0OSwxLjc2OSwxLjc2OSwwLDAsMSwzLjIyLDBBMi43NywyLjc3LDAsMCwxLDEyMTAuMDMsOTUuMDMyWm0yMi4zNCwxLjE5MWEyLjUyLDIuNTIsMCwwLDAtLjg0LTEuOTYxLDMuMDM1LDMuMDM1LDAsMCwwLTEuODEtLjcxNGwtMS4xNi0uMTgyYTIuNzE3LDIuNzE3LDAsMCwxLTEuMzEtLjUxOCwxLjQ2NSwxLjQ2NSwwLDAsMS0uNDUtMS4xNjMsMS44NTcsMS44NTcsMCwwLDEsMi4xMi0xLjg2MywzLjExMywzLjExMywwLDAsMSwyLjMzLjg2OWwwLjY4LS42ODZhNC4wNDYsNC4wNDYsMCwwLDAtMi45Ny0xLjA5M2MtMS45NywwLTMuMTksMS4xMDctMy4xOSwyLjhhMi4zNTgsMi4zNTgsMCwwLDAsLjc3LDEuODc3LDMuNTI3LDMuNTI3LDAsMCwwLDEuODIuNzU2bDEuMTYsMC4xNjhhMi4xLDIuMSwwLDAsMSwxLjMuNDksMS41NiwxLjU2LDAsMCwxLC41LDEuMjQ3YzAsMS4xNzctLjksMS44NDktMi4zNywxLjg0OWEzLjQyNSwzLjQyNSwwLDAsMS0yLjcyLTEuMDc5bC0wLjcxLjcxNGE0LjMxLDQuMzEsMCwwLDAsMy40LDEuMzE3QzEyMzEuMDEsOTkuMDUyLDEyMzIuMzcsOTcuOTczLDEyMzIuMzcsOTYuMjIyWm05LjQ0LDIuNzQ2Vjk4LjFoLTAuNTNhMC44NzQsMC44NzQsMCwwLDEtLjk0LTEuMDA4VjkyLjg0N2gxLjQ3di0wLjc3aC0xLjQ3Vjg5Ljk2MWgtMS4wMXYyLjExNWgtMC44NnYwLjc3aDAuODZ2NC4yNzJhMS42OTIsMS42OTIsMCwwLDAsMS43NywxLjg0OWgwLjcxWm0xMS45OC0zLjE4Vjk1LjM0YzAtMi4wNzMtMS4wNC0zLjM0OC0yLjgzLTMuMzQ4LTEuNzYsMC0yLjgzLDEuMjg5LTIuODMsMy41MywwLDIuNDM3LDEuMTcsMy41MywzLjAxLDMuNTNhMy4xNzcsMy4xNzcsMCwwLDAsMi41Mi0xLjA2NWwtMC42OS0uNmEyLjI1MiwyLjI1MiwwLDAsMS0xLjguNzg0Yy0xLjMzLDAtMi4wNC0uODY4LTIuMDQtMi4zODFoNC42NlptLTEtLjc1NmgtMy42NmEyLjc4NCwyLjc4NCwwLDAsMSwuMjEtMS4xNDksMS43NzYsMS43NzYsMCwwLDEsMy4yMywwQTIuOTQxLDIuOTQxLDAsMCwxLDEyNTIuNzksOTUuMDMyWm0xMy4zNywwLjQ5YTQuMSw0LjEsMCwwLDAtLjg0LTIuOTI4LDIuMzc0LDIuMzc0LDAsMCwwLTEuNjgtLjYsMi4yNDEsMi4yNDEsMCwwLDAtMS45NS45VjkyLjA3NmgtMS4wMXY5Ljk3NGgxLjAxVjk4LjE1NWEyLjI1MiwyLjI1MiwwLDAsMCwxLjk1LjksMi4zNzQsMi4zNzQsMCwwLDAsMS42OC0uNkE0LjEyNSw0LjEyNSwwLDAsMCwxMjY2LjE2LDk1LjUyMlptLTEuMDEsMGMwLDEuMzQ1LS4yMiwyLjYzMy0xLjcyLDIuNjMzcy0xLjc0LTEuMjg5LTEuNzQtMi42MzMsMC4yMy0yLjYzMywxLjc0LTIuNjMzUzEyNjUuMTUsOTQuMTc3LDEyNjUuMTUsOTUuNTIyWm0yMy4zLDMuNDQ2LTMuNjYtOS45NzNoLTAuODlsLTMuNjcsOS45NzNoMS4xM2wwLjgtMi4yNTVoNC4zNmwwLjgsMi4yNTVoMS4xM1ptLTIuMjQtMy4xOGgtMy43M2wxLjg4LTUuMjY3Wm0xMy44NSwzLjE4Vjk0LjU0MmEyLjMyNywyLjMyNywwLDAsMC0yLjQ4LTIuNTQ5LDIuNSwyLjUsMCwwLDAtMS45NC44NDFWODguOTk1aC0xLjAxdjkuOTczaDEuMDFWOTQuNzFhMS42MTIsMS42MTIsMCwwLDEsMS43My0xLjgyMSwxLjU3OCwxLjU3OCwwLDAsMSwxLjY4LDEuODIxdjQuMjU4aDEuMDFabTEyLjQ4LTMuMThWOTUuMzRjMC0yLjA3My0xLjAzLTMuMzQ4LTIuODMtMy4zNDgtMS43NSwwLTIuODMsMS4yODktMi44MywzLjUzLDAsMi40MzcsMS4xOCwzLjUzLDMuMDIsMy41M2EzLjE3NywzLjE3NywwLDAsMCwyLjUyLTEuMDY1bC0wLjY5LS42YTIuMjcyLDIuMjcyLDAsMCwxLTEuODEuNzg0Yy0xLjMzLDAtMi4wMy0uODY4LTIuMDMtMi4zODFoNC42NVptLTAuOTktLjc1NmgtMy42NmEyLjYzLDIuNjMsMCwwLDEsLjIxLTEuMTQ5LDEuNzM1LDEuNzM1LDAsMCwxLDEuNjEtMS4wMzcsMS43MTUsMS43MTUsMCwwLDEsMS42MSwxLjAzN0EyLjc1NiwyLjc1NiwwLDAsMSwxMzExLjU1LDk1LjAzMlptMTIuODEsMy45MzZWOTQuMjg5YzAtMS40ODUtLjktMi4zLTIuNzYtMi4zYTIuNjQ4LDIuNjQ4LDAsMCwwLTIuNDQsMS4wMzdsMC42OSwwLjYzYTEuODQ4LDEuODQ4LDAsMCwxLDEuNzQtLjhjMS4yNywwLDEuNzYuNTE4LDEuNzYsMS41MTN2MC42NThoLTIuMDZjLTEuNTQsMC0yLjM5Ljc3LTIuMzksMS45ODlhMS45MjEsMS45MjEsMCwwLDAsLjUxLDEuNCwyLjQ3OCwyLjQ3OCwwLDAsMCwxLjk1LjYzLDIuNDQ2LDIuNDQ2LDAsMCwwLDEuOTktLjc0MnYwLjY1OGgxLjAxWm0tMS4wMS0yLjQzN2ExLjU4NCwxLjU4NCwwLDAsMS0uMzUsMS4xOTEsMi4wNzcsMi4wNzcsMCwwLDEtMS41My40NjJjLTEuMSwwLTEuNTktLjM3OC0xLjU5LTEuMTc3czAuNTEtMS4yMTksMS41NS0xLjIxOWgxLjkydjAuNzQyWm0xMy4zMywyLjQzN1Y4OC45OTVoLTEuMDF2My44OGEyLjIxNywyLjIxNywwLDAsMC0xLjk1LS44ODMsMi4zOTEsMi4zOTEsMCwwLDAtMS42OC42LDUuNTIyLDUuNTIyLDAsMCwwLDAsNS44NTUsMi4zOTEsMi4zOTEsMCwwLDAsMS42OC42LDIuMjA2LDIuMjA2LDAsMCwwLDEuOTYtLjkxdjAuODI2aDFabS0xLjAxLTMuNDQ2YzAsMS4zNDUtLjIyLDIuNjMzLTEuNzIsMi42MzMtMS41MiwwLTEuNzQtMS4yODktMS43NC0yLjYzM3MwLjIyLTIuNjMzLDEuNzQtMi42MzNDMTMzNS40NSw5Mi44ODksMTMzNS42Nyw5NC4xNzcsMTMzNS42Nyw5NS41MjJaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMTE3OS4wNiAtODguOTA2KSIvPgo8L3N2Zz4K"></td></tr>
</tbody></table>

<hr class="PinkTopBorder">
<center id="centeryBackground">

<tbody><tr class="transperantTableBorder"><td id="logoColumnWidth" class="transperantTableBorder"><img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+CjxzdmcgdmVyc2lvbj0iMS4xIiBpZD0iTGF5ZXJfMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeD0iMHB4IiB5PSIwcHgiIHdpZHRoPSIzNDNweCIgaGVpZ2h0PSI5N3B4IiB2aWV3Qm94PSIwIDAgMzQzIDk3IiBlbmFibGUtYmFja2dyb3VuZD0ibmV3IDAgMCAzNDMgOTciIHhtbDpzcGFjZT0icHJlc2VydmUiPiAgPGltYWdlIGlkPSJpbWFnZTAiIHdpZHRoPSIzNDMiIGhlaWdodD0iOTciIHg9IjAiIHk9IjAiCiAgICBocmVmPSJkYXRhOmltYWdlL3BuZztiYXNlNjQsaVZCT1J3MEtHZ29BQUFBTlNVaEVVZ0FBQVZjQUFBQmhDQVlBQUFCaVplSWNBQUFBQkdkQlRVRUFBTEdQQy94aEJRQUFBQ0JqU0ZKTgpBQUI2SmdBQWdJUUFBUG9BQUFDQTZBQUFkVEFBQU9wZ0FBQTZtQUFBRjNDY3VsRThBQUFBQm1KTFIwUUEvd0QvQVArZ3ZhZVRBQUFBCkNYQklXWE1BQUE3RUFBQU94QUdWS3c0YkFBQkhiVWxFUVZSNDJ1MmRlVnhVVmYvSDM3UENEREFnQXdnQ2Jpa29icGc3cFpaTFBUNXAKWldwcWxyUmFWclpvejYrOXB5ZTFiTkZXczNwYVJGdWUzTXEwTkJOM2NVTUZVMVJ3WjVGdEVBYVlmZWIrL2hqbXlyQ0pDN2wwMzY5WApyM0RtM0h2Ty9kNTdQL005My9NOTU4Z0VRUkNRa0pDUWtMaWt5QzkzQXlRa0pDU3VSU1J4bFpDUWtHZ0NKSEdWa0pDUWFBSWtjWldRCmtKQm9BaVJ4bFpDUWtHZ0NKSEdWa0pDUWFBSWtjWldRa0pCb0FpUnhsWkNRa0dnQ0pIR1ZrSkNRYUFJa2NaV1FrSkJvQWlSeGxaQ1EKa0dnQ2xKZTdBUkxYTGxhcmxiemNYT3dPQndIKy9rUzBhSEc1bXlRaDhaY2hpZXNWeEJkZmZNR2tTWk1hTE9NNGVCekhnU1AxZnE5VQpLeTY2SFE2YnM5Wm44dkFRMURkMmI5VHhXelp2WnNuaXhXemR2SVdLaWdyeDh4YVJrUXdkT3BReDQ4WnkzWFhYZVIzejhnc3ZrcDZXCnhtTlBQTTd3RVNNdXFWMHZCSXZGd3I5ZmVaWGp4NC96K3ZRM2lJdUx1NkR6NU9iazhQWmJzOGpQejBldFV0VlpKaklxaXJndW5ibjEKbGxzSWo0aTQ0RFliREFiKy9jcXJuRHAxaXBsdnZrbVhibDB2bVQwTUJnTkJRVUVvRkJmL2ZQMWRrTVQxS3NObEtNVngrQVNvYXQ4NgpsVUpHV3JGQThra2JBSkdheGk5NFZ1NVNZclE2NlJJaVkwQlVEUkd3Ty9CdGhHaGJMQmFtdnpHZCtWOTloYzNtYmtPTEZpM1FhcldVCmxwYXlMejJkUGFtcExGMnloT2t6Wi9LUGZ3NFRqOTIxYXhkYnQyemhuOE52dTl3bUJzRHBkSkthbXNxKzlIU2VtVGIxZ3M5VGFUS3gKYStkT2podzUwbUE1aDkxT2wyN2RtUFh1T3lRa0pGeFFYWGFiamVTMWF6bDE2aFRUL3ZXdkMyNXpXV2twNzd6ekx1YktTdjc5bjlkSgpTMHRuL3RkZkV4c2J5K05UbmtTbjAxMGFJMS9qU09KNkZTTlRuaFU4WHdYc3pYY3lhWk9aZm4zYWNOc3Q3YWswMmNuTEtXZjNuOGNvCk91T2s3RXc1eFJVQy9rcUJDb2NNZjZWYmZQMENOUUFjemJYU0wxS2dlN2dQd1JvWmppcHRib3hFT3h3T1huenhSZWIvOTB1MGZuN2MKY2RkZFBQcm9KTUlqSWxBcGxaak5aalp0M3N4WFgveVhneGtaVEhuaUNiNzk0WHY2OU8wTElIcDFTdVdWODBncUZBclVhalZLK1lWNwphM0taekcxalB6OGVmblFTUFh2MHhHcTF1dStmWEVabFJTWGJVbEpZOWR0dkhNeklZTnJUei9DL3hZdG8xYnIxK2RlbFVOQ2hZd2NBCnRGck5CYmZaWkRLeGJQRml6R1l6RHo4NmlRUDcvK1RRd1lPY09uV0tzZVBIU2VMYVNLNmNKMW5pdktndXJFb1ptSzFPM2txdnBNS2gKWU1yVE45S2hWVUMxMHIxeHVRUXlzMG80ZHZ5TTEzbmF0bWxHMjFhQnFIMlZmUDN0UG43ODc1WUxhcyt5WmN2NGRuNFNXajgvL3ZYOAo4end6OWRsYVpkcTBiY3VBL3YxSnZHOGlCek15bURsOUJrdC9Xb1pLclFiY0F1dTZBcGNYRmhyMTgzSnVicnJwSm03czM3L1c1K01uCjNNTzNDeGJ5bjMvL20wTUhEN0o1MCtZTEV0ZXdzREIrK3VXWGkyNm5YSzRnS0NnSWdJQ0FBR0k3ZHFSSHo1NUVSVVVSSEJ4OFNXengKZDBBUzEyc0FwUnorUEFOcGVTNWF0UER6RWxhWFMwQXVseUdYeStnUXE2ZERyTjdyMkswcHVSZ01GbTVJaUNTaGZ4cyttYmVGQ3J1VApNRDhsRG1majZqZVpUSHorNlR3QWJyNzVacDU0OG9sNnk3WnAyNWFISmozQ2M4ODh5KzdVVlBidjMwLzM2NjhYdjVkWHhmUk81K1dSCm5wYU9zYUtjeUJhUmRMKytPMXF0dHM1elZsUlVzR1BIRG9xTGlna00xTkc5Ky9VMEQyOWVieHZzTmh0WlI0NlFkVGdUcTkxR205YXQKaWV2VUNUOC92enJMeTVEVitrd1F3R3ExWUxQWjBQajZpajhRRFdHdENwWFV4Ymg3eHZQOXQ5OVNYRlRFbi92MjFhb3JLeXVUUDlQZApuNGRIUk5DbGE1ZGFIcVFnZ01OdXcrbHlvVmI3SUpmTGNEcWQyTzEybEVvbFNxV1N5c3BLVW5lbFVsQllnTCtmSDkyNmRTTXlLa3A4ClZ1eDJHeGFMR1lmREFZQ3h0SlFCL2Z2VHRrMGJ3aU1pMEdndTNDUCt1M0haeExYY1pNZHNGV2dXb0VLbGxGMzhDUzhTcTkxRldZV0QKQUswU2pjL1ZsNkhtaWJQNmE5VUlBc2hrWUREYStYYitYdTRaMzVuUTBMcUZpZE81Vlg5RWdzVkdXYVhqdk92ZXRYTVhodzRleE0vUApqOGVlZVB5Y1FqTnk1RWl5VDUzQ1lYY2drM3ZiMmxSUnlidHZ2ODNYWDM1RmNYRXg0TzVTdDJ6Vml1a3paekx3cG9GaVdZdkZ3b0w1Cjgvbm1xNjg1ZGVvVU5wc050VnFOVHFkandzVDdlSGJxMUZxQ3VXWHpadDZjUG9Pc3JDeEtTMHNCVUt2VnRHelprc1FISCtDaGh4NnEKMWY2YW5tdG1aaWF2dlBnU08zZnNvSFBuenN5WTlSYng4ZkVYZGYrVVNpVSt2ajRBbU0xbThmUGRxYW04OTg2N3BPN2FKYmJYejgrUAowTkJRSmo1d1A0bjMzeStLYkdGQkFmZU1HOGVoZ3dkWi9OTXlFaElTK1BiYmIzbnAvNTduL2djZW9QL0FBYno3OWp2c1MwOFhyMXVuCjAvSHdZNC95OU5OUGMvVElVZTRkUDE2c0IyRDBYYU53T0J3a1B2Z0FyN3o2NmtWZDQ5K052MXhjblM2QkxYK1drWlZqWmtpUFpvUTEKdS96Q0N1Q2prbE5pdFBMSDdqUDBhSytsZmJRL0N2bVYwYmJHY0xKY3dDd29DRzJtb0NyTWg1KzZrcDZkRHFOV3hRRGU0cHFlVmtEbQpzUkxpOSsrbldZdy8wQnNBczZDZ3pISisxNzF0NjFZQUlpSWk2Tm1yMXpuTDYzUzZPbDlVclo4ZjN5MWN5SWtUSitqYXJSdGp4NC9ICldGWW14aU9mZS9aWlZxNWFSZlB3NXJoY0F0UGZtTTRYOCthaFZxdTUrZWFiYVJjVHc1SE1UTmF2WDgrSGM5Nm51S2lJOStiTUVlTzQKeWNuSlBQbllaUEpQbjZaZCsvYmNObUk0ZnY0QjdOcXhnNzE3OXZEcVN5OVRYRnhjcTIzVlBkZU1qQXdlZTJRU3UxTlR1ZUhHRy9uZwo0NDlvMTc3OVJkOC9vOUdJd1ZBQ1FMRGUzYnRJU1VsaDhpT1RPSFh5Sk9FUkVZeS81eDZDOVhwU3RtNWw3NTQ5dlBiU3l4dzdmcHczCjMzd1RqVWFESUxnd1ZWWlNXbHFLeStudWRsaXRWbXcyRzVzM2IyYlJqeitpMVdxWmNOKzlCQVUxSTJYclZnN3MzOCtzR1RPSmo0OG4KSmlhR1psWGRmby9BK3Z2N0ErRFRDTTljd3B1L1RGenREb0dUQlJibS9weUgzZUZpMG9nV3RHcnVXMjk1czlXRnplNUU1NmNTeGFLcAo2ZEFxZ0RLVHdPY3JDMmtiWVdUc3phR0VCcW4vc3ZvdmhxTkdGd0FCQVlIaVp6TEJSdThlZjdMeWp4WTRGQzJJYVJ0TW0rU0ZiQlZpCk9SM2Vpc0UzNmlqeTcwc1pZTTNKQWR4ZHZrT0ZWcnFIYXh0ZGQxWldGcWJLU2pwMTdZcXFublNqeHBLWGw4Y1RVNmJ3N05SbkNheUsKKzQwZWV6Y1BKZDVQWGw0ZVd6WnZadFNZMGZ5MGRDbnp2L3FLa0pBUTNuN3ZYVzY1OVZaOGZYMnhXQ3lzK2YxM3BqM3pMSXQvWE1UQQptMjVpNUYxM1VWRlJ3ZHR2dmtWeGNURkRiNzJWZDJlL1I4dFdyWkhKM0tQakgzLzhNUi9PZVora3I3L2hybEdqaUkyTkZkdms4Vnc5Cnd2cG5lanJEaGcxajlnZnZuMWRzVkttbyszVXpHQXpNbVQySG8wZU9vRlNwNk51dkx5YVRpZGRmZlkxVEowL1NxMDhmWnMrWlErZXUKWGNYMmZ2UDFOM3d3Wnc3ei8vc2x2WHYyWXZ5RWU1REozTDJBbWlsZmZuNStITXpJNE1iK056TG5ndzlvM2FhdGVKN0hKajNLMmovKwo0SWZ2ZitDenp6L2poMFUvVWxCUVFPS0VlNm1vcU9EVHp6K2pUZHUyYURTKzU3dytDVythWEZ6dERvSENVaHZMTmhYenplcDhPcmJVCjh1cDlVWFJvNVZmdk1RYWpuUzEvbHRFbVFrUFh0aGYzc3A0dmZUcnEwUGdvZVB2N1U2eEpQY01UZDdiZ2hzNEJCR2ovMm5hY0R3NFgKbEN2bGdKT1kxbWRqcXNkUEtkQUZ2TWJJTWY2a3JzbWc0dWhKdHB6VUVUYjhPZ2JkM0lIOExZY0l6OCtqckh0end2dy93bVI1RUlCYwpzd3lIcS9IMWw1UVlBTkQ2K2lLL2lKRjFtODFHdjRRRVhudjlkZVRWZWcwSkNRbmNkUFBOTEZtOG1HUEhqZ0tRTkg4K3BzcEtYbjcxCkZXNi80dzZ4cksrdkw3ZmZjUWNuanAvZ3hlZWZaOUgvZm1Ua1hYZXhZY01HRHV6ZlQwaElDTk5uenZRU3hjQ2dJS1pNbVVMYTdqMmsKcHFhU3ZqZk5LNjgxUUtmalNGWVdqejB5aVlNWkdZd2FPNVlQUHZ4QTlPb2F5L3l2djJiOXVuWFlQYkZYdVJ4elpTWHA2ZWxpVjMzSQowS0hjMkw4L3Y2OWV6ZDQ5ZXdpUGlPRDlEOTZuVTVjdVh1MTladXF6L0xsdkg3OHNYODZpSC8vSHVIdnVvWTdRTUFxWkhMdmRUbEJRCkVLKzg5aHB0MnJiMU9zKzQ4ZVBadEhFamhmbjV5T1VLOUhvOWdpQ0kzbjZ3WGs5SVNNZ0YzOU8vTTAwbXJrNlhRSDZKalExcHBTeGMKVThDaFV5YUc5bXpHeS9lMm9uVjQvYitDQnFPZHIzN0x4Mkp6Y2NjTmwrZW1kbTNyeDh5SDIvRHlsOGQ1NXBNakRPblJqQWVHUlJEWApTbnZGeG1QanRYQUM4QTl3aTV2ZElYRHMrQmtHM2hqQm9aUGxoR1hzWVA4eE82ZTc5K0Q2NjM0bU0yTTR6VnRIRWhRVGprcGhaOVB1Cld5a3BjM3RvTzB2dGVMell4cUM0Q0VHdGpzTnVaOURnd1Y3Q0N1NkJHbzlIWEhxbWxOTjVlWnpPeXlNd0tJaXUzYnBSVmkxRzZLRmIKZkR5aG9hRWN5Y3Fpc0xDUTFKMjdzTmxzOU9qUmc5Z09zYlhLQndZRjhjbThUeWs1YzRhUWtCQXNGZ3Zncm5mTjZ0OVp0blFwQnpNeQo2SDc5OWJ6OXpxeEdDNnRMRUZDcDFkanRkbGF1V0lIRGJxOVZSdXZuUjFCUUVEZjI3OCtzZDk3QjM5K2Z6UnMzQWRDcmQyOHZZYTNPClBmZmRTL0xhdGV6L2N6OEYrYWRSMXROcnNObHM5TzdUbS9ZeE1iVys4OWU1Qno4VkNqbUM0QUlVWjhVZmQ3NnZ4SVhSSk9McThUd1gKclM5aWQyWTVGcHVMa2YxRGVYcFU1RG1GZGU3UGVXemVWOHJzeDl0ZFZzTzBEdmRsNXNOdGVPL0hiRlp1TTdBN3M1d3hONFZ4ZTRLZQpWczE5cjRoQk9BL0thbnF2QzNSMzU1Vzc5eEZZYVNWdG53YTkzcGZDdUQ2RXhjSGcvaUZrN2RNUTB6VWNINDNieTVVWG1mRFZkTURQCmJzYmZWODVwcTR3U3MrQ1Y2OW9Rb1dGaEtGVXE4dlB6Y2RodDV4elFjcmtFc2pJek1SckxDQWtKOGZLbXpwV2ZxVktyeWMvUEYyZCsKUFRBeEVidmRqa3Fsd2w0bFhKNi83WFk3RlJVVmxCZ01IRHQ2RklmZFRyczZCTVpEZUVTRU9FT3Erc3l5RCtiTXdXNjNvMWFyT1g3cwpHSnMyYm1Ma1hYYzE2dDdJWlRMc05oc3FsWXBSbzBmVHRzYk1OS2ZnSWlRa2hKN1hYeStLcUNEQXFaTW5BZWpTdFV1OTUvWU1vdG50CmR2SUxDb2lPanE2em5NTnVwMVhyMXZYbXA5cHFaREhJcm9ZNDJGWEFKUlhYY3BPZFBWbVZMTjVReE1iMFV1d09BWlZTeHJBK2pSZlcKNzljV01QR1djTHEyOVR1UG1wdUcxdUcrdkRpaEpTcWxuTFc3Uy9ob2FRNWIvaXhqMUlBUWJvb1BJakxFNTNJM1VhUlZnUHVGYUJHdQpJN2ZJekw3TnB4aDZXMmVVSFNNUkJEaGNWYzV3eG9ma0hUY1EwYkVaUGxVNkZocXFKVFJVUzE1ZUJTSCtNaXdXRjdubExvSTFqZk5JCjIxN1hGclZhemVGRGh6Q1dsNlBYNnhzc2I3RmFlT1NoaHppZGw4ZXowNmJ5K0pOUDRuSzU0eENOeVhPdG5tRVEwYUlGdnI2KzlYcFkKT2wwQUdvMEdpOFdDelc0bkxDeTBVZGZrRVJpUGNEOHo5Vmt5RG1Td2NzVUszbmxyRm4zNzlqM3Z0UkxHVGJqbnZHZGYrVFlpOVVtbApVaUc0R283anVKeDFmKzl5T0ZIWHpJNjRBbk9OcjBZdWliZzZYUUlIVHBqNGVVc3hxM1lZT0ZQdVFLZFZvbElLRE93V3hITmpveG9VCm91ckMyanJjbCtFSit2T292V21KRFBIaHViSHVQTUN0ZjVhUmxXTmkxdmVuMkhiQXlKMDNCTkc3WXpBNnY4cy8zN3BMaUZzTURoM08KeDErckpFL2ZBbXVibGloeHAyVzF1ODQ5MEtWUUtIbjBrZXZ4OFczNDFnZjZOdjRGNjVlUXdBZHozcWU0dUpqVnExWXg0ZDU3R3l4Lwo4TUFCamxaTkIrM1UyZTJaeWVXTkM3ZllIUTRDZFRyVWFqVU9oNE4zWjc5SHA4NmRhNVh6bkU4UUJMUmFQd0lDQWxDclZCekpxbjhhCmFuWjJOdm1uVHhNVkZVVlFzMmJpNTFPZmU0Nm5ubm1hN094czl1emV6YUdEQjNscjVwdTgvOUdINXpYWHZucUtWVVBJWk83ZUFFREcKL2dQMWxzdlB5M1BieEc2dnloWTRmMUdVS3hXUzU5cEVYSFFBTWJmWXl2L1dGZkx5bDhmNWZtMEJUaWVFQktwd3VNNVBXQmR2S0VTbgpWWkxRT2ZDSzhGcXI0eEhZRzdvRW9sRXI4TmNvV0x2N0RLOG41ZkRKVDduc08xYko1ZjZ4YjY5WG9wRTVrYWxVZEl0dnp1M0RPK0tyClBudDdQVW5rTWhuNGFwUjFaa0FVRlZaaXNiZzluUE5KeCtyVHB3K2RPbmZHWnJQeCtielBLQ2dvYUxEOGwxLzhGNXZOUnN1V0xlbCsKdlhzeEdKZXJrU05vTGhjdFc3VWlNQ2lJNHFJaURBWUQvdjcrdGY0N2ZmbzBML3pyLzNoL3pod0VRYUJMMTY1by9mellscEtDMFdpcwpkVnFqMGNqOTkwM2twdjREV0w1OHVWZXlmUDhCN2xsVjBkSFJUUDIvZjZIMTgrT1g1Y3Y1ZWRsUFRYWS91L2ZzZ2NOdUoyM3ZYakhmCnR5WS8vZnd6ZHJ1ZGlJZ0kyclZ2MzNnYlZqZm5PVHhYYWFHV0MrZUN4ZFZzZGJFeHZaUzN2anZGck85UGNTTGZUTGhlalk5YVRsbWwKZzRST09wNGVGWGxPWVoyektJZWZ0eFNqVVNzSTlGZHdXOThyeDJ1dGprZGdlM2NNd0dvWENBMVNZN01MTEZpVHordnpUL0R6cGx3TQpSdnZGVjNRQk9GemdyMUxRTGxESmtTTkZXTXdPUWtPMTllYnBDZ0xZTEE3S0t1d1VGWm40YmZVUlhubzltU2RmK28zOEN2ZUxGUmtnCmIxUzhGZHh4MENlZm1vSmFyZWJva1NNOE0rVXBqbVJsMVNwbk5wdjVZTTc3L0xKOE9RNjduWWNuVFJMamdJMzFYQjBPQndxRmdrR0QKQjZOVXFaajk3bnRrWjJkN2xiSGJiTHovM215Kyt2SkxkdS9haFV3bTQ1Wi8zSXBLcGVMVXFWTjg5T0dINGd3a0Q4dVdMR1ZmZWpydAoyclhqNXBzSGVYMXZ0NTI5ci9lTUg4OHR0OTVLV1drcDc3M3pUcTI2THhVREJ3d2tQQ0tDSTBlTzhQNmM5OFgxQ0R4czNMQ1J4Zi83CkVWTmxKYVBIalVXcFZDSzRMcTNuNm5BNGF0VXIwWGd1S0N4d0l0L0NzczNGck5sVndvbDhDODBDbFBpcTVUaWNVRnBocDIrY2ptZEcKUnpVWVl5MDhZK1BEcGJtczJsbUNqOHA5TXp1MzhhZDd1eXZMYTYyT1cyQ2ptZm50U1hablZoQ2dVZUNqVnBPVlkrS3RINnpzT0d4bApaUDhRZXNZRy9PVVRFTUw4Wk56WlZzMzdxekxadXorZjdwM0Q2ZDYxQlg1YUZZRTZEV1ZHTTFtWkpSU1VsQU9RazF2RThWd3pCUVlMCkZSWVgvcjV5MnZnSzlJc1VHTkxjaHpBL2R6cFdZd1gyOWp2dTRPVEprOHlhK1NhYk5tNWsxSjBqR1RscUZCM2o0cERKWlpncUtsbisKODA5czJid0ZoOTNPaFB2dVk4SjkzdUVEbTczaEg2ZnFJKzJQUC9rRTY1S1QyWk9heXQxM2plS2UrKzZsZVhnNExxZUwzMWV0WXVXSwpGYlJzMlpKWFhuc05tUXppNHVKNGJQSmszbjdyTGVaOU1wY1RKMDV5eTYyM0FMQjc1eTZXTFYwS3dQaDc3aUcyUXl5VmxaVmlYZFZuCmFLblVhbDU0NlNYMjdON05rU05IZUhmVzI3ei84Y2YxM3U4TFhTc2h0a01zVTU1K2luKy8raHJ6di9xS1kwZU9jUHNkZDZCUUtjblkKZjRBZmYvaUIvTk9uNmRXbkQrUEdqblhYNWJvMEkvc2V6OVdUYTlzMXZoczllL2JrSDhPR1hlU1ovMTZjbDdoYTdTN1c3eTFsNmFZaQp0bWU0dTFiTm02bVJ5OEhoaEVxTGs2NXQvWmsycGdYdEl1c1B4SHRDQWIra0ZLUFRLcEhMWmJoY0FxTUhodFJLdzduU2FCM3V5N1F4CkxaaStNSWVEcDB3RWFCV0VCS29vcTNUeTYzWURCMDZZdU9NR1BiY242QWxyOXRmTWFuRUlnQXZ1YksraVY3aUNRNFhsNUdaVzhPVjYKOXpCV1VaVVRWbGJwSU5CUFNXalZYZStpazlNbFRFYVhFQitNVmljNkgzY1hzRldBaXgvMm1lZ1E1a09YTUFXTjljZW5QUFVVQWY0Qgp2RDk3TnNYRnhiejc5dHRlMzJ1MVdrSkNRaGc3Zmp4VG5uNEtYOSt6UDc3aWdGWWpVMy9Dd3NLWTk5azhYbm41WlhidTJNbHJMNzBzCmlyTmFwYUpkKy9iOCs0My8wS05uVC9HWXg2YzhpY1ZxNWJ1RkMxbStiQmsvZlB1dFdENHdLSWhKano3cXRieGdmWU5rc1IxaW1memsKRTB4Ly9ULzg4UDMzOU83VGgzdnV2YmZPWjFjdWsrRndPTVJNaHZQaGthcTFmVC8rOENQVy92RUh2eXhmTHJaWDYrZkg0Q0ZEZUhmTwpiSEZ0QUZsVlhkVi9wSnlDcThFZkxWZlZBaExPYWdOZUlTRWhEQmc0a0c4WExtVHJsaTM4dW5JbGp6dzZTUkxYODBRbU5ESUtubHRzCjVjZjFSYXhJS2FhNHpJNi9Sb0d2V282bkoxSnVjdEk2M0plWDcyMUZqNWo2Y3dDTmxVNCsrU21YSlp1S1VNcGxhRFZ5VEdZWDNkcjUKOGRHVTlsZHNIbWxOZG1kVzhQcjhFK1FXVzlINUtaRGh6aTB0cTNTZ1Vzb1oyQzJJZTRjMmI5QVdOV25NWXRtMkxYdXhiVXhGcHZFTwp0L2pXQ0kwZEszVlFacEZ4cU5CS3Jsbkd5WEtCQXFlRGlrcTVLTGJpc2I1dW0xZGZqaERBWHlrd280ZVN3YTNVS05xM1JIbjdvRVpkClIwRkJBV3YvK0lNZDI3WlRWRlFFZ0Y5QUFOMjZkV1hvMEtGMDZOaXgxakdyVjYwaS8zUSt2ZnYycVhOaDZwU1VGTEt5c3VnWTI0SGUKZmZ1SW56c2NEbGF2WHMzKzlIMVlxcnF3clZ1MzVwL0RieU9zYWxDb0poa1pHYXhaL2JzNHhUTWdVTWVBL3YzcDFidTMxM25YL1A0NwpaODZjWWVndHQ5UTZsOGxrNHZmVnF5a3JMU004UEp6QlF3YlhtWUptTkJwWm43d09rOG5FVFRmZmRFRzdNUncvZG93LzFxd2hMKzgwCkFFcVZrbjRKQ1F3Y09OQnJpVWFUeWNRZnY2L2h6Smt6L0dQWVB3aVBpT0R3b2NOc1Mwa2hwa05zblprS3VUazVyRiszbnViTm16TjQKNkZEeEI4TGhjTEFuZFRkWlI5emhuWmlZR0MvN1NKeWJSb25yN3N3S3ZsbDFtcFFEUnV3T0Y4RUJLdVJ5Y0FudVNTRW1pd3Mvalp6WApKcmJtNXU1QjlaNm4wdUxrOHhXbitmYVBBbEZZQmNFdHpLOU9DT2ZPQVpGWHhWUlREMnRUaTVpK01CZXoxWDM5MWUxaHRqbHBIYTVoCjNLQlE3cnd4QkQvZmN3OE1uSys0S21WbmMxd0xLd1gyNWxzNVdTN256MklIQlU0SGZ4b1VWRmhjZEdzZnhPamJPakQzeXgyaWNJYjQKeTJqWE5vajlHU1ZlWXVyNTI4TnJuV1dNNzZwRmFCUFZhSEdWa0pBNHg0Q1dJTUR5cmNXOFB2OEVHOU5MVWNwbEJPdmNjLzA5SHF2ZApJYUJRd01PM1JUUW9yRTZYd0EvSmhTemVVQWlBeGtlT0REQmJYRVNHK0hCRDE5Q3JTbGdCaHZRTVpkSUlkOUs1eGViQzB5dlVhdVFFCitpazVrVy9td3lXNXpGNlVRMjVSNDlKd0dvTks3dlpVN1hZbnZ4KzFNR1d0aVZISlpwN1o0ZVMxN1Nwc1lhbTA2cm9YcDlYT2pILzEKcDN2bmNQYjhXU2dlNzdUYUdYN1RRV1kvOXg1dEFsMmNNV3Jwb25meSs5ZGZjMHN2STA2cmR6ZlNjVDV6WVNVa0pJQUdZcTUyaDBEUwo3L2trL1Y1QWFZV2RRRDhsU29VTWdXb3Iwd3RndHJtNGQyaHpSZzlzT0RuN2w4MTVKUDFlaE5VdW9OTXFQSWRqdGptNXVYc1Erc0FyCmQrNStRNHdlR0VyQkdUdmZyRHFOV2lsM3U2NENLSlh1SDZKeWs1UEZHd3JKTHJRdzVhNm9TNVptOXZ0UkMxOGRzVld0NFJxQXdnZjgKTFdhYXQzR1JXM1l6R1NmS01RdE9Gdi84SjIxYkJsTmVYaVo2cFFvZkZhdTJ4Wk5YMElJL0RRcWV2V2NQb1hvalB5ZDM0ZlF4UHhRKwpaNzNzWExNTUdqbVNMeUVoY1pZNnhkVnFkN0Z3VFFGZi9YWWFxMTBnT0VDRlRJNVhMcWNNTUZsZDlJang1NkZoemZGUjFmOENia3d2CjVmTmZEWlJXMkFrT09DdWlEb2VBdjBiQmtCN05ycXJsL2Fyam81Sno3NUF3RHA2c1pIdUdFWDJnQ2tGQVhGTlZwMVZndGN2WW5tSEUKWUR6QjgrT2o2ZFB4d3JmSlVLbmtmSGZFeVJ2N0JVQ0JXWkF4K2grZEFOaTBlaWNkdW1ZUzFtSWtBQVVsNVd6WW5FVmc1M0JpV3JkbAorNzdkZ0x2N2Z6VFh4SUJlQi9qaU5mZkFaR201azBmK001cG1PcE5ZVjRYRkJjaFJ5aHZlNmtVUVlOVnZ2N0w0eDBVQWpCMC9qbjhNCkcwWkJRUUVmZmZnUmVUazVCT21EZWZIRkY5SHI5WHcrYng0bFo5dzdJb1NGaGhJWTFJeURHUmtvVlVxVWNnVnhuVHR4cHJTVU82c1cKWkVtYW44VGRZKzhtcUZrenZsdjRMUlB1dTVkRGh3NnhhY05HSG5sMEVocU5oajkrWDhPR2pSc0o4UFBENFhJeWV2Um9Xa1JHOHZtOAplVGdkVGl4V0t6MTc5UlEzUDB4T1RtYnp4azBvVlVvY2RnY2Q0K0lJRHc5bjgrWk5LT1VLSEM0blE0Y09wWGVmdnN5Yit3bTdVM2VqClZxdTUvOEVINk4ybkw0dCsvSkdCQXdjUUhoSEJuK243S0N3dW90MTExL0hMTDcvdzhDT1BvTkZvK0dYNWNtSmlZb2p0MEZFOGgwYWoKWWR3OTQ3bXhmMytXLy9RekhUdkZFVk50U3U0dnk1ZXovS2VmY2JsY0RCOHhnbEZqUmdQdzA3SmwvUHJyYndBTUhqU0lzZVBIc3kwbApCVUZ3MGFWTEYrYk4vUlFBaTlWS3QvaHVEQm8waUk4Ly9waWpXVWRvMGFJRlU1NStTcHphYTdmWitPN2I3N2g3M0ZnMEdpMkxmdnlSCnJLeE1zUTN4OGZFb2xVcTJiOXVPcjQ4UHVrQWREejc4c05jQXBNUzVxVk1SZjBzNXpUZXI4ckhhQlFLMGlqcUYxV3AzRWVpdllNcGQKVVFUNjErOTFIc2sxODhXSzArUVdXd24wVTdyUGhWdDRURllYbmR2NDBTcnM2bDRyTXF5Wm1vZHZpMEN2VTJFeW53MFBDSUw3V24xVQpjb0w4VldUbG1IajdoMnoySGF2RWVRRTVpUjVTenZidzhmZVZzMlQxQVZadnlzS2tiVWFwYlFBRkplVXNXWDJBTXFPTjRUY2Q1UERPCmc4ejlicmQ0VElWRGhyK3ZIRCtsZXhiU3BEZHU1Zi9lLzZlWHNGYm5YR0dCd29JQ1BwanpQcysvK0FLUFBUNlpsYitzSVAvMGFXYSsKTVowQVB6OW12ZnNPYmR1MDRmbm4va1ZSWVNHclY2MW0yTEJoM0RWcUZBTnZ1cG5ldlh2UkxiNGJLWnUzTUhqb0VIcjE2c1gyclNrYwp5TWdnTFMyZGp6LzhrTFM5YVJ6TXlHQjljaksrdnI3TS8vcHJGaVlsaWF0SmJWaS9uZ0EvUDhhTUc0dEdxK1hEOXorZzNHaGs4NmJOCmpCdzFpakZqUnRPdDJvTFdjUjA3Y3ZPZ1FleExTNmQ5VEhzR0RPaFBlbG9hNWtvVEkwZU5ZdVNkZDlLaFF3ZisrL2xuYk4rMm5kZGUKL3pmRGJ2c25IMy93SVZsWm1XeFl0dzVqdVR1dDdkaXhZK3phdm9QQ3drSm12L011bjgvN3pOMm1kZXNwS0Noa3dZSWtkdTNjeFd1dgovNXVSbzBjeCs5MTNPZkRubjZSczNlcVZKNXVjbk15WFgveVh4NTk4Z3FlblBzc1AzMzFIY25JeVc2cjJIbnZpaWNkNTdybHAvTHBpCkJidFQzUXVVNzkyN2wvejhBbmJzMk03b3U4Y3dac3hvK3ZidHl4ZWZmNDZocElSNVgzeU9TcTNtbHhVcnhIcHNkanZMZi80Sms4bUUKVEFZOWUvV2tYMElDbXpaczVLYWJicUo3OSs3OHR2Slh3aVBDdVczNGNBNGRQTVQwMS8vekY3MU4xdzYxUE5kREo4dFptRnlLMGVSdwp4MWVoMXV3alFRQ25FMjVQQ0dtd20ydXNkTEp3VFFIN2psWGdyMUdnVU1qRWN3bUEzZUdpVDBjZFd0K3JmN2Vacm0zOXVmMkdFTDVaCmRkcWQ4VkRORVJjQWhRS0MvRlZrbktqays3VUZUTGtyOG9MV0pyRGJYU1NFd2RvcWdmVlhDZ3pybDhhaFUvMFltTkNlUFg4V1VtYTAKY1RUWHhOSGNZMEFNL2xYWkFQNUtnVkNsT3pXcndpRmp5ZXBZTnE2TnBZMnZ3SFU2ZDVrQ3A0UG1WZXVPdGdwUWNsZnN1Y00xL2dIKwo2UFY2dnZqc2MvcmVrTUJUeno2RHNieWN2TnhjWnIzN0RscXRsaWxQUGNVREV4UFpzMmNQZm41KzVHVG5vTlZxaWVzVUo2WVNoWVNHCmlpUFMzYnJIYy9CQUJ1WGw1ZHpZdno5WlI3S29yS3hrd0UwRHljN094bXF4OHNqa3gvamxseFgwNmRzWGxWck5tVE5uT0hIaUJDV0cKRW9KRFFzU0pDYWRPbnNUcGN0SXg0T3oyTnhFdFdoQ3MxN04wOFdLNmR1bEtSSXNXcUgzVWxKZVhjK3JrU2VSS0JVSE5tckZsOHhhZQpuVGFWVnExYjA2cDFhK0xpNHRBRkJtS3hXRmlYbkV4MmRqWTdkKzBpS0ZDSHkrWGl4aHR2Wk8yYU5Rd2RPb1RnRUQxbWs0bk5temJ6CjlOUm54WE5zUzBsaDNmcjFLR3RrRjZ4WnRacTd4NDRWMDhjbVRMeVBOYXRXbzFRcW1mamdBM1MvL25xT0hqMUs0Z01QMEt4cWVxNUMKTGtlaGtPTjB1amg1NmhRdWh4TjlTQWl4SFRxUXNuVXJjK2ZPNVlZYmJ1RDZuajI4NmxLcHp0WjkzWFhYRWFMWG85ZnI2ZFc3Tno0KwpQcmhjTGpwMmpLTkx0NjVNbnptRGgrNS9BS1BSS0cxT2VCN1VVclVUQlhhS1N1Mm9sSExrMVFhdXFtTnp1TDNXRWVkWUEyQjkyaGsyCnBKZWlVc3J4VWN0RllaWEp3R3B6RWVpbnBIdjdnQ3RxaGFrTFJlUGpUcjlhdnFYWUszdkFneUNBVWdFcXBZek1IRFBsbFRhNEFIRlYKcWVRRSs4bHhXaTBvZkZTaVNFSUpSNDd0QWlEQTRlTE9sZ3E2aEhoRTBrVjd2UkovbFlJQXBZdHloNXdLdXhOL2xUdTJHcUE4NjVtVwpPelRvZkdVSURpY3lwUUtsekQxd2RxNWNoLy9NbU03ZVBYdlp2aldGUmQvL3dPUXBUNkwxOC9QYTl5b2dJQUM3elk3VDZTUTNOd2NmCkgxOGlvNk9JeEwxbUFMaFRnSlJLSlQxNjlPRERPZS9UTGlhR2h4NTVtQlhMZnlGdHoxNm0vZCsvK0hYbFNvNGVQWXBPcDJQYnRtM1kKYlRhVUtpVUg5dTlIcVZhek56V1Z1OGVOdytGMDRyRGJLU2dvd09Gd0VGMGw0aDRjZGdjdWx3dUgwMTIzWENhanZMeWNnb0lDbENvVgowZEhSMk8xMmRJRm5GeUEzbTh6aTFOamk0bUtDZ3BwUlhsWkdVS0FPcDh0RnU1Z1l1c1YzNDVPUFAwR2owZUJ3T3JCVVZuclpRUmVnCkUzTlBxeStnYlhNNjBBV2VGYS9nWUQwMnB6dEh0bmxZYzR4R0k4dVdMQ0Y5YnhwRGJya0ZyVmFMMVdwQkpwZmpzTnZKUDMwYWg5TkoKcXphdDZkT25MeEVSRVd6YXZKbWtiNzRoTFcwdnowNmI1cFc2cGFyMnQ4UHB4T2wwNHJBNzhQSHhxVFZqem5tSkppajhuYWdWRm1nWApxYUZsbUE5Mmg2dmUrZkp5bWV5Y01WS3IzY1dCNHlZS1NteG9mYnlEZGpMY25xKy9Sb0ZlZC9WN3JZM0Y3YTBMeEVScENOWmQySXBhCmRydUxIb0ZPNGx2SThWY0t0UEVWNkJzc1oyb0hPYTkwa3BNMFFNM1MyelI4UEVUTGc1MlZQTmpabmFmYTBsOU9zSStBU2lFajJFY1EKL3gzc0k0Zzd5Y3FVQ29KOUJBU0hFNVhDTGJCMnV4UHNEZStybFpXVnhWc3paako4eEczTStmQUR3QzBhS3BXS0g3NzdIb0EvZmw5RApYbTR1WGJ0MUJkd0o4Zzg5OHJDWTB5cTRCSzlFKzg1ZHVuRDQ4R0dNWldYMDZObVR5c3BLc3JLeUNBZ0lZTWUyN2R6NnoySDA2TjJMCnlNaEkvdmpqRHh4MkJ4TWZmSUNaYjg3azJXblQyTE43TjNLWkRQK0FBRWJjUG9JUmQ5eE9WQjFMOGxXZktHQzEyWWlOaldYRTdTTVkKZXN0UTJyWnRTOXQyN2ZqNnYxOEM3cjJ6L3ZQdmYxTmlLQ0VnSUlBeFkrNW0zUGh4M0R4NEVFNkhFNWZUaWJHc2pIL2VkaHM2blk1Vgp2LzFHOCtiTjZkQXBqcVN2dndIY2k4TnMyYnpadlZ5Z3l5V3VqMkF3R09qZHN4Yy9mUGM5WmFXbFZGWldzbUQrZkc1TXVJRWJicnlSCnIvNzdYd1NYaTZuUFBZZkZZcUdvNkd4c3lHRjNFQmdVeElqYmIyZjQ4T0ZFUjBmejBVY2ZjV0QvQWFaTm04WURqenpNeHZVYnptN3AKTFpOaHNWakl6Y3Vqb0tDQXN0SlNCRUh3bXNEaHFtcGJjWEV4SDMvOE1lSGhFWndwS1RubnVoRVNaNm1sYk5lMTBIQno5eUN5Y3N5WQpMQzR4RjdVNktxV01FcU9EdGJ2UDhPQ3c4RHBucHFnVU1scUYrNkQxVldDenU1Y2VGRU1DZ3J1YlhHbHhZVFJkRzcrSTVTWTdHOU5MCktTbTNFNnhUMWZMNDVUSW9Mck1USGViRGlBUTl6UUl1TER0Q3JnOGlzRnM3UG14LzF1YStxaEtDL000dUxPNndPUnM5cXdydzhrb0YKM0ErRjUvOGVYTUhONmoyK1Uxd2MxN1Z2eDhNUFBJUktwYUp6MTY0a0pQUWp1Rmt6M243ckxWYjk5aHNXaTRYblgzcVI1dUhoNklLQwpjRGlkVkxlQVdxMGlOUFJzeG9sR282RmZRZ0x0MnJkRG85SFEvZnJyQ1F3TUpDODNsMmJObWpGdDJqUUFtZ1VHc1hYclZnSUNkZmhVCmRYVkRtN3NUL2kxV0t4YUxoWWZ1ZndDYjNjNzFQWHJ3NnI5ZlJlSHhGbVVRSEJ3c2Jvc1NIQnpNejh0K1lzK2VQZGp0Tmg1NDZDSCsKNy8vK3hiUnB6ekgrN3JIWWJUYkdUNWhBWE9kT1hndTcrRlFOK3JqL0g0aVBqdzlUbjN1T2d3Y1BZaktaZWVycHAzbnRsVmU0ZDl4NApiSFk3dDkwK2dvRURCN0o1NHlZKy8rd3pmdnpmLzlEcjlidysvUTN5OGsvenlFTVBvMUFvYU51MkxYZU12Qk9aREk0ZE84b2pEN2tICmxlUUtCYUdoWVZXZXF4Vi9mejhNQmdNUFAvQWdwc3BLYmg0NmhBY2V1SitaMDJld0xqa1ppOFhDNDFPZUZEZHI5UEh4d2VWMDh2SUwKTCtCMHV1Zy9vRDhQUFBTUWV5V3Vxc2NxdkVVRW44NmR5NUxGaTJuWnNpVXZ2UFFpQ3hjdXBHdlhybDQ3UDBqVVQ1MlRDQXhHT3pNVwpubUx0N2hLdkZLenFPQndDd1RvVkh6L1ZydDQxQkU3a1c1ajU3VW0yWnhqZFdRTFZORmhXVmMvVG82SzQ3NWFHc3cydUJuWm5WakIxCjdoRnNEcGRYQ0FUY3dscHBkdUZ3Q1R4K1J3c1NidzJ2TXhUU21Fa0VWeklXaXdXcnhTTHVmUVh1aGJITGpXVUU2QUl2eWRSbVR4WkcKZFR6Ymg5ZFgxdU94eVdXeWN5N2s3WFE2eFVWYkZBcUYySTAyR0F4b05KcDZ0L2R1REdXbHBmajQrbnFOdWpzY0RweE9wMWZiakVZagpnc3ZsWlVkQVhPK2dyaTNBQlFGc051L3JGQVF3bHBYaXE5SGc0MU83cDJTMzJYQUpRcjEyOFh6dk9kYnBkQ0tUeWEvNEtlcFhDblVxCm1sNm40b0ZoNGJTUDBtS3kxaDBlVUNwa0ZKVFlXTENtb042Ujc5Ymh2Z3p2cHlmUVQwbTUyZW4xVXNoa29GTEtXYiszbEFyejFlMjkKR294MnZ2MmpnSkp5Tzc0MWhGVW1BNXRkd0d4ek1xS2ZucEg5UTY2SkdITmQrUHI2MWhJRXVWeEdZRkRRSlhzaDY1cG9VdCs1UFdWOQpmSHp3OGZFNXA3Q0NXMUE5NWF2SEovVjYvVVVKSzdpM2txbVp6cVJVS211MVRhZlQxYklqdUVXMUxtSDFYR3ZONjVUSjNIWFdKYXpnClhvU21JYnQ0dnE5dUcwbFlHMCs5N21MWHRuNU1HaDZCemsrQjJlcXF2ZmVaRE5RcUdYK2tubUg5bnVKNkt4alVQWkJiZWdWamQ3aXcKMmx6aUErOFN3TTlYUVZhT21iMlpwWmQ5UGRRTHhXcDNzWHBuQ1J2VFMydUZBMlNBM1M1Z05Ebm9HNmZqZ1dIaDZIVlg1MlFKQ1FtSgo4NlBCdnZpdHZZSzVkMGh6d0QxZnZxYkFLaFF5SEU0WDM2d3VybmN0MHdDdGlyc0hCdE8xclQ4VlppZE81OW5vZ0VJQkRwZkFyenVNCm1LeFhwL2Q2T052TS9OWDU0cktKSGp3cGJFYVRnL1pSV2g2N3ZlRnRiaVFrSks0dEdoUlhtUXdtREduTzhBUTlEcGVBMVY0N21WeXQKbEpPVlkrYnpYMDVqcjJmeHp3NnRBaGpkWDBlZ241Skt5MWwxRmFxODE5VEQ1UnpOczF4dVc1dzN4a29uWDZ6SXcyQjA0S091WVVvWgpsSlRiaVF6eFljckl5UE5hSFV0Q1F1THE1NXlqU0JvZk9ZK05pR0JndHlDc2RnRkhUUUdWdWJNSC90aGRRdktlTS9XZVozRFBjREU4CllMY0xaNzFYdVh1MXJKVXBobnJGK1VyRTVSSll0S0dRbEFORy9Id1YzbUVOd1MyOHdUb1ZrKzlvMGVDQ05oSVNFdGNtalJxaUQydW0KNXVsUmtYUnNxY1ZzYytGeWVRMzhvMVRLcURTNzF5UElMYTU3V3dpZG40SjdCb2ZSdGEwL1pwc0x6OXE4QXFCUnk5bTByN1RlWTY5RQo5cDh3OGVQNlFueFVzbHJybXBTYm5XalVjdTRiMnB3N2JnaTVzQW9rSkNTdWFocWQvOVE2M0pmbjcybEo2M0JmS2kzT1dnTlFhcFdNCmc2ZE1mTEhpTkdacjNYUFIyMFZxcXViZ0s3SGF6cFpSS3R4NXM4czJGMThWQTF0bEZYWXhIS0JXZXB2UWJIR2hsTXNZTnlpTSsyNXAKZnJtYktpRWhjWms0citUU3JtMzltSGEzZXpmWDhocnBVd3FGREIrVmpBMXBwU3piWEZUdk9XN3VIc1R0Q1NFb0ZHRHp4SENyUWd2cgo5NWFTWjdpeXZWZTdRMkRCbXJQaGdPb3V2T2Q2N3J3eGhQdi9FWGJWNSs1S1NFaGNPT2Y5OXQvUU9aQ3BZNkxRNjVTWUxkNGVxbG9wCnA5enNaT21tWW5ablZ0UjdqbnVHaE5FM0xoQ3JYY0N6RzdCY0xxTzR6TWFxSFNXWDJ5WU5zakd0bUdXYjNWdlVLS3BaeitFUXNOb0YKaHZac3hxTzNSeENnbFZLdUpDVCt6bHlRYTNWejl5Q2VIQm1KVmlQSGJEbTd4QjR5MFBySXljb3g4YzJxMHhTZXNkVjV2RjZuNHRIaApZYlFPOXhYREEzSzVlNzJCOVh0TDZ6M3Vjbk1rMTh3M3E0c3BxM1NpOFpHTHM5WmNMdmVpNFFPN0JmSDRuUzJrWEZZSkNZa0xFMWVBCk8yNEk0WkhiSWxDcjNJTlpIb0ZWS21WbzFBcFNEaGo1Y1gxUm5lbGI0RTdQU3J5MU9WcU5YTXhBOEZITE9aRnY0WmNVdytXMlN5M0sKVFhhK1daWFB3Vk1tcjNDQXkrWE9ka2pvcE9QcFVSZTJqS0NFaE1TMXgwVUZCU2NNYWM3OS93Z0h6dTRoSlFpZ3FWby9kTm5tSXRidgpMYTMzK0JIOTlOeWVFT0pPd2FwYXpNVWxDRmVjOStweUNmeVNVc0tHdEZMdjdBREJMYXc5WXZ4NWJteTBORWxBUWtKQzVLSkhYTzY3CnBUbjMzZEljcTEwUUJWWW1nd0NOZ3VJeU93dlhGSERvWkhuZGxjdGxQRFNzT1RkMENYUVBrQW51UlNkT0ZsajRZL2VaODJ4SjA3SHIKY0RrTDF4Umdkd2lvcXdhcFpESjN5bFhIbGxxZUg5OVNFbFlKQ1FrdkxscGNmVlJ5N3Y5SEdPTUdoVkZoZG1LeHVhZkp5dVNnMHlyWgpkNnlDK2I4WFVWWlI5L1RZUUg4VlQ5elpndGJodnBnc0xsUktHU2FyaXcxcFYwYmVhMjZ4bFM5L1BVMWhxVjJjaFNXVHVTY0pkR3lwCjVkWDdvbWdYcWJuSVdpUWtKSzQxTGttdVVJQld4VVAvREdmOG9PWmVBcXRXdWVPdmExTFBzSGhqY2IwenNOcEZhbmo4OWpEVUtobFcKdXd1TldrN0dDUk1iMGtvdnEzSE1WaGRmL1piUDdzd0tmRlR1N0FBWmJtSDE1UDEyYUJWdzBmVklTRWhjZTF5eVJFeTlUc1dqdDBkNApDU3lBbjBhTzNlSGkyN1VGYkV5cmYvV3NtNjhQNGY1L2hHTzF1OWZtTk5zdXYvZTZiSE1ScTNZWVVNcGw3cVVFY1M4djJEcmNsNWZ2CmJYWEp0c21Xa0pDNDlyaWtlNng0Qk5iaEVsaThvUkNuMHkydWVwMktmSU9OYjFZWEV4WHFXNmUzcDVETEdETXdoQ081Wm43ZGJzQmYKb3hDOTF3bEQvdnFaVGpzT0dsbTRwa0RjQVZjUW9NUm9wM1c0aHBmdmJYVlpGMkpKU1VsaDI3WnQ5WDRmSFIxTlZGUVU4Zkh4dGRZZwpuVDE3Tm9DNGtyK0VlK3VWUllzV0VSMGR6ZDEzMzMzTzhpYVRpVzNidHBHV2xrWk9UZzRtazRrUWZRalIwVkYwN2RhdFRydGZMcVQ3CmZmbTQ1QnRZNlhVcUhoc1JnZE1wc0d4ekVRb0YrS3JsaEFTcTJKMVp6dnpmaS9qWE9OODZjMEVEL1ZWTUdSbEJkcUdWZmNjcVVDbmwKYkVncjVhWnVPaUpELzdxNDVvbDhDMS8rNnQ0T1BEaEFoVndHcHcwMjJrZHBlZVcrbHBkOWhhdVNraEl5TXpNSjBZY1FyQSt1OVgxeQpjaklBaXhjdlp2TGt5Y1RFeElqZlpXWm1OcnFldnd0bXM3blJkakVZRE15WU1VTVUxSDc5K3FIVmFzbkp6dVp3WmlaNzA5SllsNXpNCjFHblRyZ2lCbGU3MzVhTkpkZ2NNYTZibWlUdGJBTzZ1dGNlRGJSYWc1TmZ0QnRwRmF1cmQyaVV5Vk1OVG95SjU1YXZqWkJkYTJYKzgKa2czcFJpWU0rV3ZFMVd4MXNXQk5BZHN6ak9pMFNtUnk5OTVYcmNOOWVlR2VhSHAzdUhLMkZ1NlgwSS9odzRmWCt0eGtNckZ1M1RwVwpyRmpCN05temVlV1ZWNGl1MnB4UDhtQXVqc1dMRm1FeW1SZ3hZa1F0MjV0TUpoWXZYa3hLU2dxTEZ5OG1NVEh4Y2pkWHV0K1hrU2JiCmVyV213QUlFK2l1dzJnVytXWlZQNitaS2h2UU1yZlBZNjlzSDhPVElTR1l1UE1XWmNnZS9iUy9oaHM2QmYwbTYwN0xOUmF4TU1hQlIKSzFDclpCU1h1ZGRrZlhGQ1N4STZCZGE1emNpVmhsYXJGVi84RlN0V3NHN2R1bk8rNkNhVGljek1USEp5Y2dEM0JvRXhNVEdpS0h2dwo3RlNxcjlybjNtQXdjUGp3WVVwS1NvaUppZkh5a2swbUV6azVPV1JtWmhJY0hIek83bkptWmliRnhjWGl1VHgxMUd4blRrNE9HbzJHCjZPaG9yenJxYTNQTk9yS3pzd0YzK0tSNmV4dkQzclEwZ0RwLzFMUmFMV1BHakNFbEpZV1VsSlE2YlY3ekdxT2lvbXJacEthTnM3T3oKU1U5UEI2QmJ0MjZZemVZNmJWTzlEb0NvR2x1SjF5UTdPNXZzN0d4S1NrcUlpb29pTlRXVndzSkNYbnJwcFRyTGU5cmx1Wi9SMGRIbgp0TFduTGNIQndjVEd4dGJiNW11Ukp0M1gyaU93RHFmQUx5bkZLTXdRNk9mT2YvMzBsMEphUi9qWG1jYWtVc3E0cFdjd1IvTXNmTEVpCmo0T25UR3pkWDliazRycDFmeGtMMXhUZ2NBbm90QXBSV0o4ZjM1SWJ1MXdkd2xxZFFZTUdzV0xGQ3E4WDNST0QrL3p6ejhWeUhrL0wKWkRMVk9rZDBWSlJYRjNmYnRtMnNXTEdDd1lNSFUySXdpR0pUdmZ6a3h4OG5MUzJObFN0WGVwMHpLU21KeE1SRUVoSVN2STVKUzB0ago4YUxGRkJ0cUQzZ21KQ1F3WnN3WXNmNmNuQnhtejU1TlRFd01zYkd4SkNjbjEycDNURXdNa3lkUDloS3R6TXhNa3VZbjFhb2pSQi9DCm9NR0RHbTFUclZhTHlXUWlPenU3VG1IUmFyVmV0ajJYamJWYUxZTUhEL1lTYTQrTlI0d1lnY0ZnSUNVbFJmd3VPRGlZcEtRa1ltSmkKNnZSS0RRWURzMmZQSmtRZndzdzNaOVo1dncwR0EvUG56NjhWTXRpN2R5KzdkdTNpbVdlZThiS2R5V1JpM3J4NWRZWVlZbUppdVB2dQp1NzFza1oyZHpXZnpQcXZ6Zm5hUGoyZGlZdUlWRVRKcGFwcFVYT0hzV3JCT2w4Q2ExRE9BQzMyZ2lxd2NFM04venVQMXhKWUUrdGVPCnYycDg1Tnc3Skl4amVXWldiak0wdWZkNkl0L0MvTlg1N2ppclRvWEJhQ2M4V00zejQxc3lzTnVsMmJuMHIwYXIxUklURXlONmEzV0oKZ2NGZ0lDa3BpZWlvS0JJVEU0bVBqd2ZjTDlUS2xTdEpUazZ1czR1Ym5KeE1URXlNR0hLby9zTE9tREVEZ0RGanhvamVha3BLQ2tsSgpTU1FsSlhsNU1KN1B0VnF0V0w5V3F5VTdPNXRmVjY0a0pTV0Y3Rk9uYXNVd2MzSnlLREdVZU5XUm1abkpvaDkvSkRNemt3VkpTVHcyCmVUTGdmdGxuejU2TlZxdGx4SWdSOU92WFQvUUlmMTI1a2tXTEZqWGFwdkh4OGFTa3BEQm56aHo2OWVzbmV0Z05lWENlYXd6UmgzaTEKTnkwdGpaVXJWckJpeFFwTUpsT3R3YlJ0S2Rzb05oU1RrSkNBWHEvSFpES1JrSkRBNHNXTHljek1GTDNiNnF4Y3VSSndoNHpxd21ReQpNV2YySElvTnhYWGFvbnYzN3N5WlBadFhYbjIxV3ZuWlpPZmtrSkNRd0tCQmc4VDc3ZmtSbURObkRxKzg4b3JZbGpsejVnQjQvWkFhCkRBWVdMMXJFM3JRMGd2WDZSZzBjWHUzOEpXdmloVFZUTTNWTUZNTjZCMk8xQzFodExvTDhWYXpkWGNLQ05ZWDFyajhRMWt6Tk02T2oKNk5MV242Mzd5MWk3KzB5VHJQZHFySFI2eFZuTFRVNjNzSTVyd1UzeGwyN24wc3VKMld5dTgvTTBUemQzeEFoUldNRXR6SjRYb0xpNAp0Z2NTb2c5aDJyUnBvcWpvOVhydXYvOSt3UDFDVHA0OG1ZU0VCRkVRRXhJU3hCZk5VNmNuUmdrd2RlcFVyL0xSMGRFOE5ua3kzZVBqCnljN0pZZDI2ZFY3MW0wd21wazd6UGlZbUpvYkpqejhPNE9WUmU4UXpNVEdSNGNPSGl5TGdxZU44UWdOanhvd2hKaVlHazhsRWNuSXkKOCtiTlk4YU1HVHo2NktQTW5qMmJSWXNXaVdHSDZ0ZW8xV3BydFRjK1BwNnAwNllSb2c4aE9Ua1pnOEY3VFkxaVF6R3Z2UEtLMkc3UAovUmc4ZURCd1ZraXIxNVdXbG9aV3EyWFFvTHE5OFhYcjFvbkNXcDh0c25OeXhIdTBidDA2c25OeUdEeDRNSW1KaVY3MzI5TW16dzh4CnVIc0lKcE9KcUtnb3J4NktYcTluWW1JaU1URXhsQml1dkxWRG1vSW05MXc5aERWVE0vWHVLSlFLR1N1MkdRQVgvaG9GM3ljWDBENUsKd3kwOW05VXBZdTBpTlR3M05vcG41eDdseC9XRkRPblI3Sko2cjA2bmt4WGJpbG1aNGs3L010dGNoQVdwZUg1OHk3L0Y5aXlEQnc4VwpYMVlQbnU3ZnVxcXNnN3FveXpPcTdrWFZKVmllN3oxQzcza1JFeElTNnZYOHh0eDlOM3ZUMGtqYnU5ZXI2K3p4R0J0cUE1eU5KWWZvClE3eCtQR3Jhb0xHajZscXRsbW5UcHBHZG5VMW1aaVpaVlRIVTdLcTRiMlptSnNuSnlhSjRlYTZ4ZTN5OEdMT3NTVXhzRE1VcHhhU2wKcFhuZGkvcnM0Z24zcEtXbGVZVk10bTNiaHNsa1l2RGd3ZlYydTlQMjduWGZ2MzUxZTdZMVF3MmU4cDRlVUUwODdVdExTeU14TVZHTQo4MlptWnJKbzBTTGk0K1BGK0xqSGRuOFgvakp4QlhlYTF0UXhrUUNzMmxHQ1NpbkQ3aENZKzNNZUxVSjg2azNLdjdGTElJL2YwWUlQCmwrYXdhRU1SL3hvYmZVbmluNElBVy9hWDgrV3ZwM0c0QkJ3dWlBeng0Ym14VVF6c0Z2UlhtcWJKTUZmRitCb2EzUERremRaOGVjNTMKc09kODhReWVOVFRJNGZrdXU2cnNoZFpSVjhxYWg0YTY5QTBkRXgwZDdTV0dub0duRlZWZC9XN2R1b24xNzAxTHF4V2Zya25OM2tWOQpkdEZxdFNRa0pJajN6ZE9HZGNsdTc3N21qMlYxc2h0aDg3ckt6NXMzcjhGeW5saXlKN3l6ZVBGaWtwT1R4YlJBY1BkMlltSmp4TkRDCnRjNWZLcTdnem1XZGRuYzBDb1dNbFNrR1ZFb1p1Y1ZXUGw2V3c2eEpiZXZNZjFYSVpZeTkyVDNCWU5VT0EvL29IWHhKWmtjZHpUUHoKeFlyVEZKZlpVU25sMTV5d21rd21zbk55Q05HSDFPdkpMRnEwaU9Ua1pFTDBJWXdZTVlLWW1CalIwd0I0OU5GSG02eDlHazNqMCtzdQpkQUNrTVhYVU5aQlhGeDR4Njlldlg2MUJPVGdydUo2UVFYcDZ1bGgvUWtKQ3ZkNmloL01aU1I4K2ZEZ3BLU21zUzE0bmV0N1Y0N01OCjJiR3gxMXU5L1BsNG5KNFFrQ2ZXYnphYnljbk9KanM3aDVTVUZOTFMwcnhpdE5jcWY3bTRnbnV6d21sM1I2R1V5L2g1U3pFK0tobnAKUnlyNS9KZlRQRHNtQ28xUDdWQndnRmJGWTdlM0lMdlF5czliaW9tTjFselVOaXFGWjJ4OCtldHBjYkpDWklnUEw5d1R6UTJkQXkrSApTWm9FVDV5eVczeTNlc3Q0Wm5xOS9NckxkYVlFTlNVZXozaGJ5clk2VTVzQWNhUTg5Z0s5YUU5MzFOTTlyMHVrUFdsTzU4SnpIcjhxCno3R2hjb0NZcmdTUWZlcFV2ZWx3SGdFNm54OGJ2VjVQOS9oNGQ4Z2tMWTN0VmZmeFhBSWVHeE1qSGxOWG1DUXBLVW5NTGtsSVNCREwKbTB5bU9zdFhUNDN6M0srU2toSnhzSzltNytlemVmUFltNWJHdG0zMTMvTnJoY3UyeVpPZnI0Sm54MFJ4NTQwaHlLdjYrTDl1TjdCcwpjMUc5ZzFhdHczMTVhbFFraFdkc3BCNHVQNC9hdkxIYVhmeVNZcWpLWGtDY0lIQXRDV3R5Y2pJclZxend5bmx0aUpwQ2FqS1ptUGZwCnAwM2FSaytlYWJHaG1LU2twRnJmWjJkbml3TmVneHJvNnA0TFR6ZDVRVkpTTGE4dE96dmJxK3ZhRURFeE1XaTFXdmFtcGRWN1RQWHoKeGNmSGk5ZVluWk5UNXpXbXBLUXdZOFlNRnYzNDQzbDc1eDZickZ5eGdyMXBhWFdLV1UzNlZvbnZ5cW9NaFpwdFQwbEpRYXZWaWtMcQpxU01wS2Nscm9BN09aaExNbmoxYmZIN01aak1yVnF5b05kaFdrK0RnWUs1MUxvdm42a0hqSStmWk1WRW9sVEorMmx5RTJlYmVucnQxCnVHKzlRdGVubzQ3OEVodDdNaXZvMHNZZm5aL2l2T3RkdjdlVWIxYmxZN0k0aVd2dDNuVHhhaFRXYlNuYk9IejRjSzNQcTg5M2YyenkKWXcyK3RQMzY5U001T1ZsTUxkSnF0UmdNQm5HME9FUWZRazVPRG9zV0xXb3dsbmVoVEo0OG1UbXpaNU9Ta2tMbTRVeTZ4WGNUcDVONgpZcFNKVmFQTUY4cnc0Y001ZlBnd2U5UFN5TTdPcVZWSGRGUlVvN3JLV3EyV3FWT25NbWZPSEJZdFdzUzY1SFhFeEo0ZFdEdDgrTEFZCnQwNnNsc3RaM3pXbTdkMHJobTBTcXpJdHpvZVltQmlpbzZMRXVPaTV2Rlp3Qzc0blh2dnl5eThUSHgrUFhxOFhiZUdKbVZiUHdFaE0KVENRcEtZa1pNMmJRUFQ2ZXFLcFVyTFFxajNidzRNR2lHUGZyMTQ5dFZaTW9zaytkSXI1N2Q3RnV6L1ZHMThna3VGWlJ2UDc2NjY5Zgp6Z2FvbERKNnhnWlFWdWtrSzhlRXdXam5WSUdWdmgzOTBmblZ2UmRWWklpS2tuSUhGcHVMRm5vMXN2TVkzVHAwc3B5WjMrV1FVMlM5CjRvUjE5KzdkOU9qUjQ1emxpb3VMM2QxSWJkM2R5RTZkT2pGZ3dBRHV2dnR1UWtKQ3ZMN0x6TXhFcjllTEQzZW5UcDJReVdRWXk4cEkKUzA5M2k0TWdrSkNRd01NUFAwemJ0bTBwTnhwQkpoTlRrTXhtYzcwem9XcWV2NjUyVno5V3BWTFJzMWN2d3NQRE1SZ01uRGgrZ3JTMApOSFE2SGJHeHNTUW1KdEs1YzJmeEhDYVRpZno4ZktLam8rblVxVk9kMTE5WEd6eXhTSVBCUUVaR0JzZVBIMGVqMFRCOCtIQUdEQng0CnpuTjZDQXdNWk1DQUFRUUdCbEptTENNbjI1MjI1S2t6UGo2ZVJ4NTVoTmpZV1BFWWxVckZnSUVEeGZvOTF4Z2VIazVDUWdLSmlZbGUKOTZrdU85V0hMakFRbzlGSXkraG9SdDUxVjZOc0VSOGZUMnhzTE9WR0k4ZVBIU2N0TFEySDNVRjg5M2p4bmxjbk9qcWFoSVFFekdZegpaV1ZsYk51MkRiUEpUTnUyYlpnd1lRSURCZ3p3dXRhZXZYcWhWcXZKejg5blYycXFtRVhodWQ1N0preEFwYnIyOTVtVENVSlRaSTZlClAyYXJpM20vNVBHLzVFTE1OaWUzOWRYejBvUlc5WHFtQnFPZDNHSWIxN1h3ZGU5cDFRaHlpNjI4OWQwcFZtNHpjSDFNd0JVbHJBQmYKZlBFRmt5Wk51dHpOa0pDUXVBUmN0cGhyVFRRK2NpYmYzb0w3Ym1tT1Npbm4xKzBHRm0wb3hPbXFXL3YxT2hXeDBScVVpc1o1clZhNwppNlRWQmF6Y1pxQkxXMzlldnJmVkZTV3NFaElTMXhaWGpMaUNXMkFuallqZzhUdmNDNzU4c2VJMDYvZlV2OEMyajByZTZJeUJKUnVMCldMQW1udzR0dGJ4K2Yrdkx2bXlnaElURXRjMFZKYTdnRnN6N2Jtbk8wNk9pTUpvY3ZQMi92SG8zT0d3c093NGErWEJKTHRGaFBzeDgKdUswa3JCSVNFazNPRlNldTRCYll4RnZEZVc1c05ObUZWcVl2ek1GZ3RGL1F1VTdrVzVpeDhCUmFqWndaRDdXUmhGVkNRdUl2NFlvVQpWM0JuRVhnRWR0K3hDdVlzeXFsM2c4UDZNRlk2bWZudFNTck1EdDZlMUpZK0hhK2NoYTRsSkNTdWJTNXJudXU1OEFnc3dGZS9uYVpOCmhDOFAzeGJSNk9NLytTbVg3RUlyTXg1cWMwMEo2OXlsV2JVK0M5QXE2UjBYY2szc1Jyc3p3MEJ1a1lXUkF5UHIvUDcrNlR1WS8ycWYKT3IvN2FXTXVlY1cxYzFaN2RReW1kOXpGVDdkY20xckU4bzJuS0RjNWVHRmlYSlBiZSs3U0xPNGNFUFdYYlhOMEpkdStLV2hLKzE2eApucXNIajhBKzlNOElsbTgxc0hwblNhT08rMjV0QVFkT1ZQTGloSmJYWEZiQTNDVlo1QlY1TC9LUlYyUWg4WTN0ZFFydjFjYXVneVVzCjMxVC9RaTA3TStxZmxydDhVdzY3TW1vL0l5OS90by83cCsrNDZMYTlQQytOeUZBdGo0OXFSMlJvMCsrTU1YZEpGcmxGalY4TDRHSzUKa20xL0tZZ2IvNXZYTlRTbGZhOW96OVdEU2luanZsdWFvL0dSczNSVEVhRkI2Z1pqcHh2VFM5bDJ3TWlrRVJFTTZCcDB1WnZmSk53eApJTEtXTnhEYlNzZXNCUms4TWFxOStGbTV5YzdCRTBZNnR0WVJvSzA3Y2R0VHB2cjVEcDBzeDFocHE5Zmp5QzB5azF0a2F2Qzg0SDRaCjZ5dlQySE9jTDczaWdyMXNBSERuZ0NpR1ByV2VReWZMdmJ6TlF5ZkxDZEFxdlR5WGh0cFZickl6cUdkWUxidWN5ODZlN3lORHRYVjYKU2ZYVm1mSERQNXZFOXVkcXoxOWgrOXdpTStVbVI2M1B6blZ0alhrMmE1NjNQdXF5Nzdud0RMQ2Y2L3hYaGJpQ2U1QnI5TUJRdENvSAp5WHZPb05jcDYxelg5ZERKY3JiK2FXVDg0REQ2eHVtdXVxMVpMb2JJVUYvS1RlNkJ2M0tUblNtejk3QXp3MER2T0wzNC80K25YVStBClZzWE9EQVAzVDkvQnpNZTY4ZkpuN29WTE1uNzRKejl0ekdYV2dnenhoY3N0TXZQQ3hEaXhtM2pvWkRsVFpxZFcxYWNWQmFYbWVTY08KYTBOeWFqNlJvZHBhZFovckhFMWpHL2YxR0N0dDNEOTlCeDFhNmRpWlllRFFTU05Qakc3UEU2UGFOOWl1QmF0T01IZUp1MWZnOGNMbQp2OXFIanExMURkclpjeDg4NTZwNXJUWHIzSmxoWU9Ld05yd3dzU1BnOXJUbXY5cUgzbkg2UzJMN211M3hlRzBmVCt2WlpDR082cmFmCnV6U0xYUmtsUklacStHbGpEcjNqOU14L3RVK2pub25xejZiT1R5VmVxOGRXaDA2V00ydEJocGV0aC9ScXpnc1RPOVo3L3p4aGpsMEgKUzFqdzJ3bDJmRFhVcSsxRG4xclBuUU9qZUdKVWU3RituWit5Nm5vY1h1OUdMWVNyREl2TkthemFZUkNXYmNnUmlzdHNYdDhWbDltRQpiLy9JRjFJUGx3c09wK3R5Ti9XOCtmenp6eHRWcnVPNFg0VWRCNHE5UHNzcE5Ba2puOThzUFBsZXFpQUlncEQ0eG5iaHBYbnBnckhTCmJTTmpwVTFJZkdPN2tQakdka0VRQkdISGdXS2g0N2hmaGNRM3RnczVoU2F4WE84SDF3akxOdVNJNXoxNHdpaDBIUGVyV0tiM2cydUUKVDVaa2l0OGJLMjNDaysrbDFqcnZXMGtaWG1WNlA3aEdTUHJ0bUNBSWdqQmt5anJ4YjgvM0k1L2ZMSjcza3lXWjR2bnF1Lzc2U0h4agp1MWY3UE9kL2FWNjYwUHZCTldLWmp1TitGYS9UV0dscjFMWFZaZnR6MlRucHQyUEN5T2MzaTk4TGdpQTgrVjZxOE5LODlGcC9lNDRmCk1tV2QyRFpQZlpmSzlpL05TeGVmRVE4dnpVc1h6OUhVdHY5a1NhYllSby9kRzNOdE9ZVW1vZU80WDRXREo0eGlHYzlubnZ2aHVSYzEKYlZuOXM1cjNyN3A5cXo4VGdpQUl5emJraU0vK2pnUEZRdThIMTNnZCs4ZXV3anJmUlE5WGplZnF3VWNsWi9EMXpkaDNUTTJKZkN2KwpHZ1UrS2psV3U0c1QrVmI2ZE5UUkpzSVh4VFd3TlV0RDFJeGhCV2hWOUk0TDVzM0pYY2t0TXJNenc4QkgwM3B4OElSUkxET29aeGl6CkZod2t0MXE4dHFhM3FQTlRzaTQxbndBL05UcXRuSTZ0ZFdMWDZhZU51ZWo4bEY3ZHZnQ3RpaGNteGpIMHFmVmU1L1Y0RTU0eUhWdnIKS0RjNUFQampvNXVCczEzQTNDS0wxN0VYeTl3bFdhS1g0cUYzbko2azEvcUsvNTQ0ckkzb2NRUm9WWTI2dHByZDU4YllPVUNySnJmSQp6RThiYytqUVNvZk9UODNIMDg2dUg2SHpVM0h3aEpHZk51WVNHZXBMWktoV3RFOTExdTRxdkNTMm4vbFlWK0JzV01Cb2NuSHdoTEhlCmRUeWF3dllkV3VtODJ0aFkyM3VlUTA5WVlOZkJzL0Zkejcybzdua0dhRlhNZjdXdmVPME5FYUJWTVhKZ0ZBdFhIUmVmaStXYmNoZzUKMEQzWTllblNMSHJIdVZmeThzUnNkVm81SFZycFdMNHB0ODRReFZVbnJ1Q093Y2EzOHlPL3hJYkY2c1JISmFmQzdLUjF1QTlCL3NwcgpYbGdCc2F0WUY1NFgvZHRWeDJwOTF6dE83L1d3MWV5R2Z6eXRKd3RYSGVmVEpZYzVkTklvSHZQeHRPdkpLellSR1ZwN2hhMnpJWVRHCkRRek1YWnJGZ3Q5T2lOMjdYbkhCbHpUdTUrbm1OMFNBbi9lajM1aHJxeTJ1cG5QYWVlVEFTTXBOTnRhbEZqSjN5UkhLVFhaUk9FWU8Kak9TRmlSMlp1K1FJeXpmbGlDOXRaS2ltVmpmOVV0bCtiV29SYnkvWVgzV3NsZzZ0ZEVTR2Fob2xRSmZLOWpXRnZESFhwdk5UTW12QgpRVEdVRUtCVjBpdnU3TEtGbnV1ditUeWZ6M1AxK0tqMkRIMXFQVHN6RE9qODFPek1NTlJ5QkQ1ZGVxVFd0ZFFYeXJvcXhSWGN1eE8wCjBQdUkvMjdtcjBRbWsvMnRZcXoxMGJHMU8rMnNacXFRNXdIcDBDcWd6bEhmM0NJenlhbjVvbmZqK2V6KzZkdFpzT29Fc2EyQ1dQRGIKQ1ZFZ1BIak81WWx6TmNTaGsrWE1YWkxGc2xuOXZkcVd2S3Znc3Rxc01kZDJJWGIrYVdNdUhWcnBtRGlzamZqOTNLVlp2UHhaT2lNSApSckpnMVFudUc5WmFGSUZ5azUyWDV1MWoxb0lNcjVTblMyRjdjR2M3UERHNm5WZDdaaTA0S1A2UVhxbTIvMmxqanVpWmVzcVVtK3pNClduQVFRQlRubWoyTXVVdXpLSzkwZUhuSzlSRVpxcUYzbko2RnEwNmc4MVBSTzA0dm5xdERLeDBCV3FWWHI4UFR4cnArR09BcVNNVnEKQ0prTVVVemxja2xZUFFSb1ZVd2Mxb2FYNXFXek5yVUljRDhFVTJidlpsMXFZYjNINmZ5VUxQanRCQXRXSFJjSHhuS0xUQmdySGNTMgpDbUpJejFBaVF6VzhORytmMkEzZG1XRmcxb0tEVEJ6VzVyd0dvenhDNEI3STJNMmhrMGJ5aXN5WE5EeHdQbHpJdFRYR3pubkZwaXJ4CmNvOHdsNXZzNUJXWjZkREtMY3k3TWtyNGRHbVdXS2V4MGtGdXRlOHZwbjMxa1Zka29keGtKN2ZJN081RnJEcU9zZEorMGRQTW05cjIKYnR0WUFMY0hudmlHT3pSMjZLUVJuWitTd1QyYlZ6MUw1ZUk1RnZ4MmdwNXgzc3R1ZXM1UkY0K1Bha2R5YWdFL2Jjemg4Vkh0eE0vdgpHOWFhblJrbHpLMjZWK1VtTzNPWFpqRmw5cDU2ejNYVmVxNS9aM3JINmRINXFSc3M4OExFanN4ZG1zV25Tdzd6MU94ZDlJN1RjK2ZBClNORmowZm1wYTRVVkFyUXFrbDdyeTl3bG1XSVh0a01ySFJQLzJab2hQVU1CU0hxdEQ3TVdIT1QrNmR0RkVSamNxN25ZRmF6cnZPRCsKNVc4Um9xVkRxd0JtUHRhTmhhdU84L0puNmVMeGR3eHN5YmVyanJFem82U3EzSVYxVXozMVhFaVpjMTFiWGJZL2w1MDl4NzQwTDUxRApKNDNWWXVQdXJYYytubmE5VjUwZTcrbUowZTFxMVhleHRuZWZveSt6Rm1UUTU2RS94THFXemVyUHJBVVovTHd4aDloV3VpYTFmWDMzCjlselhObkZZRy9LS0xFeVpuVXB1a1puZWNYb2VIeDNMNFpPbHJFc3RwSGRjQ0c5TzdzcmNKVWU4eXN5Y0hDOCt1K0FPVzh4YWtNR3MKQlJra3ZkYTMxdjNzSGFkbjVNQW9qSlYyTDF0R2htckVkK091MzdhZzgxT0tzZVQ2UWc5WHpIcXVFaElTRXRjU1YzVllRRUpDUXVKSwpSUkpYQ1FrSmlTWkFFbGNKQ1FtSkprQVNWd2tKQ1lrbVFCSlhDUWtKaVNaQUVsY0pDUW1KSmtBU1Z3a0pDWWttUUJKWENRa0ppU1pBCkVsY0pDUW1KSnVEL0FZaFBQOXEzUjlyd0FBQUFKWFJGV0hSa1lYUmxPbU55WldGMFpRQXlNREU0TFRFeExUQTFWREUwT2pNeU9qTTEKTFRBM09qQXdYSDdSK3dBQUFDVjBSVmgwWkdGMFpUcHRiMlJwWm5rQU1qQXhPQzB4TVMwd05WUXhORG96TWpvek5TMHdOem93TUMwagphVWNBQUFBWmRFVllkRk52Wm5SM1lYSmxBRUZrYjJKbElFbHRZV2RsVW1WaFpIbHh5V1U4QUFBQUFFbEZUa1N1UW1DQyIgLz4KPC9zdmc+Cg=="></td></tr>
</tbody></table>

<center class="Pink"><br><b>GAIA Automated</b></center>
<center class="Pink"><b>Device Health Check</b></center>' > $html_file
printf "<center class=\"dateGreen\">$(date "+%Y-%m-%d %H:%M:%S")</center>\n" >> $html_file
printf "<center class=\"hostnameTeal\">$(hostname)</center>\n\n" >> $html_file


echo -e '<br><br><table class="healthCheckTableBorder">


</table><div class="verticalBlueLine">
<table class="sectionTable">' >> $html_file
}


#====================================================================================================
#  Function for logging
#====================================================================================================
logger(){
    local curTime=`date +%F_%T`
    # "s" for silent, write into the log file, but not to console
    if [[ $2 != "-s" ]]; then
        printf "$curTime $1\n"
    fi
    # Write into the log file
    printf "$curTime $1\n" >> $summarizedLogFile
}


#====================================================================================================
#  Function to end a check as "WARNING"
#====================================================================================================
result_check_failed()
{
    #Insert blank line between individual errors of the same overall section
    if [[ $all_checks_passed == false ]]; then
        printf "\n" >> $logfile
    fi

    #Insert VS name between VS checks
    if [[ $vs_error -eq 2 ]]; then
        vs_error=1
        printf "\n\n" >> $logfile
        printf "#########################\n" >> $logfile
        printf "#  Virtual System $vs\t#\n" >> $logfile
        printf "#########################\n" >> $logfile
    fi

    #Set output of specific check to WARNING
    if [[ $test_output_error -eq 0 ]]; then
        printf " WARNING\t|\n" >> $output_log
        printf "${text_red} WARNING${text_reset}\t|\n"
        printf '<span class="checkFailed">WARNING</span></b><br>\n' >> $html_file
        test_output_error=1
    fi

    #Display summary error for overall section
    if [[ $summary_error -eq 0 ]]; then
        summary_error=1
        printf "\n" >> $logfile
        printf "+-----------------------+\n" >> $logfile
        printf "| $current_check_message|\n" >> $logfile
        printf "+-----------------------+\n" >> $logfile
    fi

    #Set flag that a check failed
    all_checks_passed=false
}


#====================================================================================================
#  Function to end a check as "INFO"
#====================================================================================================
result_check_info()
{
    #Insert blank line between individual errors of the same overall section
    if [[ $all_checks_passed == false ]]; then
        printf "\n" >> $logfile
    fi

    #Insert VS name between VS checks
    if [[ $vs_error -eq 2 ]]; then
        vs_error=1
        printf "\n\n" >> $logfile
        printf "#########################\n" >> $logfile
        printf "#  Virtual System $vs\t#\n" >> $logfile
        printf "#########################\n" >> $logfile
    fi

    #Set output of specific check to INFO
    if [[ $test_output_error -eq 0 ]]; then
        printf " INFO\t\t|\n" >> $output_log
        printf "${text_yellow} INFO${text_reset}\t\t|\n"
        printf '<span class="checkInfo">INFO</span></b><br>\n' >> $html_file
        test_output_error=1
    fi

    #Display summary error for overall section
    if [[ $summary_error -eq 0 ]]; then
        summary_error=1
        printf "\n" >> $logfile
        printf "+-----------------------+\n" >> $logfile
        printf "| $current_check_message|\n" >> $logfile
        printf "+-----------------------+\n" >> $logfile
    fi

    #Set flag that a check failed
    all_checks_passed=false
}


#====================================================================================================
#  Function to end a check as "OK"
#====================================================================================================
result_check_passed()
{
    printf " OK\t\t|\n" >> $output_log
    printf "${text_green} OK${text_reset}\t\t|\n"
    printf '<span class="checkOK">OK</span></b><br>\n' >> $html_file
}


#====================================================================================================
#  Local Checks Function
#====================================================================================================
run_local_checks()
{
    #Ensure we have the clish database lock
    clish -c "lock database override" >> /dev/null 2>&1
    clish -c "lock database override" >> /dev/null 2>&1

    #Set location of cpview file
    cpview_file=/var/log/CPView_history/CPViewDB.dat

    #Initialize temp log files
    printf "\n\n" > $full_output_log
    printf "########################################\n" >> $full_output_log
    printf "#  Full system diagnostic information  #\n" >> $full_output_log
    printf "########################################\n" >> $full_output_log
    printf "\n\n" > $logfile
    printf "#################################\n" >> $logfile
    printf "#  Health Check Summary Report  #\n" >> $logfile
    printf "#################################\n" >> $logfile

    #Initialize CSV log
    printf "Category,Check,Status,SK\n" > $csv_log

    #Detect CPU info for later checks
    mpstat_p_all=$(mpstat -P ALL | grep -v Linux)
    for (( i=1; i<20; i++ )); do
        if [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep idle) ]]; then
            mpstat_idle=$i
        elif [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep us) ]]; then
            mpstat_user=$i
        elif [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep sys) ]]; then
            mpstat_system=$i
        elif [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep wait) ]]; then
            mpstat_wait=$i
        elif [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep soft) ]]; then
            mpstat_soft=$i
        elif [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep CPU) ]]; then
            mpstat_cpu=$i
        fi
    done
    all_cpu_list=$(echo "$mpstat_p_all" | awk -v temp=$mpstat_cpu '{print $temp}' | grep ^[0-9])
    all_cpu_count=$(echo "$mpstat_p_all" | grep ^[0-9] | grep -v CPU | grep -v all | wc -l)

    #Display check header
    printf "\n\n##############################\n# Health Check Results Report\n########################################\n\n" > $output_log


    #Special message for SP devices
    if [[ $sys_type == "SP" ]]; then
        printf "The current device is Scalable Platform.\n"
        printf "Please note the checks will only be run:\n"
        printf "\tOn the local SGM unless using the \"-b all\" flag\n"
        printf "\tOn the SMO if executed remotely from the Management Server.\n"
    fi

    #Create HTML header
    initialize_html

    #Log Header
    printf '<tbody><tr><th><span class="sectionBlue"><b>Physical System Checks</b></span></th></tr>\n' >> $html_file
    printf "\n\n"
    check_updates
    printf "Current Script Version: $script_ver\n" | tee -a $output_log
    printf "Hostname: $(hostname)\n" | tee -a $output_log
    printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
    printf "| Physical System Checks                                                |\n" | tee -a $output_log
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    printf "| Category              | Title                         | Result        |\n" | tee -a $output_log
    printf "+=======================+===============================+===============+\n" | tee -a $output_log


    #Checks to run for all devices
    check_system
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_ntp
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_disk_space
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_memory
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_cpu
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    if [[ $sys_type != "SP" ]]; then
        check_interface_stats
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    fi
    check_known_issues
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_processes
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_core_files
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_cp_software
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_licenses
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    if [[ $(clish -c "show asset system" | egrep "Smart-1 [0-9]{4,4}") && -e /opt/MegaRAID/MegaCli/MegaCli ]]; then
        check_raid_smart1
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    elif [[ $(dmidecode -t system | grep Manufacturer | grep CheckPoint) ]]; then
        check_raid
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    fi
    check_debugs
    printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log
    printf '</tbody></table></div>\n' >> $html_file

    #Checks for firewall applications
    if [[ $sys_type == "STANDALONE" || $sys_type == "GATEWAY" || $sys_type == "SP" ]]; then
        printf '<br><div class="verticalRedLine">\n<table class="sectionTable">\n' >> $html_file
        printf '<tbody><tr><th><span class="sectionRed"><b>Firewall Application Checks</b></span></th></tr>\n' >> $html_file
        printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
        printf "| Firewall Application Checks                                           |\n" | tee -a $output_log
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        printf "| Category              | Title                         | Result        |\n" | tee -a $output_log
        printf "+=======================+===============================+===============+\n" | tee -a $output_log
        check_magic_mac
        check_fragments
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        check_connections
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log

        #Only collect clusterXL stats if clustering is enabled
        if [[ $(cpconfig <<< 10 | grep cluster) == *"Enable"* || $sys_type == "SP" ]]; then
            printf "\n\nCluster Status:\nCluster membership is disabled or device is SP.\n\n" >> $full_output_log
        else
            check_clusterxl
            printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        fi

        check_securexl
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        check_corexl
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        check_logging
        printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log
        printf '</tbody></table></div>\n' >> $html_file

    #Checks for VSX
    elif [[ $sys_type == "VSX" ]]; then
        #Global Checks
        printf '<br><div class="verticalRedLine">\n<table class="sectionTable">\n' >> $html_file
        printf '<tbody><tr><th><span class="sectionRed"><b>Firewall Application Checks</b></span></th></tr>' >> $html_file
        printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
        printf "| Firewall Application Checks                                           |\n" | tee -a $output_log
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        printf "| Category              | Title                         | Result        |\n" | tee -a $output_log
        printf "+=======================+===============================+===============+\n" | tee -a $output_log
        if [[ $(cpconfig <<< 10 | grep cluster) == *"Disable"* ]]; then
            check_magic_mac
            check_clusterxl
            printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        fi
        check_corexl
        printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log


        #Create list of all Virtual Devices
        #vs_list=$(vsx stat -l 2> /dev/null | grep -i -B2 "Virtual System" | grep VSID | awk '{print $2}')
        vs_list=$(vsx stat -l 2> /dev/null | grep VSID | awk '{print $2}')

        #Loop through each VS performing checks
        printf '<br><div class="verticalYellowLine">\n<table class="sectionTable">\n' >> $html_file
        for vs in $vs_list; do
            vs_error=2

            #Add Divider showing the VS to the full output
            printf "<tbody><tr><th><span class=\"sectionPink\"><b>Virtual System $vs</b></span></th></tr>\n" >> $html_file
            printf "\n\nVirtual System $vs:\n====================================" >> $full_output_log

            printf "\nVirtual System $vs\n" | tee -a $output_log
            vsenv $vs | tee -a $output_log
            printf "\n\nVirtual System $vs:\n" >> $csv_log
            printf "Category,Check,Status,SK\n" >> $csv_log
            vsenv $vs > /dev/null
            printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
            printf "| Category              | Title                         | Result        |\n" | tee -a $output_log
            printf "+=======================+===============================+===============+\n" | tee -a $output_log
            check_vsx
            printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log

            #Run additional checks for Virtual Systems
            if [[ $vsx_type == "System" ]]; then
                check_fragments
                printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
                check_connections
                printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log

                #Only collect clusterXL stats if clustering is enabled
                if [[ $(cpconfig <<< 10 | grep cluster) == *"Enable"* ]]; then
                    printf "\n\nCluster Status:\nCluster membership is disabled\n\n" >> $full_output_log
                else
                    check_clusterxl
                    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
                fi

                check_securexl
                printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
                check_logging
                printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log
            fi
        done

        printf '</tbody></table></div>\n' >> $html_file

    fi

    #Checks for Management Servers
    if [[ $sys_type == "MDS" || $sys_type == "SMS" || $sys_type == "STANDALONE" || $sys_type == "MLM" || $sys_type == "LOG" ]]; then
        printf '<br><div class="verticalRedLine">\n<table class="sectionTable">\n' >> $html_file
        printf '<tbody><tr><th><span class="sectionRed"><b>Security Management Checks</b></span></th></tr>\n' >> $html_file
        printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
        printf "| Security Management Checks                                            |\n" | tee -a $output_log
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        printf "| Category              | Title                         | Result        |\n" | tee -a $output_log
        printf "+=======================+===============================+===============+\n" | tee -a $output_log
        if [[ $current_version -ge 8000 ]]; then
            check_mgmt_status
            printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        fi
        check_mgmt_config
        printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log
        printf '</tbody></table></div>\n' >> $html_file
    fi
    printf '</tbody></table></div>\n' >> $html_file

    #Finalize HTLM file
    finalize_html

    #Remaining Checks
    check_software
    check_hardware
    check_blades_enabled
    check_sar

    #Show check summary
    display_summary
}


#====================================================================================================
#  Offline Checks Function
#====================================================================================================
run_offline_checks()
{
    #Determine System Type from cpinfo
    sys_info=$(grep -A2 'Version Information' $cpinfo_file | grep "This is")
    if [[ $(echo $sys_info | grep "Multi-Domain") ]]; then
        sys_type="MDS"
    elif [[ $(echo $sys_info | grep "Security Management Server") ]]; then
        sys_type="SMS"
    elif [[ $(echo $sys_info | grep "VPN") ]]; then
        sys_type="GATEWAY"
    else
        sys_type="N/A"
    fi

    #Find manufacturer
    device_manufacturer=$(dmidecode -t system 2>/dev/null | grep Manufacturer | awk '{print $2}' | tr -d ',')

    #Pull hostname from cpinfo
    cpinfo_hostname=$(grep -A2 "Issuing 'hostname'" $cpinfo_file | grep -v Issuing | sed "/^$/d" | head -n1)
    cpinfo_base_name=$(echo $cpinfo_file | awk -F'.' '{print $1}')

    #Set new log file paths
    logfile="${cpinfo_hostname}_health-check_$(date +%Y%m%d%H%M).txt"
    html_file="${cpinfo_hostname}_health-check_$(date +%Y%m%d%H%M).html"
    output_log="hc_output_log.tmp"
    full_output_log="${cpinfo_hostname}_health-check_full_$(date +%Y%m%d%H%M).log"
    csv_log="${cpinfo_hostname}_health-check_summary_$(date +%Y%m%d%H%M).csv"

    #Initialize temp log files
    printf "\n\n" > $full_output_log
    printf "########################################\n" >> $full_output_log
    printf "#  Full system diagnostic information  #\n" >> $full_output_log
    printf "########################################\n" >> $full_output_log
    printf "\n\n" > $logfile
    printf "#################################\n" >> $logfile
    printf "#  Health Check Summary Report  #\n" >> $logfile
    printf "#################################\n" >> $logfile


    #CPU info for later
    mpstat_p_all=$(grep  'Cpu(s)' $cpinfo_file)
    for (( i=1; i<20; i++ )); do
        if [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep id) ]]; then
            mpstat_idle=$i
        elif [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep us) ]]; then
            mpstat_user=$i
        elif [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep sy) ]]; then
            mpstat_system=$i
        elif [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep wa) ]]; then
            mpstat_wait=$i
        elif [[ $(echo "$mpstat_p_all" | awk -v temp=$i '{print $temp}' | grep si) ]]; then
            mpstat_soft=$i
        fi
    done
    all_cpu_list=$(grep -A500 '(cpuinfo)' $cpinfo_file | grep processor | awk '{print $3}')
    all_cpu_count=$(echo "$all_cpu_list" | wc -l)

    #Create HTML header
    initialize_html

    #Functions to run against offline files (cpinfo and cpview)
    printf "\n\nCurrent Script Release: $script_ver\n" | tee -a $output_log
    printf "Hostname: $cpinfo_hostname\n" | tee -a $output_log
    printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
    if [[ -n $cpview_file ]]; then
        printf '<tbody><tr><th><span class="sectionBlue"><b>Offline Physical System Checks using CPinfo and CPViewDb files</b></span></th></tr>' >> $html_file
        printf "| Offline Physical System Checks using CPinfo and CPViewDB files        |\n" | tee -a $output_log
    else
        printf '<tbody><tr><th><span class="sectionBlue"><b>Offline Physical System Checks using CPinfo file</b></span></th></tr>' >> $html_file
        printf "| Offline Physical System Checks using CPinfo file                      |\n" | tee -a $output_log
    fi
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    printf "| Category              | Title                         | Result        |\n" | tee -a $output_log
    printf "+=======================+===============================+===============+\n" | tee -a $output_log
    check_disk_space
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_memory
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_cpu
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_known_issues
    printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log
    printf '</tbody></table></div>\n' >> $html_file

    #Checks for firewall applications
    if [[ $sys_type == "STANDALONE" || $sys_type == "GATEWAY" || $sys_type == "SP" ]]; then
        printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
        if [[ -n $cpview_file ]]; then
            printf '<br><div class="verticalRedLine">\n<table class="sectionTable">\n' >> $html_file
            printf '<tbody><tr><th><span class="sectionRed"><b>Offline Firewall Checks using CPinfo and CPViewDb files</b></span></th></tr>' >> $html_file
            printf "| Offline Firewall Application Checks using CPinfo and CPViewDB files   |\n" | tee -a $output_log
        else
            printf '<br><div class="verticalRedLine">\n<table class="sectionTable">\n' >> $html_file
            printf '<tbody><tr><th><span class="sectionRed"><b>Offline Firewall Checks using CPinfo file</b></span></th></tr>' >> $html_file
            printf "| Offline Firewall Application Checks using CPinfo file                 |\n" | tee -a $output_log
        fi
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        printf "| Category              | Title                         | Result        |\n" | tee -a $output_log
        printf "+=======================+===============================+===============+\n" | tee -a $output_log
        check_securexl
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        check_corexl
        printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log
        printf '</tbody></table></div>\n' >> $html_file
    fi

    #Finalize HTLM file
    finalize_html

    #Show check summary
    display_summary
}


#====================================================================================================
#  Function to list all gateway items in a domain
#====================================================================================================
run_remote_checks()
{
    #Temp files
    candidate_list=/var/tmp/candidate_list
    candidate_details=/var/tmp/candidate_details
    return_code=/var/tmp/return_code
    return_details=/var/tmp/return_details

    #Collect domain login session
    domain_id=/var/tmp/$domain.id


    #MDS Specific operations
    if [[ $sys_type == "MDS" ]]; then
        mgmt_cli $alt_api_port login --root true -d $domain > $domain_id

        #Check for successful API login
        if [[ ! $(grep sid $domain_id) ]]; then
            printf "Unable to verify successful API login.  Please check you are using the correct port and try again.\n"
            show_help_info
            exit 1
        fi

        gateways_and_servers_list=$(mgmt_cli show gateways-and-servers -s $domain_id limit 500)
        #Find local CMA name
        local_cma_list=$(/bin/ls $MDSDIR/customers)
        for cma in $(echo "$local_cma_list"); do
            if [[ $(echo "$gateways_and_servers_list" | grep -w $cma) ]]; then
                current_cma=$cma
            fi
        done

    #SMS Specific operations
    else
        mgmt_cli $alt_api_port login --root true > $domain_id

        #Check for successful API login
        if [[ ! $(grep sid $domain_id) ]]; then
            printf "Unable to verify successful API login.  Please check you are using the correct port and try again.\n"
            show_help_info
            exit 1
        fi

        gateways_and_servers_list=$(mgmt_cli show gateways-and-servers -s $domain_id limit 500)
        current_cma="SMS"
    fi


    # Check if the CMA or SMS is active
    #Change context to CMA if needed
    if [[ $sys_type == "MDS" ]]; then
        mdsenv $current_cma
        #Check to see if the current CMA is active
        if [[ $(cpprod_util FwIsActiveManagement) -eq 0 ]]; then
            logger "$current_cma is not the current active Management Server for $gateway_name."
            logger "Please run this script on the Active Management Server and try again."
            return
        fi
    #Check to see if the SMS is active
    elif [[ $(cpprod_util FwIsActiveManagement) -eq 0 ]]; then
        logger "$current_cma is not the current active Management Server for $gateway_name."
        logger "Please run this script on the Active Management Server and try again."
        return
    fi

    #====================================================================================================
    #  Create list of remote targets
    #====================================================================================================

    #Collect gateway list
    gateway_list=$(echo "$gateways_and_servers_list" | grep -B1 "simple-gateway" | grep name | awk -F\" '{print $2}')
    echo "$gateway_list" >> $candidate_list

    #Collect VSX object list
    vsx_cluster_list=$(echo "$gateways_and_servers_list" | grep -B1 "CpmiVsxNetobj" | grep name | awk -F\" '{print $2}')
    echo "$vsx_cluster_list" >> $candidate_list

    #Collect VSX cluster member list
    vsx_cluster_list=$(echo "$gateways_and_servers_list" | grep -B1 "CpmiVsxClusterMember" | grep name | awk -F\" '{print $2}')
    echo "$vsx_cluster_list" >> $candidate_list

    #Collect Gateway Cluster Member list
    gw_cluster_members_list=$(echo "$gateways_and_servers_list" | grep -B1 "CpmiClusterMember" | grep name | awk -F\" '{print $2}')
    echo "$gw_cluster_members_list" >> $candidate_list

    #Remove blank lines from candidate list
    sed -i "/^$/d" $candidate_list

    #Build candidate details
    if [[ $collection_mode == "all" ]]; then
        touch $candidate_details
        #Loop through all gateway objects to build a candidate list
        for gateway_name in $(cat $candidate_list); do
            device_uid=$(echo "$gateways_and_servers_list" | grep -B1 -w $gateway_name | head -n1 | awk -F\" '{print $2}')
            device_ip=$(mgmt_cli show object uid $device_uid details-level full -s $domain_id | grep ipv4-address | tail -n1 | awk -F\" '{print $2}')
            if [[ $sys_type == "MDS" ]]; then
                cma_uid=$(echo "$gateways_and_servers_list" | grep -B1 -w $current_cma | head -n1 | awk -F\" '{print $2}')
                cma_is_primary=$(mgmt_cli show object uid $cma_uid details-level full -s $domain_id  | grep primaryManagement | awk '{print $2}')
            fi
            echo $gateway_name $device_ip $current_cma $domain_id >> $candidate_details
        done
    else
        #Set gateway devices to array IDs for later selection
        gateway_id=0
        for current_gateway in $(cat $candidate_list); do
            gw_array[$gateway_id]=$current_gateway
            ((gateway_id++))
        done

        #Loop through displaying the gateway array until a valid device is selected
        gw_arrayLength=${#gw_array[@]}
        gateway_selection_clean=0
        error_message="\n"
        until [[ $gateway_selection_clean -ge 1 && $gateway_selection_clean -le $gw_arrayLength ]]; do
            gateway_id=1
            array_id=0
            printf "Available Gateway objects:\n"
            while [[ $gateway_id -le $gw_arrayLength ]]; do
                printf "$gateway_id) ${gw_array[$array_id]}\n"
                ((gateway_id++))
                ((array_id++))
            done
            printf "$error_message"
            read -e -p "Select a device on which to remotely execute a health check [1-$gw_arrayLength]: " gateway_selection
            gateway_selection_clean=$(echo $gateway_selection |  sed 's/[^0-9]//g')
            if [[ $gateway_selection_clean -ge 1 && $gateway_selection_clean -le $gw_arrayLength ]]; then
                ((gateway_selection_clean--))
                gateway_name=${gw_array[$gateway_selection_clean]}
                ((gateway_selection_clean++))
            else
                error_message="That is not a valid option.  Please choose a number between 1 and $array_id.\n"
                clear
            fi
        done

        #Build candidate details for the selected device
        device_uid=$(echo "$gateways_and_servers_list" | grep -B1 -w $gateway_name | grep uid | awk -F\" '{print $2}')
        device_ip=$(mgmt_cli show object uid $device_uid details-level full -s $domain_id | grep ipv4-address | tail -n1 | awk -F\" '{print $2}')
        echo $gateway_name $device_ip $current_cma $domain_id >> $candidate_details
    fi


    #====================================================================================================
    #  Transfer script to remote device and execute
    #====================================================================================================

    # Just print remote candidate
    logger "Health check will be performed on following gateways:"
    # logger "Candidates:"
    # cat $candidate_details

    while read remote_candidate; do
        logger "Gateway: $remote_candidate"
    done < $candidate_details

    #Use cprid_util to transfer the script
    while read remote_candidate; do

        #Parse candidate details and save as variables
        gateway_name=$(echo $remote_candidate | awk '{print $1}')
        device_ip=$(echo $remote_candidate | awk '{print $2}')
        current_cma=$(echo $remote_candidate | awk '{print $3}')
        domain_id=$(echo $remote_candidate | awk '{print $4}')

        logger "--- Process on following remote candidate: "
        logger "GW name: $gateway_name"
        logger "GW IP: $device_ip"

        # Check if the gateway is reachable via cprid_util
        cprid_util -server $device_ip -verbose rexec -rcmd bash -c "hostname" > $cpridAvailCheckResult & sleep 5 && kill $! 2>/dev/null
        if [[ ! -s $cpridAvailCheckResult ]] || [[ "$(cat $cpridAvailCheckResult 2>/dev/null)" =~ .*NULL[[:space:]]?BUF.* ]]; then
            logger "An error has occurred. Cprid service is not running on $gateway_name."
            logger "Please ensure the device is running, SIC is established, and that it has a security policy installed."
            # Put the gateway info into summarized report
            addCsvResults_to_CsvGlobalSummaryFile dummy_string cpridUnavail
        else
            logger "Cprid availability check successful."

            #Create the script folder
            cprid_util -server $device_ip -verbose rexec -rcmd bash -c "mkdir -p /usr/local/bin/"
            if [[ $(echo $?) -ne 0 ]]; then
                logger "An error has occurred while creating folder /usr/local/bin/ $gateway_name.\n"
                logger "Please ensure the device is running, SIC is established, and that it has a security policy installed.\n"
                continue
            fi

            #Send the file
            cprid_util -server $device_ip putfile -local_file $installed_script_path -remote_file $installed_script_path -perms 0755
            if [[ $(echo $?) -ne 0 ]]; then
                logger "An error has occurred while transferring the healthcheck.sh script to $gateway_name.\n"
                logger "Please ensure the device is running, SIC is established, and that it has a security policy installed.\n"
                continue
            fi
            logger "Health Check script sent to $gateway_name."

            #Remote execute script
            mgmt_cli run-script script-name "Healthcheck" script $installed_script_path targets.1 $gateway_name -s $domain_id > $return_details

            #Parse the API results
            if [[ $(grep generic_error $return_details) ]]; then
                logger "An unknown error has occurred collecting the output from $gateway_name.\n"
                logger "Please log into the gateway and review the health check log in /var/log/\n"
            else
                grep responseMessage $return_details | awk -F\" '{print $2}' > $return_code
                return_message=$(base64 -d $return_code 2> /dev/null)
                plain_text_results=$(echo "$return_message" | grep -v base64)

                #display check output
                echo "$plain_text_results"

                #Find the log files
                remote_log_files=$(echo "$plain_text_results" | grep '/var/log' | grep -v '/var/log/messages')
                echo "$remote_log_files" >> $remote_log_file_list

                #Pull remote files
                for remote_log in $remote_log_files; do
                    cprid_util -server $device_ip getfile -local_file $remote_log -remote_file $remote_log
                    if [[ $remote_log == *"health-check_summary"* ]]; then
                        summaryReportFile=$remote_log

                        # Put the gateway info into summarized report
                        addCsvResults_to_CsvGlobalSummaryFile $summaryReportFile cpridAvail
                    fi
                done


                logger "Data for following candidate collected: $gateway_name"

                # Post data collection check
                # Test if the gateway health after the data collection
                # It makes sense, since we run the script on ALL gateways of a MDS
                # In case, the post check failed, the script must be stopped
                # ToDo:
                # Test CPU, memory, policy installation status
                cprid_util -server $device_ip -verbose rexec -rcmd bash -c "hostname"
                if [[ $(echo $?) -ne 0 ]]; then
                    logger "ERROR!!! Following gateway is not reachable after healthcheck data collection: $gateway_name"
                    logger "The script has been stopped."
                    logger "Plase analyse the not reachable gateway and determine the case of becoming not reachable."
                    temp_file_cleanup
                else
                    logger "Post data collection health check succeeded."
                fi
            fi
        fi
    done < $candidate_details

    #====================================================================================================
    #  API logout and cleanup
    #====================================================================================================

    #Logout of each domain
    for domain_id in $(cat $candidate_details | awk '{print $4}' | sort -u); do
        mgmt_cli logout -s $domain_id > /dev/null 2>&1
        rm -rf $domain_id > /dev/null 2>&1
    done

    #Temp file cleanup
    rm -rf $return_code > /dev/null 2>&1
    rm -rf $candidate_details > /dev/null 2>&1
    rm -rf $candidate_list > /dev/null 2>&1
    rm -rf $return_details > /dev/null 2>&1
}


#====================================================================================================
#  Script Version Check and Install
#====================================================================================================
script_install()
{
    if [[ -e /etc/cp-release ]]; then
        #Ensure /usr/local/bin exists
        if [[ ! -d /usr/local/bin ]]; then
            mkdir -p /usr/local/bin
        fi

        #Check to see if the script is present
        if [[ $executed_script_path != $installed_script_path && -e $installed_script_path ]]; then
            #Remove beta version if present
            if [[ $(grep "VERSION" $installed_script_path | grep "beta") ]]; then
                rm $installed_script_path > /dev/null 2>&1
                cp $executed_script_path $installed_script_path
            fi

            #Notify user
            #printf "Comparing current script to version located in /usr/local/bin/.  Please wait.\n"

            #Version of script executed by user
            executed_version=$(echo $script_ver | awk '{print $1}')
            executed_major=$(echo $executed_version | awk -F'.' '{print $1}' | bc)
            executed_minor=$(echo $executed_version | awk -F'.' '{print $2}' | bc)

            #Version of script located in /usr/local/bin/
            installed_version=$(grep ^'# VERSION' $installed_script_path | awk '{print $3}')
            installed_major=$(echo $installed_version | awk -F'.' '{print $1}' | bc)
            installed_minor=$(echo $installed_version | awk -F'.' '{print $2}' | bc)

            #Exit if /usr/local/bin script is newer
            if [[ $installed_major -ge $executed_major ]]; then
                if [[ $installed_minor -gt $executed_minor ]]; then
                    printf "\t${text_red}WARNING:${text_reset} The script installed in /usr/local/bin/ is newer than this version.\n"
                    printf "\tPlease use the latest version from sk121447.\n"
                fi

            #Do nothing if the versions match
            elif [[ $installed_major -eq $executed_major && $installed_minor -eq $executed_minor ]]; then
                true

            #Install script if it is not up to date
            else
                cp $executed_script_path $installed_script_path
            fi
        fi

        #Install script if it is not present
        if [[ ! -e $installed_script_path ]]; then
            cp $executed_script_path $installed_script_path
        fi
    fi
}





#====================================================================================================
#  Help Function
#====================================================================================================
show_help_info()
{
    echo ""
    echo "This script performs a general health check of the current system."
    echo "Specific checks will be run depending on the device type and version."
    echo ""
    echo "Usage:"
    echo "healthcheck.sh [option]"
    echo ""
    echo "Option    Name        Description"
    echo "------    --------    ----------------------------------------------------------------"
    if [[ $sys_type == "SP" ]]; then
        echo "-b all    Blade:      Run checks on all SGMs."
    fi
    if [[ $sys_type == "MDS" ]]; then
        echo "-d        Domain:     Run remote health checks on devices from specified CMA."
    fi

    echo "-f        File:       Run health checks against offline CPInfo/CPView files."
    echo "-h        Help:       Display this help screen."
    if [[ $sys_type == "MDS" || $sys_type == "SMS" ]]; then
        echo "-r        Remote:     Run remote health checks on remote devices in the environment."
    fi
    echo "-u        Update:     Update the script to the latest public version (requires connectivity)."
    echo "-v        Version:    Display script version information."
    echo ""
    echo ""
    echo "Examples:"
    echo "---------"
    if [[ $sys_type == "MDS" ]]; then
        echo "#Run remote checks for a single device in a single CMA:"
        echo "#Note: A list of devices from the CMA will be displayed automatically."
        echo "healthcheck.sh -d Production_Management_Domain"
        echo ""
        echo "#Run remote checks for a device (You will be prompted for a domain):"
        echo "healthcheck.sh -r"
        echo ""
    elif [[ $sys_type == "SMS"  ]]; then
        echo "#Run remote checks for a device managed by this Management Server:"
        echo "healthcheck.sh -r"
        echo ""
    fi
    echo "#Run offline health check against a cpinfo:"
    echo "healthcheck.sh -f example.info"
    echo ""
    echo "#Run offline health check against a cpinfo and cpview database:"
    echo "healthcheck.sh -f example.info -f CPViewDB.dat"
    echo ""
    echo "#Display version information:"
    echo "healthcheck.sh -v"
    echo ""
}


#====================================================================================================
#  Version Function
#====================================================================================================
show_version_info()
{
    build_ver=$(echo $script_ver | awk '{print $1}')
    build_date=$(echo $script_ver | awk '{print $2}')
    printf "\nCheck Point Health Check Script\n"
    printf "Build Version: $build_ver\n"
    printf "Build Date:    $build_date\n\n"
    exit 0
}


#====================================================================================================
#  Function to clean up temp files from the script
#====================================================================================================
temp_file_cleanup()
{
    #Delete all temp files
    rm -f /var/tmp/category_list > /dev/null 2>&1
    rm -f /var/tmp/header_list > /dev/null 2>&1
    rm -f /var/tmp/candidate_list > /dev/null 2>&1
    rm -f /var/tmp/candidate_details > /dev/null 2>&1
    rm -f /var/tmp/return_code > /dev/null 2>&1
    rm -f /var/tmp/return_details > /dev/null 2>&1
    rm -f /var/tmp/messages_check.tmp > /dev/null 2>&1
    rm -f /var/tmp/ntp_stat.tmp > /dev/null 2>&1
    rm -f /var/tmp/proc_start_list.tmp > /dev/null 2>&1
    rm -f /var/tmp/debug_flag_modules.tmp > /dev/null 2>&1
    rm -f /var/tmp/debug_flag_current.tmp > /dev/null 2>&1
    rm -f /var/tmp/*.id > /dev/null 2>&1
    rm -f /var/tmp/fragment_error > /dev/null 2>&1
    rm -f /var/tmp/connections_error > /dev/null 2>&1
    rm -f /var/tmp/nat_error > /dev/null 2>&1
    rm -f /var/tmp/fw_accel_error > /dev/null 2>&1
    rm -f /var/tmp/fw_ctl_pstat_error > /dev/null 2>&1
    rm -f /var/tmp/core_xl_stat > /dev/null 2>&1
    rm -f /var/tmp/jumbo.tmp > /dev/null 2>&1
    rm -f /var/tmp/cpinfo_script.tmp > /dev/null 2>&1
    rm -f /var/tmp/disk_space.tmp > /dev/null 2>&1
    rm -f /var/tmp/failovers.tmp > /dev/null 2>&1
    rm -f /var/tmp/contracts.tmp > /dev/null 2>&1
    rm -f /var/tmp/expired_license_list.tmp > /dev/null 2>&1
    rm -f /var/tmp/expired_license_contract_list.tmp > /dev/null 2>&1
    rm -f /var/tmp/expiring_license_list.tmp > /dev/null 2>&1
    rm -f /var/tmp/missing_license_contract_list.tmp > /dev/null 2>&1
    rm -f /var/tmp/expiring_contract_list.tmp > /dev/null 2>&1
    rm -rf contract_temp* > /dev/null 2>&1
    rm -f /var/tmp/expired_contract_list.tmp > /dev/null 2>&1
    rm -f /var/tmp/duplicate_licenses_list.tmp > /dev/null 2>&1
    rm -f /var/tmp/cpridAvailCheck.tmp > /dev/null 2>&1
    rm -f /var/tmp/healthcheck_download.html > /dev/null 2>&1
    rm -f /var/tmp/healthcheck.tmp > /dev/null 2>&1
    rm -f /var/tmp/remote_log_list.tmp > /dev/null 2>&1
    rm -f /var/tmp/r77_30.tmp > /dev/null 2>&1
    rm -f /var/tmp/r80_10.tmp > /dev/null 2>&1
    rm -f /var/tmp/r80_20.tmp > /dev/null 2>&1
    rm -f /var/tmp/r80_30.tmp > /dev/null 2>&1
    rm -f /var/tmp/r80_40.tmp > /dev/null 2>&1
    rm -f /var/tmp/vsx_error > /dev/null 2>&1
    rm -f /var/tmp/cpinfo_latest.tmp > /dev/null 2>&1
    rm -f /var/tmp/cpuse_temp.tmp > /dev/null 2>&1
    rm -f /var/tmp/modified_modules.tmp > /dev/null 2>&1

    echo ""
    exit 0
}


#====================================================================================================
# Add Traps
#====================================================================================================

#Set a trap to clean up all temp files if the user kills the script
trap temp_file_cleanup SIGINT
trap temp_file_cleanup SIGTERM


#====================================================================================================
# Error checking for non-flag characters
#====================================================================================================
if [[ ! $(echo $1 | grep ^'-') ]]; then
    if [[ $(echo $1 | grep [a-zA-Z0-9]) ]]; then
        show_help_info
        printf "$1 provided without a valid flag.  Please review the above help info and try again.\n"
        exit 1
    fi
fi


#====================================================================================================
# Parse Flags
#====================================================================================================
while getopts :d:b:f:o:ahuvr opt; do
    case "${opt}" in
        a)
            if [[ $sys_type == "MDS" || $sys_type == "SMS" ]]; then
                #Set collection mode to all devices
                collection_mode="all"
                remote_operations=true

                logger "--- --- ---"
                logger "Script start"
                logger "Collect healthcheck data from all gateways managed by this device."

                #Show stern warning
                all_flag_override=false

                until [[ $all_flag_override == true ]]; do
                    printf "The -a flag was hidden from the help for a reason.\n"
                    printf "This flag has not been tested in moderately sized environments\n"
                    printf "Use with extreme caution.  Check Point does not support or condone use of this flag.\n"
                    read -e -p "Do you wish to ignore this warning and proceed? [y/n]: " user_override
                    if [[ $user_override == [yY] ]]; then
                        all_flag_override=true
                    elif [[ $user_override == [nN] ]]; then
                        printf "Good choice.  Exiting...\n"
                        exit 0
                    else
                        printf "$user_override is not a valid option.  Please try again.\n"
                    fi
                done

            #Prevent flag from being selected on anything other than MDS or SMS
            else
                show_help_info
                exit 1
            fi
            ;;
        b)
            #Only run on SP platforms
            if [[ $sys_type == "SP" ]]; then
                target_sgm=${OPTARG}
                if [[ $target_sgm == "all" ]]; then
                    #Install script before running any SP commands
                    script_install

                    #Run SP commands
                    asg_cp2blades $installed_script_path
                    g_all $installed_script_path
                    exit 0
                else
                    printf "That is not a valid option.  Please try again.\n"
                    exit 1
                fi
            else
                show_help_info
                exit 1
            fi
            ;;
        d)
            #Set domain name variable
            domain=${OPTARG}
            domain_specified=true
            remote_operations=true

            #Prevent flag from  being selected on anything other than MDS
            if [[ $sys_type != "MDS" ]]; then
                show_help_info
                exit 1
            fi
            ;;
        f)
            #Set offline operations variable
            offline_operations=true


            #Set cpinfo to variable
            if [[ $(echo ${OPTARG} | grep info) ]]; then
                cpinfo_file=${OPTARG}

                #Check if multiple cpview files were provided
                if [[ $cpinfo_file_provided == true ]]; then
                    printf "Multiple cpinfo files are not supported.\n"
                    printf "Please specify a only one cpinfo file and one cpview database file.\n"
                    exit 1
                fi

                #Check to see if file is present
                if [[ ! -e $cpinfo_file ]]; then
                    printf "$cpinfo_file not found.  Exiting...\n"
                    exit 1
                fi

                #gunzip the cpinfo if needed
                if [[ $cpinfo_file == *".gz" ]]; then
                    gunzip $cpinfo_file
                    cpinfo_file=$(echo $cpinfo_file | sed "s/...$//g")
                fi

                #untar file if needed
                if [[ $cpinfo_file == *".tar" ]]; then
                    file_list=$(tar -xvf $cpinfo_file)
                elif [[ $cpinfo_file == *".tgz" ]]; then
                    file_list=$(tar -xzvf $cpinfo_file)
                fi

                #Look at unpacked files to see what fiels we have
                for file in $file_list; do
                    if [[ $(echo $file | egrep 'info$') ]]; then
                        cpinfo_file=$file
                    elif [[ $(echo $file | egrep CPViewDB.dat) ]]; then
                        cpview_file=$file
                        cpview_file_provided=true

                        #gunzip the cpinfo if needed
                        if [[ $cpview_file == *".gz" ]]; then
                            gunzip $cpview_file
                            cpview_file=$(echo $cpview_file | sed "s/...$//g")
                        fi
                    fi
                done

                #Multiple cpinfo file canary
                cpinfo_file_provided=true

            #Set cpview database to variable
            elif [[ $(echo ${OPTARG} | grep CPView) ]]; then
                cpview_file=${OPTARG}

                #Check if multiple cpview files were provided
                if [[ $cpview_file_provided == true ]]; then
                    printf "Multiple cpview databases are not supported.\n"
                    printf "Please specify a only one cpinfo file and one cpview database file.\n"
                    exit 1
                fi

                #Check to see if file is present
                if [[ ! -e $cpview_file ]]; then
                    printf "$cpview_file not found.  Exiting...\n"
                    exit 1
                fi

                #gunzip the cpinfo if needed
                if [[ $cpview_file == *".gz" ]]; then
                    gunzip $cpview_file
                    cpview_file=$(echo $cpview_file | sed "s/...$//g")
                fi

                #untar file if needed
                if [[ $cpview_file == *".tar" ]]; then
                    cpview_file=$(tar -xvf $cpview_file | egrep 'CPViewDB.dat$')
                elif [[ $cpview_file == *".tgz" ]]; then
                    cpview_file=$(tar -xzvf $cpview_file | egrep 'CPViewDB.dat$')
                fi

                #Multiple cpview database files canary
                cpview_file_provided=true

            #Catch incorrect parameter
            else
                printf "${OPTARG} is not a valid cpinfo or cpview database.\n"
                exit 1
            fi
            ;;
        h)
            #Show help info
            show_help_info
            exit 0
            ;;
        o)
            #Set the output file path
            output_archive=${OPTARG}

            #Check to see if the archive is a tgz
            if [[ $output_archive != *'.tgz' ]]; then
                printf "Please specify a full path to the output archive.\nThe name must end in .tgz\n"
                exit 1
            fi
            ;;
        r)
            #Set remote operations variable
            remote_operations=true
            domain="null"

            #Prevent flag from  being selected on anything other than MDS
            if [[ $sys_type != "MDS" && $sys_type != "SMS" ]]; then
                show_help_info
                exit 1
            fi
            ;;
        u)
            #Set flag for update requested
            update_requested="true"
            
            #Call the script update function
            check_updates

            exit 0
            ;;
        v)
            #Show version info
            show_version_info
            ;;
        *)
            #Catch all for any other flags
            show_help_info
            exit 1
            ;;
    esac
done

# Just print collection mode
logger "System type: $sys_type" -s
logger "Collection mode: $collection_mode" -s



#====================================================================================================
#  Script Version Check and Install
#====================================================================================================
script_install


#====================================================================================================
# Error checking for offline operations
#====================================================================================================
if [[ $offline_operations == true ]]; then

    #Exit script if there the remote operations flag is also used
    if [[ $remote_operations == true ]]; then
        printf "The offline operations flag is not compatible with the remote operations flag.\n"
        exit 1
    fi

    #Exit if cpview database is provided without a cpinfo
    if [[ -e $cpview_file && ! -e $cpinfo_file ]]; then
        printf "ERROR - Please specify a cpinfo file along with the cpview database.\n"
        exit 1
    fi
fi


#====================================================================================================
# Error checking for remote operations
#====================================================================================================
if [[ $remote_operations == true ]]; then

    #Make sure the device is running R80+
    if [[ $current_version -ge 8000 ]]; then

        api_status=$(api status 2> /dev/null)
        #Make sure the API is up and running
        if [[ ! $(echo "$api_status" | grep "server is up") ]];then
            printf "API not up and running.  Exiting...\n"
            exit 1
        fi

        #Auto detect API Port
        api_port=$(echo "$api_status" | grep "Gaia Port" | awk '{print $4}')
        if [[ $api_port -ne 443 ]]; then
            alt_api_port="--port $api_port"
        fi

        #Display message that the script is collecting API info
        logger "Collecting environment information using the API..."

        #Clean up variables
        unset api_status
        unset api_port

    #Display error if device is not R80+
    else
        printf "Remote operations (-d and -r flags) are only supported on R80 and higher.\nThis script will now exit.\n"
        exit 1
    fi
fi


#====================================================================================================
# MDS Remote Operations
#====================================================================================================
if [[ $sys_type == "MDS" && $remote_operations == true ]]; then
    #Collect MDS login session
    mds_id=/var/tmp/mds.id

    mgmt_cli $alt_api_port login --root true > $mds_id

    #Check for successful API login
    if [[ ! $(grep sid $mds_id) ]]; then
        printf "Unable to verify successful API login.  Please check you are using the correct port and try again.\n"
        show_help_info
        exit 1
    fi

    #====================================================================================================
    # Collect info from all gateways in all domains
    #====================================================================================================
    if [[ $collection_mode == "all" && $domain_specified == false ]]; then
        #Create a list of all Domains
        #get rid of API call, since they are pretty slow in large customer environments
        domain_list=$(mgmt_cli show domains -s $mds_id limit 500 --format json | jq ".objects[].name" -r)
        #domain_list=$($MDSVERUTIL AllCMAs)

        #Just print domain list
        logger "Domains list:"
        for domain in $domain_list; do
          logger "Domain: $domain"
        done

        #Show domain contents for all domains
        for domain in $domain_list; do
            #Collect gateway targets for the current domain and remotely execute script
            logger "--- --- Collect data from gateways of CMA: $domain"
            run_remote_checks
        done

    #====================================================================================================
    # Collect info from from a specific domain (for all or specific gateways)
    #====================================================================================================
    else
        #Ensure the domain name specified is valid
        confirm_domain_name

        #Collect gateway targets for the specified domain and remotely execute script
        run_remote_checks
    fi
    
    #Log file collection
    logger "Healthcheck data collection finished."
    logger "Detailed healthcheck reports collected into:\n$(cat $remote_log_file_list 2>/dev/null)\n"
    logger "An aggregated summary of all reports can be found in: $csv_log_history"
    
    #Logout MDS
    mgmt_cli logout -s $mds_id > /dev/null 2>&1
    rm -rf  $mds_id > /dev/null 2>&1


#====================================================================================================
# SMS Remote Operations
#====================================================================================================
elif [[ $sys_type == "SMS" && $remote_operations == true ]]; then
    #Collect SMS login session
    domain=sms

    #Collect gateway targets for the SMS and remotely execute script
    run_remote_checks
    
    #Log file collection
    logger "Healthcheck data collection finished."
    logger "Detailed healthcheck reports collected into:\n$(cat $remote_log_file_list)\n"
    logger "An aggregated summary of all reports can be found in: $csv_log_history"


#====================================================================================================
# Offline Operations
#====================================================================================================
elif [[ $offline_operations == true ]]; then
    run_offline_checks


#====================================================================================================
# Local Operations
#====================================================================================================
elif [[ $collection_mode == "local" ]]; then
    run_local_checks
fi

# Clean temp files
temp_file_cleanup
