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
# Sample
#
# SCRIPT Update GAIA REST API Installation with latest package from tftp server - SAMPLE
#
#
ScriptDate=2024-06-12
ScriptVersion=05.37.00
ScriptRevision=000
ScriptSubRevision=125
TemplateVersion=05.37.00
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.37.00
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

export BASHScriptFileNameRoot=update_gaia_rest_api
export BASHScriptShortName=Update_GAIA_REST_API
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Update GAIA REST API Installation with latest package from tftp server"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}

export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}
export BASHScriptHelpFileExamplesName=${BASHScriptFileNameRoot}.examples.help
export BASHScriptHelpExamplesFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileExamplesName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|scripts_tools|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=GAIA

export BASHScripttftptargetfolder="_template"


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


# MODIFIED 2020-09-11 -
# R80       version 1.0
# R80.10    version 1.1
# R80.20.M1 version 1.2
# R80.20 GA version 1.3
# R80.20.M2 version 1.4
# R80.30    version 1.5
# R80.40    version 1.6
# R80.40 JHF 78 version 1.6.1
# R81.00    version 1.7
#
# For common scripts minimum API version at 1.1 should suffice, otherwise get explicit
# To enable use of API Key authentication, at least version 1.6 is required
#
export MinAPIVersionRequired=1.1

export R8XRequired=true
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
export OutputToChangeLog=true
export OutputToOther=false
#
# if OutputToOther is true, then this next value needs to be set
#
export OtherOutputFolder=Specify_The_Folder_Here

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
export OutputSubfolderScriptShortName=true

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
export KeepGaiaVersionResultsFile=false


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
    R82 | R82.10 | R82.20 ) 
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
# START :  Download and if necessary, upgrade GAIA REST API
#
#==================================================================================================
#==================================================================================================


# -------------------------------------------------------------------------------------------------
# local script variables
# -------------------------------------------------------------------------------------------------


if [ ! -z ${MYTFTPSERVER1} ] && [ ${MYTFTPSERVER1} != ${MYTFTPSERVER} ]; then
    export sourcetftpserver=${MYTFTPSERVER1}
elif [ ! -z ${MYTFTPSERVER2} ] && [ ${MYTFTPSERVER2} != ${MYTFTPSERVER} ]; then
    export sourcetftpserver=${MYTFTPSERVER2}
elif [ ! -z ${MYTFTPSERVER3} ] && [ ${MYTFTPSERVER3} != ${MYTFTPSERVER} ]; then
    export sourcetftpserver=${MYTFTPSERVER3}
elif [ ! -z ${MYTFTPSERVER} ]; then
    export sourcetftpserver=${MYTFTPSERVER}
else
    export sourcetftpserver=192.169.1.1
fi


export remoterootfolder=/__gaia
export remotefilefolder=gaia_rest_api
export remotefilename=Check_Point_gaia_api.tgz
export fqpnremotefile=$remoterootfolder/$remotefilefolder/$remotefilename

#export remotescriptfolder=gaia_rest_api
#export remotescriptname=update_gaia_api.sh
#export fqpnremotescript=$remoterootfolder/$remotescriptfolder/$remotescriptname

export rootworkpath=/var/log/__customer/download
export workfolder=gaia_rest_api
export workfoldercurrent=current
export workfoldernew=new

export workfilename=$remotefilename
export installerfilename=install_gaia_api.sh

export fqpnworkfolder=$rootworkpath/$workfolder
export fqpncurrentfolder=$fqpnworkfolder/$workfoldercurrent
export fqpnnewfolder=$fqpnworkfolder/$workfoldernew

export fqfpworkfile=$fqpnworkfolder/$workfilename
export fqfpcurrentfile=$fqpncurrentfolder/$workfilename
export fqfpnewfile=$fqpnnewfolder/$workfilename


#----------------------------------------------------------------------------------------
# Check for working folders
#----------------------------------------------------------------------------------------

echo >> ${logfilepath}
echo '----------------------------------------------------------------------------------------' >> ${logfilepath}
echo ' Folder path check and creation! ' >> ${logfilepath}
echo '----------------------------------------------------------------------------------------' >> ${logfilepath}
echo >> ${logfilepath}

if [ ! -r $rootworkpath ] ; then
    mkdir -pv $rootworkpath >> ${logfilepath}
    chmod 775 $rootworkpath
else
    chmod 775 $rootworkpath
fi

if [ ! -r $fqpnworkfolder ] ; then
    mkdir -pv $fqpnworkfolder
    chmod 775 $fqpnworkfolder
else
    chmod 775 $fqpnworkfolder
fi

if [ ! -r $fqpncurrentfolder ] ; then
    mkdir -pv $fqpncurrentfolder
    chmod 775 $fqpncurrentfolder
else
    chmod 775 $fqpncurrentfolder
fi

if [ ! -r $fqpnnewfolder ] ; then
    mkdir -pv $fqpnnewfolder
    chmod 775 $fqpnnewfolder
else
    chmod 775 $fqpnnewfolder
fi

echo >> ${logfilepath}
echo '----------------------------------------------------------------------------------------' >> ${logfilepath}
echo >> ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Drop into folder and make sure we can write! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Wait until the target folder is available : '$fqpnworkfolder; echo
echo -n '!'
until [ -r $fqpnworkfolder ]
do
    echo -n '.'
done
echo

echo | tee -a -i ${logfilepath}
echo 'pushd to '$fqpnworkfolder | tee -a -i ${logfilepath}
pushd "$fqpnworkfolder"
pwd | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo 'Current content of working folder : '$fqpnworkfolder | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
ls -alh $fqpnworkfolder | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
rm  $fqpnworkfolder/* | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Post clean-up content of working folder : '$fqpnworkfolder | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
ls -alh $fqpnworkfolder | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo
read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey
echo

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Get remote files! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo "Fetch latest $remotefilename from tftp repository on $sourcetftpserver..." | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
tftp -v -m binary $sourcetftpserver -c get $fqpnremotefile | tee -a -i ${logfilepath}
#tftp -v -m binary $sourcetftpserver -c get $fqpnremotescript | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Check File transfer OK! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo "Check that we got it." | tee -a -i ${logfilepath}
if [ ! -r $workfilename ]; then
    # Oh, oh, we didn't get the $workfilename file
    echo | tee -a -i ${logfilepath}
    echo 'Critical Error!!! Did not obtain '$workfilename' file from tftp!!!' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'returning to script starting folder' | tee -a -i ${logfilepath}
    popd
    pwd | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'Exiting...' | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'Output location for all results is here : '${outputpathbase} | tee -a -i ${logfilepath}
    echo 'Log results documented in this log file : '${logfilepath} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 255
else
    # we have the $workfilename file and can work with it
    echo | tee -a -i ${logfilepath}
    ls -alh $workfilename | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}

    # copy the new file to the new folder
    cp $workfilename $fqpnnewfolder >> ${logfilepath}
fi

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Check if this is the first run or if we need to verify downloaded file is newer! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

# check installation of Dynamic CLI
rpm -q gaia_api &> /dev/null
if [ $? -ne 0 ]; then
    # Gaia REST API is not currently installed
    echo "Gaia REST API is not currenlty installed!" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}

    # overwrite the current file with the work file
    echo "Overwrite the current file : $fqfpcurrentfile with $workfilename" | tee -a -i ${logfilepath}
    echo "We'll assume this is first install and copy the new to current for later." | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    # copy the new file to the current folder
    cp $workfilename $fqpncurrentfolder >> ${logfilepath}
else
    if [ -r $fqfpcurrentfile ]; then
        # we have a current file to check
        echo "We have an existing current file : $fqfpcurrentfile" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    
        # md5sum current/Check_Point_gaia_dynamic_cli.tgz
        export md5current=$(md5sum $fqfpcurrentfile | cut -d " " -f 1)
        echo 'md5 of current : '$md5current | tee -a -i ${logfilepath}
        
        # md5sum Check_Point_gaia_dynamic_cli.tgz
        export md5new=$(md5sum $fqfpnewfile | cut -d " " -f 1)
        echo 'md5 of     new : '$md5new | tee -a -i ${logfilepath}
        
        if [ $md5new == $md5current ]; then 
            echo "Files are the same" | tee -a -i ${logfilepath}
            echo 'No reason to update the existing installation!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'returning to script starting folder' | tee -a -i ${logfilepath}
            popd
            pwd | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Exiting...' | tee -a -i ${logfilepath}
            
            echo | tee -a -i ${logfilepath}
            echo 'Output location for all results is here : '${outputpathbase} | tee -a -i ${logfilepath}
            echo 'Log results documented in this log file : '${logfilepath} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            
            exit 255
        else 
            echo "Files are different, moving right along..." | tee -a -i ${logfilepath}
        fi
        echo | tee -a -i ${logfilepath}
        
    else
        # no current file, so copy new file to current
        echo "There is no current file : $fqfpcurrentfile" | tee -a -i ${logfilepath}
        echo "We'll assume this is first install and copy the new to current for later." | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        # copy the new file to the current folder
        cp $workfilename $fqpncurrentfolder >> ${logfilepath}
    fi
fi

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Untar the '$workfilename' and execute the installer! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

if [ -r $workfilename ]; then
    # OK now that we are clear on doing the work, let's extract this file and make it happen

    # now unzip existing scripts folder
    echo "Extract $workfilename file..." | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    tar -zxvf $workfilename | tee -a -i ${logfilepath}

    echo | tee -a -i ${logfilepath}
    ls -alh | tee -a -i ${logfilepath}
    pwd | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    # now execute installer script in local folder
    echo "Execute installer file $installerfilename ..." | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}

    ./$installerfilename | tee -a -i ${logfilepath}

    cp $workfilename $fqpncurrentfolder | tee -a -i ${logfilepath}

    #echo 'Reboot to get operational!' | tee -a -i ${logfilepath}

else
    # Heh????
    
    echo | tee -a -i ${logfilepath}
    echo 'Files and folders:' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    ls -alhR | tee -a -i ${logfilepath}
    pwd | tee -a -i ${logfilepath}

    echo | tee -a -i ${logfilepath}
    echo 'returning to script starting folder' | tee -a -i ${logfilepath}
    popd
    pwd | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    echo 'Exiting...' | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'Output location for all results is here : '${outputpathbase} | tee -a -i ${logfilepath}
    echo 'Log results documented in this log file : '${logfilepath} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 255
fi


echo | tee -a -i ${logfilepath}
echo 'returning to script starting folder' | tee -a -i ${logfilepath}
popd
pwd | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo
read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey
echo

echo | tee -a -i ${logfilepath}
echo 'Files and folders:' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
ls -alhR "$fqpnworkfolder" | tee -a -i ${logfilepath}
pwd | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo 'Check Gaia REST API Status' | tee -a -i ${logfilepath}
gaia_api status | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo 'Done!' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#==================================================================================================
#==================================================================================================
#
# END :  Download and if necessary, upgrade GAIA REST API
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


# MODIFIED 2021-02-13 -

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

# ADDED 2021-02-13 -

if ${CLIparm_NOHUP} ; then
    # Cleanup Potential file indicating script is active for nohup mode
    if [ -r ${script2nohupactive} ] ; then
        rm ${script2nohupactive} >> ${logfilepath} 2>&1
    fi
fi

echo | tee -a -i ${logfilepath}
echo 'Output location for all results is here : '${outputpathbase} | tee -a -i ${logfilepath}
echo 'Log results documented in this log file : '${logfilepath} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo
echo 'Script Completed, exiting...';echo


