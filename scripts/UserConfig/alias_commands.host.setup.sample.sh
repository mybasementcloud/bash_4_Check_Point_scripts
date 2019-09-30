#
# Version :  v04.11.00.00 SAMPLE
# Date    :  2019-09-28
#
alias DTGDATE='date +%Y-%m-%d-%H%M%Z'
alias DTGSDATE='date +%Y-%m-%d-%H%M%S%Z'

alias list='ls -alh'

# 2019-09-28

export MYWORKFOLDER=/var/log/__customer

export MYWORKFOLDERUGEX=$MYWORKFOLDER/upgrade_export
export MYWORKFOLDERCHANGE=$MYWORKFOLDERUGEX/Change_Log
export MYWORKFOLDERDUMP=$MYWORKFOLDERUGEX/dump

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

# 2019-09-28

export MYTFTPSERVER=192.168.1.1
export MYTFTPFOLDER=/__gaia

alias getupdatescripts='gougex;pwd;tftp -v -m binary 192.168.1.1 -c get /__gaia/updatescripts.sh;echo;chmod 775 updatescripts.sh;echo;ls -alh updatescripts.sh'

alias getsetuphostscript='cd /var/log;pwd;tftp -v -m binary 192.168.1.1 -c get /__gaia/setuphost.sh;echo;chmod 775 setuphost.sh;echo;ls -alh setuphost.sh'

export MYSMCFOLDER=/__smcias

alias getfixsmcscript='cd /var/log;pwd;tftp -v -m binary 192.168.1.1 -c get /__smcias/fix_smcias_interfaces.sh;echo;chmod 775 fix_smcias_interfaces.sh;echo;ls -alh fix_smcias_interfaces.sh'
