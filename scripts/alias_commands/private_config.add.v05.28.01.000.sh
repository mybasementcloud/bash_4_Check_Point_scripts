# !! SAMPLE !!
#
# (C) 2016-2022 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
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
ScriptDate=2022-02-24
ScriptVersion=05.28.01
ScriptRevision=000
TemplateVersion=05.28.01
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.28.01
AliasCommandsLevel=075
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
#========================================================================================
# End of alias.commands.<action>.<scope>.sh
#========================================================================================
#========================================================================================


