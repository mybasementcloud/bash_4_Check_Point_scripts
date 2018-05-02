#!/bin/bash
#====================================================================================================
# TITLE:            healthcheck.sh
# USAGE:            ./healthcheck.sh
#
# DESCRIPTION:	    Checks the system for things that may adversely impact performance or reliability.
#
# AUTHOR:           Nathan Davieau (Check Point Advanced Diamond Engineer)
# AUTHOR:           Rosemarie Rodriguez (Check Point Advanced Diamond Engineer)
# CONTRIBUTORS:     Brandon Pace, Russell Seifert, Joshua Hatter
# VERSION:		    4.08
# SK:               sk121447
#====================================================================================================

#====================================================================================================
#  Variables
#====================================================================================================
source /etc/profile.d/CP.sh
if [[ -e /etc/profile.d/vsenv.sh ]]; then
    source /etc/profile.d/vsenv.sh
fi
logfile=/var/log/$(hostname)-health_check-$(date +%Y%m%d%H%M).txt
output_log=/var/log/hc_output_log.tmp
full_output_log=/var/log/$(hostname)-health_check_full-$(date +%Y%m%d%H%M).log
csv_log=/var/log/$(hostname)-health_check-summary-$(date +%Y%m%d%H%M).csv
cp_suite=$(ls /var/opt/ | grep CPsuite)
messages_tmp_file="/var/tmp/messages_check.tmp"
summary_error=0
vs_error=0
script_ver="4.08 01-29-2018"

#====================================================================================================
#  Text Formatting
#====================================================================================================
text_red=$(tput setaf 1)
text_green=$(tput setaf 2)
text_yellow=$(tput setaf 3)
text_underline=$(tput sgr 0 1)
text_reset=$(tput sgr0)

#====================================================================================================
#  Determine System info
#====================================================================================================

# OS Version
current_version=$(cat /etc/cp-release)
if [[ $current_version == *"R80.10"* ]]; then
    current_version="8010"
elif [[ $current_version == *"R80"* ]]; then
    current_version="8000"
elif [[ $current_version == *"R77.30"* ]]; then
    current_version="7730"
elif [[ $current_version == *"R77.20"* ]]; then
    current_version="7720"
elif [[ $current_version == *"R77.10"* ]]; then
    current_version="7710"
elif [[ $current_version == *"R77"* ]]; then
    current_version="7700"
elif [[ $current_version == *"R76"* ]]; then
    current_version="7600"
else
    yesno_loop=1
    printf "\nSupported Versions:\n" | tee -a $output_log
	printf "\tR80.xx\n" | tee -a $output_log
    printf "\tR77.xx\n" | tee -a $output_log
	printf "\tR76\n" | tee -a $output_log
    printf "\nDetected local system version:\n$current_version\n\n" | tee -a $output_log
    printf "This script has not been certified for this version and may not function properly on this system.\n" | tee -a $output_log
    
    while [[ $yesno_loop -eq 1 ]]; do
        printf "Do you still want to continue? [y/n]: "
        read -n1 yesno
        if [[ $yesno == "Y" || $yesno == "y" ]]; then
            printf "\nProceeding per user decision.\n" | tee -a $output_log
            yesno_loop=0
        elif [[ $yesno == "N" || $yesno == "n" ]]; then
            printf "\nAborting per user decision.\n" | tee -a $output_log
            exit 0
        else
            printf "$yesno is not a valid option.  Please try again.\n"
        fi
    done
fi

#  System Type
if [[ $(echo $MDSDIR | grep mds) ]]; then
    sys_type="MDS"
elif [[ $($CPDIR/bin/cpprod_util FwIsVSX 2> /dev/null) == *"1"* ]]; then
	sys_type="VSX"
elif [[ $($CPDIR/bin/cpprod_util FwIsStandAlone 2> /dev/null) == *"1"* ]]; then
    sys_type="STANDALONE"
elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallModule 2> /dev/null) == *"1"*  ]]; then
    sys_type="GATEWAY"
elif [[ $($CPDIR/bin/cpprod_util RtIsRt 2> /dev/null) == *"1"*  ]]; then
    sys_type="SmartEvent"
elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallMgmt 2> /dev/null) == *"1"*  ]]; then
    sys_type="SMS"
else
    sys_type="N/A"
fi

#====================================================================================================
#  Misc
#====================================================================================================

# Ensure we have the clish database lock
clish -c "lock database override" >> /dev/null 2>&1
clish -c "lock database override" >> /dev/null 2>&1

# Initialize temp log files
printf "\n\n#######################################\n" >> $full_output_log
printf "# Full system diagnostic information  #\n" >> $full_output_log
printf "#######################################\n" >> $full_output_log

# Initialize csv log
printf "Category,Check,Status,SK\n" >> $csv_log

#====================================================================================================
#  Functions for specific checks
#====================================================================================================
check_passed()
{
    printf " OK\t\t|\n" >> $output_log
    printf "${text_green} OK${text_reset}\t\t|\n"
    }

check_failed()
{
    if [[ $vs_error -eq 2 ]]; then
        vs_error=1
        printf "\n\nVirtual System $vs:\n====================================" >> $logfile
    fi
    if [[ $test_output_error -eq 0 ]]; then
        printf " WARNING\t|\n" >> $output_log
        printf "${text_red} WARNING${text_reset}\t|\n"
        test_output_error=1
    fi
    if [[ $summary_error -eq 0 ]]; then
        summary_error=1
        echo "" >> $logfile
        echo $current_check_message >> $logfile
        echo "##########################" >> $logfile
    fi
}

check_info()
{
    if [[ $vs_error -eq 2 ]]; then
        vs_error=1
        printf "\n\nVirtual System $vs:\n====================================" >> $logfile
    fi
    if [[ $test_output_error -eq 0 ]]; then
        printf " INFO\t\t|\n" >> $output_log
        printf "${text_yellow} INFO${text_reset}\t\t|\n"
        test_output_error=1
    fi
    if [[ $summary_error -eq 0 ]]; then
        summary_error=1
        echo "" >> $logfile
        echo $current_check_message >> $logfile
        echo "##########################" >> $logfile
    fi
}

#System Uptime Check
check_system()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# System Checks:"
    uptime  >> $full_output_log
    printf "| System\t\t| Uptime\t\t\t|" | tee -a $output_log
    #Collect current uptime
    up_time=$(uptime | awk '{print $3, $4}')

    #Review days up
    if [[ $up_time == *"days"* ]]; then
        up_days=$(echo $up_time | awk '{print $1}')
        
        #Log OK if uptime is between 8 and 365 days
        if [[ $up_days -ge 8 && $up_days -lt 365 ]]; then
            check_passed
            printf "System,Uptime,OK,\n" >> $csv_log
        else
            #Set output error
            test_output_error=1
            
            #Display the system check summary if this is the first encountered error
            if [[ $summary_error -eq 0 ]]; then
                summary_error=1
                echo "" >> $logfile
                echo $current_check_message >> $logfile
                echo "##########################" >> $logfile
            fi
            
            #Display info if uptime is less than 7 days
            if [[ $up_days -le 7 ]]; then
                printf " INFO\t\t|\n" >> $output_log
                printf "System,Uptime,INFO,\n" >> $csv_log
				printf "${text_yellow} INFO${text_reset}\t\t|\n"
                printf "Uptime Info:\nThe system has been rebooted within the last week.\nPlease review \"/var/log/messages\" files (if they have not rolled over) if the system was not manually rebooted.\n\n" >> $logfile
                
            #Display WARNING if uptime is 1y+ or undetermined
            elif [[ $up_days -ge 365 ]]; then
                printf " WARNING\t|\n" >> $output_log
                printf "System,Uptime,WARNING,\n" >> $csv_log
				printf "${text_red} WARNING${text_reset}\t|\n"
                printf "Uptime Warning:\nThe system has NOT been rebooted for over a year.\n\n" >> $logfile
            else
                printf " WARNING\t|\n" >> $output_log
                printf "System,Uptime,WARNING,\n" >> $csv_log
				printf "${text_red} WARNING${text_reset}\t|\n"
                printf "Uptime Error:\nUnable to determine time since reboot.\n\n" >> $logfile
            fi
        fi
    else
        #If uptime is less than a day, display info message
        if [[ $summary_error -eq 0 ]]; then
            summary_error=1
            echo "" >> $logfile
            echo $current_check_message >> $logfile
            echo "##########################" >> $logfile
        fi
        printf " INFO\t\t|\n" >> $output_log
        printf "System,Uptime,INFO,\n" >> $csv_log
		printf "${text_yellow} INFO${text_reset}\t\t|\n"
        printf "Uptime Check Info:\nThe system has been rebooted within the last week.\nPlease review \"/var/log/messages\" files (if they have not rolled over) if the system was not manually rebooted.\n\n" >> $logfile
    fi

    #Collect OS edition
    cp_os_edition=$(clish -c 'show version os edition' | grep OS | awk '{print $3}')
    printf "|\t\t\t| OS Version\t\t\t|" | tee -a $output_log
    
    #Review OS edition
    if [[ $cp_os_edition == "32-bit" ]]; then
        if [[ $summary_error -eq 0 ]]; then
            summary_error=1
            echo "" >> $logfile
            echo $current_check_message >> $logfile
            echo "##########################" >> $logfile
        fi
        printf " INFO\t\t|\n" >> $output_log
        printf "System,OS Version,INFO,sk94627\n" >> $csv_log
		printf "${text_yellow} INFO${text_reset}\t\t|\n"
        printf "OS Version INFO:\nOperating System Edition is 32-bit.\n" >> $logfile
        printf "If we need to change OS edition to 64-bit, use sk94627.\n\n" >> $logfile
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
}

#NTP Check
check_ntp()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    ntp_error=0
    current_check_message="# NTP Checks:"
    #Log NTP check start
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    printf "| NTP\t\t\t| NTP Daemon\t\t\t|" | tee -a $output_log
    ntp_date=$(grep ntpdate /var/log/messages)
    
    #Check to see if the ntpstat binary is present
    if [[ -e /usr/bin/ntpstat ]]; then
        
        #Collect ntp status from ntpstat
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
        printf "\nNTP Information:\nPlease use sk92602 and sk83820 for asssitance with verifying NTP is configured and functioning properly.\n\n" >> $logfile
    fi
}

#Disk Space Check
check_disk_space()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Disk Space Checks:"
    
    #Start disk space checks
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    printf "| Disk Space\t\t| Free Disk Space\t\t|" | tee -a $output_log
    printf "\n\nDisk Space Info:\n" >> $full_output_log
    
    #Add full output to temp log and disk_check variable
    df -Ph  >> $full_output_log
    disk_check=$(df -Ph | awk '{print $5}' | sed 's/%//g' | grep -v Use)
    
    #Loop through each partition
    entry=1
    disk_space_error=0
    for partition_space in $disk_check; do
        ((entry++))
        partition=$(df -Ph | head -n$entry | tail -n1 | awk '{print $6}')
        if [[ $partition_space -ge 70 && $partition_space -le 90 ]]; then
            check_failed
            printf "Free Disk Space Warning - $partition $partition_space%% full.\n" >> $logfile
            disk_space_error=1
        elif [[ $partition_space -gt 90 ]]; then
            check_failed
            printf "Free Disk Space Critical - $partition $partition_space%% full.\n" >> $logfile
            disk_space_error=1
        fi
    done
    
    #Message to display if any errors are detected
    if [[ $disk_space_error -eq 1 ]]; then
        check_failed
        printf "Disk Space,Free Disk Space,WARNING,sk60080\n" >> $csv_log
        printf "Check if any partition listed above can be cleaned up to free up disk space.\n" >> $logfile
        printf "/var/opt/$cp_suite/fw1/log) may be filled with old log files if the firewall has been logging locally.\n" >> $logfile
        printf "/var/log may have old messages files.\n" >> $logfile
        printf "Please see sk60080 for further assistance freeing up disk space.\n\n" >> $logfile
    else
        check_passed
        printf "Disk Space,Free Disk Space,OK,\n" >> $csv_log
    fi
}

#Memory Check
check_memory()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Memory Checks:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    printf "| Memory\t\t| Physical Memory\t\t|" | tee -a $output_log
    printf "\n\nMemory Info:\n" >> $full_output_log
    cat /proc/meminfo  >> $full_output_log

    #Physical memory check
    current_meminfo=$(cat /proc/meminfo)
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
            printf "Physical Memory Warning:\nPhysical memory is $used_mem_percent%% used.\n\n" >> $logfile
        elif [[ $used_mem_percent -ge 85 ]]; then
            printf "Physical Memory Critical:\nPhysical memory is $used_mem_percent%% used.\n\n" >> $logfile
        else
            printf "Physical Memory Error:\nUnable to determine Physical memory usage.\n\n" >> $logfile
        fi
    fi

    #swap check
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
        printf "Swap Memory Critical:\nSwap memory is $used_swap_percent%% used.\n\n" >> $logfile
    else
        check_failed
        printf "Memory,Swap Memory,WARNING,\n" >> $csv_log
        printf "Swap Memory Error:\n\tUnable to determine swap memory usage.\n\n" >> $logfile
    fi

    #fw ctl pstat analysis
    test_output_error=0
    if [[ $sys_type == "GATEWAY" || $sys_type == "STANDALONE" ]]; then
        fwctlpstat=$(fw ctl pstat)

        #hmem check
        printf "|\t\t\t| Hash Kernel Memory (hmem)\t|" | tee -a $output_log
        hash_memory_failed=$(echo "$fwctlpstat" | grep -A5 "hmem" | grep Allocations | awk '{print $4}')
        if [[ $hash_memory_failed -eq 0 ]]; then
            check_passed
            printf "Memory,Hash Kernel Memory (hmem),OK,\n" >> $csv_log
        elif [[ $hash_memory_failed -ge 1 ]]; then
            check_failed
            printf "Memory,Hash Kernel Memory (hmem),WARNING,\n" >> $csv_log
            printf "\nHMEM Warning:\n\tHash memory had $hash_memory_failed failures.\n" | tee -a $logfile
            printf "Presence of hmem failed allocations indicates that the hash kernel memory was full.\nThis is not a serious memory problem but indicates there is a configuration problem.\nThe value assigned to the hash memory pool, (either manually or automatically by changing the number concurrent connections in the capacity optimization section of a firewall) determines the size of the hash kernel memory.\nIf a low hmem limit was configured it leads to improper usage of the OS memory.\n\n" | tee -a $logfile
        else
            check_failed
            printf "Memory,Hash Kernel Memory (hmem),WARNING,\n" >> $csv_log
            printf "\nHMEM Error:\nUnable to determine hmem failures.\n\n" | tee -a $logfile
        fi

        #smem check
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
            printf "Presence of smem failed allocations indicates that the OS memory was exhausted or there are large non-sleep allocations.\n\tThis is symptomatic of a memory shortage.\n\tIf there are failed smem allocations and the memory is less than 2 GB, upgrading to 2GB may fix the problem.\n\tDecreasing the TCP end timeout and decreasing the number of concurrent connections can also help reduce memory consumption.\n\n" | tee -a $logfile
        else
            check_failed
            printf "Memory,System Kernel Memory (smem),WARNING,\n" >> $csv_log
            printf "\nSMEM Error:\nUnable to determine smem failures.\n\n" | tee -a $logfile
        fi

        #kmem check
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
            printf "Presence of kmem failed allocations means that some applications did not get memory.\nThis is usually an indication of a memory problem; most commonly a memory shortage.\nThe natural limit is 2GB, since the Kernel is 32bit.).\n\n" | tee -a $logfile
        else
            check_failed
            printf "Memory,Kernel Memory (kmem),WARNING,\n" >> $csv_log
            printf "\nKMEM Error\nUnable to determine kmem failures.\n\n" | tee -a $logfile
        fi
    fi
}

#CPU Check
check_cpu()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# CPU Checks:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log

    
    #Log usage
    printf "\n\nCPU information:\n" >> $full_output_log
    mpstat_p_all=$(mpstat -P ALL)
    echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' >> $full_output_log
    
    #Detect CPU column names
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
        fi
    done
    
    #idle check
    printf "| CPU\t\t\t| CPU idle%%\t\t\t|" | tee -a $output_log
    all_cpu_idle=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_idle '{print $temp}')
    current_cpu=0
    for cpu_idle in $all_cpu_idle; do
        cpu_idle=$(echo $cpu_idle | awk -F. '{print $1}')
        if [[ $cpu_idle -le 20 ]]; then
            check_failed
            printf "CPU $current_cpu - $cpu_idle%% idle\n" >> $logfile
        fi
        ((current_cpu++))
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "CPU,CPU idle%%,OK,\n" >> $csv_log
    else
        printf "CPU,CPU idle%%,WARNING,\n" >> $csv_log
        printf "CPU idle Warning:\n" >> $logfile
        printf "One or more CPUs is over 80%% utilized.\n\n" >> $logfile
    fi

    #user check
    printf "|\t\t\t| CPU user%%\t\t\t|" | tee -a $output_log
    all_cpu_user=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_user '{print $temp}')
    current_cpu=0
    test_output_error=0
    for cpu_user in $all_cpu_user; do
        cpu_user=$(echo $cpu_user | awk -F. '{print $1}')
        if [[ $cpu_user -ge 20 ]]; then
            check_failed
            printf "CPU $current_cpu - $cpu_user%% user\n" >> $logfile
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
        printf "Use \"ps\" or \"top\" to identify the offending process.\n\n" >> $logfile
    fi
    
    #system check
    printf "|\t\t\t| CPU system%%\t\t\t|" | tee -a $output_log
    all_cpu_system=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_system '{print $temp}')
    current_cpu=0
    test_output_error=0
    for cpu_system in $all_cpu_system; do
        cpu_system=$(echo $cpu_system | awk -F. '{print $1}')
        if [[ $cpu_system -ge 20 ]]; then
            check_failed
            printf "CPU $current_cpu - $cpu_system%% system\n" >> $logfile
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
        printf "disabling SecureXL templating or completely disabling SecureXL acceleration.\n\n" >> $logfile
    fi
    
    #wait check
    printf "|\t\t\t| CPU wait%%\t\t\t|" | tee -a $output_log
    all_cpu_wait=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_wait '{print $temp}')
    current_cpu=0
    test_output_error=0
    for cpu_wait in $all_cpu_wait; do
        cpu_wait=$(echo $cpu_wait | awk -F. '{print $1}')
        if [[ $cpu_wait -ge 20 ]]; then
            check_failed
            printf "CPU $current_cpu - $cpu_wait%% wait\n" >> $logfile
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
        printf "The CPU is not actually busy if this number is spiking, the CPU is blocked from doing any useful work waiting for an IO event.\n\n" >> $logfile
    fi
    
    #interrupt check
    printf "|\t\t\t| CPU interrupt%%\t\t|" | tee -a $output_log
    all_cpu_interrupt=$(echo "$mpstat_p_all" | grep -v $(hostname) | grep -v all | sed '/^$/d' | grep -v CPU | awk -v temp=$mpstat_soft '{print $temp}')
    current_cpu=0
    test_output_error=0
    for cpu_interrupt in $all_cpu_interrupt; do
        cpu_interrupt=$(echo $cpu_interrupt | awk -F. '{print $1}')
        if [[ $cpu_interrupt -ge 20 ]]; then
            check_failed
            printf "CPU $current_cpu - $cpu_interrupt%% interrupt\n" >> $logfile
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
        printf "Use \"netstat -i\" to see if interface errors are the cause.\n\n" >> $logfile
    fi
}


#Interface Errors check
check_interface_stats()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Interface Stats Check:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    
    #Collect interface list for checks
    interface_list=$(ifconfig -a | grep encap | awk '{print $1}' | grep -v lo | grep -v bond | grep -v ":") > /dev/null 2>&1
    
    #log original reading
    printf "\n\n" >> $full_output_log
    netstat -i >> $full_output_log
    
    #Check receive errors
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
        printf "Check the switch settings and fix the speed and duplex settings if there is a mismatch, check cabling and try a spare interface.\n\n" >> $logfile
    fi
        
    
    
    #Check Receive Drops
    printf "|\t\t\t| RX Drops\t\t\t|" | tee -a $output_log
    test_output_error=0
    for current_interface in $interface_list; do
        current_OK=$(netstat --interfaces=$current_interface | grep -v Kernel | grep -v Iface | awk '{print $4}') > /dev/null 2>&1
        current_drops=$(netstat --interfaces=$current_interface | grep -v Kernel | grep -v Iface | awk '{print $6}') > /dev/null 2>&1
        if [[ $current_drops -ge 1 ]]; then
            drop_percent=$(printf "%.2f\n" $(echo -e "scale=2\n((100*$current_drops/$current_OK))"|bc))
        else
            drop_percent=0.0
        fi
        drop_percent_whole=$(echo $drop_percent | awk -F. '{print $1}')
        drop_percent_decimal=$(echo $drop_percent | awk -F. '{print $2}')
        if [[ $drop_percent_whole -ge 1 ]]; then
            check_failed
            printf "RX Drops WARNING - $current_interface has $current_drops RX drops which accounts for $drop_percent%% of traffic on this interface.\n" >> $logfile
        elif [[ $drop_percent_whole -eq 0 && $drop_percent_decimal -ge 50 ]]; then
            check_failed
            printf "RX Drops WARNING - $current_interface has $current_drops RX drops which accounts for $drop_percent%% of traffic on this interface.\n" >> $logfile
        elif [[ $current_drops -gt 0 ]]; then
            printf "RX Drops INFO - $current_interface has $current_drops RX drops which accounts for $drop_percent%% of traffic on this interface.\n" >> $logfile
        fi
    done
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,RX Drops,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Drops,WARNING,\n" >> $csv_log
        printf "\nReceive Drop Information:\nThese imply the appliance is dropping packets at the network.\n" >> $logfile
        printf "Attention is required for the interfaces listed above if the drops account for more than 0.50%% as this is a sign that the firewall does not have enough FIFO memory buffer (descriptors) to hold the packets while waiting for a free interrupt to process them.\n\n" >> $logfile
    fi

    #Check Transmit errors
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
        printf "Check the switch settings and fix the speed and duplex settings if there is a mismatch, check cabling and try a spare interface.\n\n" >> $logfile
    fi
    
    #Check Transmit Drops
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
        printf "Increasing the bandwidth through link aggregation or introducing flow control may be a possible solution to this problem.\n\n" >> $logfile
    fi
	
	#Check for rx_missed_errors 
	printf "|\t\t\t| RX Missed Errors\t\t|" | tee -a $output_log
	test_output_error=0
	for current_interface in $interface_list; do
		current_rx_missed_errors=$(ethtool -S $current_interface | grep rx_missed_errors | awk '{print $2}') > /dev/null 2>&1
		if [[ $current_rx_missed_errors -ne 0 ]]; then
            current_rx_packets=$(ethtool -S $current_interface | grep rx_packets | awk '{print $2}') > /dev/null 2>&1
            if [[ $current_rx_missed_errors -ge 1 ]];then
                missed_percent=$(printf "%.2f\n" $(echo -e "scale=2\n((100*$current_rx_missed_errors/$current_rx_packets))"|bc))
            else
                missed_percent=0.0
            fi
            missed_percent_whole=$(echo $missed_percent | awk -F. '{print $1}')
            missed_percent_decimal=$(echo $missed_percent | awk -F. '{print $2}')
            if [[ $missed_percent_whole -ge 1 ]]; then
                check_failed
                printf "RX Missed - $current_interface has $current_rx_missed_errors rx_missed_errors which accounts for $missed_percent%% of traffic on this interface.\n" >> $logfile
            elif [[ $missed_percent_whole -eq 0 && $missed_percent_decimal -ge 50 ]]; then
                check_failed
                printf "RX Missed - $current_interface has $current_rx_missed_errors rx_missed_errors which accounts for $missed_percent%% of traffic on this interface.\n" >> $logfile
            elif [[ $current_rx_missed_errors -ge 1 ]]; then
                printf "RX Missed - $current_interface has $current_rx_missed_errors rx_missed_errors which accounts for $missed_percent%% of traffic on this interface.\n" >> $logfile
            fi
        fi
	done
	if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Interface Stats,RX Missed Errors,OK,\n" >> $csv_log
    fi
    
    #Display the following message if any warnings are detected
    if [[ $test_output_error -ne 0 ]]; then
        printf "Interface Stats,RX Missed Errors,WARNING,\n" >> $csv_log
        printf "\nReceive Missed Information:\nA ratio of rx_mised_errors to rx_packets greater than 0.5%% indicates the number of received packets that have been missed due to lack of capacity in the receive side which means the NIC has no resources and is actively dropping packets.\n" >> $logfile
        printf "Confirm that flow control on the switch is enabled. When flow control on the switch is disabled, we are bound to have issues for rx_missed_errors. If it is enabled, please contact Check Point Software Technologies, we need to know what the TX/RX queues are set to and we'll proceed from there.\n\n" >> $logfile
    fi
	
	#Check for tx_carrier_errors 
	printf "|\t\t\t| TX Carrier Errors\t\t|" | tee -a $output_log
	test_output_error=0
	for current_interface in $interface_list; do
		current_tx_carrier_errors=$(ethtool -S $current_interface | grep tx_carrier_errors | awk '{print $2}') > /dev/null 2>&1
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
        printf "If link is up, run Hardware Diagnostic Tool as described in sk97251. Please run network test while using loopback adaptor as explained in sk97251.\n" >> $logfile
        printf "Also provide to Check Point Support an output of the command:#cat /sys/class/net/Internal/carrier. \n\n" >> $logfile
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
		interface_driver_info=$(ethtool -i $current_interface | grep -e driver -e version | grep -v firmware)
		printf "$current_interface:\n\n" >> $full_output_log 2>&1
		echo "$interface_driver_info" >> $full_output_log 2>&1
	done
	
	#Check for Ring Buffer Size 
	printf "\n\nInterface Ring Buffer:\n" >> $full_output_log 2>&1
	for current_interface in $interface_list; do
		interface_ring_buffer=$(ethtool -g $current_interface)
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
}

#Misc. Message checks
check_misc_messages()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Misc. Messages Checks:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    
    #Combine /var/log/messages and /var/log/dmesg then start log.
    cat /var/log/messages* /var/log/dmesg >> $messages_tmp_file
    printf "| Misc. Messages\t| Known issues in logs\t\t|" | tee -a $output_log
    
    #Check Neighbor table overflow
    if [[ $(grep "Neighbor table overflow" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Neighbor table overflow,WARNING,sk43772\n" >> $csv_log
        printf "\"Neighbor table overflow\" message detected:\n" >> $logfile
        printf "See sk43772 to resolve.\n\n" >> $logfile
    fi
    
    #Check synchronization risk
    if [[ $(grep "State synchronization is in risk" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,State synchronization is in risk,WARNING,sk23695\n" >> $csv_log
        printf "\"State synchronization is in risk\" message detected:\n" >> $logfile
        printf "See sk23695 to resolve.\n\n" >> $logfile
    fi
    
    #Check SecureXL Templates
    if [[ $(grep "Connection templates are not possible for the installed policy" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,SecureXL templates are not possible for the installed policy,WARNING,sk31630\n" >> $csv_log
        printf "\"SecureXL templates are not possible for the installed policy\" message detected:\n" >> $logfile
        printf "See sk31630 to resolve.\n\n" >> $logfile
    fi
    
    #Check Out of Memory
    if [[ $(grep "Out of Memory: Killed" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Out of Memory: Killed process,WARNING,\n" >> $csv_log
        printf "\"Out of Memory: Killed process\" message detected:\n" >> $logfile
        printf "This message means there is no more memory available in the user space.\n" >> $logfile
        printf "As a result, Gaia or SecurePlatform starts to kill processes.\n\n" >> $logfile
    fi
    
    #Check Additional Sync problem
    if [[ $(grep "fwlddist_adjust_buf: record too big for sync" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Record too big for Sync,WARNING,sk35466\n" >> $csv_log
        printf "\"Record too big for Sync\" message detected:" >> $logfile
        printf "This message may indicate problems with the sync network.\n" >> $logfile
        printf "It can cause traffic loss, unsynchronized kernel tables, and connectivity problems." >> $logfile
        printf "For more information, refer to sk35466.\n\n" >> $logfile
    fi
    
    #Check Dead loop on virtual device 
    if [[ $(grep "Dead loop on virtual device" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,Dead Loop on virtual device,WARNING,sk32765\n" >> $csv_log
        printf "\"Dead Loop on virtual device\" message detected:\n" >> $logfile
        printf "This message is a SecureXL notification on the outbound connection that may cause the gateway to lose sync traffic.\n" >> $logfile
        printf "For more information, refer to sk32765.\n\n" >> $logfile
    fi
    
    #Check Stack Overflow 
    if [[ $(grep "fw_runfilter_ex" $messages_tmp_file | grep "stack overflow") ]]; then
        check_failed
        printf "Misc. Messages,Stack Overflow,WARNING,sk99329\n" >> $csv_log
        printf "\"Stack Overflow\" message detected:\n" >> $logfile
        printf "It is possible that the number of security rules has exceeded a limit or some file became corrupted.\n" >> $logfile
        printf "For more information, refer to sk99329.\n\n" >> $logfile
    fi
    
    #Check Log buffer full 
    if [[ $(grep "FW-1: Log Buffer is full" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,FW-1: Log Buffer is full,WARNING,sk52100\n" >> $csv_log
        printf "\"FW-1: Log Buffer is full\" message detected:\n" >> $logfile
        printf "The kernel module maintains a cyclic buffer of waiting log messages.\n" >> $logfile
        printf "This log buffer queue was overflown (i.e., new logs are added before all the previous ones are being read - causing messages to be overwritten) resulting in the above messages.\n" >> $logfile
        printf "The most probable causes can be: high CPU utilization, high levels of logging, increased traffic, or change in logging.\n" >> $logfile
        printf "For more information, refer to sk52100.\n\n" >> $logfile
    fi
    
    #Check Log buffer tsid 0 full 
    if [[ $(grep "FW-1: Log buffer for tsid 0 is full" $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,FW-1: Log buffer for tsid 0 is full,WARNING,sk114616\n" >> $csv_log
        printf "\"FW-1: Log buffer for tsid 0 is full\" message detected:\n" >> $logfile
        printf "Log buffer used by the FWD daemon gets full.\n" >> $logfile
        printf "As a result, FireWall log messages are not processed in time.\n" >> $logfile
        printf "For more information, refer to sk114616.\n\n" >> $logfile
    fi
    
    #Check Max entries in state on conn
    if [[ $(grep "number of entries in state on conn" $messages_tmp_file | grep "has reached maximum allowed") ]]; then
        check_failed
        printf "Misc. Messages,Number of entries in state on conn has reached maximum allowed,WARNING,sk52101\n" >> $csv_log
        printf "\"number of entries in state on conn has reached maximum allowed\" message detected:\n" >> $logfile
        printf "The \"sd_conn_state_max_entries\" kernel parameter is used by IPS.\n" >> $logfile
        printf "All connections/packets are held in this kernel table, so IPS protections can be run against them.\n" >> $logfile
        printf "If too many connections/packets are held, then the buffer will be overrun.\n" >> $logfile
        printf "For more information, refer to sk52101.\n\n" >> $logfile
    fi
    
    #Check Connections table 80% full
    if [[ $(grep 'The connections table is 80% full' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,The connections table is 80% full,WARNING,sk35627\n" >> $csv_log
        printf "\"The connections table is 80% full\" message detected:\n" >> $logfile
        printf "Traffic might be dropped by Security Gateway.\n" >> $logfile
        printf "For more information, refer to sk35627.\n\n" >> $logfile
    fi
    
    #Check Different versions
    if [[ $(grep 'fwsync: there is a different installation of Check Point' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,there is a different installation of Check Point products on each member of this cluster,WARNING,sk41023\n" >> $csv_log
        printf "\"fwsync: there is a different installation of Check Point products on each member of this cluster\" message detected:\n" >> $logfile
        printf "This issue can be seen if some Check Point packages were manually deleted or disabled on one of cluster members, bit not on others.\n" >> $logfile
        printf "For more information, refer to sk41023.\n\n" >> $logfile
    fi
    
    #Check too many internal hosts
    if [[ $(grep 'too many internal hosts' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,too many internal hosts,WARNING,sk10200\n" >> $csv_log
        printf "\"too many internal hosts\" message detected:\n" >> $logfile
        printf "Traffic may pass through Security Gateway very slowly.\n" >> $logfile
        printf "For more information, refer to sk10200.\n\n" >> $logfile
    fi
    
    #Check Interface configured in Management
    if [[ $(grep 'kernel: FW-1: No interface configured in SmartCenter server with name' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,No interface configured in SmartCenter server,WARNING,sk36849\n" >> $csv_log
        printf "\"kernel: FW-1: No interface configured in SmartCenter server with name\" message detected:\n" >> $logfile
        printf "In the SmartDashboard there were no interface(s) with such name(s) - as appear on the Security Gateway machine.\n" >> $logfile
        printf "Therefore, by design, the Firewall tries to match the interface in question by IP address.\n" >> $logfile
        printf "For more information, refer to sk36849.\n\n" >> $logfile
    fi
    
    #Check alternate Sync in risk
    if [[ $(grep 'sync in risk: did not receive ack for the last' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,sync in risk: did not receive ack,WARNING,sk82080\n" >> $csv_log
        printf "\"sync in risk: did not receive ack for the last x packets\" message detected:\n" >> $logfile
        printf "Amount of outgoing Delta Sync packets is too high for the current Sending Queue size.\n" >> $logfile
        printf "For more information, refer to sk82080.\n\n" >> $logfile
    fi
    
    #Check OSPF messages
    if [[ $(grep 'cpcl_should_send' $messages_tmp_file | grep 'returns -3') ]]; then
        check_failed
        printf "Misc. Messages,cpcl_should_send returns -3,WARNING,sk106129\n" >> $csv_log
        printf "\"cpcl_should_send returns -3\" message detected:\n" >> $logfile
        printf "OSPF routes may not be synced between the Active member and the other cluster members.\n" >> $logfile
        printf "For more information, refer to sk106129.\n\n" >> $logfile
    fi
    
    #Check cphwd_pslglue_can_offload_template
    if [[ $(grep 'cphwd_pslglue_can_offload_template: error, psl_opaque is NULL' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,cphwd_pslglue_can_offload_template: error,WARNING,sk107258\n" >> $csv_log
        printf "\"cphwd_pslglue_can_offload_template: error, psl_opaque is NULL\" message detected:\n" >> $logfile
        printf "This issue can be resolved by either disabling SecureXL or installing the latest jumbo.\n" >> $logfile
        printf "For more information, refer to sk107258.\n\n" >> $logfile
    fi
    
    #Check RIP message
    if [[ $(grep 'cpcl_should_send' $messages_tmp_file | grep 'returns -1') ]]; then
        check_failed
        printf "Misc. Messages,cpcl_should_send returns -1,WARNING,sk106128\n" >> $csv_log
        printf "\"cpcl_should_send returns -1\" message detected:\n" >> $logfile
        printf "When RIP is configured, RouteD does not check correctly if RIP sync state should be sent to other cluster members.\n" >> $logfile
        printf "For more information, refer to sk106128.\n\n" >> $logfile
    fi
    
    #Check Enter/Leave cpcl_vfr_recv_from_instance_manager
    if [[ $(grep -e 'entering cpcl_vrf_recv_from_instance_manager' -e'leaving cpcl_vrf_recv_from_instance_manager' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,entering/leaving cpcl_vrf_recv_from_instance_manager,WARNING,sk108233\n" >> $csv_log
        printf "\"entering/leaving cpcl_vrf_recv_from_instance_manager\" message detected:\n" >> $logfile
        printf "Cluster state may be changing repeatedly.\n" >> $logfile
        printf "For more information, refer to sk108233.\n\n" >> $logfile
    fi
    
    #Check duplicate address detected
    if [[ $(grep 'if_get_address: duplicate address detected:' $messages_tmp_file) ]]; then
        check_failed
        printf "Misc. Messages,if_get_address: duplicate address detected,WARNING,sk94466\n" >> $csv_log
        printf "\"if_get_address: duplicate address detected\" message detected:\n" >> $logfile
        printf "Assigning a cluster IP address in the range of the VSX internal communication network causes an IP address conflict and causes RouteD daemon to crash.\n" >> $logfile
        printf "For more information, refer to sk94466.\n\n" >> $logfile
    fi
    
    #Check vmalloc
    if [[ $(grep 'Failed to allocate' $messages_tmp_file | grep 'bytes from vmalloc') ]]; then
        check_failed
        printf "Misc. Messages,Failed to allocate bytes from vmalloc,WARNING,sk90043\n" >> $csv_log
        printf "\"Failed to allocate bytes from vmalloc\" message detected:\n" >> $logfile
        printf "Linux \"vmalloc\" reserved memory area is exhausted.\," >> $logfile
        printf "Critical allocations, which are needed for a Virtual System, can not be allocated.\n" >> $logfile
        printf "For more information, refer to sk90043.\n\n" >> $logfile
    fi
    
    if [[ $test_output_error -eq 0 ]]; then
        check_passed
        printf "Misc. Messages,Known issues in logs,OK,\n" >> $csv_log
    fi
        
    #Clean up temp message file
    rm $messages_tmp_file
}

#Application processes checks
check_application_processes()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Processes Checks:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    
    #Collect application process information
    app_all_procs=$(ps aux)
    
    printf "\n\n\nTop Processes:\n" >> $full_output_log
    top -b -n1 >> $full_output_log
    
    #Determine number of zombie processes
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
    
    #Determine number of processes restarts
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
        printf "Make sure the Check Point Processes are started and try again.\n\n" >> $logfile
    else
        check_passed
        printf "Processes,Process Restarts,OK,\n" >> $csv_log
    fi
}

check_core_files()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Core File Checks:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    
    #Find usermode cores:
    cores_found=0
    user_cores_found=false
    kernel_cores_found=false
    usermode_core_list=$(ls -lah /var/log/dump/usermode/ | grep -v total | grep -v drwx)
    kernel_core_list=$(ls -lah /var/log/crash/ | grep -v total | grep -v drwx)
    
    #Log Usermode results
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
    
    #Log kernel results
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
}

#MAC Magic Configuration
check_magic_mac()
{
    printf "\n\nMAC Magic:\n" >> $full_output_log
    magic_mac=$(fw ctl get int fwha_mac_magic)
    mac_forward_magic=$(fw ctl get int fwha_mac_forward_magic)
    printf "$magic_mac\n" >> $full_output_log
    printf "$mac_forward_magic\n" >> $full_output_log
}

#Debugs enabled Check
check_enabled_debugs()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Debug Checks:"
    
    #Check for enabled debug processes
    printf "| Debugs\t\t| Active Debug Processes\t|" | tee -a $output_log
    
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
    
    #Check for enabled debug flags
    test_output_error=0
    debug_flag_check=0
    printf "|\t\t\t| Debug Flags Present\t\t|" | tee -a $output_log
    
    #Collect list of modules:
    script -c "fw ctl debug -m" /var/tmp/debug_flag_modules.tmp > /dev/null 2>&1
    debug_flag_module_list=$(grep Module /var/tmp/debug_flag_modules.tmp | awk -F: '{print $2}' | awk '{print $1}')
    
    #Dump current module settings:
    script -c "fw ctl debug" /var/tmp/debug_flag_current.tmp >> /dev/null 2>&1
    
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
        printf "If these modules no longer need debug flags set:\nPlease run \"fw ctl debug 0\" to clear the debug flags.\n\n" >> $logfile
    else
        check_passed
        printf "Debugs,Debug Flags Present,OK,\n" >> $csv_log
    fi
    
    #Clean up temp files
    rm /var/tmp/debug_flag_current.tmp
    rm /var/tmp/debug_flag_modules.tmp
    
    #Check to see if TDERROR is set
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
}

#Fragments check
check_fragmentation()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Fragments Checks:"
    
    #Collect expired and failure numbers from "fw ctl pstat"
    all_fragments=$(fw ctl pstat | grep -A2 Fragments | grep -v Fragments)
    current_expired=$(echo $all_fragments | awk '{print $5}')
    current_failures=$(echo $all_fragments | awk '{print $13}')
    printf "| Fragments\t\t| Fragments\t\t\t|" | tee -a $output_log
    
    #Display warning messages if failures or expired packets are detected
    if [[ $current_failures -ne 0 || $current_expired -ne 0 ]]; then
        check_failed
        printf "Fragments,Fragments,WARNING,\n" >> $csv_log
        if [[ $current_failures -ne 0 ]]; then
            printf "Failures – denotes the number of fragmented packets that were received that could not be successfully re-assembled.\n\n" >> $logfile
        fi
        if [[ $current_expired -ne 0 ]];then
            printf "Expired – denotes how many fragments were expired when the firewall failed to reassemble them in a 20 seconds time frame or when due to memory exhaustion, they could not be kept in memory anymore.\n\n" >> $logfile
        fi
        
    #Display OK if everything is good
    else
        check_passed
        printf "Fragments,Fragments,OK,\n" >> $csv_log
    fi
}

#Capacity Optimization checks
check_connections_stats()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Capacity Checks:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    
    #Collect connections information
    connections_limit=$(fw tab -t connections | grep limit | grep -v Kernel | grep -v connections | grep -oP '(?<=limit ).*')
    connections_peak=$(fw tab -t connections -s | grep -v Kernel | grep -v PEAK | awk '{print $5}')
    connections_current=$(fw tab -t connections -s | grep -v Kernel | grep -v PEAK | awk '{print $4}')
    
    #Check Peak connections
    printf "| Connections Table\t| Peak Connections\t\t|" | tee -a $output_log
    if [[ $(fw tab -t connections | grep limit) == *"unlimited"* ]]; then
        check_passed
        printf "Connections Table,Peak Connections,OK,\n" >> $csv_log
        connections_limit="unlimited"
    else

        #Calculate connections percent
        if [[ $connections_limit -ge 1 ]]; then
            peak_percent=$((100*$connections_peak/$connections_limit))
        else
            peak_percent=255
        fi
        
        #Display warning messages if peak is reached
        if [[  $peak_percent -eq 255 ]]; then
            check_failed
            printf "Connections Table,Peak Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections limit.\n\n" >> $logfile
        elif [[ $peak_percent -ge 80 ]]; then
            check_failed
            printf "Connections Table,Peak Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - The Peak connections is $peak_percent%% of total capacity.\n" >> $logfile
            printf "Once the connections table is full, new connections will be dropped.\n" >> $logfile
            printf "Please consider increasing the connections table limit.\n\n" >> $logfile
        elif  [[ $peak_percent -lt 80 ]]; then
            check_passed
            printf "Connections Table,Peak Connections,OK,\n" >> $csv_log
        fi
    fi
    
    #Check Current Connections
    printf "|\t\t\t| Current Connections\t\t|" | tee -a $output_log    
    if [[ $(fw tab -t connections | grep limit) == *"unlimited"* ]]; then
        check_passed
        printf "Connections Table,Concurrent Connections,OK,\n" >> $csv_log
        connections_limit="unlimited"
    else

        #Calculate connections percent
        if [[ $connections_limit -ge 1 ]]; then
            connections_percent=$((100*$connections_current/$connections_limit))
        else
            connections_percent=255
        fi
        
        #Display warning messages if peak is reached
        if [[  $connections_percent -eq 255 ]]; then
            check_failed
            printf "Connections Table,Concurrent Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - Unable to detect connections limit.\n\n" >> $logfile
        elif [[ $connections_percent -ge 80 ]]; then
            check_failed
            printf "Connections Table,Concurrent Connections,WARNING,\n" >> $csv_log
            printf "Connections Table Warning - The current connections table is $connections_percent%% full.\n" >> $logfile
            printf "Once the connections table is full, new connections will be dropped.\n" >> $logfile
            printf "Please consider increasing the connections table limit.\n\n" >> $logfile
        elif  [[ $connections_percent -lt 80 ]]; then
            check_passed
            printf "Connections Table,Concurrent Connections,OK,\n" >> $csv_log
        fi
    fi
    
    #Log current connections values
    printf "\n\nConnections information:\n" >> $full_output_log
    printf "Limit: $connections_limit\n" >> $full_output_log
    printf "Peak: $connections_peak\n" >> $full_output_log
    
    
    #Collect NAT Values and Peak
    test_output_error=0
    printf "|\t\t\t| NAT Connections\t\t|" | tee -a $output_log
    script -c "fw tab -t fwx_cache -s | grep -v HOST" /var/tmp/nat_con.tmp >> /dev/null
    nat_connections=$(cat /var/tmp/nat_con.tmp | grep -v "Script ")
    rm /var/tmp/nat_con.tmp
    if [[ $nat_connections == *"not a FireWall-1 module"* || $nat_connections == *"Failed to get table status"* ]]; then
        check_failed
        printf "Connections Table,NAT Connections,WARNING,\n" >> $csv_log
        printf "NAT Connections - Unable to get information from fwx_cache table.\n\n" >> $logfile
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
            printf "For further information see: sk21834: How to modify the values of the properties related to the NAT cache table \n\n" >> $logfile
        else
            check_passed
            printf "Connections Table,NAT Connections,OK,\n" >> $csv_log
        fi
        
        #Log NAT values
        printf "\n\nNAT VALS: $connections_VALS\n" >> $full_output_log
        printf "NAT PEAK: $connections_PEAK\n" >> $full_output_log
    fi
}

#ClusterXL and State Synchronization
check_cluster_statistics()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Cluster Checks:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        
    ###### Collect Cluster status information #####
    ###############################################
    cphaprob_stat=$(cphaprob stat)
    
    #If the cluster is HA, find the number of active members
    if [[ "$cphaprob_stat" == *"High Availability"* ]]; then
        active_active_check=$(echo "$cphaprob_stat" | grep ^[0-9] | grep Active | wc -l)
    else
        active_active_check=0
    fi
    
    #Find the overall number of cluster members
    single_member_check=$(echo "$cphaprob_stat" | grep ^[0-9] | wc -l)
    
    #Find the local cluster status
    cluster_status=$(echo "$cphaprob_stat" | head -n10 | grep local)
    if [[ $active_active_check -gt 1 ]]; then
        cluster_status="Active-Active"
    elif [[ "$cphaprob_stat" == *"HA module not started."* ]]; then
        cluster_status="HA Module Not Started"
    else
        if [[ $cluster_status == *"Down"* ]]; then
            cluster_status="Down"
        elif [[ $cluster_status == *"Ready"* ]]; then
            cluster_status="Ready"
        elif [[ $cluster_status == *"Initializing"* ]]; then
            cluster_status="Initializing"
        elif [[ $cluster_status == *"Active Attention"* ]]; then
            cluster_status="Active Attention"
        elif [[ $cluster_status == *"Standby"* ]]; then
            cluster_status="Standby"
        elif [[ $cluster_status == *"Active"* ]]; then
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
    
    #Cluster Status messages
    printf "| Cluster\t\t| Cluster Status\t\t|" | tee -a $output_log
    
    #Other member problems
    if [[ $other_member_status == "Down" || $other_member_status == "Ready" || $other_member_status == "Initializing" || $other_member_status == "Active Attention" ]]; then
        check_failed
        printf "Cluster,Cluster Status,WARNING,\n" >> $csv_log
        printf "Cluster peer is: $other_member_status.\n" >> $logfile
    
    #Single member problem
    elif [[ $single_member_check -eq 1 ]]; then
        check_failed
        printf "Cluster,Cluster Status,WARNING,\n" >> $csv_log
        printf "\nUnable to find remote partner.\n" >> $logfile
        printf "This is usually due to one of the following reasons:\n" >> $logfile
        printf " -There is no network connectivity between the members of the cluster on the sync network.\n" >> $logfile
        printf " -The partner does not have state synchronization enabled.\n" >> $logfile
        printf " -One partner is using broadcast mode while the other is using multicast mode.\n" >> $logfile
        printf " -One of the monitored processes has an issue, such as no policy loaded.\n" >> $logfile
        printf " -The partner firewall is down.\n\n" >> $logfile
    
    #Current member success
    elif [[ $cluster_status == "Active" || $cluster_status == "Standby" ]]; then
        check_passed
        printf "Cluster,Cluster Status,OK,\n" >> $csv_log
    
    #Current member problem
    else
        check_failed
        printf "Cluster,Cluster Status,WARNING,\n" >> $csv_log
        printf "Cluster status is: $cluster_status.\n" >> $logfile
        if [[ "$cphaprob_stat" == *"HA module not started."* ]]; then
            printf "If this is a single gateway this warning can be safely ignored.\n\n" >> $logfile
        fi
    fi
    
    #Checks only performed if cluster is active
    test_output_error=0
    if [[ "$cphaprob_stat" != *"HA module not started."* ]]; then
        #ClusterXL interfaces statistics
        cluster_a_if=$(cphaprob -a if | sed "/^$/d")
        printf "\n\nCluster Interfaces: $cluster_a_if" >> $full_output_log

        #Collect pnotes information
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
            printf "Cluster,Problem Notifications,OK,\n" >> $csv_log
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

        #Check Sync status
        test_output_error=0
        printf "|\t\t\t| Sync Status\t\t\t|" | tee -a $output_log
        cluster_sync=$(fw ctl pstat | sed '1,/Sync:/d')
        printf "\n\nCluster Sync:\n$cluster_sync\n" >> $full_output_log
        
        if [[ $cluster_sync == *"off"* ]]; then
            check_failed
            printf "Cluster,Sync Status,WARNING,sk34476 and sk37029 and sk37030\n" >> $csv_log
            printf "Sync is Off!\n" >> $logfile
            printf "For more information on Sync, use sk34476: Explanation of Sync section in the output of fw ctl pstat command.\n" >> $logfile
            printf "To troubleshoot Sync issues use, sk37029- Full Synchronization issues on cluster member and sk37030 - Debugging Full Synchronization in ClusterXL.\n\n" >> $logfile
        else
            check_passed
            printf "Cluster,Sync Status,OK,\n" >> $csv_log
        fi
        
        #Check number of Sync interfaces
        test_output_error=0
        if [[ $sys_type == "VSX" ]]; then
            printf "|\t\t\t| Number of Sync Interfaces\t|" | tee -a $output_log
            sync_interface_number=$(cphaprob -a if | grep -A90 "vsid $vs" | sed '2d' | sed -n "/vsid $vs/,/------/p" | grep secured | grep -v non | grep -v Required | wc -l)
            sync_interface_list=$(cphaprob -a if | grep -A90 "vsid $vs" | sed '2d' | sed -n "/vsid $vs/,/------/p" | grep secured | grep -v non | grep -v Required | awk '{print $1}')
            printf "\n\nSync Interfaces:\n$sync_interface_list\n" >> $full_output_log
            
            if [[ $sync_interface_number -gt 1 ]]; then
                check_failed
                printf "Cluster,Number of Sync Interfaces,WARNING,sk92804\n" >> $csv_log
                printf "Multiple Sync Interfaces Detected:\n" >> $logfile
                printf "For more information on redundant sync configurations, use sk92804: Sync Redundancy in ClusterXL.\n\n" >> $logfile
            else
                check_passed
                printf "Cluster,Number of Sync Interfaces,OK,\n" >> $csv_log
            fi
        else
            printf "|\t\t\t| Number of Sync Interfaces\t|" | tee -a $output_log
            sync_interface_number=$(cphaprob -a if | grep secured | grep -v non | grep -v Required | wc -l)
            sync_interface_list=$(cphaprob -a if | grep secured | grep -v non | grep -v Required | awk '{print $1}')
            printf "\n\nSync Interfaces:\n$sync_interface_list\n" >> $full_output_log
            
            if [[ $sync_interface_number -gt 1 ]]; then
                check_failed
                printf "Cluster,Number of Sync Interfaces,WARNING,sk92804\n" >> $csv_log
                printf "Multiple Sync Interfaces Detected:\n" >> $logfile
                printf "For more information on redundant sync configurations, use sk92804: Sync Redundancy in ClusterXL.\n\n" >> $logfile
            else
                check_passed
                printf "Cluster,Number of Sync Interfaces,OK,\n" >> $csv_log
            fi
        fi
    fi
}

#SecureXL Performance
check_securexl_stats()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# SecureXL Checks:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    
    #Check SecureXl Status
    accelerator_status=$(fwaccel stat | grep "Accelerator Status" | grep -Eo 'on|off')
	sim_affinity_stat=$(sim affinity -l)
    printf "| SecureXL\t\t| SecureXL Status\t\t|" | tee -a $output_log
    
    if [[ $accelerator_status == "off" ]]; then
        check_failed
        printf "SecureXL,SecureXL Status,WARNING,sk98722\n" >> $csv_log
        printf "SecureXL Notice:\nAccelerator is off. Please confirm if it is required to be left off by your organization.\n" >> $logfile
        printf "If Accelerator was not manually turned off for debugging purposes, use sk98722-ATRG:SecureXL.\n\n" >> $logfile
        printf "\nSecureXL Information:\nAccelerator Status: Off\n\n" >> $full_output_log
    elif [[ $accelerator_status == "on" ]]; then
        check_passed
        printf "SecureXL,SecureXL Status,OK,\n" >> $csv_log
        printf "\nSecureXL Information:\n" >> $full_output_log
        fwaccel stat >> $full_output_log
        
        #Check Accept Templates
        test_output_error=0
        printf "|\t\t\t| Accept Templates\t\t|" | tee -a $output_log
        accept_templated_status=$(fwaccel stat | grep "Accept Templates" | grep -Eo 'disabled|enabled')
        if [[ $accept_templated_status == "enabled" ]]; then
            check_passed
            printf "SecureXL,Accept Templates,OK,\n" >> $csv_log
        elif [[ $accept_templated_status == "disabled" ]]; then
            check_failed
            
            #Check to see if accept templates were disabled by a specific rule
            accept_templated_disabled=$(fwaccel stat | grep -A1 "Accept Templates" | tail -n1 | awk '{print $1, $2, $3, $4}')
            if [[ $(echo $accept_templated_disabled | grep "disabled from rule") ]]; then
                printf "SecureXL,Accept Templates,WARNING,sk32578\n" >> $csv_log
                printf "SecureXL Notice:\nAccept Templates are $accept_templated_disabled.\nPlease review sk32578 to see what is causing these to be disabled.\n\n" >> $logfile
            else
                printf "SecureXL,Accept Templates,WARNING,sk98722\n" >> $csv_log
                printf "SecureXL Notice:\nAccept Templates are disabled.\n\n" >> $logfile
            fi
        else
            check_failed
            printf "SecureXL,Accept Templates,WARNING,sk98722\n" >> $csv_log
            printf "SecureXL Notice:\nUnable to determine if Accept Templates are enabled or disabled.\n\n" >> $logfile
        fi
        
        #Check Drop Templates
        test_output_error=0
        printf "|\t\t\t| Drop Templates\t\t|" | tee -a $output_log
        drop_templated_status=$(fwaccel stat | grep "Drop Templates" | grep -Eo 'disabled|enabled')
        if [[ $drop_templated_status == "enabled" ]]; then
            check_passed
            printf "SecureXL,Drop Templates,OK,\n" >> $csv_log
        elif [[ $drop_templated_status == "disabled" ]]; then
            check_info
            printf "SecureXL,Drop Templates,INFO,sk67861\n" >> $csv_log
            printf "SecureXL Notice:\nDrop Templates are disabled.\nAccelerated Drop Rules feature protects the Security Gateway and site from Denial of Service attacks by dropping packets at the acceleration layer.\nPlease review sk67861 for more information.\n\n" >> $logfile
        else
            check_failed
            printf "SecureXL,Drop Templates,WARNING,sk98722\n" >> $csv_log
            printf "SecureXL Notice:\nUnable to determine if Drop Templates are enabled or disabled.\n\n" >> $logfile
        fi
    else
        check_failed
        printf "SecureXL,SecureXL Status,WARNING,sk98722\n" >> $csv_log
        printf "SecureXL Information:\nUnable to determine accelerator status.\n\tPlease run \"fwaccel stat\" for further details.\n\n" >> $logfile
        printf "\nAccelerator Status: Unable to determine status.  Use sk98722-ATRG:SecureXL\n\n" >> $full_output_log
    fi
    
    #Collect performance information of fwaccel
    accelerator_table_status=$(fwaccel stats)
    printf "\n\nAcceleration Statistics:\n$accelerator_table_status\n" >> $full_output_log
    
    #Collect Aggressive Aging information
    test_output_error=0
    printf "|\t\t\t| Aggressive Aging\t\t|" | tee -a $output_log
    agg_aging=$(fw ctl pstat | grep Aggressive)
    printf "\nAggressive Aging:\n$agg_aging\n" >> $full_output_log
    
    if [[ $agg_aging == *"not active"* ]]; then
        check_passed
        printf "SecureXL,Aggressive Aging,OK,\n" >> $csv_log
    elif [[ $agg_aging == *"disabled"* ]]; then
        check_failed
        printf "SecureXL,Aggressive Aging,WARNING,\n" >> $csv_log
        printf "Aggressive Aging Warning:\nAggressive Aging has been set to Inactive in SmartDefence or IPS.\n\n" >> $logfile
    elif [[ $agg_aging == *"detect"* ]]; then
        check_failed
        printf "SecureXL,Aggressive Aging,WARNING,\n" >> $csv_log
        printf "Aggressive Aging Info:\nAggressive Aging is in Detect Mode.\n\n" >> $logfile
    fi
}

#CoreXL Check
check_coreXL_stats()
{
	#Check if CoreXL is enabled
	summary_error=0
    test_output_error=0
    current_check_message="# CoreXL Check:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
	
	#Check CoreXl Status
	script -c "fw ctl multik stat" /var/tmp/core_xl_stat > /dev/null
    core_stat=$(cat /var/tmp/core_xl_stat | grep -v Script)
	
	#Collect Affinity Status
	core_affinity_stat=$(fw ctl affinity -l -r -v -a)
    cpu_interrupts=$(cat /proc/interrupts | grep -E "CPU|eth")
	
	rm /var/tmp/core_xl_stat
	printf "\n\nCoreXL Status:\n" >> $full_output_log
	echo "$core_stat" >> $full_output_log
	printf "\n\nCoreXL Affinity Status:\n" >> $full_output_log
	echo "$core_affinity_stat" >> $full_output_log
	printf "\n\nCPU Interrupts Status:\n\n" >> $full_output_log
	echo "$cpu_interrupts" >> $full_output_log
    printf "| CoreXL\t\t| CoreXL Status\t\t\t|" | tee -a $output_log
	
	
	if [[ $(echo $core_stat | grep disabled) ]]; then
		check_failed
        printf "CoreXL,CoreXL Status,WARNING,\n" >> $csv_log
		printf "CoreXL Notice: CoreXL is disabled.  Please confirm if it is required to be left off by your organization.\n" >> $logfile
	else
		check_passed
        printf "CoreXL,CoreXL Status,OK,\n" >> $csv_log
	fi
    
    #Collect Dynamic Dispatcher settings
    if [[ $current_version -ge 7730 ]]; then
        test_output_error=0
        printf "|\t\t\t| Dynamic Dispatcher\t\t|" | tee -a $output_log
        
        #Collect the dynamic dispatcher status based on version
        if [[ $current_version -eq 7730 ]]; then
            dispatcher_mode=$(fw ctl multik get_mode)
        else
            dispatcher_mode=$(fw ctl multik dynamic_dispatching get_mode)
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
}

#Check to see if the firewall is logging locally
check_local_logging()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Local Logging Check:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    
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
        printf "Local Logging Fail:\nThe $FWDIR/log/fw.log file is increasing in size.\n\n" >> $logfile
    else
        check_passed
        printf "Logging,Local Logging,OK,\n" >> $csv_log
    fi
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
}

	
#Hardware Platform
check_hardware_platform()
{
    #Insert full log header
    printf "\n# Hardware Platform Checks:\n" >> $full_output_log
    
    #Collect Hardware Platform Information
    hardware_platform_expert=$(dmiparse System Product)
    hardware_platform_clish=$(clish -c 'show asset system')
    
    #Review platform information
    echo "$hardware_platform_expert" >> $full_output_log
    echo "$hardware_platform_clish" >> $full_output_log
}
    
    
#Hardware Sensor Readings
check_hardware_sensors()
{
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

#Operating System Version and Hotfixes
check_OS_ver_patches()
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

#CPinfo build
check_cp_software()
{
    #Reset counters and start log
    summary_error=0
    test_output_error=0
    current_check_message="# Check Point Software:"
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    
    
    #Collect cpinfo build version
    printf "| Check Point\t\t| CPInfo Build Number\t\t|" | tee -a $output_log
    cpinfo_build_version=$(cpvinfo /opt/CPinfo-10/bin/cpinfo | grep Build | awk '{print $4}')
    printf "\n\ncpinfo build:\n$cpinfo_build_version\n"  >> $full_output_log
	if [[ $cpinfo_build_version -ge 914000182 ]]; then
        check_passed
        printf "Check Point,CPInfo Build Number,OK,\n" >> $csv_log
        printf "The cpinfo utility is up to date as of 01-29-2018.\n" >> $full_output_log
	else
        check_failed
        printf "Check Point,CPInfo Build Number,WARNING,sk92739\n" >> $csv_log
		printf "The cpinfo utility is outdated. Please update cpinfo utility to the latest version using sk92739 (preferably using CPUSE).\n" | tee -a $full_output_log $logfile > /dev/null
	fi
    
    #Collect CPUSE build version
    test_output_error=0
    cpuse_build_version=$(cpvinfo $DADIR/bin/DAService | grep Build | awk '{print $4}')
    printf "|\t\t\t| CPUSE Build Number\t\t|" | tee -a $output_log
    if [[ $cpuse_build_version -ge 1418 ]]; then
        check_passed
        printf "Check Point,CPUSE Build Number,OK,\n" >> $csv_log
        printf "CPUSE is up to date as of 01-29-2018.\n" >> $full_output_log
	else
        check_failed
        printf "Check Point,CPUSE Build Number,WARNING,sk92449\n" >> $csv_log
		printf "CPUSE is outdated. Please update CPUSE to the latest version using sk92449.\n" | tee -a $full_output_log $logfile > /dev/null
	fi

    #Check cpview history
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
    
    printf "+-----------------------+-------------------------------+---------------+\n\n" | tee -a $output_log
}

#Check for Blades Enabled
check_blades_enabled()
{
	#Check blades status
	printf "\n\n# Blades Status:\n" >> $full_output_log
	blades_enabled=$(blades_summary 2> /dev/null | grep "blade id" | awk -F\" '{print $2, $4}' | grep 1| sed 's/1//g')
    blades_disabled=$(blades_summary 2> /dev/null | grep "blade id" | awk -F\" '{print $2, $4}' | grep 0 | sed 's/0//g')
	
    #Log enabled blades or "N/A" if none are present
    printf "Enabled Blades:\n" >> $full_output_log
    if [[ -z $blades_enabled ]]; then
        if [[ $sys_type == "SmartEvent" ]]; then
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
}

#====================================================================================================
# MAIN
#====================================================================================================
printf "\n\n##############################\n# Health Check Results Report\n########################################\n\n" >> $output_log
printf "\n\nCurrent Script Release: $script_ver\n" | tee -a $output_log
printf "Current time: $(date)\n" | tee -a $output_log
printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
printf "| Physical System Checks \t\t\t\t\t\t|\n" | tee -a $output_log
printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
printf "| Category\t\t| Title\t\t\t\t| Result\t|\n"| tee -a $output_log
printf "+=======================+===============================+===============+\n" | tee -a $output_log

printf "##############################\n# Health Check Summary Report\n##############################\n" >> $logfile


#Checks to run
check_system
check_ntp
check_disk_space
check_memory
check_cpu
check_interface_stats
check_misc_messages
check_application_processes
check_core_files
check_cp_software

#Checks for firewall applications
if [[ $sys_type == "STANDALONE" || $sys_type == "GATEWAY" ]]; then
    printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
    printf "| Firewall Application Checks \t\t\t\t\t\t|\n" | tee -a $output_log
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    printf "| Category\t\t| Title\t\t\t\t| Result\t|\n"| tee -a $output_log
    printf "+=======================+===============================+===============+\n" | tee -a $output_log
    check_magic_mac
    check_enabled_debugs
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    check_fragmentation
    check_connections_stats
    check_cluster_statistics
    check_securexl_stats
	check_coreXL_stats
	check_local_logging
    
    
#Checks for VSX
elif [[ $sys_type == "VSX" ]]; then
    #Global Checks
    printf "+-----------------------------------------------------------------------+\n" | tee -a $output_log
    printf "| Firewall Application Checks \t\t\t\t\t\t|\n" | tee -a $output_log
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    printf "| Category\t\t| Title\t\t\t\t| Result\t|\n"| tee -a $output_log
    printf "+=======================+===============================+===============+\n" | tee -a $output_log
    check_magic_mac
    check_enabled_debugs
    check_coreXL_stats
    
    #VS Checks
    printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
    printf ""
	vs_list=$(vsx stat -v | grep \| | grep -v ID | awk -F\| '{print $1, $2}' | awk '{print $1, $2}' | grep S | awk '{print $1}')
    for vs in $vs_list; do
        vs_error=2
        
		printf "\nVirtual System $vs\n" | tee -a $output_log
        vsenv $vs | tee -a $output_log
        printf "\n\nVirtual System $vs:\n" >> $csv_log
        printf "Category,Check,Status,SK\n" >> $csv_log
        vsenv $vs > /dev/null
        printf "+-----------------------+-------------------------------+---------------+\n" | tee -a $output_log
        printf "| Category\t\t| Title\t\t\t\t| Result\t|\n"| tee -a $output_log
        printf "+=======================+===============================+===============+\n" | tee -a $output_log
		check_fragmentation
		check_connections_stats
		check_cluster_statistics
		check_securexl_stats
        check_local_logging
	done
fi

#Remaining Checks
check_OS_ver_patches
check_hardware_platform
check_hardware_sensors
check_blades_enabled

#Display summary
cat $logfile

#Consolidate and clean up logs
cat $output_log >> $logfile
cat $full_output_log >> $logfile
rm $output_log
rm $full_output_log


#Log completion
printf "\n# Summary:\n##########################\n"
printf "A report with the above output and the results from each command run has been saved to the following log files:\n"
printf "$logfile\n"
printf "$csv_log\n\n"