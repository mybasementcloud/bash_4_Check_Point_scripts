# !! SAMPLE !!
#
# Version   :  v04.33.00
# Revision  :  000|00
# Date      :  2020-09-17
#
#========================================================================================
#========================================================================================
# start of alias.commands.<action>.<scope>.sh
#========================================================================================
#========================================================================================


echo
echo 'Configuring User Environment...'
echo


#========================================================================================
# Setup standard environment export variables
#========================================================================================


# 2020-09-17
export ENVIRONMENTHELPFILE=$HOME/environment_help_file.txt

echo '===============================================================================' > $ENVIRONMENTHELPFILE
echo 'User Environment Configuration Variables and Alias Commands' >> $ENVIRONMENTHELPFILE
echo '===============================================================================' >> $ENVIRONMENTHELPFILE
echo >> $ENVIRONMENTHELPFILE

tempENVHELPFILEvars=/var/tmp/environment_help_file.temp.variables.txt
tempENVHELPFILEalias=/var/tmp/environment_help_file.temp.alias.txt

echo '===============================================================================' > $tempENVHELPFILEvars
echo 'List Custom User variables set by alias_commands.add.all' >> $tempENVHELPFILEvars
echo '===============================================================================' >> $tempENVHELPFILEvars
echo >> $tempENVHELPFILEvars

echo '===============================================================================' > $tempENVHELPFILEalias
echo 'List Custom User alias commands set by alias_commands.add.all' >> $tempENVHELPFILEalias
echo '===============================================================================' >> $tempENVHELPFILEalias
echo >> $tempENVHELPFILEalias


#========================================================================================
# 2019-09-28, 2020-05-30

export MYWORKFOLDER=/var/log/__customer

export MYWORKFOLDERUGEX=$MYWORKFOLDER/upgrade_export
export MYWORKFOLDERUGEXSCRIPTS=$MYWORKFOLDER/upgrade_export/scripts
export MYWORKFOLDERCHANGE=$MYWORKFOLDERUGEX/Change_Log
export MYWORKFOLDERDUMP=$MYWORKFOLDERUGEX/dump
export MYWORKFOLDERDOWNLOADS=$MYWORKFOLDER/download
export MYWORKFOLDERSCRIPTS=$MYWORKFOLDER/_scripts
export MYWORKFOLDERSCRIPTSB4CP=$MYWORKFOLDER/_scripts/bash_4_Check_Point

echo '$MYWORKFOLDER                ='"$MYWORKFOLDER" >> $tempENVHELPFILEvars
echo '$MYWORKFOLDERUGEX            ='"$MYWORKFOLDERUGEX" >> $tempENVHELPFILEvars
echo '$MYWORKFOLDERUGEXSCRIPTS     ='"$MYWORKFOLDERUGEXSCRIPTS" >> $tempENVHELPFILEvars
echo '$MYWORKFOLDERCHANGE          ='"$MYWORKFOLDERCHANGE" >> $tempENVHELPFILEvars
echo '$MYWORKFOLDERDUMP            ='"$MYWORKFOLDERDUMP" >> $tempENVHELPFILEvars
echo '$MYWORKFOLDERDOWNLOADS       ='"$MYWORKFOLDERDOWNLOADS" >> $tempENVHELPFILEvars
echo '$MYWORKFOLDERSCRIPTS         ='"$MYWORKFOLDERSCRIPTS" >> $tempENVHELPFILEvars
echo '$MYWORKFOLDERSCRIPTSB4CP     ='"$MYWORKFOLDERSCRIPTSB4CP" >> $tempENVHELPFILEvars
echo >> $tempENVHELPFILEvars

#========================================================================================
# 2020-01-0

# points to where jq is installed
if [ -r ${CPDIR}/jq/jq ] ; then
    export JQ=${CPDIR}/jq/jq
elif [ -r ${CPDIR_PATH}/jq/jq ] ; then
    export JQ=${CPDIR_PATH}/jq/jq
elif [ -r ${MDS_CPDIR}/jq/jq ] ; then
    export JQ=${MDS_CPDIR}/jq/jq
else
    export JQ=
fi

# points to where jq 1.6 is installed, which is not generally part of Gaia, even R80.40EA (2020-01-20)
export JQ16PATH=$MYWORKFOLDER/_tools/JQ
export JQ16FILE=jq-linux64
export JQ16FQFN=$JQ16PATH/$JQ16FILE
if [ -r $JQ16FQFN ] ; then
    # OK we have the easy-button alternative
    export JQ16=$JQ16FQFN
else
    export JQ16=
fi

echo '$JQ                          ='"$JQ" >> $tempENVHELPFILEvars
echo '$JQ16PATH                    ='"$JQ16PATH" >> $tempENVHELPFILEvars
echo '$JQ16FILE                    ='"$JQ16FILE" >> $tempENVHELPFILEvars
echo '$JQ16FQFN                    ='"$JQ16FQFN" >> $tempENVHELPFILEvars
echo '$JQ16                        ='"$JQ16" >> $tempENVHELPFILEvars
echo >> $tempENVHELPFILEvars


#========================================================================================
# Setup alias and other complex operations
#========================================================================================


#========================================================================================
# 2020-09-17
alias show_environment_help='echo;cat $ENVIRONMENTHELPFILE;echo'

echo 'show_environment_help        :  Display help for environment variables and alias values set' >> $tempENVHELPFILEalias


#========================================================================================

alias DTGDATE='date +%Y-%m-%d-%H%M%Z'
alias DTGSDATE='date +%Y-%m-%d-%H%M%S%Z'

echo 'DTGDATE                      :  Generate Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMTZ3' >> $tempENVHELPFILEalias
echo 'DTGDATE                      :  Generate Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMSSTZ3' >> $tempENVHELPFILEalias

alias timecheck='echo -e "Current Date-Time-Group : `DTGSDATE` \n"'
echo 'timecheck                    :  Show Current DTGS Date Time Group (YYYY-mm-dd-HHMMSSTZ3)' >> $tempENVHELPFILEalias


#========================================================================================
# Updated 2020-09-17
#alias list='ls -alh'
alias list='ls -alh --color=auto --group-directories-first'
echo 'list                         :  display folder content -- '`alias list` >> $tempENVHELPFILEalias


#========================================================================================
# 2020-09-17
alias gocustomer='cd $MYWORKFOLDER;echo Current path = `pwd`;echo'
alias gougex='cd $MYWORKFOLDER/upgrade_export;echo Current path = `pwd`;echo'
alias gochangelog='cd "$MYWORKFOLDERCHANGE";echo Current path = `pwd`;echo'
alias godump='cd "$MYWORKFOLDERDUMP";echo Current path = `pwd`;echo'
alias godownload='cd "$MYWORKFOLDERDOWNLOADS";echo Current path = `pwd`;echo'
alias goscripts='cd "$MYWORKFOLDERSCRIPTS";echo Current path = `pwd`;echo'
alias gob4cp='cd "$MYWORKFOLDERSCRIPTSB4CP";echo Current path = `pwd`;echo'
alias gob4CP='gob4cp'

echo 'gocustomer                   :  Go to customer work folder '$MYWORKFOLDER >> $tempENVHELPFILEalias
echo 'gougex                       :  Go to upgrade export folder '$MYWORKFOLDER/upgrade_export >> $tempENVHELPFILEalias
echo 'gochangelog                  :  Go to Change Log folder '$MYWORKFOLDERCHANGE >> $tempENVHELPFILEalias
echo 'godump                       :  Go to dump folder '$MYWORKFOLDERDUMP >> $tempENVHELPFILEalias
echo 'godownload                   :  Go to download folder '$MYWORKFOLDERDOWNLOADS >> $tempENVHELPFILEalias
echo 'goscripts                    :  Go to scripts folder '$MYWORKFOLDERSCRIPTS >> $tempENVHELPFILEalias
echo 'gob4cp                       :  Go to bash 4 Check Point folder '$MYWORKFOLDERSCRIPTSB4CP >> $tempENVHELPFILEalias
echo 'gob4CP                       :  Go to bash 4 Check Point folder '$MYWORKFOLDERSCRIPTSB4CP >> $tempENVHELPFILEalias

#========================================================================================
# 2020-09-17
if [ -r $MYWORKFOLDER/cli_api_ops ] ; then
    alias goapi='cd $MYWORKFOLDER/cli_api_ops;echo Current path = `pwd`;echo'
    alias goapiexport='cd $MYWORKFOLDER/cli_api_ops/export_import;echo Current path = `pwd`;echo'
    echo 'goapi                        :  Go to api work folder '$MYWORKFOLDER/cli_api_ops >> $tempENVHELPFILEalias
    echo 'goapiexport                  :  Go to api export folder '$MYWORKFOLDER/cli_api_ops/export_import >> $tempENVHELPFILEalias
fi
if [ -r $MYWORKFOLDER/cli_api_ops.wip ] ; then
    alias goapiwip='cd $MYWORKFOLDER/cli_api_ops.wip;echo Current path = `pwd`;echo'
    alias goapiwipexport='cd $MYWORKFOLDER/cli_api_ops.wip/export_import.wip;echo Current path = `pwd`;echo'
    echo 'goapiwip                     :  Go to api development work folder '$MYWORKFOLDER/cli_api_ops.wip >> $tempENVHELPFILEalias
    echo 'goapiwipexport               :  Go to api development export folder '$MYWORKFOLDER/cli_api_ops.wip/export_import.wip >> $tempENVHELPFILEalias
fi

#========================================================================================
# 2020-09-17
if [ -r $MYWORKFOLDER/devops ] ; then
    alias godevops='cd $MYWORKFOLDER/devops;echo Current path = `pwd`;echo'
    alias godevopsexport='cd $MYWORKFOLDER/devops/export_import;echo Current path = `pwd`;echo'
    echo 'godevops                     :  Go to api devops folder '$MYWORKFOLDER/devops >> $tempENVHELPFILEalias
    echo 'godevopsexport               :  Go to api devops export folder '$MYWORKFOLDER/devops/export_import >> $tempENVHELPFILEalias
fi
if [ -r $MYWORKFOLDER/devops.dev ] ; then
    alias godevopsdev='cd $MYWORKFOLDER/devops.dev;echo Current path = `pwd`;echo'
    alias godevopsdevexport='cd $MYWORKFOLDER/devops.dev/export_import.wip;echo Current path = `pwd`;echo'
    echo 'godevopsdev                  :  Go to api devops development folder '$MYWORKFOLDER/devops.dev >> $tempENVHELPFILEalias
    echo 'godevopsdevexport            :  Go to api devops development export folder '$MYWORKFOLDER/devops.dev/export_import.wip >> $tempENVHELPFILEalias
fi

#========================================================================================
# 2020-09-17

alias makedumpnow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERDUMP/$DTGSNOW";list "$MYWORKFOLDERDUMP/";echo;echo "New dump folder = $MYWORKFOLDERDUMP/$DTGSNOW";echo Current path = `pwd`;echo'
alias godumpnow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERDUMP/$DTGSNOW";list "$MYWORKFOLDERDUMP/";echo;cd "$MYWORKFOLDERDUMP/$DTGSNOW";echo;echo Current path = `pwd`;echo'
alias makedumpdtg='DTGNOW=`DTGDATE`;mkdir -pv "$MYWORKFOLDERDUMP/$DTGNOW";list "$MYWORKFOLDERDUMP/";echo;echo "New dump folder = $MYWORKFOLDERDUMP/$DTGNOW";echo Current path = `pwd`;echo'
alias godumpdtg='DTGNOW=`DTGDATE`;mkdir -pv "$MYWORKFOLDERDUMP/$DTGNOW";list "$MYWORKFOLDERDUMP/";echo;cd "$MYWORKFOLDERDUMP/$DTGNOW";echo;echo Current path = `pwd`;echo'

echo 'makedumpnow                  :  Create a dump folder with current Date Time Group (DTGS) and show that folder' >> $tempENVHELPFILEalias
echo 'godumpnow                    :  Create a dump folder with current Date Time Group (DTGS) and change to that folder' >> $tempENVHELPFILEalias
echo 'makedumpdtg                  :  Create a dump folder with current Date Time Group (DTG) and show that folder' >> $tempENVHELPFILEalias
echo 'godumpdtg                    :  Create a dump folder with current Date Time Group (DTG) and change to that folder' >> $tempENVHELPFILEalias

alias makechangelognow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERCHANGE/$DTGSNOW";list "$MYWORKFOLDERCHANGE/";echo;echo Current path = `pwd`;echo'
alias gochangelognow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERCHANGE/$DTGSNOW";list "$MYWORKFOLDERCHANGE/";echo;cd "$MYWORKFOLDERCHANGE/$DTGSNOW";echo;echo Current path = `pwd`;echo'
alias makechangelogdtg='DTGNOW=`DTGDATE`;mkdir -pv "$MYWORKFOLDERCHANGE/$DTGNOW";list "$MYWORKFOLDERCHANGE/";echo;echo Current path = `pwd`;echo'
alias gochangelogdtg='DTGNOW=`DTGDATE`;mkdir -pv "$MYWORKFOLDERCHANGE/$DTGNOW";list "$MYWORKFOLDERCHANGE/";echo;cd "$MYWORKFOLDERCHANGE/$DTGNOW";echo;echo Current path = `pwd`;echo'

echo 'makechangelognow             :  Create a Change Log folder with current Date Time Group (DTGS) and show that folder' >> $tempENVHELPFILEalias
echo 'gochangelognow               :  Create a Change Log folder with current Date Time Group (DTGS) and change to that folder' >> $tempENVHELPFILEalias
echo 'makechangelogdtg             :  Create a Change Log folder with current Date Time Group (DTG) and show that folder' >> $tempENVHELPFILEalias
echo 'gochangelogdtg               :  Create a Change Log folder with current Date Time Group (DTG) and change to that folder' >> $tempENVHELPFILEalias

#========================================================================================
# 2020-09-17

alias versionsdump='echo;echo;uname -a;echo;echo;clish -c "show version all";echo;echo;clish -c "show installer status";echo;echo;cpinfo -y all;echo;echo'
echo 'versionsdump                 :  Dump current version information for linux, clish, and cpinfo ' >> $tempENVHELPFILEalias

#alias configdump='echo;gougex;pwd;echo;echo;./config_capture;echo;echo;./healthdump;echo;echo'
alias configdump='echo;config_capture;echo;healthdump;echo'
echo 'configdump                   :  Execute configuration dump (config_capture) and health status check (healthdump)' >> $tempENVHELPFILEalias

#alias braindump='echo;gougex;pwd;echo;echo;./config_capture;echo;echo;./healthdump;echo;echo;./interface_info;echo;echo;./check_point_service_status_check;echo;echo'
alias braindump='echo;config_capture;echo;healthdump;echo;interface_info;echo;check_point_service_status_check;echo'
echo 'braindump                    :  Execute complete configuration and status dump (config_capture, healthdump, interface_info, check_point_service_status_check) ' >> $tempENVHELPFILEalias

alias checkFTW='echo; echo "Check if FTW completed!  TRUE if .wizard_accepted found"; echo; ls -alh /etc/.wizard_accepted; echo; tail -n 10 /var/log/ftw_install.log; echo'
echo 'checkFTW                     :  Display status of First Time Wizard (FTW) completion or operation' >> $tempENVHELPFILEalias

#========================================================================================
# 2020-09-17

if [ -r $MYWORKFOLDERSCRIPTSB4CP/watch_accel_stats ] ; then
    # GW related aliases
    
    alias dumpzdebugnow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERDUMP/$DTGSNOW";list "$MYWORKFOLDERDUMP/";echo;cd "$MYWORKFOLDERDUMP/$DTGSNOW";echo;echo Current path = `pwd`;echo;fw ctl zdebug drop | tee -a zdebug_drop.$DTGSNOW.txt'
    echo 'dumpzdebugnow                :  Gateway : generate zdebug drop dump to new dump folder with current Date Time Group (DTGS)' >> $tempENVHELPFILEalias
fi


#========================================================================================
# 2020-09-17

export MYWORKFOLDERCCC=$MYWORKFOLDER/_scripts/ccc
echo '$MYWORKFOLDERCCC             ='"$MYWORKFOLDERCCC" >> $tempENVHELPFILEvars

alias installccc="mkdir $MYWORKFOLDERCCC; curl_cli -k https://dannyjung.de/ccc | zcat > $MYWORKFOLDERCCC/ccc && chmod +x $MYWORKFOLDERCCC/ccc; alias ccc='$MYWORKFOLDERCCC/ccc'"
echo 'installccc                   :  Install ccc utility by Danny Jung and put in folder '"$MYWORKFOLDERCCC" >> $tempENVHELPFILEalias

if [ -r $MYWORKFOLDERCCC/ccc ] ; then
    # ccc related aliases
    
    alias ccc='$MYWORKFOLDERCCC/ccc'
    echo 'ccc                          :  Execute ccc utility by Danny Jung folder '"$MYWORKFOLDERCCC" >> $tempENVHELPFILEalias
    
fi

#========================================================================================
#========================================================================================
# 2020-09-17 Updated

#
# This section expects definition of the following external variables.  These are usually part of the user profile setup in the $HOME folder
#  MYTFTPSERVER     default TFTP/FTP server to use for TFTP/FTP operations, usually set to one of the following
#  MYTFTPSERVER1    first TFTP/FTP server to use for TFTP/FTP operations
#  MYTFTPSERVER2    second TFTP/FTP server to use for TFTP/FTP operations
#  MYTFTPSERVER3    third TFTP/FTP server to use for TFTP/FTP operations
#
#  MYTFTPSERVER* values are assumed to be an IPv4 Address (0.0.0.0 to 255.255.255.255) that represents a valid TFTP/FTP target host.
#  Setting one of the MYTFTPSERVER* to blank ignores that host.  Future scripts may include checks to see if the host actually has a reachable TFTP/FTP server
#

export MYTFTPSERVER1=192.168.1.1
export MYTFTPSERVER2=192.168.1.2
export MYTFTPSERVER3=
export MYTFTPSERVER=$MYTFTPSERVER1
export MYTFTPFOLDER=/__gaia

echo '$MYTFTPSERVER1               ='"$MYTFTPSERVER1" >> $tempENVHELPFILEvars
echo '$MYTFTPSERVER2               ='"$MYTFTPSERVER2" >> $tempENVHELPFILEvars
echo '$MYTFTPSERVER3               ='"$MYTFTPSERVER3" >> $tempENVHELPFILEvars
echo '$MYTFTPSERVER                ='"$MYTFTPSERVER" >> $tempENVHELPFILEvars
echo '$MYTFTPFOLDER                ='"$MYTFTPFOLDER" >> $tempENVHELPFILEvars
echo >> $tempENVHELPFILEvars

alias show_mytftpservers='echo -e "MYTFTPSERVERs: \n MYTFTPSERVER  = $MYTFTPSERVER \n MYTFTPSERVER1 = $MYTFTPSERVER1 \n MYTFTPSERVER2 = $MYTFTPSERVER2 \n MYTFTPSERVER3 = $MYTFTPSERVER3" ;echo'
echo 'show_mytftpservers           :  Show current settings for the TFTP servers defined by MYTFTPSERVERx ' >> $tempENVHELPFILEalias

alias getupdatescripts='gougex;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYTFTPFOLDER/updatescripts.sh;echo;chmod 775 updatescripts.sh;echo;ls -alh updatescripts.sh'
echo 'getupdatescripts             :  Get the current update script from the primary TFTP server' >> $tempENVHELPFILEalias

alias getsetuphostscript='cd /var/log;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYTFTPFOLDER/setuphost.sh;echo;chmod 775 setuphost.sh;echo;ls -alh setuphost.sh'
echo 'getsetuphostscript           :  Get the current host setup script from the primary TFTP server' >> $tempENVHELPFILEalias

# 2020-01-03
# Clear legacy value if set
alias getupdatetoolsscript 2>nul >nul ; if [ $? -eq 0 ] ; then echo 'alias getupdatetoolsscript SET!  REMOVING!'; unalias getupdatetoolsscript; fi ; echo

alias gettoolsupdatescript='gougex;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYTFTPFOLDER/update_tools.sh;echo;chmod 775 update_tools.sh;echo;ls -alh update_tools.sh'
echo 'gettoolsupdatescript         :  Get the current tools setup script from the primary TFTP server' >> $tempENVHELPFILEalias


#========================================================================================
#========================================================================================
# 2020-09-17 Updated

export MYSMCFOLDER=/__smcias

echo '$MYSMCFOLDER                 ='"$MYSMCFOLDER" >> $tempENVHELPFILEvars
echo >> $tempENVHELPFILEvars

alias getfixsmcscript='cd /var/log;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYSMCFOLDER/fix_smcias_interfaces.sh;echo;chmod 775 fix_smcias_interfaces.sh;echo;ls -alh fix_smcias_interfaces.sh'
echo 'getfixsmcscript              :  Get script to fix SMC IAS Server interfaces from the primary TFTP server' >> $tempENVHELPFILEalias


#========================================================================================
#========================================================================================
# 2020-09-17 Updated

alias generate_script_links='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/generate_script_links'
alias remove_script_links='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/remove_script_links'
alias reset_script_links='gougex;echo;remove_script_links;echo;generate_script_links;echo;list'
echo 'generate_script_links        :  Generate links and references to current scripts' >> $tempENVHELPFILEalias
echo 'remove_script_links          :  Remove links and references to current scripts' >> $tempENVHELPFILEalias
echo 'reset_script_links           :  Remove and Regenerate links and references to current scripts' >> $tempENVHELPFILEalias

alias gaia_version_type='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/gaia_version_type'
echo 'gaia_version_type            :  Display and document current Gaia version and installation type' >> $tempENVHELPFILEalias

alias do_script_nohup='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/do_script_nohup'
echo 'do_script_nohup              :  Execute script in passed parameters via nohup' >> $tempENVHELPFILEalias

alias config_capture='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/config_capture'
alias interface_info='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/interface_info'
echo 'config_capture               :  Execute capture and documentation of key configuration elements' >> $tempENVHELPFILEalias
echo 'interface_info               :  Execute capture and documentation of interface information' >> $tempENVHELPFILEalias

if [ -r $MYWORKFOLDERSCRIPTSB4CP/EPM_config_check ] ; then
    alias EPM_config_check='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/EPM_config_check'
    echo 'EPM_config_check             :  Execute Configuration Capture for Endpoint Management Server' >> $tempENVHELPFILEalias
fi

if [ -r $MYWORKFOLDERSCRIPTSB4CP/update_gaia_rest_api ] ; then
    alias update_gaia_rest_api='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/update_gaia_rest_api'
    alias update_gaia_dynamic_cli='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/update_gaia_dynamic_cli'
    echo 'update_gaia_rest_api         :  Execute update script for Gaia REST API' >> $tempENVHELPFILEalias
    echo 'update_gaia_dynamic_cli      :  Execute update script for Gaia (clish) Dynamic CLI' >> $tempENVHELPFILEalias
fi

if [ -r $MYWORKFOLDERSCRIPTSB4CP/watch_accel_stats ] ; then
    # GW scripts set
    alias enable_rad_admin_stats_and_cpview='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/enable_rad_admin_stats_and_cpview'
    alias vpn_client_operational_info='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/vpn_client_operational_info'
    alias watch_accel_stats='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/watch_accel_stats'
    echo -e 'enable_rad_admin_stats_and_cpview :'"\n"'                             ::  Launch cpview with rad_admin stats enabled' >> $tempENVHELPFILEalias
    echo 'vpn_client_operational_info  :  Display status of VPN Clients connected to the gateway' >> $tempENVHELPFILEalias
    echo 'watch_accel_stats            :  Display (watch) status of firewall SecureXL Accelleration' >> $tempENVHELPFILEalias
    if [ -r $MYWORKFOLDERSCRIPTSB4CP/watch_cluster_status ] ; then
        alias watch_cluster_status='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/watch_cluster_status'
        alias show_cluster_info='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/show_cluster_info'
        echo 'watch_cluster_status         :  Display (watch) current ClusterXL information' >> $tempENVHELPFILEalias
        echo 'show_cluster_info            :  Display and document current ClusterXL information' >> $tempENVHELPFILEalias
    fi
fi

alias healthcheck='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/healthcheck'
alias healthdump='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/healthdump'
alias check_point_service_status_check='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/check_point_service_status_check'
echo 'healthcheck                  :  Execute Check Point Healthcheck script' >> $tempENVHELPFILEalias
echo 'healthdump                   :  Execute Check Point Healthcheck script and place results in healtchecks folder' >> $tempENVHELPFILEalias
echo -e 'check_point_service_status_check :'"\n"'                             ::  Check and document status of access to Check Point Internet resource locations' >> $tempENVHELPFILEalias

if [ -r $MYWORKFOLDERSCRIPTSB4CP/report_mdsstat ] ; then
    alias report_mdsstat='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/report_mdsstat'
    alias watch_mdsstat='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/watch_mdsstat'
    alias show_domains_in_array='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/show_domains_in_array'
    echo 'report_mdsstat               :  Display and document status of MDSM server and domains' >> $tempENVHELPFILEalias
    echo 'watch_mdsstat                :  Display (watch) status of MDSM server and domains' >> $tempENVHELPFILEalias
    echo 'show_domains_in_array        :  Display list of currently defined MDSM Domains on this MDS ' >> $tempENVHELPFILEalias
fi

alias identify_self_referencing_symbolic_link_files='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/identify_self_referencing_symbolic_link_files'
#alias Lite_identify_self_referencing_symbolic_link_files='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/Lite.identify_self_referencing_symbolic_link_files'
alias check_status_of_scheduled_ips_updates_on_management='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/check_status_of_scheduled_ips_updates_on_management'
echo -e 'identify_self_referencing_symbolic_link_files :'"\n"'                             ::  Identify and if set, remove self referencing symbolic link files in target folder' >> $tempENVHELPFILEalias
#echo -e 'Lite_identify_self_referencing_symbolic_link_files :'"\n"'                             ::  Identify and if set, remove self referencing symbolic link files in target folder' >> $tempENVHELPFILEalias
echo -e 'check_status_of_scheduled_ips_updates_on_management :'"\n"'                             ::  Check and document the status of IPS updates process' >> $tempENVHELPFILEalias

if [ -r $MYWORKFOLDERSCRIPTSB4CP/remove_zerolocks_sessions ] ; then
    alias remove_zerolocks_sessions='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/remove_zerolocks_sessions'
    alias remove_zerolocks_web_api_sessions='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/remove_zerolocks_web_api_sessions'
    alias show_zerolocks_sessions='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/show_zerolocks_sessions'
    alias show_zerolocks_web_api_sessions='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/show_zerolocks_web_api_sessions'
    echo 'remove_zerolocks_sessions    :  Remove management sessions with Zero locks' >> $tempENVHELPFILEalias
    echo -e 'remove_zerolocks_web_api_sessions :'"\n"'                             ::  Remove management sessions with Zero locks for the web_api user' >> $tempENVHELPFILEalias
    echo 'show_zerolocks_sessions      :  Show management sessions with Zero locks' >> $tempENVHELPFILEalias
    echo -e 'show_zerolocks_web_api_sessions :'"\n"'                             ::  Show management sessions with Zero locks for the web_api user' >> $tempENVHELPFILEalias
fi

if [ -r $MYWORKFOLDERSCRIPTSB4CP/remove_zerolocks_sessions ] ; then
    # Means we have api potential
    alias apiversions='apiwebport=`clish -c "show web ssl-port" | cut -d " " -f 2`;echo "API web port = $apiwebport";echo;echo "API Versions:";mgmt_cli -r true --port $apiwebport show-api-versions -f json'
    echo 'apiversions                  :  Display current management API version' >> $tempENVHELPFILEalias
fi

if [ -r $MYWORKFOLDERSCRIPTSB4CP/SmartEvent_backup ] ; then
    alias SmartEvent_backup='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/SmartEvent_backup'
    #alias SmartEvent_restore='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/SmartEvent_restore'
    alias Reset_SmartLog_Indexing='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/Reset_SmartLog_Indexing'
    #alias SmartEvent_NUKE_Index_and_Logs='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/SmartEvent_NUKE_Index_and_Logs'
    echo 'SmartEvent_backup            :  Backup SmartEvent Indexing and Log files' >> $tempENVHELPFILEalias
    #echo 'SmartEvent_restore           :  Backup SmartEvent Indexing and Log files' >> $tempENVHELPFILEalias
    echo 'Reset_SmartLog_Indexing      :  Reset SmartLog Indexing back the number of days provided in parameter' >> $tempENVHELPFILEalias
    #echo -e 'SmartEvent_NUKE_Index_and_Logs :'"\n"'                             ::  Annihilate SmartEvent Indexes and Logs' >> $tempENVHELPFILEalias
fi

alias report_cpwd_admin_list='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/report_cpwd_admin_list'
alias report_admin_status='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/report_cpwd_admin_list'
alias watch_cpwd_admin_list='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/watch_cpwd_admin_list'
alias admin_status='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/watch_cpwd_admin_list'
echo 'report_cpwd_admin_list       :  Report management services status' >> $tempENVHELPFILEalias
echo 'report_admin_status          :  Report management services status' >> $tempENVHELPFILEalias
echo 'watch_cpwd_admin_list        :  Display watch of management services status' >> $tempENVHELPFILEalias
echo 'admin_status                 : Display watch of management services status' >> $tempENVHELPFILEalias
if [ -r $MYWORKFOLDERSCRIPTSB4CP/restart_mgmt ] ; then
    alias restart_mgmt='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/restart_mgmt'
    echo 'restart_mgmt                 :  Execute and document a restart of management services' >> $tempENVHELPFILEalias
fi

alias alias_commands_add_user='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/alias_commands_add_user'
alias alias_commands_add_all_users='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/alias_commands_add_all_users'
alias alias_commands_update_user='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/alias_commands_update_user'
alias alias_commands_update_all_users='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/alias_commands_update_all_users'
echo 'alias_commands_add_user      : Add alias commands to current user' >> $tempENVHELPFILEalias
echo 'alias_commands_add_all_users :  Add alias commands to all user' >> $tempENVHELPFILEalias
echo 'alias_commands_update_user   :  Update alias commands to current user' >> $tempENVHELPFILEalias
echo -e 'alias_commands_update_all_users :'"\n"'                             ::  Update alias commands to current user' >> $tempENVHELPFILEalias

#alias alias_commands_CORE_G2_NPM_add_user='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/alias_commands_CORE_G2_NPM_add_user'
#alias alias_commands_CORE_G2_NPM_add_all_users='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/alias_commands_CORE_G2_NPM_add_all_users'
#alias alias_commands_CORE_G2_NPM_update_user='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/alias_commands_CORE_G2_NPM_update_user'
#alias alias_commands_CORE_G2_NPM_update_all_users='gougex;echo;$MYWORKFOLDERSCRIPTSB4CP/alias_commands_CORE_G2_NPM_update_all_users'
#echo -e 'alias_commands_CORE_G2_NPM_add_user :'"\n"'                             ::  Add alias commands for CORE_G2_NPM to current user' >> $tempENVHELPFILEalias
#echo -e 'alias_commands_CORE_G2_NPM_add_all_users :'"\n"'                             ::  Add alias commands for CORE_G2_NPM to all user' >> $tempENVHELPFILEalias
#echo -e 'alias_commands_CORE_G2_NPM_update_user :'"\n"'                             ::  Update alias commands for CORE_G2_NPM to current user' >> $tempENVHELPFILEalias
#echo -e 'alias_commands_CORE_G2_NPM_update_all_users  :'"\n"'                             ::  Update alias commands for CORE_G2_NPM to current user' >> $tempENVHELPFILEalias


#========================================================================================
#========================================================================================
# 2020-05-30
#

# Add function to show the variables exported (set) in this script
#

_list_custom_user_vars () 
{ 
    echo
    echo '==============================================================================='
    echo 'List Custom User variables set by alias_commands.add.all'
    echo '==============================================================================='
    echo
    
    echo '$MYWORKFOLDER                ='"$MYWORKFOLDER"
    echo '$MYWORKFOLDERUGEX            ='"$MYWORKFOLDERUGEX"
    echo '$MYWORKFOLDERUGEXSCRIPTS     ='"$MYWORKFOLDERUGEXSCRIPTS"
    echo '$MYWORKFOLDERCHANGE          ='"$MYWORKFOLDERCHANGE"
    echo '$MYWORKFOLDERDUMP            ='"$MYWORKFOLDERDUMP"
    echo '$MYWORKFOLDERDOWNLOADS       ='"$MYWORKFOLDERDOWNLOADS"
    echo '$MYWORKFOLDERSCRIPTS         ='"$MYWORKFOLDERSCRIPTS"
    echo '$MYWORKFOLDERSCRIPTSB4CP     ='"$MYWORKFOLDERSCRIPTSB4CP"
    echo
    
    echo '$JQ                          ='"$JQ"
    echo '$JQ16PATH                    ='"$JQ16PATH"
    echo '$JQ16FILE                    ='"$JQ16FILE"
    echo '$JQ16FQFN                    ='"$JQ16FQFN"
    echo '$JQ16                        ='"$JQ16"
    echo
    
    echo '$MYTFTPSERVER1               ='"$MYTFTPSERVER1"
    echo '$MYTFTPSERVER2               ='"$MYTFTPSERVER2"
    echo '$MYTFTPSERVER3               ='"$MYTFTPSERVER3"
    echo '$MYTFTPSERVER                ='"$MYTFTPSERVER"
    echo '$MYTFTPFOLDER                ='"$MYTFTPFOLDER"
    echo
    
    echo '$MYSMCFOLDER                 ='"$MYSMCFOLDER"
    echo
    
    echo '==============================================================================='
    echo '==============================================================================='
    echo
    
}


#========================================================================================
# Build environment help file
#========================================================================================

cat $tempENVHELPFILEvars >> $ENVIRONMENTHELPFILE
rm -f $tempENVHELPFILEvars
tempENVHELPFILEvars=

cat $tempENVHELPFILEalias >> $ENVIRONMENTHELPFILE
rm -f $tempENVHELPFILEalias
tempENVHELPFILEalias=

list $ENVIRONMENTHELPFILE

echo
echo 'Configuration of User Environment completed!'
echo 'Display help regarding configured variables and aliases with command :  show_environment_help'
echo

#========================================================================================
#========================================================================================
# End of alias.commands.<action>.<scope>.sh
#========================================================================================
#========================================================================================


