#!/bin/bash
#
# (C) 2016-2024 Eric James Beasley, mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
#
# -#- Start Making Changes Here -#- 
#
# SCRIPT capture configuration values for bash and clish
#
#
ScriptDate=2024-01-28
ScriptVersion=05.36.01
ScriptRevision=000
ScriptSubRevision=000
TemplateVersion=05.36.01
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.36.01
#

export BASHScriptVersion=v${ScriptVersion}
export BASHScriptTemplateVersion=v${TemplateVersion}

export BASHScriptVersionX=v${ScriptVersion//./x}
export BASHScriptTemplateVersionX=v${TemplateVersion//./x}

export BASHScriptTemplateLevel=${TemplateLevel}.v${TemplateVersion}

export BASHSubScriptsVersion=v${SubScriptsVersion}
export BASHSubScriptTemplateVersion=v${TemplateVersion}
export BASHExpectedSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion}

export BASHSubScriptsVersionX=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersionX=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersionX=${SubScriptsLevel}.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=config_capture
export BASHScriptShortName="config_capture"
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Configuration Capture for bash and clish"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}.v${ScriptVersion}

export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}
export BASHScriptHelpFileExamplesName=${BASHScriptFileNameRoot}.examples.help
export BASHScriptHelpExamplesFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileExamplesName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|scripts_tools|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=Config

export BASHScripttftptargetfolder="host_data"


# =================================================================================================
# =================================================================================================
# START: Root Configuration
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Output formating values
# -------------------------------------------------------------------------------------------------

export txtCLEAR=`tput clear`

export txtNORM=`tput sgr0`
export txtBOLD=`tput bold`
export txtDIM=`tput dim`
export txtREVERSE=`tput rev`

export txtULINEbeg=`tput smul`
export txtULINEend=`tput rmul`

export txtSTANDOUTbeg=`tput smso`
export txtSTANDOUTend=`tput rmso`

export getWindowColumns=`tput cols`
export getWindowLines=`tput lines`


#tput setab color  Set ANSI Background color
#tput setaf color  Set ANSI Foreground color
export txtBLACK=`tput setaf 0`
export txtRED=`tput setaf 1`
export txtGREEN=`tput setaf 2`
export txtYELLOW=`tput setaf 3`
export txtBLUE=`tput setaf 4`
export txtMAGENTA=`tput setaf 5`
export txtCYAN=`tput setaf 6`
export txtWHITE=`tput setaf 7`
export txtDEFAULT=`tput setaf 9`

export txtbkgBLACK=`tput setab 0`
export txtbkgRED=`tput setab 1`
export txtbkgGREEN=`tput setab 2`
export txtbkgYELLOW=`tput setab 3`
export txtbkgBLUE=`tput setab 4`
export txtbkgMAGENTA=`tput setab 5`
export txtbkgCYAN=`tput setab 6`
export txtbkgWHITE=`tput setab 7`
export txtbkgDEFAULT=`tput setab 9`


# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

export DATEUTC=`date -u +%Y-%m-%d-%H%M%Z`
export DATEUTCDTG=`date -u +%Y-%m-%d-%H%M%Z`
export DATEUTCDTGS=`date -u +%Y-%m-%d-%H%M%S%Z`
export DATEUTCYMD=`date -u +%Y-%m-%d`


# -------------------------------------------------------------------------------------------------
# Script key folders and files variable configuration
# -------------------------------------------------------------------------------------------------

export customerpathroot=/var/log/__customer
export customerworkpathroot=${customerpathroot}/upgrade_export

export scriptspathroot=${customerworkpathroot}/scripts

export subscriptsfolder=_subscripts

export rootscriptconfigfile=__root_script_config.sh


# -------------------------------------------------------------------------------------------------
# Script Operations Control variable configuration
# -------------------------------------------------------------------------------------------------


#
# -#- Start Making Changes Here -#- 
#


WAITTIME=20

B4CPSCRIPTVERBOSE=false


# -------------------------------------------------------------------------------------------------
# R8X API variable configuration
# -------------------------------------------------------------------------------------------------


# MODIFIED 2022-10-27 -
# R80           version 1.0
# R80.10        version 1.1
# R80.20.M1     version 1.2
# R80.20 GA     version 1.3
# R80.20.M2     version 1.4
# R80.30        version 1.5
# R80.40        version 1.6
# R80.40 JHF 78 version 1.6.1
# R81           version 1.7
# R81 JHF 34    version 1.7.1
# R81.10        version 1.8
# R81.10 JHF 79 version 1.8.1
# R81.20        version 1.9
#
# For common scripts minimum API version at 1.1 should suffice, otherwise get explicit
# To enable use of API Key authentication, at least version 1.6 is required
#
export MinAPIVersionRequired=1.1

# ADDED 2022-03-09 - 
#    
#    mgmt_cli command-name command-parameters optional-switches
#    
#    optional-switches:
#    ---------------
#    [--conn-timeout]
#            Defines maximum time the request is allowed to take in seconds.
#            Default {180}
#            Environment variable: MGMT_CLI_CONNECTION_TIMEOUT
#
export APICLIconntimeout=600

# ADDED 2021-11-09 - 
# MaaS (Smart-1 Cloud) current versions
# R81           version 1.7
# R81 JHF 34    version 1.7.1  !! ????
# R81.10        version 1.8
#
# for MaaS (Smart-1 Cloud) operation assume at least the minimum API version as 1.7 for R81
#
export MinMaaSAPIVersion=1.7
export MaxMaaSAPIVersion=1.8

# If the API version needs to be enforced in commands set this to true
# NOTE not currently used!
#
export ForceAPIVersionToMinimum=false

export R8XRequired=false
export UseR8XAPI=false
export UseJSONJQ=true
export UseJSONJQ16=true
export JQ16Required=false


# -------------------------------------------------------------------------------------------------
# Log file and logging control variables
# -------------------------------------------------------------------------------------------------


# Configure output file folder target
# One of these needs to be set to true, just one
#
export OutputToRoot=false
export OutputToDump=false
export OutputToChangeLog=false
export OutputToOther=true
#
# if OutputToOther is true, then this next value needs to be set
#
export OtherOutputFolder=./host_data

# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-12 -
# if we are date-time stamping the output location as a subfolder of the 
# output folder set this to true,  otherwise it needs to be false
#
# OutputEnableLogFile             : true|false : log output to log file
#
# OutputYearSubfolder             : true|false : Add a folder level with just the year (YYYY)
# OutputYMSubfolder               : true|false : Add a folder level with the year-month (YYYY-MM)
# OutputDTGSSubfolder             : true|false : Add a folder level with Date Time Group with Seconds (YYYY-MM-DD-HHmmSS)
# Append script name to output subfolder, only one of these should be true, ignored if both are false
# OutputSubfolderScriptName       : true|false : Add full script name to folder name of output folder
#                                 :: setting this value true will override OutputSubfolderScriptShortName
# OutputSubfolderScriptShortName  : true|false : Add short script name to folder name of output folder
#
# OutputDTGTZinUTC                : true|false : Instead of using the local timezone in logs use UTC timezone
#

export OutputEnableLogFile=true

export OutputYearSubfolder=true
export OutputYMSubfolder=false
export OutputDTGSSubfolder=true
export OutputSubfolderScriptName=false
export OutputSubfolderScriptShortName=false

export OutputDTGTZinUTC=false


# -------------------------------------------------------------------------------------------------
# Local initial logfile variables
# -------------------------------------------------------------------------------------------------


export logfilefolderroot=/var/log/tmp/b4CPscripts
export logfilefoldername=${BASHScriptName}


# -------------------------------------------------------------------------------------------------
# logfile configuration
# -------------------------------------------------------------------------------------------------


# ADDED 2020-12-22
# we need the quick version of the gaiaversion
cpreleasefile=/etc/cp-release
export getgaiaquickversion=$(cat ${cpreleasefile} | cut -d " " -f 4)
export gaiaquickversion=${getgaiaquickversion}

# setup initial log file for output logging
export logfilefolder=${logfilefolderroot}/${logfilefoldername}
if $OutputDTGTZinUTC ; then
    export logfilepath=${logfilefolder}/${BASHScriptName}.${HOSTNAME}.${gaiaquickversion}.${DATEUTCDTGS}.log
else
    export logfilepath=${logfilefolder}/${BASHScriptName}.${HOSTNAME}.${gaiaquickversion}.${DATEDTGS}.log
fi

if ${OutputEnableLogFile} ; then
    # We are logging, so create the initial working folder and log file
    if [ ! -w ${logfilefolder} ]; then
        mkdir -pv ${logfilefolder} > /dev/null
    fi
    
    touch ${logfilepath}
    
    echo
else
    # We are NOT logging, so don't create the initial working folder and log file
    # set the logfilepath to device null /dev/null to squelch the output
    
    export logfilepath=/dev/null
    echo
fi


# -------------------------------------------------------------------------------------------------
# Variables for check operation in users home path
# -------------------------------------------------------------------------------------------------


# MODIFIED 2021-02-13 -
export notthispath=/home/
export localdotpathroot=.

# MODIFIED 2020-11-20 -
export localdotpath=`pwd`
export currentlocalpath=${localdotpath}
export workingpath=${currentlocalpath}

# MODIFIED 2021-02-13 -
export expandedpath=$(cd ${localdotpathroot} ; pwd)
export startpathroot=${expandedpath}


# -------------------------------------------------------------------------------------------------
# Gaia and installation type handling
# -------------------------------------------------------------------------------------------------


#
# -#- Start Making Changes Here -#- 
#


export UseGaiaVersionAndInstallation=true
export ShowGaiaVersionResults=true
export KeepGaiaVersionResultsFile=true


# -------------------------------------------------------------------------------------------------
# Configure variables for subscripts calls
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-13 -

# Configure basic information for formation of file path for basic script setup handler script
#
# basic_script_setup_handler_root - root path to command line parameter handler script
# basic_script_setup_handler_folder - folder for under root path to command line parameter handler script
# basic_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export basic_script_setup_handler_root=${scriptspathroot}
export basic_script_setup_handler_folder=${subscriptsfolder}
export basic_script_setup_handler_name=basic_script_setup
export basic_script_setup_handler_file=${basic_script_setup_handler_name}.subscript.${SubScriptsLevel}.v${SubScriptsVersion}.sh


# Configure basic information for formation of file path for command line parameter handler script
#
# cli_script_cmdlineparm_handler_root - root path to command line parameter handler script
# cli_script_cmdlineparm_handler_folder - folder for under root path to command line parameter handler script
# cli_script_cmdlineparm_handler_file - filename, without path, for command line parameter handler script
#
export cli_script_cmdlineparm_handler_root=${scriptspathroot}
export cli_script_cmdlineparm_handler_folder=${subscriptsfolder}
export cli_script_cmdlineparm_handler_name=cmd_line_parameters_handler
export cli_script_cmdlineparm_handler_file=${cli_script_cmdlineparm_handler_name}.subscript.${SubScriptsLevel}.v${SubScriptsVersion}.sh


# Configure basic information for formation of file path for configure script output paths and folders handler script
#
# script_output_paths_and_folders_handler_root - root path to configure script output paths and folders handler script
# script_output_paths_and_folders_handler_folder - folder for under root path to configure script output paths and folders handler script
# script_output_paths_and_folders_handler_file - filename, without path, for configure script output paths and folders handler script
#
export script_output_paths_and_folders_handler_root=${scriptspathroot}
export script_output_paths_and_folders_handler_folder=${subscriptsfolder}
export script_output_paths_and_folders_handler_name=script_output_paths_and_folders
export script_output_paths_and_folders_handler_file=${script_output_paths_and_folders_handler_name}.subscript.${SubScriptsLevel}.v${SubScriptsVersion}.sh


# Configure basic information for formation of file path for gaia version and type handler script
#
# gaia_version_type_handler_root - root path to gaia version and type handler script
# gaia_version_type_handler_folder - folder for under root path to gaia version and type handler script
# gaia_version_type_handler_file - filename, without path, for gaia version and type handler script
#
export gaia_version_type_handler_root=${scriptspathroot}
export gaia_version_type_handler_folder=${subscriptsfolder}
export gaia_version_type_handler_name=gaia_version_installation_type
export gaia_version_type_handler_file=${gaia_version_type_handler_name}.subscript.${SubScriptsLevel}.v${SubScriptsVersion}.sh


# Configure basic information for API mgmt_cli operations handler script
#
# mgmt_cli_api_ops_handler_root - root path to API mgmt_cli operations handler script
# mgmt_cli_api_ops_handler_folder - folder for under root path to API mgmt_cli operations handler script
# mgmt_cli_api_ops_handler_file - filename, without path, for API mgmt_cli operations handler script
#
export mgmt_cli_api_ops_handler_root=${scriptspathroot}
export mgmt_cli_api_ops_handler_folder=${subscriptsfolder}
export mgmt_cli_api_ops_handler_name=mgmt_cli_api_operations
export mgmt_cli_api_ops_handler_file=${mgmt_cli_api_ops_handler_name}.subscript.${SubScriptsLevel}.v${SubScriptsVersion}.sh


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# END:  Root Configuration
# =================================================================================================
# =================================================================================================


#==================================================================================================
#==================================================================================================
#==================================================================================================
# Start of template 
#==================================================================================================
#==================================================================================================


# MOVED 2020-11-12 -
#==================================================================================================
# Announce Script, this should also be the first log entry!
#==================================================================================================


# MODIFIED 2023-02-17:01 -

echo | tee -a -i ${logfilepath}
echo ${txtCYAN}${BASHScriptName}${txtDEFAULT}', script version '${txtYELLOW}${ScriptVersion}${txtDEFAULT}', revision '${txtYELLOW}${ScriptRevision}${txtDEFAULT}', subrevision '${txtGREEN}${ScriptSubRevision}${txtDEFAULT}' from '${txtYELLOW}${ScriptDate}${txtDEFAULT} | tee -a -i ${logfilepath}
echo ${BASHScriptDescription} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Date Time Group   :  '${txtCYAN}${DATEDTGS}${txtDEFAULT} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# -------------------------------------------------------------------------------------------------
# Quick Gaia main train version check for R8X release
# -------------------------------------------------------------------------------------------------


# MODIFIED/MOVED 2020-12-22 -

if [ -z ${gaiaversion} ] ; then
    
    cpreleasefile=/etc/cp-release
    export getgaiaquickversion=$(cat ${cpreleasefile} | cut -d " " -f 4)
    export gaiaversion=${getgaiaquickversion}
    
fi

export checkR77version=`echo "${FWDIR}" | grep -i "R77"`
export checkifR77version=`test -z ${checkR77version}; echo $?`
if [ ${checkifR77version} -eq 1 ] ; then
    export isitR77version=true
else
    export isitR77version=false
fi
#echo ${isitR77version}

export checkR8Xversion=`echo "${FWDIR}" | grep -i "R8"`
export checkifR8Xversion=`test -z ${checkR8Xversion}; echo $?`
if [ ${checkifR8Xversion} -eq 1 ] ; then
    export isitR8Xversion=true
else
    export isitR8Xversion=false
fi
#echo ${isitR8Xversion}


if ${isitR77version}; then
    echo "This is an R77.X version..." >> ${logfilepath}
    export UseR8XAPI=false
    export UseJSONJQ=false
    export UseJSONJQ16=false
elif ${isitR8Xversion}; then
    echo "This is an R8X version..." >> ${logfilepath}
    export UseR8XAPI=${UseR8XAPI}
    export UseJSONJQ=${UseJSONJQ}
    export UseJSONJQ16=${UseJSONJQ16}
else
    echo "This is not an R77.X or R8X version ????" >> ${logfilepath}
fi


# =================================================================================================
# =================================================================================================
# START:  Local Command Line Parameter Handling and Help Configuration and Local Handling
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Define command line parameters and set appropriate values
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-19 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# Standard Scripts and R8X API Scripts Command Line Parameters
#
# -? | --help
# -v | --verbose
# -P <web-ssl-port> | --port <web-ssl-port> | -P=<web-ssl-port> | --port=<web-ssl-port>
# -r | --root
# -u <admin_name> | --user <admin_name> | -u=<admin_name> | --user=<admin_name>
# -p <password> | --password <password> | -p=<password> | --password=<password>
# --api-key "<api_key_value>" | --api-key="<api_key_value>" 
# -m <server_IP> | --management <server_IP> | -m=<server_IP> | --management=<server_IP>
# -d <domain> | --domain <domain> | -d=<domain> | --domain=<domain>
# -s <session_file_filepath> | --session-file <session_file_filepath> | -s=<session_file_filepath> | --session-file=<session_file_filepath>
# --session-timeout <session_time_out> 10-3600
# -l <log_path> | --log-path <log_path> | -l=<log_path> | --log-path=<log_path>'
#
# -o <output_path> | --output <output_path> | -o=<output_path> | --output=<output_path> 
#
# --NOWAIT
#
# --NOSTART
# --RESTART
#
# --NOHUP
# --NOHUP-Script <NOHUP_SCRIPT_NAME> | --NOHUP-Script=<NOHUP_SCRIPT_NAME>
# --NOHUP-DTG <NOHUP_SCRIPT_DATE_TIME_GROUP> | --NOHUP-DTG=<NOHUP_SCRIPT_DATE_TIME_GROUP>
# --NOHUP-PATH <NOHUP_SCRIPT_EXECUTION_PATH> | --NOHUP-PATH=<NOHUP_SCRIPT_EXECUTION_PATH>
#

export SHOWHELP=false
# MODIFIED 2018-09-29 -
#export CLIparm_websslport=443
export CLIparm_websslport=
export CLIparm_rootuser=false
export CLIparm_user=
export CLIparm_password=
export CLIparm_mgmt=
export CLIparm_domain=
export CLIparm_sessionidfile=
export CLIparm_sessiontimeout=
export CLIparm_logpath=

export CLIparm_outputpath=

# ADDED 2020-08-19 -
export CLIparm_api_key=
export CLIparm_use_api_key=false

# --NOWAIT
#

export CLIparm_NOWAIT=false

if [ -z "${NOWAIT}" ]; then
    # NOWAIT mode not set from shell level
    export CLIparm_NOWAIT=false
    export NOWAIT=false
elif [ x"`echo "${NOWAIT}" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    # NOWAIT mode set OFF from shell level
    export CLIparm_NOWAIT=false
    export NOWAIT=false
elif [ x"`echo "${NOWAIT}" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
    # NOWAIT mode set ON from shell level
    export CLIparm_NOWAIT=true
    export NOWAIT=true
else
    # NOWAIT mode set to wrong value from shell level
    export CLIparm_NOWAIT=false
    export NOWAIT=false
fi

# --NOSTART
#

export CLIparm_NOSTART=false

if [ -z "${NOSTART}" ]; then
    # NOSTART mode not set from shell level
    export CLIparm_NOSTART=false
    export NOSTART=false
elif [ x"`echo "${NOSTART}" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    # NOSTART mode set OFF from shell level
    export CLIparm_NOSTART=false
    export NOSTART=false
elif [ x"`echo "${NOSTART}" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
    # NOSTART mode set ON from shell level
    export CLIparm_NOSTART=true
    export NOSTART=true
else
    # NOSTART mode set to wrong value from shell level
    export CLIparm_NOSTART=false
    export NOSTART=false
fi

# MODIFIED 2021-02-13 -
export CLIparm_NOHUP=false
export CLIparm_NOHUPScriptName=
export CLIparm_NOHUPDTG=
export CLIparm_NOHUPPATH=

export REMAINS=

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-11-19


# -------------------------------------------------------------------------------------------------
# Define local command line parameter CLIparm values
# -------------------------------------------------------------------------------------------------


#
# -#- Start Making Changes Here -#- 
#


#export CLIparm_local1=

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# processcliremains - Local command line parameter processor
# -------------------------------------------------------------------------------------------------


#
# -#- Start Making Changes Here -#- 
#


processcliremains () {
    #
    
    # -------------------------------------------------------------------------------------------------
    # Process command line parameters from the REMAINS returned from the standard handler
    # -------------------------------------------------------------------------------------------------
    
    while [ -n "$1" ]; do
        # Copy so we can modify it (can't modify $1)
        OPT="$1"
        
        # testing
        echo 'OPT = '${OPT}
        #
            
        # Detect argument termination
        if [ x"${OPT}" = x"--" ]; then
            
            shift
            for OPT ; do
                # MODIFIED 2019-03-08
                #LOCALREMAINS="${LOCALREMAINS} \"${OPT}\""
                LOCALREMAINS="${LOCALREMAINS} ${OPT}"
            done
            break
        fi
        # Parse current opt
        while [ x"${OPT}" != x"-" ] ; do
            case "${OPT}" in
                # Help and Standard Operations
                '-?' | --help )
                    SHOWHELP=true
                    ;;
                # Handle --flag=value opts like this
                -q=* | --qlocal1=* )
                    CLIparm_local1="${OPT#*=}"
                    #shift
                    ;;
                # and --flag value opts like this
                -q* | --qlocal1 )
                    CLIparm_local1="$2"
                    shift
                    ;;
                # Anything unknown is recorded for later
                * )
                    # MODIFIED 2019-03-08
                    #LOCALREMAINS="${LOCALREMAINS} \"${OPT}\""
                    LOCALREMAINS="${LOCALREMAINS} ${OPT}"
                    break
                    ;;
            esac
            # Check for multiple short options
            # NOTICE: be sure to update this pattern to match valid options
            # Remove any characters matching "-", and then the values between []'s
            #NEXTOPT="${OPT#-[upmdsor?]}" # try removing single short opt
            NEXTOPT="${OPT#-[vrf?]}" # try removing single short opt
            if [ x"${OPT}" != x"${NEXTOPT}" ] ; then
                OPT="-${NEXTOPT}"  # multiple short opts, keep going
            else
                break  # long form, exit inner loop
            fi
        done
        # Done with that param. move to next
        shift
    done
    # Set the non-parameters back into the positional parameters ($1 $2 ..)
    eval set -- ${LOCALREMAINS}
    
    export CLIparm_local1=$CLIparm_local1

}


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# dumpcliparmparselocalresults
# -------------------------------------------------------------------------------------------------

#
# -#- Start Making Changes Here -#- 
#
# MODIFIED 2020-09-11 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

dumpcliparmparselocalresults () {
    
    #
    # Testing - Dump acquired local values
    #
    #
    workoutputfile=/var/tmp/workoutputfile.2.${DATEDTGS}.txt
    echo > ${workoutputfile}
    
    # Screen width template for sizing, default width of 80 characters assumed
    #
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    
    echo 'Local CLI Parameters :' >> ${workoutputfile}
    echo >> ${workoutputfile}
    
    #echo 'CLIparm_local1          = '$CLIparm_local1 >> ${workoutputfile}
    #echo 'CLIparm_local2          = '$CLIparm_local2 >> ${workoutputfile}
    echo  >> ${workoutputfile}
    echo 'LOCALREMAINS            = '${LOCALREMAINS} >> ${workoutputfile}
    
    if ${B4CPSCRIPTVERBOSE} ; then
        # Verbose mode ON
        
        echo | tee -a -i ${logfilepath}
        cat ${workoutputfile} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        for i ; do echo - $i | tee -a -i ${logfilepath} ; done
        echo | tee -a -i ${logfilepath}
        echo CLI parms - number "$#" parms "$@" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if ! ${NOWAIT} ; then
            read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey
            echo
        fi
        
        echo | tee -a -i ${logfilepath}
        echo "End of local execution" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    
    else
        # Verbose mode OFF
        
        echo >> ${logfilepath}
        cat ${workoutputfile} >> ${logfilepath}
        echo >> ${logfilepath}
        for i ; do echo - $i >> ${logfilepath} ; done
        echo >> ${logfilepath}
        echo CLI parms - number "$#" parms "$@" >> ${logfilepath}
        echo >> ${logfilepath}
        
    fi
    
    rm ${workoutputfile}
}


#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-09-11


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# End:  Local Command Line Parameter Handling and Help Configuration and Local Handling
# =================================================================================================
# =================================================================================================


# =================================================================================================
# =================================================================================================
# START:  Command Line Parameter Handling and Help
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# dumprawcliremains
# -------------------------------------------------------------------------------------------------

dumprawcliremains () {
    #
    if ${B4CPSCRIPTVERBOSE} ; then
        # Verbose mode ON
        
        echo | tee -a -i ${logfilepath}
        echo "Command line parameters remains : " | tee -a -i ${logfilepath}
        echo "Number parms $#" | tee -a -i ${logfilepath}
        echo "remains raw : \> $@ \<" | tee -a -i ${logfilepath}
        
        parmnum=0
        for k ; do
            echo -e "${parmnum} \t ${k}" | tee -a -i ${logfilepath}
            parmnum=`expr ${parmnum} + 1`
        done
        
        echo | tee -a -i ${logfilepath}
        
    else
        # Verbose mode OFF
        
        echo >> ${logfilepath}
        echo "Command line parameters remains : " >> ${logfilepath}
        echo "Number parms $#" >> ${logfilepath}
        echo "remains raw : \> $@ \<" >> ${logfilepath}
        
        parmnum=0
        for k ; do
            echo -e "${parmnum} \t ${k}" >> ${logfilepath}
            parmnum=`expr ${parmnum} + 1`
        done
        
        echo >> ${logfilepath}
        
    fi

}


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# CommandLineParameterHandler - Command Line Parameter Handler calling routine
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-11-20 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CommandLineParameterHandler () {
    #
    # CommandLineParameterHandler - Command Line Parameter Handler calling routine
    #
    
    # -------------------------------------------------------------------------------------------------
    # Check Command Line Parameter Handlerr action script exists
    # -------------------------------------------------------------------------------------------------
    
    # MODIFIED 2018-11-20 -
    
    export configured_handler_root=${cli_script_cmdlineparm_handler_root}
    export actual_handler_root=${configured_handler_root}
    
    if [ "${configured_handler_root}" == "." ] ; then
        if [ ${ScriptSourceFolder} != ${localdotpath} ] ; then
            # Script is not running from it's source folder, might be linked, so since we expect the handler folder
            # to be relative to the script source folder, use the identified script source folder instead
            export actual_handler_root=${ScriptSourceFolder}
        else
            # Script is running from it's source folder
            export actual_handler_root=${configured_handler_root}
        fi
    else
        # handler root path is not period (.), so stipulating fully qualified path
        export actual_handler_root=${configured_handler_root}
    fi
    
    export cli_script_cmdlineparm_handler_path=${actual_handler_root}/${cli_script_cmdlineparm_handler_folder}
    export cli_script_cmdlineparm_handler=${cli_script_cmdlineparm_handler_path}/${cli_script_cmdlineparm_handler_file}
    
    # Check that we can finde the command line parameter handler file
    #
    if [ ! -r ${cli_script_cmdlineparm_handler} ] ; then
        # no file found, that is a problem
        if ${B4CPSCRIPTVERBOSE} ; then
            echo | tee -a -i ${logfilepath}
            echo 'Command Line Parameter handler script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${cli_script_cmdlineparm_handler} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Other parameter elements : ' | tee -a -i ${logfilepath}
            echo '  Configured Root path    : '${configured_handler_root} | tee -a -i ${logfilepath}
            echo '  Actual Script Root path : '${actual_handler_root} | tee -a -i ${logfilepath}
            echo '  Root of folder path : '${cli_script_cmdlineparm_handler_root} | tee -a -i ${logfilepath}
            echo '  Folder in Root path : '${cli_script_cmdlineparm_handler_folder} | tee -a -i ${logfilepath}
            echo '  Folder Root path    : '${cli_script_cmdlineparm_handler_path} | tee -a -i ${logfilepath}
            echo '  Script Filename     : '${cli_script_cmdlineparm_handler_file} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        else
            echo | tee -a -i ${logfilepath}
            echo 'Command Line Parameter handler script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${cli_script_cmdlineparm_handler} | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        fi
        
        exit 251
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Call Command Line Parameter Handlerr action script exists
    # -------------------------------------------------------------------------------------------------
    
    if ${B4CPSCRIPTVERBOSE} ; then
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo "Calling external Command Line Paramenter Handling Script" | tee -a -i ${logfilepath}
        echo " - External Script : "${cli_script_cmdlineparm_handler} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    . ${cli_script_cmdlineparm_handler} "$@"
    
    if ${B4CPSCRIPTVERBOSE} ; then
        echo | tee -a -i ${logfilepath}
        echo "Returned from external Command Line Paramenter Handling Script" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if ! ${NOWAIT} ; then
            read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey
            echo
        fi
        
        echo | tee -a -i ${logfilepath}
        echo "Starting local execution" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-10-03

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Call command line parameter handler action script
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-10-03 -
    
CommandLineParameterHandler "$@"

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Handle locally defined command line parameters
# -------------------------------------------------------------------------------------------------

# Check if we have left over parameters that might be handled locally
#
if [ -n "${REMAINS}" ]; then
     
    dumprawcliremains ${REMAINS}
    
    processcliremains ${REMAINS}
    
    # MODIFIED 2019-03-08
    
    dumpcliparmparselocalresults ${REMAINS}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# END:  Command Line Parameter Handling and Help
# =================================================================================================
# =================================================================================================


# =================================================================================================
# =================================================================================================
# START: Root Procedures
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# CheckAndUnlockGaiaDB - Check and Unlock Gaia database
# -------------------------------------------------------------------------------------------------

# MODIFIED 2023-02-17 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CheckAndUnlockGaiaDB () {
    #
    # CheckAndUnlockGaiaDB - Check and Unlock Gaia database
    #
    
    echo -n 'Unlock gaia database : '
    
    export gaiadbunlocked=false
    
    until ${gaiadbunlocked} ; do
        
        export checkgaiadblocked=$(clish -i -c 'lock database override' | grep -i 'owned')
        export isclishowned=$(test -z ${checkgaiadblocked}; echo $?)
        
        if [ ${isclishowned} -eq 1 ]; then 
            echo -n '.'
            export gaiadbunlocked=false
        else
            echo -n '!'
            export gaiadbunlocked=true
        fi
        
    done
    
    echo; echo
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2023-02-17

#CheckAndUnlockGaiaDB

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# GetScriptSourceFolder - Get the actual source folder for the running script
# -------------------------------------------------------------------------------------------------

# MODIFIED 2021-02-13 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

GetScriptSourceFolder () {
    #
    # repeated procedure description
    #
    
    echo >> ${logfilepath}
    
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "${SOURCE}" ]; do # resolve ${SOURCE} until the file is no longer a symlink
        TARGET="$(readlink "${SOURCE}")"
        if [[ ${TARGET} == /* ]]; then
            echo "SOURCE '${SOURCE}' is an absolute symlink to '${TARGET}'" >> ${logfilepath}
            SOURCE="${TARGET}"
        else
            DIR="$( dirname "${SOURCE}" )"
            echo "SOURCE '${SOURCE}' is a relative symlink to '${TARGET}' (relative to '${DIR}')" >> ${logfilepath}
            SOURCE="${DIR}/${TARGET}" # if ${SOURCE} was a relative symlink, we need to resolve it relative to the path where the symlink file was located
        fi
    done
    
    echo "SOURCE is '${SOURCE}'" >> ${logfilepath}
    
    RDIR="$( dirname "${SOURCE}" )"
    DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
    if [ "${DIR}" != "${RDIR}" ]; then
        echo "DIR '${RDIR}' resolves to '${DIR}'" >> ${logfilepath}
    fi
    echo "DIR is '${DIR}'" >> ${logfilepath}
    
    export ScriptSourceFolder=${DIR}
    echo "ScriptSourceFolder is '${ScriptSourceFolder}'" >> ${logfilepath}
    
    echo >> ${logfilepath}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2021-02-13

#GetScriptSourceFolder

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# REMOVED 2020-11-13 -


# -------------------------------------------------------------------------------------------------
# DoBasicScriptSetup - Setup and call configure script basic setup handler action script
# -------------------------------------------------------------------------------------------------

# ADDED 2020-11-13 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

DoBasicScriptSetup () {
    #
    # Setup and call configure script basic setup handler action script
    #
    
    export basic_script_setup_handler_path=${basic_script_setup_handler_root}/${basic_script_setup_handler_folder}
    
    export basic_script_setup_handler=${basic_script_setup_handler_path}/${basic_script_setup_handler_file}
    
    # -------------------------------------------------------------------------------------------------
    # Check script basic setup handler action script exists
    # -------------------------------------------------------------------------------------------------
    
    # Check that we can finde the script basic setup handler action script file
    #
    if [ ! -r ${basic_script_setup_handler} ] ; then
        # no file found, that is a problem
        if ${B4CPSCRIPTVERBOSE} ; then
            echo | tee -a -i ${logfilepath}
            echo 'script basic setup handler action script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${basic_script_setup_handler} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Other parameter elements : ' | tee -a -i ${logfilepath}
            echo '  Root of folder path : '${basic_script_setup_handler_root} | tee -a -i ${logfilepath}
            echo '  Folder in Root path : '${basic_script_setup_handler_folder} | tee -a -i ${logfilepath}
            echo '  Folder Root path    : '${basic_script_setup_handler_path} | tee -a -i ${logfilepath}
            echo '  Script Filename     : '${basic_script_setup_handler_file} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        else
            echo | tee -a -i ${logfilepath}
            echo 'script basic setup handler action script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${basic_script_setup_handler} | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        fi
        
        exit 251
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Call script basic setup handler action script
    # -------------------------------------------------------------------------------------------------
    
    #
    # script basic setup handler action script calling routine
    #
    
    if ${B4CPSCRIPTVERBOSE} ; then
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo "Calling external Configure script output paths and folders Handling Script" | tee -a -i ${logfilepath}
        echo " - External Script : "${basic_script_setup_handler} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    . ${basic_script_setup_handler} "$@"
    
    if ${B4CPSCRIPTVERBOSE} ; then
        echo | tee -a -i ${logfilepath}
        echo "Returned from external Configure script basic setup Handling Script" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if ! ${NOWAIT} ; then
            read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey
            echo
        fi
        
        echo | tee -a -i ${logfilepath}
        echo "Continueing local execution" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/- ADDED 2020-11-13

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# END:  Root Procedures
# =================================================================================================
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Root Operations
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Script Source Folder
# -------------------------------------------------------------------------------------------------
# We need the Script's actual source folder to find subscripts
#
GetScriptSourceFolder

# -------------------------------------------------------------------------------------------------
# Execute basic script setup
# -------------------------------------------------------------------------------------------------

DoBasicScriptSetup "$@"


# -------------------------------------------------------------------------------------------------
# END:  Root Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#
# -#- Start Making Changes Here -#- 
#


# -------------------------------------------------------------------------------------------------
# Validate we are working on a system that handles this operation
# -------------------------------------------------------------------------------------------------

case "${gaiaversion}" in
    R80 | R80.10 | R80.20.M1 | R80.20.M2 | R80.20 | R80.30 | R80.40 ) 
        export IsR8XVersion=true
        ;;
    R81 | R81.10 | R81.20 ) 
        export IsR8XVersion=true
        ;;
    R82 ) 
        export IsR8XVersion=true
        ;;
    *)
        export IsR8XVersion=false
        ;;
esac

if ${R8XRequired} && ! ${IsR8XVersion}; then
    # we expect to run on R8X versions, so this is not where we want to execute
    echo "System is running Gaia version '${gaiaversion}', which is not supported!" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo "This script is not meant for versions prior to R80, exiting!" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'Output location for all results is here : '${outputpathbase} | tee -a -i ${logfilepath}
    echo 'Log results documented in this log file : '${logfilepath} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 255
fi

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#==================================================================================================
#==================================================================================================
# End of template 
#==================================================================================================
#==================================================================================================
#==================================================================================================


#----------------------------------------------------------------------------------------
# Setup Basic Parameters
#----------------------------------------------------------------------------------------


#==================================================================================================
#==================================================================================================
#
# START :  Collect and Capture Configuration and Information data
#
#==================================================================================================
#==================================================================================================


#----------------------------------------------------------------------------------------
# Configure specific parameters
#----------------------------------------------------------------------------------------

export targetversion=${gaiaversion}

export outputfilepath=${outputpathbase}/
export outputfileprefix=${HOSTNAME}'_'${targetversion}
export outputfilesuffix='_'${DATEDTGS}
export outputfiletype=.txt

if [ ! -r ${outputfilepath} ] ; then
    mkdir -pv ${outputfilepath} | tee -a -i ${logfilepath}
    chmod 775 ${outputfilepath} | tee -a -i ${logfilepath}
else
    chmod 775 ${outputfilepath} | tee -a -i ${logfilepath}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#==================================================================================================
# -------------------------------------------------------------------------------------------------
# START :  Action Script Procedures
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# DoConfigActionScriptSetup - Setup and call configuration capture action script handler action script
# -------------------------------------------------------------------------------------------------

# ADDED 2023-02-17 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

DoConfigActionScriptSetup () {
    #
    # Setup and call configure script basic setup handler action script
    #
    #export action_script_setup_handler_root=${scriptspathroot}
    #export action_script_setup_handler_folder=Config
    #export action_script_setup_handler_name=config_details_capture.action_script.XXX
    #export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh
    
    export action_script_setup_handler_path=${action_script_setup_handler_root}/${action_script_setup_handler_folder}
    
    export action_script_setup_handler=${action_script_setup_handler_path}/${action_script_setup_handler_file}
    
    # -------------------------------------------------------------------------------------------------
    # Check script basic setup handler action script exists
    # -------------------------------------------------------------------------------------------------
    
    # Check that we can finde the script basic setup handler action script file
    #
    if [ ! -r ${action_script_setup_handler} ] ; then
        # no file found, that is a problem
        if ${B4CPSCRIPTVERBOSE} ; then
            echo | tee -a -i ${logfilepath}
            echo 'script basic setup handler action script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${action_script_setup_handler} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Other parameter elements : ' | tee -a -i ${logfilepath}
            echo '  Root of folder path : '${action_script_setup_handler_root} | tee -a -i ${logfilepath}
            echo '  Folder in Root path : '${action_script_setup_handler_folder} | tee -a -i ${logfilepath}
            echo '  Folder Root path    : '${action_script_setup_handler_path} | tee -a -i ${logfilepath}
            echo '  Script Filename     : '${action_script_setup_handler_file} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        else
            echo | tee -a -i ${logfilepath}
            echo 'script basic setup handler action script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${action_script_setup_handler} | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        fi
        
        exit 251
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Call script basic setup handler action script
    # -------------------------------------------------------------------------------------------------
    
    #
    # script basic setup handler action script calling routine
    #
    
    if ${B4CPSCRIPTVERBOSE} ; then
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo "Calling external Configuration Action script output paths and folders Handling Script" | tee -a -i ${logfilepath}
        echo " - External Script : "${action_script_setup_handler} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    . ${action_script_setup_handler} "$@"
    
    if ${B4CPSCRIPTVERBOSE} ; then
        echo | tee -a -i ${logfilepath}
        echo "Returned from external Configuration Action script basic setup Handling Script" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if ! ${NOWAIT} ; then
            read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey
            echo
        fi
        
        echo | tee -a -i ${logfilepath}
        echo "Continueing local execution" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/- ADDED 2020-11-13


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#DoConfigActionScriptSetup "$@"


# -------------------------------------------------------------------------------------------------
# END:  Action Script Procedures
# =================================================================================================
# =================================================================================================


#==================================================================================================
# -------------------------------------------------------------------------------------------------
# START :  Operational Procedures
# -------------------------------------------------------------------------------------------------


#
# -#- Start Making Changes Here -#- 
#


# -------------------------------------------------------------------------------------------------
# CopyFileAndDump2FQDNOutputfile - Copy identified file at path to output file path and also dump to output file
# -------------------------------------------------------------------------------------------------

# MODIFIED 2022-03-08 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CopyFileAndDump2FQDNOutputfile () {
    #
    # Copy identified file at path to output file path and also dump to output file
    #
    
    export outputfile=${outputfileprefix}'_file_'${outputfilenameaddon}${file2copy}${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    if [[ -d "${file2copypathfqfp}" ]]; then
        echo "${file2copypathfqfp} is a directory" | tee -a -i ${outputfilefqfn}
        if [[ -f "${file2copypathfqfp}/${file2copy}" ]]; then
            echo "${file2copypathfqfp}/${file2copy} is a file" | tee -a -i ${outputfilefqfn}
            export file2copypathfqfp="${file2copypathfqfp}/${file2copy}"
        else
            echo "${file2copypathfqfp}/${file2copy} is not valid" | tee -a -i ${outputfilefqfn}
            return 1
        fi
    elif [[ -f "${file2copypathfqfp}" ]]; then
        echo "${file2copypathfqfp} is a file" | tee -a -i ${outputfilefqfn}
    else
        echo "${file2copypathfqfp} is not valid" | tee -a -i ${outputfilefqfn}
        return 1
    fi
    
    if [ ! -r ${file2copypathfqfp} ] ; then
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'NO File Found at Path! :  ' | tee -a -i ${outputfilefqfn}
        echo ' - File : '${file2copy} | tee -a -i ${outputfilefqfn}
        echo ' - Path : '"${file2copypathfqfp}" | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    else
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'Found File at Path :  ' | tee -a -i ${outputfilefqfn}
        echo ' - File : '${file2copy} | tee -a -i ${outputfilefqfn}
        echo ' - Path : '"${file2copypathfqfp}" | tee -a -i ${outputfilefqfn}
        echo 'Copy File at Path to Target : ' | tee -a -i ${outputfilefqfn}
        echo ' - File at Path : '"${file2copypathfqfp}" | tee -a -i ${outputfilefqfn}
        echo ' - to Target    : '"${outputfilefqdn}" | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        cp "${file2copypathfqfp}" "${outputfilefqdn}" >> ${outputfilefqfn}
        
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
        echo 'Dump contents of Source File to Logging File :' | tee -a -i ${outputfilefqfn}
        echo ' - Source File  : '"${file2copypathfqfp}" | tee -a -i ${outputfilefqfn}
        echo ' - Logging File : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        cat "${file2copypathfqfp}" >> ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    fi
    echo | tee -a -i ${outputfilefqfn}
    
    echo
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2022-03-08

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# CopyFileAndDump2FQDNOutputfile

# -------------------------------------------------------------------------------------------------
# FindFilesAndCollectIntoArchive - Document identified file locations to output file path and also collect into archive
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

FindFilesAndCollectIntoArchive () {
    #
    # Document identified file locations to output file path and also collect into archive
    #
    
    export file2findpath="/"
    export file2findname=${file2find/\*/(star)}
    export command2run=find
    export outputfile=${outputfileprefix}'_'${command2run}'_'${file2findname}${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Find file : '${file2find}' and document locations' | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    find / -name "${file2find}" 2> /dev/null >> ${outputfilefqfn}
    
    export archivefile='archive_'${file2findname}${outputfilesuffix}'.tgz'
    export archivefqfn=${outputfilefqdn}${archivefile}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Archive all found Files to Target Archive' | tee -a -i ${outputfilefqfn}
    echo ' - Found Files    : '${file2find} | tee -a -i ${outputfilefqfn}
    echo ' - Target Archive : '${archivefqfn} | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    tar czvf ${archivefqfn} --exclude=${customerworkpathroot}* $(find / -name "${file2find}" 2> /dev/null) >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#FindFilesAndCollectIntoArchive


# -------------------------------------------------------------------------------------------------
# FindFilesAndCollectIntoArchiveAllVariants - Document identified file locations to output file path and also collect into archive all variants
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

FindFilesAndCollectIntoArchiveAllVariants () {
    #
    # Document identified file locations to output file path and also collect into archive all variants
    #
    
    export file2findpath="/"
    export file2findname=${file2find/\*/(star)}
    export command2run=find
    export outputfile=${outputfileprefix}'_'${command2run}'_'${file2findname}'_all_variants'${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Find file : '${file2find}'* and document locations' | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    find / -name "${file2find}*" 2> /dev/null >> ${outputfilefqfn}
    
    export archivefile='archive_'${file2findname}'_all_variants'${outputfilesuffix}'.tgz'
    export archivefqfn=${outputfilefqdn}${archivefile}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Archive all found Files* to Target Archive' | tee -a -i ${outputfilefqfn}
    echo ' - Found Files    : '${file2find}'*' | tee -a -i ${outputfilefqfn}
    echo ' - Target Archive : '${archivefqfn} | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    tar czvf ${archivefqfn} --exclude=${customerworkpathroot}* $(find / -name "${file2find}*" 2> /dev/null) >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#export file2find=cpm.elg

#FindFilesAndCollectIntoArchiveAllVariants


# -------------------------------------------------------------------------------------------------
# FindFilesAndCollectIntoArchiveSpecific - Document identified file locations to output file path and also collect into archive specific variants
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

FindFilesAndCollectIntoArchiveSpecific () {
    #
    # Document identified file locations to output file path and also collect into archive specific variants
    #
    
    export file2findpath="/"
    export file2findname=${file2find/\*/(star)}
    export command2run=find
    export outputfile=${outputfileprefix}'_'${command2run}'_'${file2findname}'_specific_variants'${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Find file : '${file2find}'* and document locations' | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    find / -name "${file2find}*" 2> /dev/null >> ${outputfilefqfn}
    
    export archivefile='archive_'${file2findname}'_specific_variants'${outputfilesuffix}'.tgz'
    export archivefqfn=${outputfilefqdn}${archivefile}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Archive all found Files* to Target Archive' | tee -a -i ${outputfilefqfn}
    echo ' - Found Files    : '${file2findname} | tee -a -i ${outputfilefqfn}
    echo ' - Exclude        : '${file2findstartpath}'/' | tee -a -i ${outputfilefqfn}
    echo ' - Start Path     : '${file2findexclude}'/*' | tee -a -i ${outputfilefqfn}
    echo ' - Target Archive : '${archivefqfn} | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    tar czvf ${archivefqfn} --exclude=${file2findexclude}/* $(find ${file2findstartpath}/ -name "${file2find}*" 2> /dev/null) >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#export file2find=cpm.elg
#export file2findstartpath=${MDS_FWDIR}/log
#export file2findexclude=${MDS_FWDIR}/log/imported_logs

#FindFilesAndCollectIntoArchiveSpecific


# -------------------------------------------------------------------------------------------------
# CopyFiles2CaptureFolder - repeated proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CopyFiles2CaptureFolder () {
    #
    # repeated procedure description
    #
    
    export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
        export targetpath=${outputfilefqdn}${command2run}/
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
        export targetpath=${outputfilefqdn}${command2run}/
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Copy files from Source to Target' | tee -a -i ${outputfilefqfn}
    echo ' - Source : '${sourcepath} | tee -a -i ${outputfilefqfn}
    echo ' - Target : '${targetpath} | tee -a -i ${outputfilefqfn}
    echo ' - Log to : '"${outputfilefqfn}" | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    mkdir -pv ${targetpath} >> "${outputfilefqfn}" 2>&1
    
    echo >> ${outputfilefqfn}
    
    cp -a -v ${sourcepath} ${targetpath} | tee -a -i ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#CopyFiles2CaptureFolder


# -------------------------------------------------------------------------------------------------
# DoCommandAndDocument - Execute command and document results to dedicated file
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

DoCommandAndDocument () {
    #
    # repeated procedure description
    #
    
    export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Execute Command with output to Output Path : ' | tee -a -i ${outputfilefqfn}
    echo ' - Execute Command    : '${command2run} | tee -a -i ${outputfilefqfn}
    echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    echo ' - Command with Parms # '"$@" | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    "$@" >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED YYYY-MM-DD

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#DoCommandAndDocument


# -------------------------------------------------------------------------------------------------
# Populate DNS Servers - Populate DNS Servers for nslookup operations
# -------------------------------------------------------------------------------------------------

# MODIFIED 2021-08-30 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Populate_DNS_Servers () {
    #
    # Populate_DNS_Servers - Populate DNS Servers for nslookup operations
    #
    
    export DNS_primary=
    export DNS_secondary=
    export DNS_tertiary=
    
    export get_DNS_primary=`clish -c "show dns primary"`
    export get_DNS_secondary=`clish -c "show dns secondary"`
    export get_DNS_tertiary=`clish -c "show dns tertiary"`
    export DNS_primary=${get_DNS_primary}
    export DNS_secondary=${get_DNS_secondary}
    export DNS_tertiary=${get_DNS_tertiary}
    
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '| DNS Server Primary   :  '${DNS_primary} | tee -a -i ${outputfilefqfn}
    echo '| DNS Server Secondary :  '${DNS_secondary} | tee -a -i ${outputfilefqfn}
    echo '| DNS Server Tertiary  :  '${DNS_tertiary} | tee -a -i ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2021-08-30

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#
#export DNS_primary=
#export DNS_secondary=
#export DNS_tertiary=
#
# Populate_DNS_Servers


# -------------------------------------------------------------------------------------------------
# Document_nslookup - Document nslookup of target URL with all DNS servers with log of response
# -------------------------------------------------------------------------------------------------

# MODIFIED 2021-08-30 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Document_nslookup () {
    #
    # Document_nslookup - Document nslookup of target URL with all DNS servers with log of response
    #
    
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '| nslookup address :  '${1}  | tee -a -i ${outputfilefqfn}
    
    if [ x"${DNS_primary}" != x"" ] ; then
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| nslookup command with DNS Server Primary :  '${DNS_primary} | tee -a -i ${outputfilefqfn}
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        
        nslookup ${1} ${DNS_primary} | tee -a -i ${outputfilefqfn}
    else
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| DNS Server Primary ['${DNS_primary}'] NOT DEFINED!' | tee -a -i ${outputfilefqfn}
    fi
    
    if [ x"${DNS_secondary}" != x"" ] ; then
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| nslookup command with DNS Server Secondary :  '${DNS_secondary} | tee -a -i ${outputfilefqfn}
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        
        nslookup ${1} ${DNS_secondary} | tee -a -i ${outputfilefqfn}
    else
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| DNS Server Secondary ['${DNS_secondary}'] NOT DEFINED!' | tee -a -i ${outputfilefqfn}
    fi
    
    if [ x"${DNS_tertiary}" != x"" ] ; then
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| nslookup command with DNS Server Tertiary :  '${DNS_tertiary} | tee -a -i ${outputfilefqfn}
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        
        nslookup ${1} ${DNS_tertiary} | tee -a -i ${outputfilefqfn}
    else
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| DNS Server Tertiary ['${DNS_tertiary}'] NOT DEFINED!' | tee -a -i ${outputfilefqfn}
    fi
    
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2021-08-30

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# Document_nslookup ${URL_to_check}


# -------------------------------------------------------------------------------------------------
# Document_curl - Document curl command with log of error response (the actual response)
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-01-19 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Document_curl () {
    #
    # Document_curl - Document curl command with log of error response (the actual response)
    #
    
    templogfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.curl_ops.log
    templogerrorfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.curl_ops.errout.log
    
    curl_cli "$@" 2> $templogerrorfile >> $templogfile
    curlerror=$?
    
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '| curl command | result = '$curlerror | tee -a -i ${outputfilefqfn}
    echo '| # curl_cli '$@ | tee -a -i ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    
    cat $templogfile >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    rm $templogfile >> ${outputfilefqfn}
    
    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' >> ${outputfilefqfn}
    
    cat $templogerrorfile >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    rm $templogerrorfile >> ${outputfilefqfn}
    
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-19

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# Document_curl


# -------------------------------------------------------------------------------------------------
# Document_wget - Document wget command with log of error response (the actual response)
# -------------------------------------------------------------------------------------------------

# MODIFIED 2023-02-17 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Document_wget () {
    #
    # Document_wget - Document wget command with log of error response (the actual response)
    #
    
    templogfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.wget_ops.log
    templogerrorfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.wget_ops.errout.log
    
    rm index.html
    wget "$@" 2> ${templogerrorfile} >> ${templogfile}
    rm index.html
    wgeterror=$?
    
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '| wget command | result = '${wgeterror} | tee -a -i ${outputfilefqfn}
    echo '| # wget '$@ | tee -a -i ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    
    cat ${templogfile} >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    rm ${templogfile} >> ${outputfilefqfn}
    
    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ' >> ${outputfilefqfn}
    
    cat ${templogerrorfile} >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    rm ${templogerrorfile} >> ${outputfilefqfn}
    
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2023-02-17

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# Document_wget


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# END :  Operational Procedures
# -------------------------------------------------------------------------------------------------
#==================================================================================================


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# GaiaWebSSLPortCheck - Check local Gaia Web SSL Port configuration for local operations
# -------------------------------------------------------------------------------------------------


# MODIFIED 2022-06-27:00 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# GaiaWebSSLPortCheck - Check local Gaia Web SSL Port configuration for local operations
#

GaiaWebSSLPortCheck () {
    
    # Removing dependency on clish to avoid collissions when database is locked
    #
    #export currentapisslport=$(clish -c "show web ssl-port" | cut -d " " -f 2)
    #
    if [ -r ${MDS_FWDIR}/Python/bin/python3 ] ; then
        # Working on R81.20 EA or later, where python3 replaces the regular python call
        #
        #export currentapisslport=$(clish -c "show web ssl-port" | cut -d " " -f 2)
        #
        export pythonpath=${MDS_FWDIR}/Python/bin
        export get_api_local_port=`${pythonpath}/python3 ${MDS_FWDIR}/scripts/api_get_port.py -f json | ${JQ} '. | .external_port'`
        export api_local_port=${get_api_local_port//\"/}
        export currentapisslport=${api_local_port}
    else
        # Not working MaaS so will check locally for Gaia web SSL port setting
        # Removing dependency on clish to avoid collissions when database is locked
        #
        #export currentapisslport=$(clish -c "show web ssl-port" | cut -d " " -f 2)
        #
        export pythonpath=${MDS_FWDIR}/Python/bin
        export get_api_local_port=`${pythonpath}/python ${MDS_FWDIR}/scripts/api_get_port.py -f json | ${JQ} '. | .external_port'`
        export api_local_port=${get_api_local_port//\"/}
        export currentapisslport=${api_local_port}
    fi
    
    if ${B4CPSCRIPTVERBOSE} ; then
        echo 'Current Gaia web ssl-port : '${currentapisslport} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    else
        echo 'Current Gaia web ssl-port : '${currentapisslport} >> ${logfilepath}
        echo >> ${logfilepath}
    fi
    
    return 0
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2022-06-27:00


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


GaiaWebSSLPortCheck


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# clish operations - might have issues if user is in Gaia webUI
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


export command2folder=
export command2run=clish_commands
export clishoutputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
export clishoutputfilefqfn=${outputfilepath}$clishoutputfile

echo | tee -a ${logfilepath}
echo 'Execute clish opertations with common log in : '${clishoutputfilefqfn} | tee -a ${logfilepath}
echo | tee -a ${logfilepath}

echo | tee -a ${clishoutputfilefqfn}
echo 'Execute clish opertations with common log in : '${clishoutputfilefqfn} | tee -a ${clishoutputfilefqfn}
echo | tee -a ${clishoutputfilefqfn}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# clish - save configuration to file
#----------------------------------------------------------------------------------------

export command2folder=configuration
export command2run=clish_config
export configfile=${command2run}'_'${outputfileprefix}${outputfilesuffix}
export configfilefqfn=${outputfilepath}${configfile}
export outputfile=${command2run}'_'${outputfileprefix}${outputfilesuffix}${outputfiletype}
if [ -z ${command2folder} ] ; then
    export outputfilefqdn=${outputfilepath}
    export outputfilefqfn=${outputfilepath}${outputfile}
else
    export outputfilefqdn=${outputfilepath}${command2folder}/
    export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
fi

if [ ! -r ${outputfilefqdn} ] ; then
    mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
else
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
fi

echo | tee -a ${outputfilefqfn}
echo 'Execute '${command2run}' with output to : '${configfilefqfn} | tee -a ${outputfilefqfn}
echo | tee -a ${outputfilefqfn}

CheckAndUnlockGaiaDB

clish -i -s -c "save configuration ${configfile}" >> ${outputfilefqfn}

cp "${configfile}" "${configfilefqfn}" >> ${outputfilefqfn}
cp "${configfile}" "${configfilefqfn}.txt" >> ${outputfilefqfn}

cat ${outputfilefqfn} >> ${clishoutputfilefqfn}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - backup user's home folder
#----------------------------------------------------------------------------------------

export homebackuproot=${startpathroot}

export expandedpath=$(cd ${homebackuproot} ; pwd)
export homebackuproot=${expandedpath}
export checkthispath=`echo "${expandedpath}" | grep -i "$notthispath"`
export isitthispath=`test -z ${checkthispath}; echo $?`

if [ ${isitthispath} -eq 1 ] ; then
    #Oh, Oh, we're in the home directory executing, not good!!!
    #Configure homebackuproot for ${alternatepathroot} folder since we can't run in /home/
    export homebackuproot=${alternatepathroot}
else
    #OK use the current folder and create host_data sub-folder
    export homebackuproot=${startpathroot}
fi

if [ ! -r ${homebackuproot} ] ; then
    #not where we're expecting to be, since ${homebackuproot} is missing here
    #maybe this hasn't been run here yet.
    #OK, so make the expected folder and set permissions we need
    mkdir -pv ${homebackuproot} >> ${logfilepath} 2>&1
    chmod 775 ${homebackuproot} >> ${logfilepath} 2>&1
else
    #set permissions we need
    chmod 775 ${homebackuproot} >> ${logfilepath} 2>&1
fi

export expandedpath=$(cd ${homebackuproot} ; pwd)
export homebackuproot=${expandedpath}
export homebackuppath="${homebackuproot}/home.backup"

if [ ! -r ${homebackuppath} ] ; then
    mkdir -pv ${homebackuppath} >> ${logfilepath} 2>&1
    chmod 775 ${homebackuppath} >> ${logfilepath} 2>&1
else
    chmod 775 ${homebackuppath} >> ${logfilepath} 2>&1
fi

export command2folder=
export command2run=backup-home
export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
if [ -z ${command2folder} ] ; then
    export outputfilefqdn=${outputfilepath}
    export outputfilefqfn=${outputfilepath}${outputfile}
else
    export outputfilefqdn=${outputfilepath}${command2folder}/
    export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
fi

if [ ! -r ${outputfilefqdn} ] ; then
    mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
else
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
fi
touch ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo 'Execute '${command2run}' to '${outputhomepath}' with output to : '${outputfilefqfn} >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo "Current path : " >> ${outputfilefqfn}
pwd >> ${outputfilefqfn}

echo "Copy /home folder to ${outputhomepath}" >> ${outputfilefqfn}
cp -a -v "/home/" "${outputhomepath}" >> ${outputfilefqfn}

echo
echo 'Execute '${command2run}' to '${homebackuppath}' with output to : '${outputfilefqfn}
echo >> ${outputfilefqfn}

pushd /home

echo >> ${outputfilefqfn}
echo "Current path : " >> ${outputfilefqfn}
pwd >> ${outputfilefqfn}

echo "Copy /home folder contents to ${homebackuppath}" >> ${outputfilefqfn}
cp -a -v "." "${homebackuppath}" >> ${outputfilefqfn}

popd

echo >> ${outputfilefqfn}
echo "Current path : " >> ${outputfilefqfn}
pwd >> ${outputfilefqfn}

echo >> ${outputfilefqfn}

echo "Current path : " >> ${outputfilefqfn}
pwd >> ${outputfilefqfn}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure variables for action subscripts call -system_common
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17 -

# Configure basic information for formation of file path for action script
#
# action_script_setup_handler_root - root path to action script
# action_script_setup_handler_folder - folder for under root path to action script
# action_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export action_script_setup_handler_root=${scriptspathroot}
export action_script_setup_handler_folder=Config
export action_script_setup_handler_name=config_details_capture.action_script.system_common
export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh

DoConfigActionScriptSetup "$@"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure variables for action subscripts call -user_environment
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17 -

# Configure basic information for formation of file path for action script
#
# action_script_setup_handler_root - root path to action script
# action_script_setup_handler_folder - folder for under root path to action script
# action_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export action_script_setup_handler_root=${scriptspathroot}
export action_script_setup_handler_folder=Config
export action_script_setup_handler_name=config_details_capture.action_script.user_environment
export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh

DoConfigActionScriptSetup "$@"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure variables for action subscripts call - installation
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17 -

# Configure basic information for formation of file path for action script
#
# action_script_setup_handler_root - root path to action script
# action_script_setup_handler_folder - folder for under root path to action script
# action_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export action_script_setup_handler_root=${scriptspathroot}
export action_script_setup_handler_folder=Config
export action_script_setup_handler_name=config_details_capture.action_script.installation
export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh

DoConfigActionScriptSetup "$@"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure variables for action subscripts call -hardware
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17 -

# Configure basic information for formation of file path for action script
#
# action_script_setup_handler_root - root path to action script
# action_script_setup_handler_folder - folder for under root path to action script
# action_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export action_script_setup_handler_root=${scriptspathroot}
export action_script_setup_handler_folder=Config
export action_script_setup_handler_name=config_details_capture.action_script.hardware
export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh

DoConfigActionScriptSetup "$@"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure variables for action subscripts call - networking
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17 -

# Configure basic information for formation of file path for action script
#
# action_script_setup_handler_root - root path to action script
# action_script_setup_handler_folder - folder for under root path to action script
# action_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export action_script_setup_handler_root=${scriptspathroot}
export action_script_setup_handler_folder=Config
export action_script_setup_handler_name=config_details_capture.action_script.networking
export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh

DoConfigActionScriptSetup "$@"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure variables for action subscripts call - Security_and_Crypto
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17 -

# Configure basic information for formation of file path for action script
#
# action_script_setup_handler_root - root path to action script
# action_script_setup_handler_folder - folder for under root path to action script
# action_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export action_script_setup_handler_root=${scriptspathroot}
export action_script_setup_handler_folder=Config
export action_script_setup_handler_name=config_details_capture.action_script.Security_and_Crypto
export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh

DoConfigActionScriptSetup "$@"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure variables for action subscripts call - CP_Security_Management
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17 -

# Configure basic information for formation of file path for action script
#
# action_script_setup_handler_root - root path to action script
# action_script_setup_handler_folder - folder for under root path to action script
# action_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export action_script_setup_handler_root=${scriptspathroot}
export action_script_setup_handler_folder=Config
export action_script_setup_handler_name=config_details_capture.action_script.CP_Security_Management
export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh

DoConfigActionScriptSetup "$@"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure variables for action subscripts call - SmartLog_SmartEvent
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17 -

# Configure basic information for formation of file path for action script
#
# action_script_setup_handler_root - root path to action script
# action_script_setup_handler_folder - folder for under root path to action script
# action_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export action_script_setup_handler_root=${scriptspathroot}
export action_script_setup_handler_folder=Config
export action_script_setup_handler_name=config_details_capture.action_script.SmartLog_SmartEvent
export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh

DoConfigActionScriptSetup "$@"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure variables for action subscripts call - CP_Gateway_or_Cluster
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17 -

# Configure basic information for formation of file path for action script
#
# action_script_setup_handler_root - root path to action script
# action_script_setup_handler_folder - folder for under root path to action script
# action_script_setup_handler_file - filename, without path, for command line parameter handler script
#
export action_script_setup_handler_root=${scriptspathroot}
export action_script_setup_handler_folder=Config
export action_script_setup_handler_name=config_details_capture.action_script.CP_Gateway_or_Cluster
export action_script_setup_handler_file=${action_script_setup_handler_name}.v${SubScriptsVersion}.sh

DoConfigActionScriptSetup "$@"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - ?what next?
#----------------------------------------------------------------------------------------

#export command2folder=
#export command2run=command
#export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
#if [ -z ${command2folder} ] ; then
    #export outputfilefqfn=${outputfilepath}${outputfile}
#else
    #export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    
    #if [ ! -r ${outputfilepath}${command2folder} ] ; then
        #mkdir -pv ${outputfilepath}${command2folder} >> ${logfilepath} 2>&1
        #chmod 775 ${outputfilepath}${command2folder} >> ${logfilepath} 2>&1
    #else
        #chmod 775 ${outputfilepath}${command2folder} >> ${logfilepath} 2>&1
    #fi
#fi

#echo
#echo 'Execute '${command2run}' with output to : '${outputfilefqfn}
#${command2run} > ${outputfilefqfn}

#echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
#echo >> ${outputfilefqfn}
#echo 'fwacell stats -s' >> ${outputfilefqfn}
#echo >> ${outputfilefqfn}
#
#fwaccel stats -s >> ${outputfilefqfn}
#


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Wrap-up the common log for clish including operations
#----------------------------------------------------------------------------------------

echo | tee -a ${clishoutputfilefqfn}
echo 'opertations clish with common log in completed!' | tee -a ${clishoutputfilefqfn}
echo | tee -a ${clishoutputfilefqfn}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of clish operations - might have issues if user is in Gaia webUI
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#==================================================================================================
#==================================================================================================
#
# END :  Collect and Capture Configuration and Information data
#
#==================================================================================================
#==================================================================================================


#==================================================================================================
#==================================================================================================
#
# shell clean-up and log dump
#
#==================================================================================================
#==================================================================================================


if [ -r nul ] ; then
    rm nul >> ${logfilepath}
fi

if [ -r None ] ; then
    rm None >> ${logfilepath}
fi

echo | tee -a -i ${logfilepath}
echo 'List folder : '${outputpathbase} | tee -a -i ${logfilepath}
ls -alh ${outputpathbase} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo 'List files : '${outputpathbase}'/fw*' | tee -a -i ${logfilepath}
ls -alh ${outputpathroot}/fw* | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo >> ${logfilepath}
echo 'Output location for all results is here : '${outputpathbase} >> ${logfilepath}
echo 'Log results documented in this log file : '${logfilepath} >> ${logfilepath}
echo >> ${logfilepath}


#==================================================================================================
#==================================================================================================
#
# Archive results for easy transport
#
#==================================================================================================
#==================================================================================================


# MODIFIED 2020-11-11 -
if [ -z ${archivepathbase} ]; then
    export expandedpath=$(cd ${OtherOutputFolder} ; pwd)
    export archivepathbase=${expandedpath}
    #export archivepathbase=${outputpathbase}
fi
export archivefiletype=.tgz
export archivefilename=${HOSTNAME}'_'${gaiaversion}'_'${BASHScriptName}.${DATEDTGS}${archivefiletype}
export archivefqfn=${archivepathbase}/${archivefilename}

if [ -z ${archivestartfolder} ]; then
    if ${OutputDTGSSubfolder} ; then
        if $OutputDTGTZinUTC ; then
            export archivestartfolder=${DATEUTCDTGS}
        else
            export archivestartfolder=${DATEDTGS}
        fi
        if ${OutputSubfolderScriptName} ; then
            export archivestartfolder=${archivestartfolder}.${BASHScriptName}
        elif ${OutputSubfolderScriptShortName} ; then
            export archivestartfolder=${archivestartfolder}.${BASHScriptShortName}
        fi
    else
        if ${OutputSubfolderScriptName} ; then
            export archivestartfolder=${BASHScriptName}
        elif ${OutputSubfolderScriptShortName} ; then
            export archivestartfolder=${BASHScriptShortName}
        else
            export archivestartfolder=.
        fi
    fi
fi

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------'
echo '----------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Archive of operation results' | tee -a -i ${logfilepath}
echo ' - from '${archivepathbase}/${archivestartfolder} | tee -a -i ${logfilepath}
echo ' - to : '${archivefqfn} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

#tar czvf ${archivefqfn} --directory=${archivepathbase} ${outputpathbase} ${DATEDTGS}
#tar czvf ${archivefqfn} --directory=${archivepathbase} .
tar czvf ${archivefqfn} --directory=${archivepathbase} ${archivestartfolder}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#==================================================================================================
#==================================================================================================
#
# Push Archived results to tftp server
#
#==================================================================================================
#==================================================================================================

export archivetftptargetfolder=${tftptargetfolder_root}/${BASHScripttftptargetfolder}
export archivetftpfilefqfn=${archivetftptargetfolder}/${archivefilename}

if ${EXPORTRESULTSTOTFPT} ; then
    
    if [ ! -z ${MYTFTPSERVER} ]; then
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'Push archive file : '${archivefqfn}
        echo ' - to tftp server : '${MYTFTPSERVER}
        echo ' - target path    : '${archivetftpfilefqfn}
        echo '----------------------------------------------------------------------------'
        echo
        
        tftp -v -m binary ${MYTFTPSERVER} -c put ${archivefqfn} ${archivetftpfilefqfn}
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    else
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'tftp server value ${MYTFTPSERVER} not set!'
        echo '  Not executing push to that tftp server!'
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    fi

    if [ ! -z ${MYTFTPSERVER1} ] && [ ${MYTFTPSERVER1} != ${MYTFTPSERVER} ]; then
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'Push archive file : '${archivefqfn}
        echo ' - to tftp server : '${MYTFTPSERVER1}
        echo ' - target path    : '${archivetftpfilefqfn}
        echo '----------------------------------------------------------------------------'
        echo
        
        tftp -v -m binary ${MYTFTPSERVER1} -c put ${archivefqfn} ${archivetftpfilefqfn}
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    else
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'tftp server value ${MYTFTPSERVER1} not set!'
        echo '  Not executing push to that tftp server!'
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    fi
    
    if [ ! -z ${MYTFTPSERVER2} ] && [ ${MYTFTPSERVER2} != ${MYTFTPSERVER} ]; then
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'Push archive file : '${archivefqfn}
        echo ' - to tftp server : '${MYTFTPSERVER2}
        echo ' - target path    : '${archivetftpfilefqfn}
        echo '----------------------------------------------------------------------------'
        echo
        
        tftp -v -m binary ${MYTFTPSERVER2} -c put ${archivefqfn} ${archivetftpfilefqfn}
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    else
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'tftp server value ${MYTFTPSERVER2} not set!'
        echo '  Not executing push to that tftp server!'
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    fi
    
    if [ ! -z ${MYTFTPSERVER3} ] && [ ${MYTFTPSERVER3} != ${MYTFTPSERVER} ]; then
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'Push archive file : '${archivefqfn}
        echo ' - to tftp server : '${MYTFTPSERVER3}
        echo ' - target path    : '${archivetftpfilefqfn}
        echo '----------------------------------------------------------------------------'
        echo
        
        tftp -v -m binary ${MYTFTPSERVER3} -c put ${archivefqfn} ${archivetftpfilefqfn}
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    else
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'tftp server value ${MYTFTPSERVER3} not set!'
        echo '  Not executing push to that tftp server!'
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    fi
    
else
    
    echo
    echo '----------------------------------------------------------------------------'
    echo '----------------------------------------------------------------------------'
    echo 'tftp server results export not enabled!'
    echo '----------------------------------------------------------------------------'
    echo '----------------------------------------------------------------------------'
    echo
    
fi


#==================================================================================================
#==================================================================================================
#
# Final information to the executing script
#
#==================================================================================================
#==================================================================================================


# ADDED 2021-02-13 -

if ${CLIparm_NOHUP} ; then
    # Cleanup Potential file indicating script is active for nohup mode
    if [ -r ${script2nohupactive} ] ; then
        rm ${script2nohupactive} >> ${logfilepath} 2>&1
    fi
fi

echo
echo 'Output location for all results is here : '${outputpathbase}
echo 'Log results documented in this log file : '${logfilepath}
echo 'Archive of operation is here            : '${archivefqfn}
echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo
echo 'Script Completed, exiting...';echo


