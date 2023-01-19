# !! SAMPLE !!
#
# (C) 2016-2023 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
# SCRIPT  Private variables configuration for bash shell launch
#
#
ScriptDate=2023-01-18
ScriptVersion=05.33.00
ScriptRevision=000
ScriptSubRevision=000
TemplateVersion=05.33.00
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.33.00
AliasCommandsLevel=090
#

#========================================================================================
#========================================================================================
# start of private_config.<action>.sh
#========================================================================================
#========================================================================================


echo ${tGREEN}'==============================================================================='${tDEFAULT}
echo ${tGREEN}' MyBasementCloud bash 4 Check Point Environmen - Private User Environment'${tDEFAULT}
echo ${tGREEN}' Scripts :  Version '${ScriptVersion}', Revision '${ScriptRevision}', Level '${AliasCommandsLevel}' from Date '${ScriptDate}${tDEFAULT}
echo ${tGREEN}'==============================================================================='${tDEFAULT}
echo
echo ${tGREEN}'Configuring Private User Environment...'${tDEFAULT}
echo


#========================================================================================
# 
#========================================================================================


#========================================================================================
#========================================================================================
# Configure actual details for My TFTP Servers
#========================================================================================
# 2020-11-26 Updated

#
# This section expects definition of the following external variables.  These are usually part of the user profile setup in the ${HOME} folder
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
export MYTFTPSERVER=${MYTFTPSERVER1}
export MYTFTPFOLDER=/__gaia


#========================================================================================
# 
#========================================================================================


#========================================================================================
# Management Policy Installation
#========================================================================================
# 2023-01-18

#if [ "${HOSTNAME}" == "yourhostname" ] ; then
    
    #export PolicyPackage='yourpolicypackage'
    #export PolicyStandard='Standard'
    #export Policy_Target_GW1=yourgateway1
    #export Policy_Target_GW2=yourgateway2
    
    #printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "PolicyPackage" ${PolicyPackage} >> ${tempENVHELPFILEvars}
    #printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "Policy_Target_GW1" ${Policy_Target_GW1} >> ${tempENVHELPFILEvars}
    #printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "Policy_Target_GW2" ${Policy_Target_GW2} >> ${tempENVHELPFILEvars}
    #echo >> ${tempENVHELPFILEvars}
    
    #alias installpolicyaccess='WORKNOWFOLDER="${MYWORKFOLDERDUMP}/`date +%Y`/`DTGSDATE`_install_policy";mkdir -pv "${WORKNOWFOLDER}";list "${MYWORKFOLDERDUMP}/";echo;pushd "${WORKNOWFOLDER}";echo;mgmt_cli -r true install-policy policy-package "${PolicyPackage}" access true threat-prevention false targets.1 "${Policy_Target_GW1}" -f json | tee -a -i installpolicyaccess_`DTGSDATE`.txt;echo;ls -alh --color=auto .;echo;popd;echo Current path = `pwd`;echo'
    #alias installpolicythreat='WORKNOWFOLDER="${MYWORKFOLDERDUMP}/`date +%Y`/`DTGSDATE`_install_policy";mkdir -pv "${WORKNOWFOLDER}";list "${MYWORKFOLDERDUMP}/";echo;pushd "${WORKNOWFOLDER}";echo;mgmt_cli -r true install-policy policy-package "${PolicyPackage}" access false threat-prevention true targets.1 "${Policy_Target_GW1}" -f json | tee -a -i installpolicythreat_`DTGSDATE`.txt;echo;ls -alh --color=auto .;echo;popd;echo Current path = `pwd`;echo'
    #alias installpolicyall='WORKNOWFOLDER="${MYWORKFOLDERDUMP}/`date +%Y`/`DTGSDATE`_install_policy";mkdir -pv "${WORKNOWFOLDER}";list "${MYWORKFOLDERDUMP}/";echo;pushd "${WORKNOWFOLDER}";echo;mgmt_cli -r true install-policy policy-package "${PolicyPackage}" access true threat-prevention true targets.1 "${Policy_Target_GW1}" -f json | tee -a -i installpolicyall_`DTGSDATE`.txt;echo;ls -alh --color=auto .;echo;popd;echo Current path = `pwd`;echo'
    
    #printf "${tCYAN}%-30s${tNORM} : %s\n" "installpolicyaccess" 'Install the Access Control policy '${PolicyPackage}' to target gateway '${Policy_Target_GW1} >> ${tempENVHELPFILEalias}
    #printf "${tCYAN}%-30s${tNORM} : %s\n" "installpolicythreat" 'Install the Threat Prevention policy '${PolicyPackage}' to target gateway '${Policy_Target_GW1} >> ${tempENVHELPFILEalias}
    #printf "${tCYAN}%-30s${tNORM} : %s\n" "installpolicyall" 'Install the complete policy '${PolicyPackage}' to target gateway '${Policy_Target_GW1} >> ${tempENVHELPFILEalias}
    
    #alias installstandardaccess='WORKNOWFOLDER="${MYWORKFOLDERDUMP}/`date +%Y`/`DTGSDATE`_install_policy";mkdir -pv "${WORKNOWFOLDER}";list "${MYWORKFOLDERDUMP}/";echo;pushd "${WORKNOWFOLDER}";echo;mgmt_cli -r true install-policy policy-package "${PolicyStandard}" access true threat-prevention false targets.1 "${Policy_Target_GW2}" -f json | tee -a -i installpolicyaccess_`DTGSDATE`.txt;echo;ls -alh --color=auto .;echo;popd;echo Current path = `pwd`;echo'
    #alias installstandardthreat='WORKNOWFOLDER="${MYWORKFOLDERDUMP}/`date +%Y`/`DTGSDATE`_install_policy";mkdir -pv "${WORKNOWFOLDER}";list "${MYWORKFOLDERDUMP}/";echo;pushd "${WORKNOWFOLDER}";echo;mgmt_cli -r true install-policy policy-package "${PolicyStandard}" access false threat-prevention true targets.1 "${Policy_Target_GW2}" -f json | tee -a -i installpolicythreat_`DTGSDATE`.txt;echo;ls -alh --color=auto .;echo;popd;echo Current path = `pwd`;echo'
    #alias installstadardall='WORKNOWFOLDER="${MYWORKFOLDERDUMP}/`date +%Y`/`DTGSDATE`_install_policy";mkdir -pv "${WORKNOWFOLDER}";list "${MYWORKFOLDERDUMP}/";echo;pushd "${WORKNOWFOLDER}";echo;mgmt_cli -r true install-policy policy-package "${PolicyStandard}" access true threat-prevention true targets.1 "${Policy_Target_GW2}" -f json | tee -a -i installpolicyall_`DTGSDATE`.txt;echo;ls -alh --color=auto .;echo;popd;echo Current path = `pwd`;echo'
    
    #printf "${tCYAN}%-30s${tNORM} : %s\n" "installstandardaccess" 'Install the Access Control policy '${PolicyStandard}' to target gateway '${Policy_Target_GW2} >> ${tempENVHELPFILEalias}
    #printf "${tCYAN}%-30s${tNORM} : %s\n" "installstandardthreat" 'Install the Threat Prevention policy '${PolicyStandard}' to target gateway '${Policy_Target_GW2} >> ${tempENVHELPFILEalias}
    #printf "${tCYAN}%-30s${tNORM} : %s\n" "installstadardall" 'Install the complete policy '${PolicyStandard}' to target gateway '${Policy_Target_GW2} >> ${tempENVHELPFILEalias}
    #echo >> ${tempENVHELPFILEalias}
    
#fi


#========================================================================================


#========================================================================================
#========================================================================================
# End of alias.commands.<action>.<scope>.sh
#========================================================================================
#========================================================================================


