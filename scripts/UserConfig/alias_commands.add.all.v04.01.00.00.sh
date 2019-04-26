#
# Version :  v04.01.00.00
# Date    :  2019-04-20
#
alias DTGDATE='date +%Y-%m-%d-%H%M%Z'
alias DTGSDATE='date +%Y-%m-%d-%H%M%S%Z'

alias list='ls -alh'

export MYWORKFOLDER=/var/log/__customer

alias gocustomer='cd $MYWORKFOLDER'
alias gougex='cd $MYWORKFOLDER/upgrade_export'
alias goapi='cd $MYWORKFOLDER/cli_api_ops'
alias goexport='cd $MYWORKFOLDER/cli_api_ops/export_import'
alias goapiwip='cd $MYWORKFOLDER/cli_api_ops.wip'
alias goexportwip='cd $MYWORKFOLDER/cli_api_ops.wip/export_import.wip'

# 2019-02-01

export MYTFTPSERVER=10.69.248.60
export MYTFTPFOLDER=/__gaia

alias getupdatescripts='gougex;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYTFTPFOLDER/updatescripts.sh;echo;chmod 775 updatescripts.sh;echo;ls -alh updatescripts.sh'

alias getsetuphostscript='cd /var/log;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYTFTPFOLDER/setuphost.sh;echo;chmod 775 setuphost.sh;echo;ls -alh setuphost.sh'

export MYSMCFOLDER=/__smcias

alias getfixsmcscript='cd /var/log;pwd;tftp -v -m binary $MYTFTPSERVER -c get $MYSMCFOLDER/fix_smcias_interfaces.sh;echo;chmod 775 fix_smcias_interfaces.sh;echo;ls -alh fix_smcias_interfaces.sh'

alias versionsdump='echo;echo;uname -a;echo;echo;clish -c "show version all";echo;echo;cpinfo -y all;echo;echo'
alias configdump='echo;gougex;pwd;echo;echo;./config_capture;echo;echo;./healthdump;echo;echo'

