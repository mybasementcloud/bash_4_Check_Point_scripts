#!/bin/bash
#====================================================================================================
# TITLE:                 healthcheck.sh
# USAGE:                 ./healthcheck.sh
#
# DESCRIPTION:	         Checks the system for things that may adversely impact performance or reliability.
#
# AUTHOR (all versions): Nathan Davieau (Check Point Diamond Services Tech Lead)
# CO-AUTHOR (v0.2-v3.6): Rosemarie Rodriguez
# CODE CONTRIBUTORS:     Brandon Pace, Russell Seifert, Joshua Hatter, Kevin Hoffman
# VERSION:               5.10
# SK:                    sk121447
#====================================================================================================

#====================================================================================================
#  Global Variables
#====================================================================================================
if [[ -e /etc/profile.d/CP.sh ]]; then
    source /etc/profile.d/CP.sh
fi
if [[ -e /etc/profile.d/vsenv.sh ]]; then
    source /etc/profile.d/vsenv.sh
fi
logfile=/var/log/$(hostname)_health-check_$(date +%Y%m%d%H%M).txt
output_log=/var/log/hc_output_log.tmp
full_output_log=/var/log/$(hostname)_health-check_full_$(date +%Y%m%d%H%M).log
csv_log=/var/log/$(hostname)_health-check_summary_$(date +%Y%m%d%H%M).csv
summary_error=0
vs_error=0
all_checks_passed=true
script_ver="5.10 10-01-2018"
collection_mode="local"
domain_specified=false
remote_operations=false
offline_operations=false


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
current_version=$(cat /etc/cp-release | sed 's/\.//')
if [[ $(echo $current_version | grep -ow R8020) ]]; then
    current_version="8020"
elif [[ $(echo $current_version | grep -ow R8010) ]]; then
    current_version="8010"
elif [[ $(echo $current_version | grep -ow R80) ]]; then
    current_version="8000"
elif [[ $(echo $current_version | grep -ow R7730) ]]; then
    current_version="7730"
elif [[ $(echo $current_version | grep -ow R7720) ]]; then
    current_version="7720"
elif [[ $(echo $current_version | grep -ow R7710) ]]; then
    current_version="7710"
elif [[ $(echo $current_version | grep -ow R77) ]]; then
    current_version="7700"
elif [[ $(echo $current_version | grep R76) ]]; then
    current_version="7600"
else
    yesno_loop=1
    printf "\nSupported Versions:\n" | tee -a $output_log
	printf "\tR80.20\n" | tee -a $output_log
	printf "\tR80.10\n" | tee -a $output_log
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


#====================================================================================================
#  Determine System Type
#====================================================================================================
if [[ $(cat /etc/cp-release | grep SP) ]]; then
    sys_type="SP"
elif [[ $(echo $MDSDIR | grep mds) ]]; then
    sys_type="MDS"
elif [[ $($CPDIR/bin/cpprod_util FwIsVSX 2> /dev/null) == *"1"* ]]; then
	sys_type="VSX"
    vsenv 0 > /dev/null 2>&1
elif [[ $($CPDIR/bin/cpprod_util FwIsStandAlone 2> /dev/null) == *"1"* ]]; then
    sys_type="STANDALONE"
elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallModule 2> /dev/null) == *"1"*  ]]; then
    sys_type="GATEWAY"
elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallMgmt 2> /dev/null) == *"1"*  ]]; then
    sys_type="SMS"
else
    sys_type="N/A"
fi


#####################################################################################################
#
#  Start of Functions section
#
#####################################################################################################

#====================================================================================================
#  Function to end a check as "OK"
#====================================================================================================
check_passed()
{
    printf " OK\t\t|\n" >> $output_log
    printf "${text_green} OK${text_reset}\t\t|\n"
}

    
#====================================================================================================
#  Function to end a check as "WARNING"
#====================================================================================================
check_failed()
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
check_info()
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
    echo ""
    exit 0
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
    up_time=$(uptime | awk '{print $3, $4}')
    echo $up_time  >> $full_output_log

    #Review days up
    if [[ $up_time == *"days"* ]]; then
        up_days=$(echo $up_time | awk '{print $1}')
        
        #Log OK if uptime is between 8 and 365 days
        if [[ $up_days -ge 8 && $up_days -lt 365 ]]; then
            check_passed
            printf "System,Uptime,OK,\n" >> $csv_log
        else
            #Display info if uptime is less than 7 days
            if [[ $up_days -le 7 ]]; then
                check_info
                printf "System,Uptime,INFO,\n" >> $csv_log
                printf "Uptime Info:\nThe system has been rebooted within the last week.\nPlease review \"/var/log/messages\" files (if they have not rolled over) if the system was not manually rebooted.\n" >> $logfile
                
            #Display WARNING if uptime is 1y+ or undetermined
            elif [[ $up_days -ge 365 ]]; then
                check_failed
                printf "System,Uptime,WARNING,\n" >> $csv_log
                printf "Uptime Warning:\nThe system has NOT been rebooted for over a year.\n" >> $logfile
            else
                check_failed
                printf "System,Uptime,WARNING,\n" >> $csv_log
                printf "Uptime Error:\nUnable to determine time since reboot.\n" >> $logfile
            fi
        fi
    else
        check_info
        printf "System,Uptime,INFO,\n" >> $csv_log
        printf "Uptime Check Info:\nThe system has been rebooted within the last week.\nPlease review \"/var/log/messages\" files (if they have not rolled over) if the system was not manually rebooted.\n" >> $logfile
    fi
    

    #====================================================================================================
    #  OS Edition Check
    #====================================================================================================
    test_output_error=0
    cp_os_edition=$(clish -c 'show version os edition' | grep OS | awk '{print $3}')
    printf "|\t\t\t| OS Version\t\t\t|" | tee -a $output_log
    
    #Review OS edition
    if [[ $cp_os_edition == "32-bit" ]]; then
        check_info
        printf "System,OS Version,INFO,sk94627\n" >> $csv_log
        printf "OS Version INFO:\nOperating System Edition is 32-bit.\n" >> $logfile
        printf "If we need to change OS edition to 64-bit, use sk94627.\n" >> $logfile
    else 
        check_passed
        printf "System,OS Version,OK,\n" >> $csv_log
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
    
    #Check to see if the ntpstat binary is present
    if [[ -e /usr/bin/ntpstat ]]; then
        
        #Collect NTP status from ntpstat
        tmp_ntp=/var/tmp/ntp_stat.tmp
        ntpstat >> $tmp_ntp 2>&1
        if [[ $(grep "Unable to talk" $tmp_ntp) ]]; then
            check_failed
            printf "NTP,NTP Daemon,WARNING,sk92602 and sk83820\n" >> $csv_log
            ntp_error=1
            printf "NTP Daemon: Unable to talk to the NTP daemon.\n" >> $logfile
        elif [[ $(grep -i "synchronised to NTP server" $tmp_ntp) ]]; then
            check_passed
            printf "NTP,NTP Daemon,OK,\n" >> $csv_log
        elif [[ $(grep -i "unsynchronised" $tmp_ntp) ]]; then
            check_failed
            printf "NTP,NTP Daemon,WARNING,sk92602 and sk83820\n" >> $csv_log
            ntp_error=1
            printf "NTP Daemon: NTP is not synchronized.\n" >> $logfile
        else
            check_failed
            printf "NTP,NTP Daemon,WARNING,sk92602 and sk83820\n" >> $csv_log
            ntp_error=1
            printf "NTP Daemon: Unable to determine NTP daemon status.\n" >> $logfile
        fi
        
        #Clean up temp file
        rm $tmp_ntp
    
    #Display warning if ntpstat binary is not present
    else
        check_failed
        printf "NTP,NTP Daemon,WARNING,sk92602 and sk83820\n" >> $csv_log
        ntp_error=1
        printf "NTP Daemon: Unable to find ntpstat binary.\n" >> $logfile
    fi
    
    #Log final NTP error
    if [[ $ntp_error -eq 1 ]]; then
        printf "\nNTP Information:\nPlease use sk92602 and sk83820 for assistance with verifying NTP is configured and functioning properly.\n" >> $logfile
    fi
    
    #Unset NTP Variables
    unset ntp_error
    unset tmp_ntp
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
            check_failed
            printf "Free Disk Space Warning - $partition_name $partition_space%% full.\n" >> $logfile
            disk_space_error=1
        elif [[ $partition_space -gt 90 ]]; then
            check_failed
            printf "Free Disk Space Critical - $partition_name $partition_space%% full.\n" >> $logfile
            disk_space_error=1
        fi
    done < $disk_check_file
    
    #Message to display if any errors are detected
    if [[ $disk_space_error -eq 1 ]]; then
        check_failed
        printf "Disk Space,Free Disk Space,WARNING,sk60080\n" >> $csv_log
        printf "Check if any partition listed above can be cleaned up to free up disk space.\n" >> $logfile
        printf "Please see sk60080 for further assistance freeing up disk space.\n" >> $logfile
    else
        check_passed
        printf "Disk Space,Free Disk Space,OK,\n" >> $csv_log
    fi
    
    #Remove temp file
    rm -rf $disk_check_file > /dev/null 2>&1
    
    #Unset Disk Space Variables
    unset disk_check
    unset partition_entry
    unset disk_space_error
    unset partition_space
    unset partition_name
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
    printf "\n\nMemory Info:\n" >> $full_output_log
    cat /proc/meminfo  >> $full_output_log

    #Physical memory check
    if [[ $offline_operations == true ]]; then
        current_meminfo=$(grep -A50 '(meminfo)' $cpinfo_file | grep -B50 cpuinfo | grep -v Additional | grep -v '\-\-\-')
    else
        current_meminfo=$(cat /proc/meminfo)
    fi
    total_mem=$(echo "$current_meminfo" | egrep '^MemTotal' | awk '{print $2}')
    free_mem=$(echo "$current_meminfo" | egrep 'MemFree|Buffers|^Cached' | awk '{print $2}')
    
    #Memory calculations
    for mem in $free_mem; do
        (( all_free_mem = all_free_mem + mem ))
    done
    free_mem_percent=$(echo "100 * $all_free_mem / $total_mem" | bc)
    (( used_mem_percent = 100 - free_mem_percent ))
    
    #Determine memory status
    if [[ $used_mem_percent -le 69 ]]; then
        check_passed
        printf "Memory,Physical Memory,OK,\n" >> $csv_log
    else
        check_failed
        printf "Memory,Physical Memory,WARNING,\n" >> $csv_log
        if [[ $used_mem_percent -ge 70 && $used_mem_percent -le 84 ]]; then
            printf "Physical Memory Warning:\nPhysical memory is $used_mem_percent%% used.\n" >> $logfile
        elif [[ $used_mem_percent -ge 85 ]]; then
            printf "Physical Memory Critical:\nPhysical memory is $used_mem_percent%% used.\n" >> $logfile
        else
            printf "Physical Memory Error:\nUnable to determine Physical memory usage.\n" >> $logfile
        fi
    fi
    
    
    #====================================================================================================
    #  Swap Memory Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Swap Memory\t\t\t|" | tee -a $output_log
    total_swap=$(echo "$current_meminfo" | grep SwapTotal | awk '{print $2}')
    free_swap=$(echo "$current_meminfo" | grep SwapFree | awk '{print $2}')
    (( used_swap = total_swap - free_swap ))
    used_swap_percent=$(echo "100 * $used_swap / $total_swap" | bc)
    if [[ $used_swap_percent -le 1 ]]; then
        check_passed
        printf "Memory,Swap Memory,OK,\n" >> $csv_log
    elif [[ $used_swap_percent -ge 2 ]]; then
        check_failed
        printf "Memory,Swap Memory,WARNING,\n" >> $csv_log
        printf "Swap Memory Critical:\nSwap memory is $used_swap_percent%% used.\n" >> $logfile
    else
        check_failed
        printf "Memory,Swap Memory,WARNING,\n" >> $csv_log
        printf "Swap Memory Error:\n\tUnable to determine swap memory usage.\n" >> $logfile
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
            hash_memory_failed=$(echo "$fwctlpstat" | grep -A5 "hmem" | grep Allocations | awk '{print $4}')
            if [[ $hash_memory_failed -eq 0 ]]; then
                check_passed
                printf "Memory,Hash Kernel Memory (hmem),OK,\n" >> $csv_log
            elif [[ $hash_memory_failed -ge 1 ]]; then
                check_failed
                printf "Memory,Hash Kernel Memory (hmem),WARNING,\n" >> $csv_log
                printf "\nHMEM Warning:\n\tHash memory had $hash_memory_failed failures.\n" | tee -a $logfile
                printf "Presence of hmem failed allocations indicates that the hash kernel memory was full.\nThis is not a serious memory problem but indicates there is a configuration problem.\nThe value assigned to the hash memory pool, (either manually or automatically by changing the number concurrent connections in the capacity optimization section of a firewall) determines the size of the hash kernel memory.\nIf a low hmem limit was configured it leads to improper usage of the OS memory.\n" | tee -a $logfile
            else
                check_failed
                printf "Memory,Hash Kernel Memory (hmem),WARNING,\n" >> $csv_log
                printf "\nHMEM Error:\nUnable to determine hmem failures.\n" | tee -a $logfile
            fi

            #====================================================================================================
            #  SMEM Check
            #====================================================================================================
            test_output_error=0
            printf "|\t\t\t| System Kernel Memory (smem)\t|" | tee -a $output_log
            system_memory_failed=$(echo "$fwctlpstat" | grep -A5 "smem" | grep Allocations | awk '{print $4}')
            if [[ $system_memory_failed -eq 0 ]]; then
                check_passed
                printf "Memory,System Kernel Memory (smem),OK,\n" >> $csv_log
            elif [[ $system_memory_failed -ge 1 ]]; then
                check_failed
                printf "Memory,System Kernel Memory (smem),WARNING,\n" >> $csv_log
                printf "\nSMEM Warning:\nSystem memory had $system_memory_failed failures.\n" | tee -a $logfile
                printf "Presence of smem failed allocations indicates that the OS memory was exhausted or there are large non-sleep allocations.\n\tThis is symptomatic of a memory shortage.\n\tIf there are failed smem allocations and the memory is less than 2 GB, upgrading to 2GB may fix the problem.\n\tDecreasing the TCP end timeout and decreasing the number of concurrent connections can also help reduce memory consumption.\n" | tee -a $logfile
            else
                check_failed
                printf "Memory,System Kernel Memory (smem),WARNING,\n" >> $csv_log
                printf "\nSMEM Error:\nUnable to determine smem failures.\n" | tee -a $logfile
            fi

            #====================================================================================================
            #  KMEM Check
            #====================================================================================================
            test_output_error=0
            printf "|\t\t\t| Kernel Memory (kmem)\t\t|" | tee -a $output_log
            kernel_memory_failed=$(echo "$fwctlpstat" | grep -A5 "kmem" | grep Allocations | grep -v External | awk '{print $4}')
            if [[ $kernel_memory_failed -eq 0 ]]; then
                check_passed
                printf "Memory,Kernel Memory (kmem),OK,\n" >> $csv_log
            elif [[ $kernel_memory_failed -ge 1 ]]; then
                check_failed
                printf "Memory,Kernel Memory (kmem),WARNING,\n" >> $csv_log
                printf "\nKMEM Warning:\n\tKernel memory had $kernel_memory_failed failures.\n" | tee -a $logfile
                printf "Presence of kmem failed allocations means that some applications did not get memory.\nThis is usually an indication of a memory problem; most commonly a memory shortage.\nThe natural limit is 2GB, since the Kernel is 32bit.).\n" | tee -a $logfile
            else
                check_failed
                printf "Memory,Kernel Memory (kmem),WARNING,\n" >> $csv_log
                printf "\nKMEM Error\nUnable to determine kmem failures.\n" | tee -a $logfile
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
                test_output_error=0
                
                
                #Turn average usage into a percent
                mem_average_used=$(echo $mem_avg/$mem_total*100 | bc -l | awk '{printf "%.0f", int($1+0.5)}')
                
                #Log final output
                if [[ $mem_average_used -ge 70 ]]; then
                    check_failed
                    printf "Memory,Memory 30-Day Average,WARNING,sk98348\n" >> $csv_log
                    printf "The average memory usage over the last month was $mem_average_used percent.\nPlease check to see if there are any configuration optimizations from sk98348 that can be used or see if additional RAM can be installed in this system.\n" >> $logfile
                else
                    check_passed
                    printf "Memory,Memory 30-Day Average,OK,\n" >> $csv_log
                fi
            fi
            
            if [[ -n $mem_total && -n $mem_peak ]]; then
                #====================================================================================================
                #  Memory 30-Day Max Check
                #====================================================================================================
                printf "|\t\t\t| Memory 30-Day Peak\t\t|" | tee -a $output_log
                test_output_error=0
                
                #Turn max usage into a percent
                mem_peak_used=$(echo $mem_peak/$mem_total*100 | bc -l | awk '{printf "%.0f", int($1+0.5)}')
                
                #Log final output
                if [[ $mem_peak_used -ge 70 ]]; then
                    check_failed
                    printf "Memory,Memory 30-Day Peak,WARNING,\n" >> $csv_log
                    printf "Peak memory usage was $mem_peak_used%% over the last month.\nPlease review the memory usage on this device to see if a configuration change or hardware upgrade is needed.\n" >> $logfile
                else
                    check_passed
                    printf "Memory,Memory 30-Day Peak,OK,\n" >> $csv_log
                fi
            fi
        fi
    fi
    
    #Unset Memory Variables
    unset current_meminfo
    unset total_mem
    unset free_mem
    unset all_free_mem
    unset used_mem_percent
    unset free_mem_percent
    unset used_swap
    unset free_swap
    unset total_swap
    unset mem
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
    if [[ $offline_operations == true ]]; then
        all_cpu_idle=$(echo "$mpstat_p_all" | awk -v temp=$mpstat_idle '{print $temp}' | awk -F\% '{print $1}')
    else
        all_cpu_idle=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_idle '{print $temp}')
    fi
    current_cpu=0
    for cpu_idle in $all_cpu_idle; do
        cpu_idle=$(echo $cpu_idle | awk '{printf "%.0f", int($1+0.5)}')
        if [[ $cpu_idle -le 20 ]]; then
            check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_idle%% idle\n" >> $logfile
            else
                printf "CPU $current_cpu - $cpu_idle%% idle\n" >> $logfile
            fi
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "CPU,CPU idle%%,OK,\n" >> $csv_log
    else
        printf "CPU,CPU idle%%,WARNING,\n" >> $csv_log
        printf "CPU idle Warning:\n" >> $logfile
        printf "One or more CPUs is over 80%% utilized.\n" >> $logfile
    fi

    #====================================================================================================
    #  CPU User Check
    #====================================================================================================
    printf "|\t\t\t| CPU user%%\t\t\t|" | tee -a $output_log
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
            check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_user%% user\n" >> $logfile
            else
                printf "CPU $current_cpu - $cpu_user%% user\n" >> $logfile
            fi
            cpu_user_warning=1
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "CPU,CPU user%%,OK,\n" >> $csv_log
    fi
    if [[ $cpu_user_warning -eq 1 ]]; then
        printf "CPU,CPU user%%,WARNING,\n" >> $csv_log
        printf "High CPU user time indicates that some process is consuming high CPU.\n" >> $logfile
        printf "Security Server processes like fwssd and in.ahttpd have been offenders in the past.\n" >> $logfile
        printf "Use \"ps\" or \"top\" to identify the offending process.\n" >> $logfile
    fi
    
    #====================================================================================================
    #  CPU System Check
    #====================================================================================================
    printf "|\t\t\t| CPU system%%\t\t\t|" | tee -a $output_log
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
            check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_system%% system\n" >> $logfile
            else
                printf "CPU $current_cpu - $cpu_system%% system\n" >> $logfile
            fi
            cpu_system_warning=1
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "CPU,CPU system%%,OK,\n" >> $csv_log
    fi
    if [[ $cpu_system_warning -eq 1 ]]; then
        printf "CPU,CPU system%%,WARNING,\n" >> $csv_log
        printf "High CPU system time indicates that the Check Point kernel is consuming CPU.\n" >> $logfile
        printf "Certain configurations in SmartDefense and web-intelligence can cause this to occur by\n" >> $logfile
        printf "disabling SecureXL templates or completely disabling SecureXL acceleration.\n" >> $logfile
    fi

    #====================================================================================================
    #  CPU Wait Check
    #====================================================================================================
    printf "|\t\t\t| CPU wait%%\t\t\t|" | tee -a $output_log
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
            check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_wait%% wait\n" >> $logfile
            else
                printf "CPU $current_cpu - $cpu_wait%% wait\n" >> $logfile
            fi
            cpu_wait_warning=1
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "CPU,CPU wait%%,OK,\n" >> $csv_log
    fi
    if [[ $cpu_wait_warning -eq 1 ]]; then
    printf "CPU,CPU wait%%,WARNING,\n" >> $csv_log
        printf "High CPU wait time occurs when the CPU is idle due to the system waiting for an outstanding disk IO request to complete.\n"  >> $logfile
        printf "This indicates your system is probably low on physical memory and is swapping out memory (paging).\n" >> $logfile
        printf "The CPU is not actually busy if this number is spiking, the CPU is blocked from doing any useful work waiting for an IO event.\n" >> $logfile
    fi

    #====================================================================================================
    #  CPU Interrupt Check
    #====================================================================================================
    printf "|\t\t\t| CPU interrupt%%\t\t|" | tee -a $output_log
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
            check_failed
            if [[ $offline_operations == true ]]; then
                printf "top reading $current_cpu - $cpu_interrupt%% interrupt\n" >> $logfile
            else
                printf "CPU $current_cpu - $cpu_interrupt%% interrupt\n" >> $logfile
            fi
            cpu_interrupt_warning=1
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "CPU,CPU interrupt%%,OK,\n" >> $csv_log
    fi
    if [[ $cpu_interrupt_warning -eq 1 ]]; then
        printf "CPU,CPU interrupt%%,WARNING,\n" >> $csv_log
        printf "High CPU software interrupt time indicates that there is probably a high load of traffic on the firewall.\n" >> $logfile
        printf "Use \"netstat -i\" to see if interface errors are the cause.\n" >> $logfile
    fi
    
    
    #====================================================================================================
    #  CPView Database Checks
    #====================================================================================================
    if [[ -e $cpview_file ]] && [[ $sys_type == "VSX" ||  $sys_type == "STANDALONE" || $sys_type == "GATEWAY" ]]; then
    
        
        #====================================================================================================
        #  CPU 30-Day Average Check
        #====================================================================================================
        printf "|\t\t\t| CPU 30-Day Average\t\t|" | tee -a $output_log
        current_cpu=0
        cpu_over_80=0
        test_output_error=0
        for current_cpu in $all_cpu_list; do
            current_cpu_avg=$(sqlite3 $cpview_file "select avg(cpu_usage) from UM_STAT_UM_CPU_UM_CPU_ORDERED_TABLE where name_of_cpu=$current_cpu;" 2> /dev/null | awk '{printf "%.0f", int($1+0.5)}')
            if [[ $current_cpu_avg -ge 80 ]]; then
                ((cpu_over_80++))
                check_failed
                printf "CPU $current_cpu Average Usage: $current_cpu_avg\n" >> $logfile
            fi
        done
        
        #Log final output
        if [[ $cpu_over_80 -ge 1 ]]; then
            printf "CPU,CPU 30-Day Average,WARNING,\n" >> $csv_log
            printf "$cpu_over_80 core(s) out of $all_cpu_count had an average over 80%% in the last month.\nPlease review the CPU usage on this device to see if a configuration change or hardware upgrade is needed.\n" >> $logfile
        else
            check_passed
            printf "CPU,CPU 30-Day Average,OK,\n" >> $csv_log
        fi
        
        #====================================================================================================
        #  CPU 30-Day Max Check
        #====================================================================================================
        printf "|\t\t\t| CPU 30-Day Peak\t\t|" | tee -a $output_log
        current_cpu=0
        cpu_over_80=0
        test_output_error=0
        for current_cpu in $all_cpu_list; do
            current_cpu_peak=$(sqlite3 $cpview_file "select max(cpu_usage) from UM_STAT_UM_CPU_UM_CPU_ORDERED_TABLE where name_of_cpu=$current_cpu;" 2> /dev/null | awk '{printf "%.0f", int($1+0.5)}')
            if [[ $current_cpu_peak -ge 80 ]]; then
                ((cpu_over_80++))
                check_failed
                printf "CPU $current_cpu Peak Usage: $current_cpu_peak\n" >> $logfile
            fi
        done
        
        #Log final output
        if [[ $cpu_over_80 -ge 1 ]]; then
            printf "CPU,CPU 30-Day Peak,WARNING,\n" >> $csv_log
            printf "$cpu_over_80 core(s) out of $all_cpu_count went over 80%% in the last month.\nPlease review the CPU usage on this device to see if a configuration change or hardware upgrade is needed.\n" >> $logfile
        else
            check_passed
            printf "CPU,CPU 30-Day Peak,OK,\n" >> $csv_log
        fi
    fi
        
    
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
#  Interface Info Function
#====================================================================================================
check_interface_stats()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Interface Stats\t"
    
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
    for current_interface in $interface_list; do
        current_errors=$(netstat --interfaces=$current_interface | grep -v Kernel | grep -v Iface | awk '{print $5}') > /dev/null 2>&1
        if [[ $current_errors -ne 0 ]]; then
            check_failed
            printf "RX Errors - $current_interface has $current_errors RX errors\n" >> $logfile
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,RX Errors,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Errors,WARNING,\n" >> $csv_log
        printf "\nReceive Error Information:\nThese usually indicate a mismatch in duplex setting, mtu size, bad cabling or possibly a faulty interface card.\n" >> $logfile
        printf "Check the switch settings and fix the speed and duplex settings if there is a mismatch, check cabling and try a spare interface.\n" >> $logfile
    fi
        

    #====================================================================================================
    #  RX Drop Check
    #====================================================================================================
    printf "|\t\t\t| RX Drops\t\t\t|" | tee -a $output_log
    test_output_error=0
    
    #Loop through each interface to collect RX-Drop and RX-OK info
    for current_interface in $interface_list; do
        current_OK=$(netstat --interfaces=$current_interface | grep -v Kernel | grep -v Iface | awk '{print $4}') > /dev/null 2>&1
        current_drops=$(netstat --interfaces=$current_interface | grep -v Kernel | grep -v Iface | awk '{print $6}') > /dev/null 2>&1
        
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
            check_failed
            printf "RX Drops WARNING - $current_interface has $current_drops RX drops which accounts for $drop_percent%% of traffic on this interface.\n" >> $logfile
        fi
    done
    
    #Log success if no interfaces are over .5% drops
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,RX Drops,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Drops,WARNING,\n" >> $csv_log
        printf "\nReceive Drop Information:\nThese imply the appliance is dropping packets at the network.\n" >> $logfile
        printf "Attention is required for the interfaces listed above if the drops account for more than 0.50%% as this is a sign that the firewall does not have enough FIFO memory buffer (descriptors) to hold the packets while waiting for a free interrupt to process them.\n" >> $logfile
    fi

    #====================================================================================================
    #  RX Missed Check
    #====================================================================================================
	printf "|\t\t\t| RX Missed Errors\t\t|" | tee -a $output_log
	test_output_error=0
    
    #Loop through each interface to collect rx_missed_errors and rx_packets
	for current_interface in $interface_list; do
		current_rx_missed_errors=$(ethtool -S $current_interface 2> /dev/null| grep rx_missed_errors | awk '{print $2}') > /dev/null 2>&1
        current_rx_packets=$(ethtool -S $current_interface 2> /dev/null | grep rx_packets | awk '{print $2}') > /dev/null 2>&1
            
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
            check_failed
            printf "RX Missed WARNING - $current_interface has $current_rx_missed_errors rx_missed_errors which accounts for $missed_percent%% of traffic on this interface.\n" >> $logfile
        elif [[ -z $current_rx_packets || -z $current_rx_missed_errors ]]; then
            check_failed
            printf "RX Missed - Unable to determine RX packets or RX missed packets for $current_interface.\n" >> $logfile
        fi
	done
    
    #Log success if no interfaces are over .5% missed
	if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,RX Missed Errors,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Missed Errors,WARNING,\n" >> $csv_log
        printf "\nReceive Missed Information:\nA ratio of rx_mised_errors to rx_packets greater than 0.5%% indicates the number of received packets that have been missed due to lack of capacity in the receive side which means the NIC has no resources and is actively dropping packets.\n" >> $logfile
        printf "Confirm that flow control on the switch is enabled. When flow control on the switch is disabled, we are bound to have issues for rx_missed_errors. If it is enabled, please contact Check Point Software Technologies, we need to know what the TX/RX queues are set to and we'll proceed from there.\n" >> $logfile
    fi
    
    #====================================================================================================
    #  RX Overrun Check
    #====================================================================================================
    printf "|\t\t\t| RX Overruns\t\t\t|" | tee -a $output_log
    test_output_error=0
    for current_interface in $interface_list; do
        current_rx_overruns=$(netstat --interfaces=$current_interface | grep -v Kernel | grep -v Iface | awk '{print $7}') > /dev/null 2>&1
        if [[ $current_rx_overruns -ne 0 ]]; then
            check_failed
            printf "RX Overruns - $current_interface has $current_rx_overruns RX Overruns\n" >> $logfile
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,RX Overruns,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Overruns,WARNING,\n" >> $csv_log
        printf "\nReceive Overrun Information:\nThese imply the appliance is getting overrun with traffic from the network.\n" >> $logfile
    fi
    
    #====================================================================================================
    #  TX Error Check
    #====================================================================================================
    printf "|\t\t\t| TX Errors\t\t\t|" | tee -a $output_log
    test_output_error=0
    for current_interface in $interface_list; do
        current_errors=$(netstat --interfaces=$current_interface | grep -v Kernel | grep -v Iface | awk '{print $9}') > /dev/null 2>&1
        if [[ $current_errors -ne 0 ]]; then
            check_failed
            printf "TX Errors - $current_interface has $current_errors TX errors\n" >> $logfile
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,TX Errors,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,TX Errors,WARNING,\n" >> $csv_log
        printf "\nTransmit Errors Information:\nThese usually indicate a mismatch in duplex setting, mtu size, bad cabling or possibly a faulty interface card.\n" >> $logfile
        printf "Check the switch settings and fix the speed and duplex settings if there is a mismatch, check cabling and try a spare interface.\n" >> $logfile
    fi

    #====================================================================================================
    #  TX Drops Check
    #====================================================================================================
    printf "|\t\t\t| TX Drops\t\t\t|" | tee -a $output_log
    test_output_error=0
    for current_interface in $interface_list; do
        current_drops=$(netstat --interfaces=$current_interface | grep -v Kernel | grep -v Iface | awk '{print $10}') > /dev/null 2>&1
        if [[ $current_drops -ne 0 ]]; then
            check_failed
            printf "  $current_interface has $current_drops TX drops\n" >> $logfile
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,TX Drops,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,TX Drops,WARNING,\n" >> $csv_log
        printf "\nTransmit Drop Information:\nThese usually indicate that there is a downstream issue and the firewall has to drop the packets as it is unable to put them on the wire fast enough.\n" >> $logfile
        printf "Increasing the bandwidth through link aggregation or introducing flow control may be a possible solution to this problem.\n" >> $logfile
    fi


    #====================================================================================================
    #  TX Carrier Errors Check
    #====================================================================================================
	printf "|\t\t\t| TX Carrier Errors\t\t|" | tee -a $output_log
	test_output_error=0
	for current_interface in $interface_list; do
		current_tx_carrier_errors=$(ethtool -S $current_interface 2> /dev/null | grep tx_carrier_errors | awk '{print $2}') > /dev/null 2>&1
		if [[ $current_tx_carrier_errors -ne 0 ]]; then
            check_failed
            printf "TX Carrier Errors - $current_interface has $current_tx_carrier_errors.\n" >> $logfile
		fi
	done
	if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,TX Carrier Errors,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,TX Carrier Errors,WARNING,sk97251\n" >> $csv_log
        printf "\nTransmit Carrier Errors Information:\nThese indicate the number of packets that could not be transmitted because of carrier errors (e.g: physical link down).\n" >> $logfile
        printf "If link is up, run Hardware Diagnostic Tool as described in sk97251. Please run network test while using loopback adapter as explained in sk97251.\n" >> $logfile
        printf "Also provide to Check Point Support an output of the command:#cat /sys/class/net/Internal/carrier. \n" >> $logfile
    fi

    
    
    #====================================================================================================
    #  TX Overrun Check
    #====================================================================================================
    printf "|\t\t\t| TX Overruns\t\t\t|" | tee -a $output_log
    test_output_error=0
    for current_interface in $interface_list; do
        current_tx_overruns=$(netstat --interfaces=$current_interface | grep -v Kernel | grep -v Iface | awk '{print $11}') > /dev/null 2>&1
        if [[ $current_tx_overruns -ne 0 ]]; then
            check_failed
            printf "TX Overruns - $current_interface has $current_tx_overruns TX Overruns\n" >> $logfile
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,TX Overruns,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,TX Overruns,WARNING,\n" >> $csv_log
        printf "\nReceive Overrun Information:\nThese imply the appliance is getting overrun with traffic to the network.\n" >> $logfile
    fi
    
    
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
#  Messages Function
#====================================================================================================
check_misc_messages()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="Misc. Messages\t"
    
    #Combine /var/log/messages and /var/log/dmesg then start log.
    if [[ $offline_operations == true ]]; then
        messages_tmp_file="messages_check.tmp"
        grep -A5000 ^/var/log/messages $cpinfo_file | grep -B5000 /var/log/dmesg | grep -v /var/log | grep -v '\-\-\-' >> $messages_tmp_file 2> /dev/null
    else
        messages_tmp_file="/var/tmp/messages_check.tmp"
        cat /var/log/messages* /var/log/dmesg >> $messages_tmp_file 2> /dev/null
    fi
    
    printf "| Misc. Messages\t| Known issues in logs\t\t|" | tee -a $output_log
    
    #Check Neighbor table overflow
    if [[ $(grep -i "neighbour table overflow" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Neighbor table overflow,WARNING,sk43772\n" >> $csv_log
        printf "\"neighbour table overflow\" message detected:\n" >> $logfile
        printf "For more information, refer to sk43772.\n" >> $logfile
    fi
    
    #Check synchronization risk
    if [[ $(grep -i "State synchronization is in risk" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,State synchronization is in risk,WARNING,sk23695\n" >> $csv_log
        printf "\"State synchronization is in risk\" message detected:\n" >> $logfile
        printf "For more information, refer to sk23695.\n" >> $logfile
    fi
    
    #Check SecureXL Templates
    if [[ $(grep -i "Connection templates are not possible for the installed policy (network quota is active)" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,SecureXL templates are not possible for the installed policy,WARNING,sk31630\n" >> $csv_log
        printf "\"SecureXL templates are not possible for the installed policy\" message detected:\n" >> $logfile
        printf "For more information, refer to sk31630.\n" >> $logfile
    fi
    
    #Check Out of Memory
    if [[ $(grep -i "Out of Memory: Killed" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Out of Memory: Killed process,WARNING,sk33219\n" >> $csv_log
        printf "\"Out of Memory: Killed process\" message detected:\n" >> $logfile
        printf "This message means there is no more memory available in the user space.\n" >> $logfile
        printf "As a result, Gaia or SecurePlatform starts to kill processes.\n" >> $logfile
        printf "For more information, refer to sk33219.\n" >> $logfile
    fi
    
    #Check Additional Sync problem
    if [[ $(grep -i "fwlddist_adjust_buf: record too big for sync" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Record too big for Sync,WARNING,sk35466\n" >> $csv_log
        printf "\"Record too big for Sync\" message detected:" >> $logfile
        printf "This message may indicate problems with the sync network.\n" >> $logfile
        printf "It can cause traffic loss, unsynchronized kernel tables, and connectivity problems." >> $logfile
        printf "For more information, refer to sk35466.\n" >> $logfile
    fi
    
    #Check Dead loop on virtual device 
    if [[ $(grep -i "Dead loop on virtual device" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Dead Loop on virtual device,WARNING,sk32765\n" >> $csv_log
        printf "\"Dead Loop on virtual device\" message detected:\n" >> $logfile
        printf "This message is a SecureXL notification on the outbound connection that may cause the gateway to lose sync traffic.\n" >> $logfile
        printf "For more information, refer to sk32765.\n" >> $logfile
    fi
    
    #Check Stack Overflow 
    if [[ $(grep -i "fw_runfilter_ex" $messages_tmp_file | grep -i "stack overflow") ]]; then
        check_failed
        printf "Misc. Messages,Stack Overflow,WARNING,sk99329\n" >> $csv_log
        printf "\"Stack Overflow\" message detected:\n" >> $logfile
        printf "It is possible that the number of security rules has exceeded a limit or some file became corrupted.\n" >> $logfile
        printf "For more information, refer to sk99329.\n" >> $logfile
    fi
    
    #Check Log buffer full 
    if [[ $(grep -i "FW-1: Log Buffer is full" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,FW-1: Log Buffer is full,WARNING,sk52100\n" >> $csv_log
        printf "\"FW-1: Log Buffer is full\" message detected:\n" >> $logfile
        printf "The kernel module maintains a cyclic buffer of waiting log messages.\n" >> $logfile
        printf "This log buffer queue was overflown (i.e., new logs are added before all the previous ones are being read - causing messages to be overwritten) resulting in the above messages.\n" >> $logfile
        printf "The most probable causes can be: high CPU utilization, high levels of logging, increased traffic, or change in logging.\n" >> $logfile
        printf "For more information, refer to sk52100.\n" >> $logfile
    fi
    
    #Check Log buffer tsid 0 full 
    if [[ $(grep -i "FW-1: Log buffer for tsid 0 is full" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,FW-1: Log buffer for tsid 0 is full,WARNING,sk114616\n" >> $csv_log
        printf "\"FW-1: Log buffer for tsid 0 is full\" message detected:\n" >> $logfile
        printf "Log buffer used by the FWD daemon gets full.\n" >> $logfile
        printf "As a result, FireWall log messages are not processed in time.\n" >> $logfile
        printf "For more information, refer to sk114616.\n" >> $logfile
    fi
    
    #Check Max entries in state on conn
    if [[ $(grep -i "number of entries in state on conn" $messages_tmp_file | grep -i "has reached maximum allowed") ]]; then
        check_failed
        printf "Misc. Messages,Number of entries in state on conn has reached maximum allowed,WARNING,sk52101\n" >> $csv_log
        printf "\"number of entries in state on conn has reached maximum allowed\" message detected:\n" >> $logfile
        printf "The \"sd_conn_state_max_entries\" kernel parameter is used by IPS.\n" >> $logfile
        printf "All connections/packets are held in this kernel table, so IPS protections can be run against them.\n" >> $logfile
        printf "If too many connections/packets are held, then the buffer will be overrun.\n" >> $logfile
        printf "For more information, refer to sk52101.\n" >> $logfile
    fi
    
    #Check Connections table 80% full
    if [[ $(grep -i 'The connections table is 80% full' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,The connections table is 80% full,WARNING,sk35627\n" >> $csv_log
        printf "\"The connections table is 80% full\" message detected:\n" >> $logfile
        printf "Traffic might be dropped by Security Gateway.\n" >> $logfile
        printf "For more information, refer to sk35627.\n" >> $logfile
    fi
    
    #Check Different versions
    if [[ $(grep -i 'fwsync: there is a different installation of Check Point' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,there is a different installation of Check Point products on each member of this cluster,WARNING,sk41023\n" >> $csv_log
        printf "\"fwsync: there is a different installation of Check Point products on each member of this cluster\" message detected:\n" >> $logfile
        printf "This issue can be seen if some Check Point packages were manually deleted or disabled on one of cluster members, bit not on others.\n" >> $logfile
        printf "For more information, refer to sk41023.\n" >> $logfile
    fi
    
    #Check too many internal hosts
    if [[ $(grep -i 'too many internal hosts' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,too many internal hosts,WARNING,sk10200\n" >> $csv_log
        printf "\"too many internal hosts\" message detected:\n" >> $logfile
        printf "Traffic may pass through Security Gateway very slowly.\n" >> $logfile
        printf "For more information, refer to sk10200.\n" >> $logfile
    fi
    
    #Check Interface configured in Management
    if [[ $(grep -i 'kernel: FW-1: No interface configured in SmartCenter server with name' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,No interface configured in SmartCenter server,WARNING,sk36849\n" >> $csv_log
        printf "\"kernel: FW-1: No interface configured in SmartCenter server with name\" message detected:\n" >> $logfile
        printf "In the SmartDashboard there were no interface(s) with such name(s) - as appear on the Security Gateway machine.\n" >> $logfile
        printf "Therefore, by design, the Firewall tries to match the interface in question by IP address.\n" >> $logfile
        printf "For more information, refer to sk36849.\n" >> $logfile
    fi
    
    #Check alternate Sync in risk
    if [[ $(grep -i 'sync in risk: did not receive ack for the last' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,sync in risk: did not receive ack,WARNING,sk82080\n" >> $csv_log
        printf "\"sync in risk: did not receive ack for the last x packets\" message detected:\n" >> $logfile
        printf "Amount of outgoing Delta Sync packets is too high for the current Sending Queue size.\n" >> $logfile
        printf "For more information, refer to sk82080.\n" >> $logfile
    fi
    
    #Check OSPF messages
    if [[ $(grep -i 'cpcl_should_send' $messages_tmp_file | grep -i 'returns -3') ]]; then
        check_failed
        printf "Misc. Messages,cpcl_should_send returns -3,WARNING,sk106129\n" >> $csv_log
        printf "\"cpcl_should_send returns -3\" message detected:\n" >> $logfile
        printf "OSPF routes may not be synced between the Active member and the other cluster members.\n" >> $logfile
        printf "For more information, refer to sk106129.\n" >> $logfile
    fi
    
    #Check cphwd_pslglue_can_offload_template
    if [[ $(grep -i 'cphwd_pslglue_can_offload_template: error, psl_opaque is NULL' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,cphwd_pslglue_can_offload_template: error,WARNING,sk107258\n" >> $csv_log
        printf "\"cphwd_pslglue_can_offload_template: error, psl_opaque is NULL\" message detected:\n" >> $logfile
        printf "This issue can be resolved by either disabling SecureXL or installing the latest jumbo.\n" >> $logfile
        printf "For more information, refer to sk107258.\n" >> $logfile
    fi
    
    #Check RIP message
    if [[ $(grep -i 'cpcl_should_send' $messages_tmp_file | grep -i 'returns -1') ]]; then
        check_failed
        printf "Misc. Messages,cpcl_should_send returns -1,WARNING,sk106128\n" >> $csv_log
        printf "\"cpcl_should_send returns -1\" message detected:\n" >> $logfile
        printf "When RIP is configured, RouteD does not check correctly if RIP sync state should be sent to other cluster members.\n" >> $logfile
        printf "For more information, refer to sk106128.\n" >> $logfile
    fi
    
    #Check Enter/Leave cpcl_vfr_recv_from_instance_manager
    if [[ $(grep -i -e 'entering cpcl_vrf_recv_from_instance_manager' -e'leaving cpcl_vrf_recv_from_instance_manager' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,entering/leaving cpcl_vrf_recv_from_instance_manager,WARNING,sk108233\n" >> $csv_log
        printf "\"entering/leaving cpcl_vrf_recv_from_instance_manager\" message detected:\n" >> $logfile
        printf "Cluster state may be changing repeatedly.\n" >> $logfile
        printf "For more information, refer to sk108233.\n" >> $logfile
    fi
    
    #Check duplicate address detected
    if [[ $(grep -i 'if_get_address: duplicate address detected:' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,if_get_address: duplicate address detected,WARNING,sk94466\n" >> $csv_log
        printf "\"if_get_address: duplicate address detected\" message detected:\n" >> $logfile
        printf "Assigning a cluster IP address in the range of the VSX internal communication network causes an IP address conflict and causes RouteD daemon to crash.\n" >> $logfile
        printf "For more information, refer to sk94466.\n" >> $logfile
    fi
    
    #Check vmalloc
    if [[ $(grep -i 'Failed to allocate' $messages_tmp_file | grep -i 'bytes from vmalloc') ]]; then
        check_failed
        printf "Misc. Messages,Failed to allocate bytes from vmalloc,WARNING,sk90043\n" >> $csv_log
        printf "\"Failed to allocate bytes from vmalloc\" message detected:\n" >> $logfile
        printf "Linux \"vmalloc\" reserved memory area is exhausted.\n" >> $logfile
        printf "Critical allocations, which are needed for a Virtual System, can not be allocated.\n" >> $logfile
        printf "For more information, refer to sk90043.\n" >> $logfile
    fi
    
    #Check Soft Lockup
    if [[ $(grep -i 'kernel: BUG: soft lockup - CPU' $messages_tmp_file | grep -i 'stuck for 10s') ]]; then
        check_failed
        printf "Misc. Messages,kernel: BUG: soft lockup - CPU x stuck for 10s,WARNING,sk116870 and sk105729\n" >> $csv_log
        printf "\"kernel: BUG: soft lockup - CPU x stuck for 10s\" message detected:\n" >> $logfile
        printf "A soft lockup isn't necessarily anything 'crashing', it is the symptom of a task or kernel thread using and not releasing a CPU for a longer period of time than allowed; in Check Point the default fault is 10 seconds.\n" >> $logfile
        printf "For more information, refer to sk116870 and sk105729.\n" >> $logfile
    fi
    
    #Check LOM not responding
    if [[ $(grep -i 'The LOM is not accepting our command' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,LOM is not accepting our command,WARNING,sk92788 or sk94639\n" >> $csv_log
        printf "\"Max retry count exceeded. The LOM is not accepting our command\" message detected:\n" >> $logfile
        printf "A delay in synchronization of hardware sensor information between Gaia OS and LOM card has occurred.\n" >> $logfile
        printf "For more information, refer to sk92788 and sk94639.\n" >> $logfile
    fi
    
    #Check IPv6
    if [[ $(grep -i 'modprobe: FATAL: Could not open' $messages_tmp_file | grep -i '/lib/modules/2.6.18-92cpx86_64/kernel/net/ipv6/ipv6.ko') ]]; then
        check_failed
        printf "Misc. Messages,Could not open ipv6.ko,WARNING,sk95222\n" >> $csv_log
        printf "\"modprobe: FATAL: Could not open /lib/modules/2.6.18-92cpx86_64/kernel/net/ipv6/ipv6.ko\" message detected:\n" >> $logfile
        printf "If IPv6 is disabled, this message can be safely ignored.\n" >> $logfile
        printf "For more information, refer to sk95222.\n" >> $logfile
    fi
    
    #Check syslogd sendto errors
    if [[ $(grep -i 'syslogd: sendto' $messages_tmp_file | grep -i -e 'Invalid argument' -e 'Bad File Descriptor' -e 'Connection refused') ]]; then
        check_failed
        printf "Misc. Messages,syslogd sendto errors,WARNING,sk83160\n" >> $csv_log
        printf "\"syslogd: sendto:\" failure message detected:\n" >> $logfile
        printf "Syslog messages are not forwarded from Security Gateway to Security Management Server, although \"Send Syslog messages to management server\" option is activated in Gaia Portal on Security Gateway.\n" >> $logfile
        printf "For more information, refer to sk83160.\n" >> $logfile
    fi
    
    #Check Incorrect validation of SNMP traps 
    if [[ $(grep -i 'xpand' $messages_tmp_file | grep -i 'The value of sensor could not be read') ]]; then
        check_failed
        printf "Misc. Messages,Incorrect validation of SNMP traps,WARNING,sk101898\n" >> $csv_log
        printf "\"xpand[PID]: The value of sensor could not be read\" message detected:\n" >> $logfile
        printf "SNMP Traps may be sent due to incorrect validation of the values returned by sensors.\n" >> $logfile
        printf "For more information, refer to sk101898.\n" >> $logfile
    fi
    
    #Check Open Server blank hardware sensors
    if [[ $(grep -i 'SQL error: columns time_stamp, sensor_name are not unique rc=19' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Blank hardware sensors on open server,WARNING,sk97109\n" >> $csv_log
        printf "\"SQL error: columns time_stamp, sensor_name are not unique rc=19\" message detected:\n" >> $logfile
        printf "On Open Server, hardware sensor names are all empty causing duplicate entries appear in the SQL database of sensor data.\n" >> $logfile
        printf "For more information, refer to sk97109.\n" >> $logfile
    fi
    
    #Check Kernel Parameters
    if [[ $(grep -i 'Global param: operation failed: Unknown parameter' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Global param: operation failed: Unknown parameter,WARNING,sk87006\n" >> $csv_log
        printf "\"Global param: operation failed: Unknown parameter\" message detected:\n" >> $logfile
        printf "Defined kernel parameters or their values are not valid.\n" >> $logfile
        printf "For more information, refer to sk87006.\n" >> $logfile
    fi
    
    #Check DHCP config
    if [[ $(grep -i 'DHCPINFORM' $messages_tmp_file | grep -i 'not authoritative for subnet') ]]; then
        check_failed
        printf "Misc. Messages,DHCP not authoritative for subnet,WARNING,sk92436\n" >> $csv_log
        printf "\"DHCP not authoritative for subnet\" message detected:\n" >> $logfile
        printf "This is not specific to Check Point Software. This is a global DHCP message.\n" >> $logfile
        printf "For more information, refer to sk92436.\n" >> $logfile
    fi
    
    #Check /var/log/db
    if [[ $(grep -i 'SQL error: database disk image is malformed' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,SQL error: database disk image is malformed,WARNING,sk98338\n" >> $csv_log
        printf "\"SQL error: database disk image is malformed\" message detected:\n" >> $logfile
        printf "Possible reason: /var/log/db database might be corrupted.\n" >> $logfile
        printf "For more information, refer to sk98338.\n" >> $logfile
    fi
    
    #Check TSO offload
    if [[ $(grep -i 'e1000_set_tso: TSO is enabled' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,e1000_set_tso: TSO is enabled,WARNING,sk52761\n" >> $csv_log
        printf "\"e1000_set_tso: TSO is enabled\" message detected:\n" >> $logfile
        printf "TCP Segmentation Offload (TSO) is not supported by the FireWall.\n" >> $logfile
        printf "For more information, refer to sk52761.\n" >> $logfile
    fi
    
    #Check CUL
    if [[ $(grep -i 'cul_load_freeze' $messages_tmp_file | grep -i 'high kernel CPU usage') ]]; then
        check_failed
        printf "Misc. Messages,Cluster Under Load,WARNING,sk92723\n" >> $csv_log
        printf "\"Cluster Under Load\" message detected:\n" >> $logfile
        if [[ $(grep -w 'cul_load_freeze' $messages_tmp_file | grep -i 'high kernel CPU usage') ]]; then
            printf "The local cluster member is experiencing high CPU spikes which are triggering the CUL mechanism.\nWhen under heavy load, cluster flapping may occur.\n" >> $logfile
        elif [[ $(grep -w 'cul_load_freeze_on_remote' $messages_tmp_file | grep -i 'high kernel CPU usage') ]]; then
            printf "A remote cluster member is experiencing high CPU spikes which are triggering the CUL mechanism.\nWhen under heavy load, cluster flapping may occur.\n" >> $logfile
        else
            printf "A gateway in this cluster is experiencing high CPU spikes which are triggering the CUL mechanism.\nWhen under heavy load, cluster flapping may occur.\n" >> $logfile
        fi
        printf "For more information, refer to sk92723.\n" >> $logfile
    fi
    
    #Log check as OK if no messages are found
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Misc. Messages,Known issues in logs,OK,\n" >> $csv_log
    fi
        
    #Clean up temp message file
    rm $messages_tmp_file
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
    top -b -n1 >> $full_output_log
    
    #====================================================================================================
    #  Zombie Processes Check
    #====================================================================================================
    printf "| Processes\t\t| Zombie Processes\t\t|" | tee -a $output_log
    zombie_procs_list=$(echo "$app_all_procs" | grep defunct | grep -v grep | grep -v USER)
    zombie_procs_count=$(echo "$app_all_procs" | grep defunct | grep -v grep | grep -v USER | wc -l)
    if [[ $zombie_procs_count -gt 0 ]]; then
        check_failed
        printf "Processes,Zombie Processes,WARNING,\n" >> $csv_log
        printf "$zombie_procs_count zombie processes found.\n" >> $logfile
        printf "PID\tCOMMAND\n" >> $logfile
        while read -r i; do
            zpid=$(echo $i | awk '{print $2}')
            zcom=$(echo $i | awk '{print $11,$12,$13,$14,$15,$16,$17,$18,$19}')
            printf "$zpid\t$zcom\n" >> $logfile
        done <<< "$zombie_procs_list"
        printf "\n" >> $logfile
    else
        check_passed
        printf "Processes,Zombie Processes,OK,\n" >> $csv_log
    fi
    
    #====================================================================================================
    #  Process Restarts Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Process Restarts\t\t|" | tee -a $output_log
    
    #Store "cpwd_admin list" output
    cpwd_admin list > /var/tmp/proc_start_list.tmp 2> /dev/null
    printf "\nCPWD Admin List:\n" >> $full_output_log
    cat /var/tmp/proc_start_list.tmp >> $full_output_log
    restarted_procs=$(cat /var/tmp/proc_start_list.tmp | grep -v APP | awk -F] '{print $2}' | awk '{print $1}' | sort -u | wc -l)
    rm /var/tmp/proc_start_list.tmp
    
    #Report results of the process check
    if [[ $restarted_procs -gt 1 ]]; then
        check_failed
        printf "Processes,Process Restarts,WARNING,\n" >> $csv_log
        printf "Restarted Process Warning: $restarted_procs different processes start times found.\n" >> $logfile
        printf "Review \"cpwd_admin list\" to locate the restarted processes.\n\n" >> $logfile
    elif [[ $restarted_procs -eq 0 ]]; then
        check_failed
        printf "Processes,Process Restarts,WARNING,\n" >> $csv_log
        printf "Restated Process Fail:\n" >> $logfile
        printf "Unable to obtain list of process start times.\n" >> $logfile
        printf "Make sure the Check Point Processes are started and try again.\n" >> $logfile
    else
        check_passed
        printf "Processes,Process Restarts,OK,\n" >> $csv_log
    fi
    
    #Unset Application Process variables
    unset app_all_procs
    unset zombie_procs_list
    unset zombie_procs_count
    unset zpid
    unset zcom
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
    user_cores_found=false
    kernel_cores_found=false
    usermode_core_list=$(ls -lah /var/log/dump/usermode/ | grep -v total | grep -v drwx)
    kernel_core_list=$(ls -lah /var/log/crash/ | grep -v total | grep -v drwx)
    
    #====================================================================================================
    #  Usermode Core Check
    #====================================================================================================
    printf "| Core Files\t\t| Usermode Cores Present\t|" | tee -a $output_log
    if [[ $(echo "$usermode_core_list" | sed "/^$/d" | wc -l) -ge 1 ]]; then
        check_failed
        printf "Core Files,Usermode Cores Present,WARNING,\n" >> $csv_log
        printf "Usermode Cores:\n" >> $logfile
        echo "$usermode_core_list" >> $logfile
        printf "\n" >> $logfile
        user_cores_found=true
        cores_found=1
    else
        check_passed
        printf "Core Files,Usermode Cores Present,OK,\n" >> $csv_log
    fi
    
    #====================================================================================================
    #  Kernel Core Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Kernel Cores Present\t\t|" | tee -a $output_log
    if [[ $(echo "$kernel_core_list" | sed "/^$/d" | wc -l) -ge 1 ]]; then
        check_failed
        printf "Core Files,Kernel Cores Present,WARNING,\n" >> $csv_log
        printf "Kernel Cores:\n" >> $logfile
        echo "$kernel_core_list" >> $logfile
        printf "\n" >> $logfile
        kernel_cores_found=true
        cores_found=1
    else
        check_passed
        printf "Core Files,Kernel Cores Present,OK,\n" >> $csv_log
    fi
    
    #Log core instructions if cores are found
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
    
    #Unset Core File variables
    unset cores_found
    unset user_cores_found
    unset kernel_cores_found
    unset usermode_core_list
    unset kernel_core_list
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
    elif [[ $current_version -ge 8000 ]]; then
        magic_mac=$(cphaprob mmagic | sed "/^$/d")
        printf "$magic_mac\n" >> $full_output_log
    fi
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
    printf "| Debugs\t\t| Active tcpdumps\t\t|" | tee -a $output_log
    
    tcpdumps_active=$(ps aux | grep tcpdump | grep -v grep)
    
    #Check if kdebug or zdebug are running.
    if [[ $(echo "$tcpdumps_active" | grep tcpdump) ]]; then
        check_failed
        printf "Debugs,Active tcpdumps,WARNING,\n" >> $csv_log
        printf "The following tcpdumps are running:\n" >> $logfile
        printf "PID\tCOMMAND\n" >> $logfile
        while read -r current_tcpdump; do
            current_tcpdump_PID=$(echo $current_tcpdump | awk '{print $2}')
            current_tcpdump_command=$(echo $current_tcpdump | awk '{print $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25}')
            printf "$current_tcpdump_PID\t$current_tcpdump_command\n" >> $logfile
        done <<< "$tcpdumps_active"
        printf "Please stop these processes if these captures are no longer needed.\n" >> $logfile
    else
        check_passed
        printf "Debugs,Active Debug Processes,OK,\n" >> $csv_log
    fi
    
    #====================================================================================================
    #  Active Debug Check
    #====================================================================================================
    printf "|\t\t\t| Active Debug Processes\t|" | tee -a $output_log
    
    debugs_active=$(ps aux | grep debug | grep -v grep)
    
    #Check if kdebug or zdebug are running.
    if [[ $(echo "$debugs_active" | grep debug) ]]; then
        check_failed
        printf "Debugs,Active Debug Processes,WARNING,\n" >> $csv_log
        printf "The following debugs were enabled:\n" >> $logfile
        printf "PID\tCOMMAND\n" >> $logfile
        while read -r current_debug; do
            current_debug_PID=$(echo $current_debug | awk '{print $2}')
            current_debug_command=$(echo $current_debug | awk '{print $11, $12, $13, $14, $15, $16, $17}')
            printf "$current_debug_PID\t$current_debug_command\n" >> $logfile
        done <<< "$debugs_active"
        printf "If these debugs are no longer needed:\nPlease stop these processes and run \"fw ctl debug 0\" to clear the debug flags.\n\n" >> $logfile
    else
        check_passed
        printf "Debugs,Active Debug Processes,OK,\n" >> $csv_log
    fi

    #====================================================================================================
    #  Firewall Debug Flag Check
    #====================================================================================================
    if [[ $sys_type == "STANDALONE" || $sys_type == "GATEWAY" || $sys_type == "VSX" ]]; then
        test_output_error=0
        debug_flag_check=0
        printf "|\t\t\t| Debug Flags Present\t\t|" | tee -a $output_log
        
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

        
        #Loop through and check each module
        for current_module in $debug_flag_module_list; do
            #Delete control characters from module name
            current_module=$(echo $current_module | tr -d '[:cntrl:]')
            
            #Find the current debug flag setting
            current_module_setting=$(grep -w -A3 $current_module /var/tmp/debug_flag_current.tmp | grep "debugging options" | awk -F: '{print $2}' | awk '{print $1,$2}' | tr -d '[:cntrl:]')
            
            #Check to see if it does not contain the default flags
            if [[ $current_module_setting != *"error warning"* && $current_module_setting != *"error"* && $current_module_setting != *"None"* && $current_module_setting != *"err"* && -n $current_module_setting ]]; then
                check_failed
                printf "$current_module\n" >> /var/tmp/modified_modules.tmp
                debug_flag_check=1
            fi
        done
        
        #Message to display if any modified flags are detected
        if [[ $(echo "$debug_flag_check") -ne 0 ]]; then
            check_failed
            printf "Debugs,Debug Flags Present,WARNING,\n" >> $csv_log
            printf "Detected modified debug flags for the following modules:\n" >> $logfile
            cat /var/tmp/modified_modules.tmp >> $logfile
            rm /var/tmp/modified_modules.tmp
            printf "If these modules no longer need debug flags set:\nPlease run \"fw ctl debug 0\" to clear the debug flags.\n" >> $logfile
        else
            check_passed
            printf "Debugs,Debug Flags Present,OK,\n" >> $csv_log
        fi
        
        #Clean up temp files
        rm /var/tmp/debug_flag_current.tmp
        rm /var/tmp/debug_flag_modules.tmp
    fi

    #====================================================================================================
    #  CPM Debug Check
    #====================================================================================================
    if [[ $current_version -ge 8000 ]]; then
        if [[ $sys_type == "MDS" || $sys_type == "SMS" || $sys_type == "STANDALONE" ]]; then
            test_output_error=0
            debug_flag_check=0
            printf "|\t\t\t| CPM Debugs \t\t\t|" | tee -a $output_log
            
            #Check to see if CPM debugs are enabled in tdlog.cpm
            if [[ $(grep TOPIC-DEBUG $MDS_FWDIR/conf/tdlog.cpm) ]]; then
                check_failed
                printf "Debugs,CPM Debugs,WARNING,sk115557\n" >> $csv_log
                printf "CPM Debugs are present for the following modules:\n" >> $logfile
                grep TOPIC-DEBUG $MDS_FWDIR/conf/tdlog.cpm | awk -F: '{print $2}' >> $logfile
                printf "If these debugs are no longer needed, please follow the steps from sk115557 to disable them.\n" >> $logfile
            else
                check_passed
                printf "Debugs,CPM Debugs,OK,\n" >> $csv_log
            fi
        fi
    fi
    
    
    #====================================================================================================
    #  TDERROR Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| TDERROR Configured\t\t|" | tee -a $output_log
    if [[ $(env | grep TDERROR) ]]; then
        check_failed
        printf "Debugs,TDERROR Configured,WARNING,\n" >> $csv_log
        active_tderror=$(env | grep TDERROR | awk -F= '{print $1}')
        if [[ $(echo "$active_tderror" | wc -l) -eq 1 ]]; then
            printf "Detected $active_tderror environment variable.\nIf this is no longer needed, run the following command:\n    unset $active_tderror\n" >> $logfile
        else
            printf "Detected multiple \"TDERROR\" environment variables:\n" >> $logfile
            printf "These can be disabled with the respective commands below:\n" >> $logfile
            for i in $(echo "$active_tderror"); do
                printf "    unset $i\n" >> $logfile
            done
        fi
    else
        check_passed
        printf "Debugs,TDERROR Configured,OK,\n" >> $csv_log
    fi

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
    
    
    #Display ERROR if fw ctl pstat is unable to execute
    if [[ -s $fragment_error_file ]]; then
        check_failed
        printf "Fragments,Fragments,ERROR,\n" >> $csv_log
        printf "\"fw ctl pstat\" resulted in an error and fragment information was unable to be determined.\n" >> $logfile
    
    #Display warning messages if failures or expired packets are detected
    elif [[ $current_failures -ne 0 || $current_expired -ne 0 ]]; then
        check_failed
        printf "Fragments,Fragments,WARNING,\n" >> $csv_log
        if [[ $current_failures -ne 0 ]]; then
            printf "Failures – denotes the number of fragmented packets that were received that could not be successfully re-assembled.\n" >> $logfile
        fi
        if [[ $current_expired -ne 0 ]];then
            printf "Expired – denotes how many fragments were expired when the firewall failed to reassemble them in a 20 seconds time frame or when due to memory exhaustion, they could not be kept in memory anymore.\n" >> $logfile
        fi
    
        
    #Display OK if everything is good
    else
        check_passed
        printf "Fragments,Fragments,OK,\n" >> $csv_log
    fi
    
    #Clean up temp file
    rm $fragment_error_file > /dev/null 2>&1
    
    #Unset Fragments variables
    unset all_fragments
    unset current_expired
    unset current_failures
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
    
    #Display error if there was a problem accessing the connections table
    if [[ -s $connections_error_file ]]; then
        check_failed
        printf "Connections Table,Peak Connections,ERROR,\n" >> $csv_log
        printf "Connections Table ERROR - Unable to open connections table.\n" >> $logfile
    
    #Display check passed if connections table is unlimited
    elif [[ $(echo "$fw_tab_connections" | grep limit) == *"unlimited"* ]]; then
        check_passed
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
            check_failed
            printf "Connections Table,Peak Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections limit.\n" >> $logfile
        
        #Display warning messages if peak is reached
        elif [[ $peak_percent -ge 80 ]]; then
            check_failed
            printf "Connections Table,Peak Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - The Peak connections is $peak_percent%% of total capacity.\n" >> $logfile
            printf "Once the connections table is full, new connections will be dropped.\n" >> $logfile
            printf "Please consider increasing the connections table limit.\n" >> $logfile
        
        #Display check passed if connection capacity is less than 80%
        elif  [[ $peak_percent -lt 80 ]]; then
            check_passed
            printf "Connections Table,Peak Connections,OK,\n" >> $csv_log
        
        #Catch all message if none of the other conditions match
        else
            check_failed
            printf "Connections Table,Peak Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections information.\n" >> $logfile
        fi
    fi

    
    #====================================================================================================
    #  Current Connections Check
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| Current Connections\t\t|" | tee -a $output_log    
    
    #Display error if there was a problem accessing the connections table
    if [[ -s $connections_error_file ]]; then
        check_failed
        printf "Connections Table,Concurrent Connections,ERROR,\n" >> $csv_log
        printf "Concurrent Connections ERROR - Unable to open connections table.\n" >> $logfile
    
    #Display check passed if connections table is unlimited
    elif [[ $(echo "$fw_tab_connections" | grep limit) == *"unlimited"* ]]; then
        check_passed
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
            check_failed
            printf "Connections Table,Concurrent Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections limit.\n" >> $logfile
        
        #Display warning messages if peak is reached
        elif [[ $connections_percent -ge 80 ]]; then
            check_failed
            printf "Connections Table,Concurrent Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - The current connections table is $connections_percent%% full.\n" >> $logfile
            printf "Once the connections table is full, new connections will be dropped.\n" >> $logfile
            printf "Please consider increasing the connections table limit.\n" >> $logfile
        
        #Display check passed if connection capacity is less than 80%
        elif  [[ $connections_percent -lt 80 ]]; then
            check_passed
            printf "Connections Table,Concurrent Connections,OK,\n" >> $csv_log
        
        #Catch all message if none of the other conditions match
        else
            check_failed
            printf "Connections Table,Concurrent Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections information.\n" >> $logfile
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
    nat_connections=$(fw tab -t fwx_cache -s 2> $nat_error_file | grep -v HOST)
    
    #Display error if there was a problem accessing the NAT table
    if [[ -s $nat_error_file ]]; then
        check_failed
        printf "Connections Table,NAT Connections,ERROR,\n" >> $csv_log
        printf "NAT Table ERROR - Unable to open fwx_cache table.\n" >> $logfile
        
    #Display error if there was any other problems accessing the connections table
    elif [[ $nat_connections == *"not a FireWall-1 module"* || $nat_connections == *"Failed to get table status"* ]]; then
        check_failed
        printf "Connections Table,NAT Connections,WARNING,\n" >> $csv_log
        printf "NAT Connections - Unable to get information from fwx_cache table.\n" >> $logfile
    
    #Check NAT connections info
    else
        connections_VALS=$(echo $nat_connections | awk '{print $4}')
        connections_PEAK=$(echo $nat_connections | awk '{print $5}')
        
        #Display warning messages if peak is reached
        if [[ $connections_PEAK -eq 10000 ]]; then
            check_failed
            printf "Connections Table,NAT Connections,WARNING,\n" >> $csv_log
            printf "NAT Connections:\n" >> $logfile
            if [[ $connections_VALS -eq 10000 ]]; then
                printf "The value of VALS is equal to 10,000 which indicates that the NAT cache table is currently full.\n" >> $logfile
            else
                printf "The value of #PEAK is equal to 10,000 which indicates that the NAT cache table (default 10,000) was full at some time.\n" >> $logfile
            fi
            printf "For improved NAT cache performance the size of the NAT cache should be increased or the time entries are held in the table decreased.\n" >> $logfile
            printf "For further information see: sk21834: How to modify the values of the properties related to the NAT cache table \n" >> $logfile
        
        #Display check passed if NAT connections are OK
        else
            check_passed
            printf "Connections Table,NAT Connections,OK,\n" >> $csv_log
        fi
        
        #Log NAT values
        printf "\n\nNAT VALS: $connections_VALS\n" >> $full_output_log
        printf "NAT PEAK: $connections_PEAK\n" >> $full_output_log
    fi
    
    #Clean up temp file
    rm $nat_error_file > /dev/null 2>&1

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
    elif [[ "$cphaprob_stat" == *"HA module not started."* ]]; then
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
        check_failed
        printf "ClusterXL,Cluster Status,WARNING,\n" >> $csv_log
        printf "Cluster peer is: $other_member_status.\n" >> $logfile
    
    #Single member problem
    elif [[ $single_member_check -eq 1 ]]; then
        check_failed
        printf "ClusterXL,Cluster Status,WARNING,\n" >> $csv_log
        printf "\nUnable to find remote partner.\n" >> $logfile
        printf "This is usually due to one of the following reasons:\n" >> $logfile
        printf " -There is no network connectivity between the members of the cluster on the sync network.\n" >> $logfile
        printf " -The partner does not have state synchronization enabled.\n" >> $logfile
        printf " -One partner is using broadcast mode while the other is using multicast mode.\n" >> $logfile
        printf " -One of the monitored processes has an issue, such as no policy loaded.\n" >> $logfile
        printf " -The partner firewall is down.\n" >> $logfile
    
    #Current member success
    elif [[ $cluster_status == "Active" || $cluster_status == "Standby" ]]; then
        check_passed
        printf "ClusterXL,Cluster Status,OK,\n" >> $csv_log
    
    #Current member problem
    else
        check_failed
        printf "ClusterXL,Cluster Status,WARNING,\n" >> $csv_log
        printf "Cluster status is: $cluster_status.\n" >> $logfile
        if [[ "$cphaprob_stat" == *"HA module not started."* ]]; then
            printf "Cluster membership is enabled in cpconfig but the HA module is not started\nPlease review the configuration to determine if this device is supposed to be a member of a cluster.\n" >> $logfile
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
        if [[ $current_version -ge 7730 ]]; then
            cluster_pnotes=$(cphaprob -l list | grep -e "Device Name" -e "Current state")
        else
            cluster_pnotes=$(cphaprob -ia list | grep -e "Device Name" -e "Current state")
        fi
        problem_state=$(echo "$cluster_pnotes" | grep -B1 "problem" | grep Device | awk '{print $3, $4, $5}')
        problem_count=$(echo "$cluster_pnotes" | grep "problem" | wc -l)
        if [[ $problem_count -ge 1 ]]; then
            check_failed
            printf "Cluster,Problem Notifications,WARNING,\n" >> $csv_log
            printf "The following pnotes were detected:\n" >> $logfile
            while read -r current_pnote; do
                printf "  $current_pnote\n" >> $logfile
            done <<< "$problem_state"
            printf "\n" >> $logfile
        else
            check_passed
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
        clusterXL_HA_info=$(cpstat ha -f all | sed "/^$/d" | sed '/table/i \\')
        printf "\nCluster full status HA information:\n$clusterXL_HA_info\n" >> $full_output_log

    
        #====================================================================================================
        #  Cluster Sync Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Sync Status\t\t\t|" | tee -a $output_log
        cluster_sync=$(fw ctl pstat | sed '1,/Sync:/d')
        printf "\n\nCluster Sync:\n$cluster_sync\n" >> $full_output_log
        
        if [[ $cluster_sync == *"off"* ]]; then
            check_failed
            printf "ClusterXL,Sync Status,WARNING,sk34476 and sk37029 and sk37030\n" >> $csv_log
            printf "Sync is Off!\n" >> $logfile
            printf "For more information on Sync, use sk34476: Explanation of Sync section in the output of fw ctl pstat command.\n" >> $logfile
            printf "To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.\n" >> $logfile
        else
            check_passed
            printf "ClusterXL,Sync Status,OK,\n" >> $csv_log
        fi
        
        
        #====================================================================================================
        #  Cluster Sync Interfaces Check
        #====================================================================================================
        test_output_error=0
        if [[ $sys_type == "VSX" ]]; then
            printf "|\t\t\t| Number of Sync Interfaces\t|" | tee -a $output_log
            sync_interface_list=$(echo "$cluster_a_if" | grep -A90 "vsid $vs" | sed '2d' | sed -n "/vsid $vs/,/------/p" | grep secured | grep -v non | grep -v Required | awk '{print $1}')
            sync_interface_number=$(echo "$sync_interface_list" | wc -l)
            
            printf "\n\nSync Interfaces:\n$sync_interface_list\n" >> $full_output_log
            
            if [[ $sync_interface_number -gt 1 ]]; then
                check_failed
                printf "ClusterXL,Number of Sync Interfaces,WARNING,sk92804\n" >> $csv_log
                printf "Multiple Sync Interfaces Detected:\n" >> $logfile
                printf "For more information on redundant sync configurations, use sk92804: Sync Redundancy in ClusterXL.\n" >> $logfile
            else
                check_passed
                printf "ClusterXL,Number of Sync Interfaces,OK,\n" >> $csv_log
            fi
        else
            printf "|\t\t\t| Number of Sync Interfaces\t|" | tee -a $output_log
            sync_interface_list=$(echo "$cluster_a_if" | grep secured | grep -v non | grep -v Required | awk '{print $1}')
            sync_interface_number=$(echo "$sync_interface_list" | wc -l)
            
            printf "\n\nSync Interfaces:\n$sync_interface_list\n" >> $full_output_log
            
            if [[ $sync_interface_number -gt 1 ]]; then
                check_failed
                printf "ClusterXL,Number of Sync Interfaces,WARNING,sk92804\n" >> $csv_log
                printf "Multiple Sync Interfaces Detected:\n" >> $logfile
                printf "For more information on redundant sync configurations, use sk92804: Sync Redundancy in ClusterXL.\n" >> $logfile
            else
                check_passed
                printf "ClusterXL,Number of Sync Interfaces,OK,\n" >> $csv_log
            fi
        fi
        
        
        #====================================================================================================
        #  Cluster Failover Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Cluster Failovers\t\t|" | tee -a $output_log
        
        #Misc. Variables
        current_day_of_the_year=$(date +%j)
        failovers_in_the_last_week=0
        failover_temp_file=/var/tmp/failovers.tmp
        
        #Collect list of failovers
        clish -c "show routed cluster-state detailed" | grep -A 11 "Cluster State Change History" | grep "[0-9]" > $failover_temp_file
        
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

        #Report on the check result
        if [[ $failovers_in_the_last_week -ge 1 ]]; then
            check_failed
            printf "ClusterXL,Cluster Failovers,WARNING,\n" >> $csv_log
            printf "The cluster has failed over $failovers_in_the_last_week time(s) in the last week.\n" >> $logfile
        else
            check_passed
            printf "ClusterXL,Cluster Failovers,OK,\n" >> $csv_log
        fi
    fi

    #Unset ClusterXL variables
    unset cphaprob_stat
    unset active_active_check
    unset single_member_check
    unset cluster_status
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
    
    #Display error if fwaccel stat is not able to be run
    if [[ -s $fw_accel_error ]]; then
        check_failed
        printf "SecureXL,SecureXL Status,ERROR,\n" >> $csv_log
        printf "SecureXL ERROR:\nThe \"fwaccel stat\" command resulted in an error.\n" >> $logfile
        rm $fw_accel_error > /dev/null 2>&1
        
    #Display warning if fwaccel is off
    elif [[ $accelerator_status == "off" ||  $accelerator_status == "disabled" ]]; then
        check_failed
        printf "SecureXL,SecureXL Status,WARNING,sk98722\n" >> $csv_log
        printf "SecureXL Notice:\nAccelerator is off. Please confirm if it is required to be left off by your organization.\n" >> $logfile
        printf "If Accelerator was not manually turned off for debugging purposes, use sk98722-ATRG:SecureXL.\n" >> $logfile
        printf "\nSecureXL Information:\nAccelerator Status: Off\n" >> $full_output_log
    
    #Display check passed if fwaccel is on then perform additional checks
    elif [[ $accelerator_status == "on" ||  $accelerator_status == "enabled" ]]; then
        check_passed
        printf "SecureXL,SecureXL Status,OK,\n" >> $csv_log
        printf "\nSecureXL Information:\n" >> $full_output_log
        echo "$fwaccel_stat" >> $full_output_log 2>&1
        

        #====================================================================================================
        #  Accept Templates Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Accept Templates\t\t|" | tee -a $output_log
        accept_templated_status=$(echo "$fwaccel_stat" | grep "Accept Templates" | grep -Eo 'disabled|enabled')
        if [[ $accept_templated_status == "enabled" ]]; then
            check_passed
            printf "SecureXL,Accept Templates,OK,\n" >> $csv_log
        elif [[ $accept_templated_status == "disabled" ]]; then
            check_failed
            
            #Check to see if accept templates were disabled by a specific rule
            accept_templated_disabled=$(echo "$fwaccel_stat" | grep -A1 "Accept Templates" | tail -n1 | grep disable | awk -F'from ' '{print $2}')
            if [[ $(echo $accept_templated_disabled | grep "rule") ]]; then
                printf "SecureXL,Accept Templates,WARNING,sk32578\n" >> $csv_log
                printf "SecureXL Notice:\nAccept Templates are disabled from $accept_templated_disabled.\nPlease review sk32578 to see what is causing these to be disabled.\n" >> $logfile
            else
                printf "SecureXL,Accept Templates,WARNING,sk98722\n" >> $csv_log
                printf "SecureXL Notice:\nAccept Templates are disabled.\n" >> $logfile
            fi
        else
            check_failed
            printf "SecureXL,Accept Templates,WARNING,sk98722\n" >> $csv_log
            printf "SecureXL Notice:\nUnable to determine if Accept Templates are enabled or disabled.\n" >> $logfile
        fi

        
        #====================================================================================================
        #  Drop Templates Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| Drop Templates\t\t|" | tee -a $output_log
        drop_templated_status=$(echo "$fwaccel_stat" | grep "Drop Templates")
        if [[ $drop_templated_status == *"enabled"* || $drop_templated_status == *"disabled by Firewall"*  ]]; then
            check_passed
            printf "SecureXL,Drop Templates,OK,\n" >> $csv_log
        elif [[ $drop_templated_status == *"disabled"* ]]; then
            check_info
            printf "SecureXL,Drop Templates,INFO,sk90861 and sk90941\n" >> $csv_log
            printf "SecureXL Notice:\nDrop Templates are disabled.\nAccelerated Drop Rules feature protects the Security Gateway and site from Denial of Service attacks by dropping packets at the acceleration layer.\nPlease review sk90861 and sk90941 for more information.\n" >> $logfile
        else
            check_failed
            printf "SecureXL,Drop Templates,WARNING,sk90861 and sk90941\n" >> $csv_log
            printf "SecureXL Notice:\nUnable to determine if Drop Templates are enabled or disabled.\n" >> $logfile
        fi
        
        
        #====================================================================================================
        #  F2F Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| F2F Packets\t\t\t|" | tee -a $output_log
        f2f_percent=$(echo "$fwaccel_stats_s" | grep F2F | awk -F\( '{print $2}' | awk -F\% '{print $1}')
        if [[ $f2f_percent -le 40  ]]; then
            check_passed
            printf "SecureXL,F2F Packets,OK,\n" >> $csv_log
        elif [[ $f2f_percent -ge 41 && $f2f_percent -le 60  ]]; then
            check_info
            printf "SecureXL,F2F Packets,INFO,sk98348\n" >> $csv_log
            printf "SecureXL Notice:\nF2F (firewall/slow path) packets account for $f2f_percent%% of all traffic.\n" >> $logfile
            printf "For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance\n" >> $logfile
        else
            check_failed
            printf "SecureXL,F2F Packets,WARNING,sk98348\n" >> $csv_log
            printf "SecureXL WARNING:\nF2F (firewall/slow path) packets account for $f2f_percent%% of all traffic.\n" >> $logfile
            printf "For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance\n" >> $logfile
        fi
        
        #====================================================================================================
        #  PXL Check
        #====================================================================================================
        test_output_error=0
        printf "|\t\t\t| PXL Packets\t\t\t|" | tee -a $output_log
        pxl_percent=$(echo "$fwaccel_stats_s" | grep PXL | awk -F\( '{print $2}' | awk -F\% '{print $1}')
        if [[ $pxl_percent -le 40  ]]; then
            check_passed
            printf "SecureXL,PXL Packets,OK,\n" >> $csv_log
        elif [[ $pxl_percent -ge 41 && $pxl_percent -le 60  ]]; then
            check_info
            printf "SecureXL,PXL Packets,INFO,sk98348\n" >> $csv_log
            printf "SecureXL Notice:\nPXL (medium path) packets account for $pxl_percent%% of all traffic.\n" >> $logfile
            printf "For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance\n" >> $logfile
        else
            check_failed
            printf "SecureXL,PXL Packets,WARNING,sk98348\n" >> $csv_log
            printf "SecureXL WARNING:\nPXL (medium path) packets account for $pxl_percent%% of all traffic.\n" >> $logfile
            printf "For more information regarding tuning connections, use sk98348: Best Practices - Security Gateway Performance\n" >> $logfile
        fi
        
        
    else
        check_failed
        printf "SecureXL,SecureXL Status,WARNING,sk98722\n" >> $csv_log
        printf "SecureXL Information:\nUnable to determine accelerator status.\n\tPlease run \"fwaccel stat\" for further details.\n\n" >> $logfile
        printf "\nAccelerator Status: Unable to determine status.  Use sk98722-ATRG:SecureXL\n" >> $full_output_log
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
    if [[ $offline_operations == true ]]; then
        agg_aging=$(grep -A50 '(fw ctl pstat)' $cpinfo_file | grep "Aggressive")
    else
        fw_ctl_pstat_error=/var/tmp/fw_ctl_pstat_error
        agg_aging=$(fw ctl pstat 2> $fw_ctl_pstat_error | grep Aggressive)
    fi
    printf "\nAggressive Aging:\n$agg_aging\n" >> $full_output_log
    
    #Display error if fw ctl pstat is unable to run
    if [[ -s $fw_ctl_pstat_error ]]; then
        check_failed
        printf "SecureXL,Aggressive Aging,ERROR,\n" >> $csv_log
        printf "Aggressive Aging ERROR:\nAn error was encountered while running \"fw ctl pstat\".\n" >> $logfile
    
    #Display check passed if aggressive aging is not active
    elif [[ $agg_aging == *"not active"* ]]; then
        check_passed
        printf "SecureXL,Aggressive Aging,OK,\n" >> $csv_log
    
    #Display warning if aggressive aging is disabled
    elif [[ $agg_aging == *"disabled"* ]]; then
        check_failed
        printf "SecureXL,Aggressive Aging,WARNING,\n" >> $csv_log
        printf "Aggressive Aging Warning:\nAggressive Aging has been set to Inactive in SmartDefence or IPS.\n" >> $logfile
    
    #Display warning if aggressive aging is in detect mode
    elif [[ $agg_aging == *"detect"* ]]; then
        check_failed
        printf "SecureXL,Aggressive Aging,WARNING,\n" >> $csv_log
        printf "Aggressive Aging Info:\nAggressive Aging is in Detect Mode.\n" >> $logfile
    fi
    
    #Remove temp file
    rm -rf $fw_ctl_pstat_error > /dev/null 2>&1
    rm -rf $fw_accel_error > /dev/null 2>&1

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
        core_stat=$(fw ctl multik stat 2> /dev/null)
	
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
	
    #Manually pass the CoreXL check for VSX
    if [[ $sys_type == "VSX" ]]; then
        core_stat=""
    fi
    
	#Display status results of CoreXL checks
	if [[ $(echo $core_stat | grep disabled) ]]; then
		check_failed
        printf "CoreXL,CoreXL Status,WARNING,\n" >> $csv_log
		printf "CoreXL Notice: CoreXL is disabled.  Please confirm if it is required to be left off by your organization.\n" >> $logfile
	else
		check_passed
        printf "CoreXL,CoreXL Status,OK,\n" >> $csv_log
        
        #If CoreXL is enabled, proceed with checks for CPU usage distribution
        if [[ $sys_type == "GATEWAY" || $sys_type == "VSX" ]]; then

            #====================================================================================================
            #  SND/FW Worker Overlap Check
            #====================================================================================================
            test_output_error=0
            printf "|\t\t\t| SND/FW Core Overlap \t\t|" | tee -a $output_log
            
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
                check_passed
                printf "CoreXL,SND/FW Core Overlap,OK,\n" >> $csv_log
            
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
                    check_failed
                    printf "CoreXL,SND/FW Core Overlap,WARNING,sk98737 and sk98348\n" >> $csv_log
                    printf "CoreXL Notice: Cores detected operating as both fw workers and SNDs.  Please review sk98737 and sk98348 for more information.\n" >> $logfile
                    printf "CoreXL Settings:\n" >> $logfile
                    echo "$fw_ctl_affinity" | egrep 'Interface|VS_|Kernel' >> $logfile
                else
                    check_passed
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
                    check_failed
                    printf "CoreXL,SND/FW Core Distribution,WARNING,sk98348\n" >> $csv_log
                    printf "CoreXL Notice: The average core utilization for the $higher_usage is $core_difference percent higher than the $lower_usage.  Please review the CoreXL best practices section of sk98348 for more information on how to tune the number of SND and FW instances.\n" >> $logfile
                else
                    check_passed
                    printf "CoreXL,SND/FW Core Distribution,OK,\n" >> $csv_log
                fi
                
                
                if [[ -n $cpu_usage ]]; then
                    #====================================================================================================
                    #  SND Core Distribution Check
                    #====================================================================================================
                    
                    test_output_error=0
                    printf "|\t\t\t| SND Core Distribution \t|" | tee -a $output_log
                    
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
                        check_failed
                        printf "CoreXL,SND Core Distribution,WARNING,sk98348\n" >> $csv_log
                        printf "CoreXL Notice: The average core utilization for CPU $high_snd_core is $snd_usage_difference percent higher than CPU $low_snd_core.  Please review the CoreXL best practices section of sk98348 for more information on how to tune the SNDs.\n" >> $logfile
                        printf "\nSND configuration per interface:\n" >> $logfile
                        echo "$fw_ctl_affinity" | grep Interface >> $logfile
                    else
                        check_passed
                        printf "CoreXL,SND Core Distribution,OK,\n" >> $csv_log
                    fi
                    
                    #====================================================================================================
                    #  SND Interface Distribution Check
                    #====================================================================================================
                    if [[ $snd_usage_difference -ge 20 ]]; then
                        test_output_error=0
                        printf "|\t\t\t| SND Interface Distribution \t|" | tee -a $output_log
                        
                        #List of interfaces associated with highest SND core
                        high_core_interface_list=$(echo "$fw_ctl_affinity" | grep Interface | grep -w $high_snd_core | awk '{print $2}' | sed 's/.$//g')
                        low_core_interface_list=$(echo "$fw_ctl_affinity" | grep Interface | grep -w $low_snd_core | awk '{print $2}' | sed 's/.$//g')
                        
                        #Verify if the high SND Core interface number
                        if [[ $(echo "$high_core_interface_list" | wc -l) -gt 1 ]]; then
                            check_failed
                            printf "CoreXL,SND Interface Distribution,WARNING,sk98348\n" >> $csv_log
                            printf "CoreXL Notice:\nCPU $high_snd_core is $high_snd_usage%% used (average) and shared across the following interfaces:\n" >> $logfile
                            echo "$high_core_interface_list" >> $logfile
                            printf "CPU $low_snd_core is $low_snd_usage%% used (average) and assigned to the following interface(s):\n" >> $logfile
                            echo "$low_core_interface_list" >> $logfile
                            printf "Please consider redistributing interfaces to better balance SND workload or using a dedicated SND for busy interfaces.\n" >> $logfile
                        else
                            check_passed
                            printf "CoreXL,SND Interface Distribution,OK,\n" >> $csv_log
                        fi
                    fi
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
            check_failed
            printf "CoreXL,Dynamic Dispatcher,WARNING,sk105261\n" >> $csv_log
            printf "CoreXL Notice: Dynamic Dispatcher is disabled.  Please review sk105261 for more information.\n" >> $logfile
        elif [[ $dispatcher_mode == *"On"* ]]; then
            check_passed
            printf "CoreXL,Dynamic Dispatcher,OK,\n" >> $csv_log
        else
            check_failed
            printf "CoreXL,Dynamic Dispatcher,WARNING,sk105261\n" >> $csv_log
            printf "CoreXL Notice: Unable to determine Dynamic Dispatcher status.  Please review sk105261 for more information.\n" >> $logfile
        fi
    fi
    
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
    sleep 5
    
    #Find end size of fw.log
    log_stop_size=$(ls -l $FWDIR/log/fw.log | awk '{print $5}')
    
    #Compare sizes and log
    if [[ $log_stop_size -gt $log_start_size ]]; then
        check_failed
        printf "Logging,Local Logging,WARNING,\n" >> $csv_log
        printf "Local Logging Fail:\nThe $FWDIR/log/fw.log file is increasing in size.\n" >> $logfile
    else
        check_passed
        printf "Logging,Local Logging,OK,\n" >> $csv_log
    fi
    
    #Unset local logging variables
    unset log_start_size
    unset log_stop_size
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
    rm /var/tmp/cpinfo_script.tmp
    rm /var/tmp/jumbo.tmp
    
}


#====================================================================================================
#  Check Point Software Function
#====================================================================================================
check_cp_software()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    script_build_date="10-01-2018"
    current_check_message="Check Point\t\t"
    
    
    #====================================================================================================
    #  CPinfo Build Check (sk92739)
    #====================================================================================================
    printf "| Check Point\t\t| CPInfo Build Number\t\t|" | tee -a $output_log
    cpinfo_build_version=$(cpvinfo /opt/CPinfo-10/bin/cpinfo | grep Build | awk '{print $4}')
    latest_cpinfo_build="914000182"
    printf "\n\ncpinfo build:\n$cpinfo_build_version\n"  >> $full_output_log
	if [[ $cpinfo_build_version -ge $latest_cpinfo_build ]]; then
        check_passed
        printf "Check Point,CPInfo Build Number,OK,\n" >> $csv_log
        printf "The cpinfo utility is up to date as of $script_build_date.\n" >> $full_output_log
	else
        check_failed
        printf "Check Point,CPInfo Build Number,WARNING,sk92739\n" >> $csv_log
        printf "An updated version of the CPInfo utility is available in sk92739 (as of $script_build_date).\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Local Build:  $cpinfo_build_version\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Latest Build: $latest_cpinfo_build\n" | tee -a $full_output_log $logfile > /dev/null
	fi
    
    
    #====================================================================================================
    #  CPUSE Build Check (sk92449)
    #====================================================================================================
    test_output_error=0
    printf "|\t\t\t| CPUSE Build Number\t\t|" | tee -a $output_log
    cpuse_build_version=$(cpvinfo $DADIR/bin/DAService | grep Build | awk '{print $4}')
    latest_cpuse_build="1573"
    if [[ $cpuse_build_version -ge $latest_cpuse_build ]]; then
        check_passed
        printf "Check Point,CPUSE Build Number,OK,\n" >> $csv_log
        printf "CPUSE is up to date as of $script_build_date.\n" >> $full_output_log
	else
        check_failed
        printf "Check Point,CPUSE Build Number,WARNING,sk92449\n" >> $csv_log
        printf "An updated version of CPUSE is available in sk92449 (as of $script_build_date).\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Local Build:  $cpuse_build_version\n" | tee -a $full_output_log $logfile > /dev/null
        printf "Latest Build: $latest_cpuse_build\n" | tee -a $full_output_log $logfile > /dev/null
	fi

    #====================================================================================================
    #  CPView History Check
    #====================================================================================================
    if [[ -e /bin/cpview_start.sh ]] && [[ $sys_type == "VSX" || $sys_type == "STANDALONE" || $sys_type == "GATEWAY" ]]; then
        test_output_error=0
        history_stat=$(/bin/cpview_start.sh history stat)
        printf "|\t\t\t| CPView History Status\t\t|" | tee -a $output_log
        if [[ $history_stat == *"history daemon is activated"* ]]; then
            check_passed
            printf "Check Point,CPView History Status,OK,\n" >> $csv_log
        elif [[ $history_stat == *"history daemon is not activated"* ]]; then
            check_failed
            printf "Check Point,CPView History Status,WARNING,sk101878\n" >> $csv_log
            printf "CPView History is not running.  Please use sk101878 for more information.\n" | tee -a $full_output_log $logfile > /dev/null
        else
            check_failed
            printf "Check Point,CPView History Status,WARNING,sk101878\n" >> $csv_log
            printf "Unable to determine CPView history status.  Please use sk101878 for more information.\n" | tee -a $full_output_log $logfile > /dev/null
        fi
    fi
    
    #Unset CP Software check variables
    unset script_build_date
    unset cpinfo_build_version
    unset latest_cpinfo_build
    unset cpuse_build_version
    unset latest_cpuse_build
    unset history_stat
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
    printf "\n\n" >> $full_output_log
    printf "########################################\n" >> $full_output_log
    printf "#  Full system diagnostic information  #\n" >> $full_output_log
    printf "########################################\n" >> $full_output_log
    printf "\n\n" >> $logfile
    printf "#################################\n" >> $logfile
    printf "#  Health Check Summary Report  #\n" >> $logfile
    printf "#################################\n" >> $logfile

    #Initialize CSV log
    printf "Category,Check,Status,SK\n" >> $csv_log

    #Detect CPU info for later checks
    mpstat_p_all=$(mpstat -P ALL)
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
    all_cpu_list=$(echo "$mpstat_p_all" | grep -v Linux | awk -v temp=$mpstat_cpu '{print $temp}' | grep ^[0-9])
    all_cpu_count=$(echo "$mpstat_p_all" | grep ^[0-9] | grep -v CPU | grep -v all | wc -l)

    #Display check header
    printf "\n\n##############################\n# Health Check Results Report\n########################################\n\n" >> $output_log
    
    
    #Special message for SP devices
    if [[ $sys_type == "SP" ]]; then
        printf "The current device is Scalable Platform.\n"
        printf "Please note the checks will only be run:\n"
        printf "\tOn the local SGM unless using the \"-b all\" flag\n"
        printf "\tOn the SMO if executed remotely from the Management Server.\n"
    fi
    
    #Log Header
    printf "\n\nCurrent Script Release: $script_ver\n" | tee -a $output_log
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
    check_misc_messages
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_processes
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_core_files
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_cp_software
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_debugs
    printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log


    #Checks for firewall applications
    if [[ $sys_type == "STANDALONE" || $sys_type == "GATEWAY" || $sys_type == "SP" ]]; then
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
        
    #Checks for VSX
    elif [[ $sys_type == "VSX" ]]; then
        #Global Checks
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
        
        
        #Create list of all VSs except 0
        vs_list=$(vsx stat -l 2> /dev/null | grep VSID | awk '{print $2}'| grep -v -w 0)
        
        #Loop through each VS performing checks
        for vs in $vs_list; do
            vs_error=2
            
            #Add Divider showing the VS to the full output
            printf "\n\nVirtual System $vs:\n====================================" >> $full_output_log
            
            printf "\nVirtual System $vs\n" | tee -a $output_log
            vsenv $vs | tee -a $output_log
            printf "\n\nVirtual System $vs:\n" >> $csv_log
            printf "Category,Check,Status,SK\n" >> $csv_log
            vsenv $vs > /dev/null
            printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
            printf "| Category              | Title                         | Result        |\n" | tee -a $output_log
            printf "+=======================+===============================+===============+\n" | tee -a $output_log
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
        done
        
    fi

    #Remaining Checks
    check_software
    check_hardware
    check_blades_enabled

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
    
    #Pull hostname from cpinfo
    cpinfo_hostname=$(grep -A2 "Issuing 'hostname'" $cpinfo_file | grep -v Issuing | sed "/^$/d" | head -n1)
    cpinfo_base_name=$(echo $cpinfo_file | awk -F'.' '{print $1}')
    
    #Set new log file paths
    logfile="${cpinfo_hostname}_health-check_$(date +%Y%m%d%H%M).txt"
    output_log="hc_output_log.tmp"
    full_output_log="${cpinfo_hostname}_health-check_full_$(date +%Y%m%d%H%M).log"
    csv_log="${cpinfo_hostname}_health-check_summary_$(date +%Y%m%d%H%M).csv"
    
    #Initialize temp log files
    printf "\n\n" >> $full_output_log
    printf "########################################\n" >> $full_output_log
    printf "#  Full system diagnostic information  #\n" >> $full_output_log
    printf "########################################\n" >> $full_output_log
    printf "\n\n" >> $logfile
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
    
    
    #Functions to run against offline files (cpinfo and cpview)
    printf "\n\nCurrent Script Release: $script_ver\n" | tee -a $output_log
    printf "Hostname: $cpinfo_hostname\n" | tee -a $output_log
    printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
    if [[ -n $cpview_file ]]; then
        printf "| Offline Physical System Checks using CPinfo and CPViewDB files        |\n" | tee -a $output_log
    else
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
    check_misc_messages
    printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log
    
    #Checks for firewall applications
    if [[ $sys_type == "STANDALONE" || $sys_type == "GATEWAY" || $sys_type == "SP" ]]; then
        printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
        if [[ -n $cpview_file ]]; then
            printf "| Offline Firewall Application Checks using CPinfo and CPViewDB files   |\n" | tee -a $output_log
        else
            printf "| Offline Firewall Application Checks using CPinfo file                 |\n" | tee -a $output_log
        fi
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        printf "| Category              | Title                         | Result        |\n" | tee -a $output_log
        printf "+=======================+===============================+===============+\n" | tee -a $output_log
        check_securexl
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        check_corexl
        printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log
    fi
    
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
        mgmt_cli login --root true -d $domain > $domain_id
        gateways_and_servers_list=$(mgmt_cli show gateways-and-servers -s $domain_id)
        #Find local CMA name
        local_cma_list=$(/bin/ls $MDSDIR/customers)
        for cma in $(echo "$local_cma_list"); do
            if [[ $(echo "$gateways_and_servers_list" | grep -w $cma) ]]; then
                current_cma=$cma
            fi
        done
    
    #SMS Specific operations
    else
        mgmt_cli login --root true > $domain_id
        gateways_and_servers_list=$(mgmt_cli show gateways-and-servers -s $domain_id)
        current_cma="SMS"
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
            cma_uid=$(echo "$gateways_and_servers_list" | grep -B1 -w $current_cma | head -n1 | awk -F\" '{print $2}')
            cma_is_primary=$(mgmt_cli show object uid $cma_uid details-level full -s $domain_id  | grep primaryManagement | awk '{print $2}')
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
    
    #Use cprid_util to transfer the script
    while read remote_candidate; do
        #Parse candidate details and save as variables
        gateway_name=$(echo $remote_candidate | awk '{print $1}')
        device_ip=$(echo $remote_candidate | awk '{print $2}')
        current_cma=$(echo $remote_candidate | awk '{print $3}')
        domain_id=$(echo $remote_candidate | awk '{print $4}')
        
        #Change context to CMA if needed
        if [[ $sys_type == "MDS" ]]; then
            mdsenv $current_cma
            
            #Check to see if the current CMA is active
            if [[ $(cpprod_util FwIsActiveManagement) -eq 0 ]]; then
                printf "$current_cma is not the current active Management Server for $gateway_name.  Please run this script on the Active Management Server and try again.\n"
                continue
            fi
        
        #Check to see if the SMS is active
        elif [[ $(cpprod_util FwIsActiveManagement) -eq 0 ]]; then
            printf "$current_cma is not the current active Management Server for $gateway_name.  Please run this script on the Active Management Server and try again.\n"
            continue
        fi
        
        #Send the file
        cprid_util -server $device_ip putfile -local_file "/home/admin/healthcheck.sh" -remote_file "/home/admin/healthcheck.sh" -perms 0755
        if [[ $(echo $?) -ne 0 ]]; then
            printf "An error has occurred while transferring the healthcheck.sh script to $gateway_name.  Please ensure the device is running and that SIC is established.\n"
            continue
        fi
        
        #Remote execute script
        mgmt_cli run-script script-name "Healthcheck" script "/home/admin/healthcheck.sh" targets.1 $gateway_name -s $domain_id > $return_details
        
        #Parse the API results
        if [[ $(grep generic_error $return_details) ]]; then
            printf "An unknown error has occurred collecting the output from $gateway_name.\n"
            printf "Please log into the gateway and review the health check log in /var/log/\n"
        else
            grep responseMessage $return_details | awk -F\" '{print $2}' > $return_code
            return_message=$(base64 -d $return_code 2> /dev/null)
            echo "$return_message" | grep -v base64
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
#  Confirm Domain Name Function
#====================================================================================================
confirm_domain_name()
{
    #Loop through asking for a valid domain name until one is specified
    domain_valid=false
    until [[ $domain_valid == true ]]; do
        
        #Set domain_valid to true to exit the loop if domain name is valid
        if [[ $(mgmt_cli show domains -s $mds_id  --format json | jq ".objects[].name" -r | grep -w $domain$) == $domain ]]; then
            domain_valid=true
        
        #Prompt the user if the domain name is not valid
        else
            #Set Domain Names to array IDs for later selection
            domain_name_id=0
            for current_domain in $(mgmt_cli show domains -s $mds_id  --format json | jq ".objects[].name" -r); do
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
        cat $logfile.tmp | grep '|' | awk -F'|' '{print $2}' 2>/dev/null | awk '{print $1, $2}' > $category_list
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
        cat $logfile.tmp | grep '#' | awk -F'#' '{print $2}' 2>/dev/null | awk '{print $1, $2, $3, $4}' > $header_list
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
    rm $output_log
    rm $full_output_log


    #Log completion
    printf "\n\n# Output Files:\n"
    printf "#########################\n"
    printf "A report with the above output and the results from each command run has been saved to the following log files:\n"
    printf "$logfile\n"
    printf "$csv_log\n\n"
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
    echo "./$(basename $0) [option]"
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
    echo "-v        Version:    Display script version information."
	echo ""
    echo ""
    echo "Examples:"
    echo "---------"
    if [[ $sys_type == "MDS" ]]; then
        echo "#Run remote checks for a single device in a single CMA:"
        echo "#Note: A list of devices from the CMA will be displayed automatically."
        echo "./$(basename $0) -d Production_Management_Domain"
        echo ""
        echo "#Run remote checks for a device (You will be prompted for a domain):"
        echo "./$(basename $0) -r"
        echo ""
    elif [[ $sys_type == "SMS"  ]]; then
        echo "#Run remote checks for a device managed by this Management Server:"
        echo "./$(basename $0) -r"
        echo ""
    fi
    echo "#Run offline health check against a cpinfo:"
    echo "./$(basename $0) -f example.info"
    echo ""
    echo "#Run offline health check against a cpinfo and cpview database:"
    echo "./$(basename $0) -f example.info -f CPViewDB.dat"
    echo ""
    echo "#Display version information:"
    echo "./$(basename $0) -v"
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
# Main Script
#====================================================================================================

#Set a trap to clean up all temp files if the user kills the script
trap temp_file_cleanup SIGINT
trap temp_file_cleanup SIGTERM


#====================================================================================================
# Parse Flags
#====================================================================================================
while getopts :d:b:f:ahvr opt; do
    case "${opt}" in
        a)
            if [[ $sys_type == "MDS" || $sys_type == "SMS" ]]; then
                #Set collection mode to all devices
                collection_mode="all"
                remote_operations=true
                
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
                    asg_cp2blades /home/admin/healthcheck.sh
                    g_all /home/admin/healthcheck.sh
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
                    cpinfo_file=$(tar -xvf $cpinfo_file | grep info)
                elif [[ $cpinfo_file == *".tgz" ]]; then
                    cpinfo_file=$(tar -xzvf $cpinfo_file | grep info)
                fi
                
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
                    cpview_file=$(tar -xvf $cpview_file | grep CPViewDB.dat$)
                elif [[ $cpview_file == *".tgz" ]]; then
                    cpview_file=$(tar -xzvf $cpview_file | grep CPViewDB.dat$)
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
        
        #Make sure the script is located in /home/admin
        if [[ ! -e /home/admin/healthcheck.sh ]]; then
            printf "Remote operations require the script be located in /home/admin/\n"
            printf "Please move the script to this location and try again.\n"
            exit 1
        fi
        
        #Make sure the API is up and running
        if [[ ! $(api status 2> /dev/null | grep "server is up") ]];then
            printf "API not up and running.  Exiting...\n"
            exit 1
        fi
        
        #Display message that the script is collecting API info
        clear
        printf "Collecting environment information using the API...\n"
        
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
    mgmt_cli login --root true > $mds_id

    #====================================================================================================
    # Collect info from all gateways in all domains
    #====================================================================================================
    if [[ $collection_mode == "all" && $domain_specified == false ]]; then
        #Create a list of all Domains
        domain_list=$(mgmt_cli show domains -s $mds_id  --format json | jq ".objects[].name" -r)
        
        #Show domain contents for all domains
        for domain in $domain_list; do

            #Collect gateway targets for the current domain and remotely execute script
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
