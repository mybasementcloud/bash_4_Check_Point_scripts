#
# Version :  v03.04.00
# Date    :  2019-02-01
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
alias goexportwip='cd $$MYWORKFOLDER/cli_api_ops.wip/export_import.wip'

# 2019-02-01

export MYTFTPSERVER=10.69.248.60
export MYTFTPFOLDER=/__gaia

alias getupdatescripts='gougex;pwd;tftp -v -m binary 10.69.248.60 -c get /__gaia/updatescripts.sh;echo;chmod 775 updatescripts.sh;echo;ls -alh updatescripts.sh'

alias getsetuphostscript='cd /var/log;pwd;tftp -v -m binary 10.69.248.60 -c get /__gaia/setuphost.sh;echo;chmod 775 setuphost.sh;echo;ls -alh setuphost.sh'

export MYSMCFOLDER=/__smcias
alias getfixsmcscript='cd /var/log;pwd;tftp -v -m binary 10.69.248.60 -c get /__smcias/fix_smcias_interfaces.sh;echo;chmod 775 fix_smcias_interfaces.sh;echo;ls -alh fix_smcias_interfaces.sh'


