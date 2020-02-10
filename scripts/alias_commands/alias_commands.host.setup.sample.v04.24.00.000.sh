#
# Version :  v04.24.00.000
# Date    :  2020-02-07
# !! SAMPLE !!
#
#========================================================================================
#========================================================================================
# start of alias.commands.<action>.<scope>.sh
#========================================================================================
#========================================================================================


alias DTGDATE='date +%Y-%m-%d-%H%M%Z'
alias DTGSDATE='date +%Y-%m-%d-%H%M%S%Z'

alias list='ls -alh'

# 2019-10-05

export MYWORKFOLDER=/var/log/__customer

export MYWORKFOLDERUGEX=$MYWORKFOLDER/upgrade_export
export MYWORKFOLDERCHANGE=$MYWORKFOLDERUGEX/Change_Log
export MYWORKFOLDERDUMP=$MYWORKFOLDERUGEX/dump

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
export JQ16FQFN=$JQ16PATH$JQ16FILE
if [ -r $JQ16FQFN ] ; then
    # OK we have the easy-button alternative
    export JQ16=$JQ16FQFN
else
    export JQ16=
fi


alias gocustomer='cd $MYWORKFOLDER;echo Current path = `pwd`;echo'
alias gougex='cd $MYWORKFOLDER/upgrade_export;echo Current path = `pwd`;echo'
alias gochangelog='cd "$MYWORKFOLDERCHANGE";echo Current path = `pwd`;echo'
alias godump='cd "$MYWORKFOLDERDUMP";echo Current path = `pwd`;echo'

# Testing
#alias gochangelognow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDER/upgrade_export/Change_Log/$DTGSNOW";list "$MYWORKFOLDER/upgrade_export/Change_Log/";cd "$MYWORKFOLDER/upgrade_export/Change_Log/$DTGSNOW";echo;echo Current path = `pwd`;echo'

alias makechangelognow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERCHANGE/$DTGSNOW";list "$MYWORKFOLDERCHANGE/";echo;echo Current path = `pwd`;echo'
alias gochangelognow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERCHANGE/$DTGSNOW";list "$MYWORKFOLDERCHANGE/";echo;cd "$MYWORKFOLDERCHANGE/$DTGSNOW";echo;echo Current path = `pwd`;echo'
alias makechangelogdtg='DTGNOW=`DTGDATE`;mkdir -pv "$MYWORKFOLDERCHANGE/$DTGNOW";list "$MYWORKFOLDERCHANGE/";echo;echo Current path = `pwd`;echo'
alias gochangelogdtg='DTGNOW=`DTGDATE`;mkdir -pv "$MYWORKFOLDERCHANGE/$DTGNOW";list "$MYWORKFOLDERCHANGE/";echo;cd "$MYWORKFOLDERCHANGE/$DTGNOW";echo;echo Current path = `pwd`;echo'

# Testing
#alias godumpnow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDER/upgrade_export/dump/$DTGSNOW";list "$MYWORKFOLDER/upgrade_export/dump/";cd "$MYWORKFOLDER/upgrade_export/dump/$DTGSNOW";echo;echo Current path = `pwd`;echo'

alias makedumpnow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERDUMP/$DTGSNOW";list "$MYWORKFOLDERDUMP/";echo;echo Current path = `pwd`;echo'
alias godumpnow='DTGSNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERDUMP/$DTGSNOW";list "$MYWORKFOLDERDUMP/";echo;cd "$MYWORKFOLDERDUMP/$DTGSNOW";echo;echo Current path = `pwd`;echo'
alias makedumpdtg='DTGNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERDUMP/$DTGNOW";list "$MYWORKFOLDERDUMP/";echo;echo Current path = `pwd`;echo'
alias godumpdtg='DTGNOW=`DTGSDATE`;mkdir -pv "$MYWORKFOLDERDUMP/$DTGNOW";list "$MYWORKFOLDERDUMP/";echo;cd "$MYWORKFOLDERDUMP/$DTGNOW";echo;echo Current path = `pwd`;echo'

alias goapi='cd $MYWORKFOLDER/cli_api_ops;echo Current path = `pwd`;echo'
alias goapiexport='cd $MYWORKFOLDER/cli_api_ops/export_import;echo Current path = `pwd`;echo'
alias goapiwip='cd $MYWORKFOLDER/cli_api_ops.wip;echo Current path = `pwd`;echo'
alias goapiwipexport='cd $MYWORKFOLDER/cli_api_ops.wip/export_import.wip;echo Current path = `pwd`;echo'

# 2019-02-01

alias versionsdump='echo;echo;uname -a;echo;echo;clish -c "show version all";echo;echo;cpinfo -y all;echo;echo'
alias configdump='echo;gougex;pwd;echo;echo;./config_capture;echo;echo;./healthdump;echo;echo'

# 2019-11-21

alias braindump='echo;gougex;pwd;echo;echo;./config_capture;echo;echo;./healthdump;echo;echo;./interface_info;echo;echo;./check_point_service_status_check;echo;echo'
alias checkFTW='echo; echo "Check if FTW completed!  TRUE if .wizard_accepted found"; echo; ls -alh /etc/.wizard_accepted; echo; tail -n 10 /var/log/ftw_install.log; echo'

# 2019-11-21 Updated

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

alias showmytftpservers='echo -e "MYTFTPSERVERs: \n MYTFTPSERVER  = $MYTFTPSERVER \n MYTFTPSERVER1 = $MYTFTPSERVER1 \n MYTFTPSERVER2 = $MYTFTPSERVER2 \n MYTFTPSERVER3 = $MYTFTPSERVER3" ;echo'

alias getupdatescripts='gougex;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYTFTPFOLDER/updatescripts.sh;echo;chmod 775 updatescripts.sh;echo;ls -alh updatescripts.sh'

alias getsetuphostscript='cd /var/log;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYTFTPFOLDER/setuphost.sh;echo;chmod 775 setuphost.sh;echo;ls -alh setuphost.sh'

# 2020-01-03

alias gettoolsupdatescript='gougex;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYTFTPFOLDER/update_tools.sh;echo;chmod 775 update_tools.sh;echo;ls -alh update_tools.sh'

# 2020-01-03
# Clear legacy value if set
alias getupdatetoolsscript 2>nul >nul ; if [ $? -eq 0 ] ; then echo 'alias getupdatetoolsscript SET!  REMOVING!'; unalias getupdatetoolsscript; fi ; echo

# 2019-11-21 Updated

export MYSMCFOLDER=/__smcias

alias getfixsmcscript='cd /var/log;pwd;tftp -v -m binary 192.168.1.1 -c get /__smcias/fix_smcias_interfaces.sh;echo;chmod 775 fix_smcias_interfaces.sh;echo;ls -alh fix_smcias_interfaces.sh'


# 2020-01-04
#

# Add function to show the variables exported (set) in this script
#

_list_custom_user_vars () 
{ 
    echo
    echo '==============================================================================='
    echo 'List Custom User variables set by alias_commands.host.setup'
    echo '==============================================================================='
    echo
    
    echo '$MYWORKFOLDER                ='"$MYWORKFOLDER"
    echo '$MYWORKFOLDERCHANGE          ='"$MYWORKFOLDERCHANGE"
    echo '$MYWORKFOLDERCHANGE          ='"$MYWORKFOLDERCHANGE"
    echo '$MYWORKFOLDERDUMP            ='"$MYWORKFOLDERDUMP"
    echo

    echo '$JQ                          ='"$JQ"
    echo '$JQ16FILE                    ='"$JQ16FILE"
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

# 2020-01-04
#

#========================================================================================
#========================================================================================
# End of alias.commands.<action>.<scope>.sh
#========================================================================================
#========================================================================================


