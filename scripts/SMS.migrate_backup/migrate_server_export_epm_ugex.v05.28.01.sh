#!/bin/bash
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
# SCRIPT for BASH to execute migrate export to /var/log/__customer/upgrade_export folder
# using /var/log/__customer/upgrade_export/migration_tools/<version>/migrate file
# EPM export includes standard NPM export and adds export of EP Client MSI files
#
#
ScriptDate=2022-02-24
ScriptVersion=05.28.01
ScriptRevision=000
TemplateVersion=05.28.01
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.28.01
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

export BASHScriptFileNameRoot=migrate_server_export_epm_ugex
export BASHScriptShortName="migrate_server_export_epm"
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="migrate_server export EPM with EP Client MSI to local folder using version tools"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}.v${ScriptVersion}

export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}
export BASHScriptHelpFileExamplesName=${BASHScriptFileNameRoot}.examples.help
export BASHScriptHelpExamplesFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileExamplesName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=SMS.migrate_backup

export BASHScripttftptargetfolder="_template"


# =================================================================================================
# =================================================================================================
# START: Root Configuration
# -------------------------------------------------------------------------------------------------

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
export OtherOutputFolder=migrate_backup

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

export OutputYearSubfolder=false
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


echo | tee -a -i ${logfilepath}
echo ${BASHScriptName}', script version '${ScriptVersion}', revision '${ScriptRevision}' from '${ScriptDate} | tee -a -i ${logfilepath}
echo ${BASHScriptDescription} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Date Time Group   :  '${DATEDTGS} | tee -a -i ${logfilepath}
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

# MODIFIED 2019-12-06 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

export CLIparm_l01_toolvername=
export CLIparm_l02_toolpath=
export CLIparm_l03_NOCPSTART=false
export CLIparm_l04_targetversion=
export CLIparm_l05_forcemigrate=false

export DOCPSTART=true
export EXPORTVERSIONDIFFERENT=false
export FORCEUSEMIGRATE=false

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2019-12-06


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# processcliremains - Local command line parameter processor
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-12-06 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
                --NOCPSTART )
                    export CLIparm_l03_NOCPSTART=true
                    export DOCPSTART=false
                    ;;
                --forcemigrate | --FORCEMIGRATE )
                    export CLIparm_l05_forcemigrate=true
                    export FORCEUSEMIGRATE=true
                    ;;
                # Handle --flag=value opts like this
                --toolversion=* )
                    export CLIparm_l01_toolvername="${OPT#*=}"
                    ;;
                --toolpath=* )
                    export CLIparm_l02_toolpath="${OPT#*=}"
                    ;;
                --exportversion=* )
                    export CLIparm_l04_targetversion="${OPT#*=}"
                    ;;
                # and --flag value opts like this
                --toolversion )
                    export CLIparm_l01_toolvername="$2"
                    shift
                    ;;
                --toolpath )
                    export CLIparm_l02_toolpath="$2"
                    shift
                    ;;
                --exportversion )
                    export CLIparm_l04_targetversion="$2"
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

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2019-12-06


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# dumpcliparmparselocalresults
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-12-06 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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

    echo 'CLIparm_l01_toolvername   = '${CLIparm_l01_toolvername} >> ${workoutputfile}
    echo 'CLIparm_l02_toolpath      = '${CLIparm_l02_toolpath} >> ${workoutputfile}
    echo 'CLIparm_l03_NOCPSTART     = '${CLIparm_l03_NOCPSTART} >> ${workoutputfile}
    echo 'CLIparm_l04_targetversion = '${CLIparm_l04_targetversion} >> ${workoutputfile}
    echo 'CLIparm_l05_forcemigrate  = '${CLIparm_l05_forcemigrate} >> ${workoutputfile}
    echo  >> ${workoutputfile}
    echo 'FORCEUSEMIGRATE           = '${FORCEUSEMIGRATE} >> ${workoutputfile}
    echo  >> ${workoutputfile}
    echo 'DOCPSTART                 = '${DOCPSTART} >> ${workoutputfile}
    echo  >> ${workoutputfile}
    echo 'LOCALREMAINS              = '${LOCALREMAINS} >> ${workoutputfile}
    
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
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2019-12-06


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

# MODIFIED 2020-11-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CheckAndUnlockGaiaDB () {
    #
    # CheckAndUnlockGaiaDB - Check and Unlock Gaia database
    #
    
    echo -n 'Unlock gaia database : '
    
    export gaiadbunlocked=false
    
    until ${gaiadbunlocked} ; do
        
        export checkgaiadblocked=`clish -i -c "lock database override" | grep -i "owned"`
        export isclishowned=`test -z ${checkgaiadblocked}; echo $?`
        
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-11-11

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


# -------------------------------------------------------------------------------------------------
# Configure tools version from Gaia version and CLI parameters
# -------------------------------------------------------------------------------------------------

export toolsversion=${gaiaversion}

if [ -z ${CLIparm_l04_targetversion} ]; then
    export toolsversion=${gaiaversion}
else
    export toolsversion=${CLIparm_l04_targetversion}
fi

if [ ${gaiaversion} != ${toolsversion} ] ; then
    export EXPORTVERSIONDIFFERENT=true
else
    export EXPORTVERSIONDIFFERENT=false
fi


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
# shell meat
#
#==================================================================================================
#==================================================================================================


# -------------------------------------------------------------------------------------------------
# DocumentMgmtcpwdadminlist - Document the last execution of the cpwd_admin list command
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-04-20 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

DocumentMgmtcpwdadminlist () {
    #
    # Document the last execution of the cpwd_admin list command
    #
    
    echo | tee -a -i ${logfilepath}
    echo 'Check Point management services and processes' | tee -a -i ${logfilepath}
    if ${IsR8XVersion} ; then
        # cpm_status.sh only exists in R8X
        echo '${MDS_FWDIR}/scripts/cpm_status.sh' | tee -a -i ${logfilepath}
        ${MDS_FWDIR}/scripts/cpm_status.sh | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    echo 'cpwd_admin list' | tee -a -i ${logfilepath}
    cpwd_admin list | tee -a -i ${logfilepath}

    echo | tee -a -i ${logfilepath}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-04-20

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#DocumentMgmtcpwdadminlist


# -------------------------------------------------------------------------------------------------
# WatchMgmtcpwdadminlist - Watch and document the last execution of the cpwd_admin list command
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-04-20 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

WatchMgmtcpwdadminlist () {
    #
    # Watch and document the last execution of the cpwd_admin list command
    #
    
    watchcommands="echo 'Check Point management services and processes'"
    
    if ${IsR8XVersion} ; then
        # cpm_status.sh only exists in R8X
        watchcommands=${watchcommands}";echo;echo;echo '${MDS_FWDIR}/scripts/cpm_status.sh';${MDS_FWDIR}/scripts/cpm_status.sh"
    fi
    
    watchcommands=${watchcommands}";echo;echo;echo 'cpwd_admin list';cpwd_admin list"
    
    if ${CLIparm_NOWAIT} ; then
        echo 'Not watching and waiting...'
    else
        watch -d -n 1 "${watchcommands}"
    fi
    
    DocumentMgmtcpwdadminlist
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-04-20

#WatchMgmtcpwdadminlist

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# RemoveRemnantTempMigrationFolder - repeated proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED YYYY-MM-DD -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

RemoveRemnantTempMigrationFolder () {
    #
    # repeated procedure description
    #
    
    #export migration_work_folder="/var/log/opt/CPsuite-${gaiaversion}/fw1/tmp/migrate"
    export migration_work_folder="${FWDIR}/tmp/migrate"
    
    if [ -d ${migration_work_folder} ] ; then
        # found previous migrations work folder, that needs to go...
        echo 'Found Previous Migrations work Folder :  '${migration_work_folder} | tee -a -i ${logfilepath}
        echo >> ${logfilepath}
        ls -Alsh ${migration_work_folder} >> ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        echo 'Removing Previous Migrations work Folder :  '${migration_work_folder} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        rm -R -v -I ${migration_work_folder} | tee -a -i ${logfilepath}
        
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
    else
        
        echo 'No Previous Migrations work Folder found in '${migration_work_folder} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
    fi
    
    
    
    echo
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED YYYY-MM-DD

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#RemoveRemnantTempMigrationFolder

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Configure tools version from Gaia version and CLI parameters
# -------------------------------------------------------------------------------------------------

export toolsversion=${gaiaversion}

if [ -z ${CLIparm_l04_targetversion} ]; then
    export toolsversion=${gaiaversion}
else
    export toolsversion=${CLIparm_l04_targetversion}
fi

if [ ${gaiaversion} != ${toolsversion} ] ; then
    export EXPORTVERSIONDIFFERENT=true
else
    export EXPORTVERSIONDIFFERENT=false
fi


# -------------------------------------------------------------------------------------------------
# Validate we are working on a system that handles this operation
# -------------------------------------------------------------------------------------------------

export SMSMigrateServerExportSupported=false
export MDSMMigrateServerExportSupported=false
case "${gaiaversion}" in
    R80.20.M1 | R80.20.M2 ) 
        export SMSMigrateServerExportSupported=true
        export MDSMMigrateServerExportSupported=false
        ;;
    R80.20 ) 
        case "${toolsversion}" in
            R80.20.M1 ) 
                export SMSMigrateServerExportSupported=false
                export MDSMMigrateServerExportSupported=false
                ;;
            R80.20.M2 ) 
                export SMSMigrateServerExportSupported=true
                export MDSMMigrateServerExportSupported=false
                ;;
            R80.30 ) 
                export SMSMigrateServerExportSupported=false
                export MDSMMigrateServerExportSupported=false
                ;;
            *)
                export SMSMigrateServerExportSupported=true
                export MDSMMigrateServerExportSupported=true
                ;;
        esac
        ;;
    R80.30 | R80.40 ) 
        export SMSMigrateServerExportSupported=true
        export MDSMMigrateServerExportSupported=true
        ;;
    R81 | R81.10 | R81.20 ) 
        export SMSMigrateServerExportSupported=true
        export MDSMMigrateServerExportSupported=true
        ;;
    *)
        export SMSMigrateServerExportSupported=false
        export MDSMMigrateServerExportSupported=false
        ;;
esac


if [ ${Check4SMS} -gt 0 ] && [ ${Check4MDS} -eq 0 ]; then
    echo "System is Security Management Server!" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    if ${SMSMigrateServerExportSupported} ; then
        echo 'Continueing with Migrate Export... '${gaiaversion}' to '${toolsversion} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    else
        echo 'This script is not meant for SMS migration from  '${gaiaversion}' to '${toolsversion}', exiting!' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo '!! CRITICAL ERROR!!' | tee -a -i ${logfilepath}
        echo ' EXITING...' | tee -a -i ${logfilepath}
        echo ' LOGFILE : ' ${logfilepath} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        exit 255
    fi
elif [ ${Check4SMS} -gt 0 ] && [ ${Check4MDS} -gt 0 ]; then
    echo "System is Multi-Domain Management Server!" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    if ${MDSMMigrateServerExportSupported} ; then
        echo 'Continueing with Migrate Export... '${gaiaversion}' to '${toolsversion} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    else
        echo 'This script is not meant for MDM migration from  '${gaiaversion}' to '${toolsversion}', exiting!' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo '!! CRITICAL ERROR!!' | tee -a -i ${logfilepath}
        echo ' EXITING...' | tee -a -i ${logfilepath}
        echo ' LOGFILE : ' ${logfilepath} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        exit 255
    fi
else
    echo "System is a gateway!" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo "This script is not meant for gateways, exiting!" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo '!! CRITICAL ERROR!!' | tee -a -i ${logfilepath}
    echo ' EXITING...' | tee -a -i ${logfilepath}
    echo ' LOGFILE : ' ${logfilepath} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 255
fi


# -------------------------------------------------------------------------------------------------
# Setup script values
# -------------------------------------------------------------------------------------------------


#export outputfilepath=${outputpathroot}/
export outputfilepath=${logfilepathbase}/
if [ ${Check4MDS} -gt 0 ] ; then
    export outputfileprefix=migrate_server_export_${HOSTNAME}'_MDSM_'${gaiaversion}
else
    export outputfileprefix=migrate_server_export_${HOSTNAME}'_'${gaiaversion}
fi
export outputfilesuffix='_'${DATEDTGS}
export outputfiletype=.tgz

#----------------------------------------------------------------------------------------
# clish - save configuration to file
#----------------------------------------------------------------------------------------

export command2run=clish_config
export configfile=${command2run}'_'${outputfileprefix}${outputfilesuffix}
export configfilefqfn=${outputfilepath}${configfile}

echo | tee -a ${logfilepath}
echo 'Execute '${command2run}' with output to : '${configfilefqfn} | tee -a ${logfilepath}
echo | tee -a ${logfilepath}

CheckAndUnlockGaiaDB

clish -i -s -c "save configuration ${configfile}" >> ${logfilepath}

cp "${configfile}" "${configfilefqfn}" >> ${logfilepath}
mv "${configfile}" "${configfilefqfn}.txt" >> ${logfilepath}

#----------------------------------------------------------------------------------------

if [ -z ${CLIparm_l01_toolvername} ]; then
    if ${EXPORTVERSIONDIFFERENT} ; then
        export outputfileprefix=migrate_server_export_${HOSTNAME}'_'${gaiaversion}'_export_to_'${toolsversion}
    else
        export outputfileprefix=migrate_server_export_${HOSTNAME}'_'${gaiaversion}
    fi
else
    if ${EXPORTVERSIONDIFFERENT} ; then
        export outputfileprefix=migrate_server_export_${HOSTNAME}'_'${gaiaversion}'_export_to_'${toolsversion}'_using_'${CLIparm_l01_toolvername}
    else
        export outputfileprefix=migrate_server_export_${HOSTNAME}'_'${gaiaversion}'_export_using_'${CLIparm_l01_toolvername}
    fi
fi

# MODIFIED 2022-02-22 -

export migratefilename=migrate_server

case "${toolsversion}" in
    R80.20.M1 | R80.20.M2 | R80.20 | R80.30 | R80.40 ) 
        # /opt/CPsuite-R80.30/fw1/scripts/migrate_server
        # /opt/CPupgrade-tools-R80.30/scripts/migrate_server
        # /opt/CPsuite-R80.40/fw1/scripts/migrate_server
        # /opt/CPupgrade-tools-R80.40/scripts/migrate_server
        
        echo 'Version SUPPORTED for '${migratefilename}' export :  '${toolsversion} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        ;;
    R81 | R81.10 | R81.20 ) 
        #/opt/CPsuite-R81/fw1/scripts/migrate_server
        #/opt/CPupgrade-tools-R81/scripts/migrate_server
        #/opt/CPsuite-R81.10/fw1/scripts/migrate_server
        #/opt/CPupgrade-tools-R81.10/scripts/migrate_server
        #/opt/CPsuite-R81.20/fw1/scripts/migrate_server
        #/opt/CPupgrade-tools-R81.20/scripts/migrate_server
        
        echo 'Version SUPPORTED for '${migratefilename}' export :  '${toolsversion} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        ;;
    *)  
        echo 'Version NOT SUPPORTED for '${migratefilename}' export :  '${toolsversion} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo '!! CRITICAL ERROR!!' | tee -a -i ${logfilepath}
        echo ' EXITING...' | tee -a -i ${logfilepath}
        echo ' LOGFILE : ' ${logfilepath} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        exit 255
        ;;
esac

if [ -z ${CLIparm_l02_toolpath} ]; then
    if [ -r "/opt/CPupgrade-tools-${toolsversion}" ]; then
        export migratefilefolderroot=/opt/CPupgrade-tools-${toolsversion}
        export migratefilepath=${migratefilefolderroot}/scripts/
        echo 'Using version :  '${toolsversion}' from '${migratefilepath} | tee -a -i ${logfilepath}
    elif [ -r "/opt/CPsuite-${toolsversion}" ]; then
        export migratefilefolderroot=/opt/CPsuite-${toolsversion}
        export migratefilepath=${migratefilefolderroot}/fw1/scripts/
        echo 'Using version :  '${toolsversion}' from '${migratefilepath} | tee -a -i ${logfilepath}
    elif [ -r "/opt/CPupgrade-tools-${gaiaversion}" ]; then
        export migratefilefolderroot=/opt/CPupgrade-tools-${gaiaversion}
        export migratefilepath=${migratefilefolderroot}/scripts/
        echo 'Using version :  '${gaiaversion}', NOT version '${toolsversion}' from '${migratefilepath} | tee -a -i ${logfilepath}
    else
        export migratefilefolderroot=/opt/CPsuite-${gaiaversion}
        export migratefilepath=${migratefilefolderroot}/fw1/scripts/
        echo 'Using version :  '${gaiaversion}', NOT version '${toolsversion}' from '${migratefilepath} | tee -a -i ${logfilepath}
    fi
else
    if [ -r ${CLIparm_l02_toolpath} ]; then
        export migratefilefolderroot=
        export migratefilepath=${CLIparm_l02_toolpath%/}/
    else
        if [ -r "/opt/CPupgrade-tools-${toolsversion}" ]; then
            export migratefilefolderroot=/opt/CPupgrade-tools-${toolsversion}
            export migratefilepath=${migratefilefolderroot}/scripts/
            echo 'Using version :  '${toolsversion}' from '${migratefilepath} | tee -a -i ${logfilepath}
        elif [ -r "/opt/CPsuite-${toolsversion}" ]; then
            export migratefilefolderroot=/opt/CPsuite-${toolsversion}
            export migratefilepath=${migratefilefolderroot}/fw1/scripts/
            echo 'Using version :  '${toolsversion}' from '${migratefilepath} | tee -a -i ${logfilepath}
        elif [ -r "/opt/CPupgrade-tools-${gaiaversion}" ]; then
            export migratefilefolderroot=/opt/CPupgrade-tools-${gaiaversion}
            export migratefilepath=${migratefilefolderroot}/scripts/
            echo 'Using version :  '${gaiaversion}', NOT version '${toolsversion}' from '${migratefilepath} | tee -a -i ${logfilepath}
        else
            export migratefilefolderroot=/opt/CPsuite-${gaiaversion}
            export migratefilepath=${migratefilefolderroot}/fw1/scripts/
            echo 'Using version :  '${gaiaversion}', NOT version '${toolsversion}' from '${migratefilepath} | tee -a -i ${logfilepath}
        fi
    fi
fi

export migratefile=${migratefilepath}${migratefilename}

if [ ! -r ${migratefilepath} ]; then
    echo '!! CRITICAL ERROR!!' | tee -a -i ${logfilepath}
    echo '  Missing '${migratefilename}' file folder!' | tee -a -i ${logfilepath}
    echo '  Missing folder : '${migratefilepath} | tee -a -i ${logfilepath}
    echo ' EXITING...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 255
fi

if [ ! -r ${migratefile} ]; then
    echo '!! CRITICAL ERROR!!' | tee -a -i ${logfilepath}
    echo '  Missing '${migratefilename}' executable file !' | tee -a -i ${logfilepath}
    echo '  Missing executable file : '${migratefile} | tee -a -i ${logfilepath}
    echo ' EXITING...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 255
fi

echo | tee -a -i ${logfilepath}
echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Execute fw logswitch' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

fw logswitch | tee -a -i ${logfilepath}
fw logswitch -audit | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Migration Tools Folder to use:  '${migratefilepath} | tee -a -i ${logfilepath}
echo 'Migration Export Tools to use:  '${migratefile} | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

RemoveRemnantTempMigrationFolder


#
#    [host:0]# /opt/CPupgrade-tools-R81.10/scripts/migrate_server
#    
#    Use the migrate utility to : 1. Verify, export and import the Check Point
#                                    Security Management Server database.
#                                 2. Migrate_import_domain
#    
#        1. Verify, export and import
#    
#             Usage: migrate_server <ACTION> <PARAMETERS> [OPTIONS] <FILE>
#    
#             ACTION (required parameter):
#    
#             export - Exports the database of the Management Server or Multi-Domain Server.
#             import - Imports the database of the Management Server or Multi-Domain Server.
#             verify - Verifies the database of the Management Server or Multi-Domain Server.
#                   print_installed_tools - returns the upgrade tools installed for a given version.
#    
#             Parameters (required parameter):
#    
#             '-v <target version>'          Import version.
#    
#             Options (optional parameters):
#             '-h'                           Show this message.
#             '-skip_upgrade_tools_check'    Does not check for updated upgrade tools.
#             '-force-upgrade-flow'          When the source and target servers are on the same major version, migrate_server uses an accelerated flow to migrate the data.
#                                            This flag forces the full migration flow.
#                                            Note: if this flag is used, it is mandatory to use it both on export and import.
#             '-npb,--no_progress_bar'       Disable the progress bar.
#             '-l'                           Export/import logs without log indexes.
#             '-x'                           Export/import logs with log indexes.
#                                            Note: Only closed logs are exported/imported.
#             '-n'                           Run non-interactively.
#             '--exclude-uepm-postgres-db'   skip the backup/restore of PostgreSQL.
#             '--include-uepm-msi-files'     Export/import the uepm msi files.
#             '--exclude-licenses'           skip over backup/restore of licenses.
#    
#             <FILE> (required parameter only for import):
#    
#             Name of the archived file to export/import the database to/from.
#             Path to archive should exist.
#    
#    
#        2. Migrate_import_domain
#              usage: migrate_server <ACTION>  [OPTIONS]
#    
#              ACTION (required parameter):
#    
#              migrate_import_domain - Imports the database of the Domain Management Server
#                                      from a Multi-Domain Server.
#    
#              Options (optional parameters):
#    
#    
#              '-sn <Domain Server name>'      Name of the Domain Management Server
#    
#              '-dsi <Domain Server IP address>'      IP address of the Management Server
#                                          Default is local machine.
#              '-skip_logs'                Skip import logs (without log indexes.)
#    
#              '-o <path to export file>'    Path to export file.
#    
#              Name of the archived file to import.
#    
#    
#        Note:
#        Run the utility either from the current directory or use
#        an absolute path.
#    [host:0]#
#

case "${gaiaversion}" in
    R80.20.M1 | R80.20.M2 | R80.20 | R80.30 | R80.40 ) 
        export IsMigrateWIndexes=true
        ;;
    R81 | R81.10 | R81.20 ) 
        export IsMigrateWIndexes=true
        ;;
    *)
        export IsMigrateWIndexes=false
        ;;
esac

if $IsMigrateWIndexes ; then
    # Migrate supports export of indexes
    #export command2run='export -n -x'
    #export command2run='export -n'
    export command2run='export -n --include-uepm-msi-files'
else
    # Migrate does not supports export of indexes
    #export command2run='export -n -l'
    #export command2run='export -n'
    export command2run='export -n --include-uepm-msi-files'
fi

export command2run=${command2run}' -v '${toolsversion}

export UTOptionNPB=false

case "${toolsversion}" in
    R80.20.M1 | R80.20.M2 | R80.20 | R80.30 ) 
        export UTOptionNPB=false
        ;;
    R80.40 ) 
        export UTOptionNPB=true
        ;;
    R81 | R81.10 | R81.20 ) 
        export UTOptionNPB=true
        ;;
    *)  
        export UTOptionNPB=false
        ;;
esac

if ${CLIparm_NOHUP} ; then
    # running in NOHUP mode so disabling progress bar, if supported
    if ${UTOptionNPB} ; then
        export command2run=${command2run}' -npb'
    fi
fi

#export outputfile=${outputfileprefix}${outputfilesuffix}${outputfiletype}
export outputfile=${outputfileprefix}'_msi_logs'${outputfilesuffix}${outputfiletype}
export outputfilefqdn=${outputfilepath}${outputfile}

if $IsMigrateWIndexes ; then
    # Migrate supports export of indexes
    #export command2run2='export -n -x --include-uepm-msi-files'
    #export command2run2='export -n --include-uepm-msi-files'
    export command2run2='export -n'
else
    # Migrate does not supports export of indexes
    #export command2run2='export -n -l --include-uepm-msi-files'
    #export command2run2='export -n --include-uepm-msi-files'
    export command2run2='export -n'
fi

export command2run2=${command2run2}' -v '${toolsversion}

if ${CLIparm_NOHUP} ; then
    # running in NOHUP mode so disabling progress bar, if supported
    if ${UTOptionNPB} ; then
        export command2run2=${command2run2}' -npb'
    fi
fi

#export outputfile2=${outputfileprefix}'_msi_logs'${outputfilesuffix}${outputfiletype}
export outputfile2=${outputfileprefix}${outputfilesuffix}${outputfiletype}
export outputfilefqdn2=${outputfilepath}${outputfile2}

echo | tee -a -i ${logfilepath}
echo 'Execute command : '${migratefile} ${command2run} | tee -a -i ${logfilepath}
echo ' with ouptut to : '${outputfilefqdn} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

if [ ${Check4EPM} -gt 0 ]; then
    echo 'Execute command 2 : '${migratefile} ${command2run2} | tee -a -i ${logfilepath}
    echo ' with ouptut 2 to : '${outputfilefqdn2} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
fi

if ! ${NOWAIT} ; then read -t ${WAITTIME} -n 1 -p "Any key to continue or wait ${WAITTIME} seconds : " anykey ; fi
echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo 'Preparing ...' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

DocumentMgmtcpwdadminlist

if [ x"${migratefilename}" = x"migrate" ] ; then
    # migrate benefits from a cpstop, migrate_server does not
    
    echo | tee -a -i ${logfilepath}
    echo 'cpstop ...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    cpstop | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'cpstop completed' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
else
    # migrate benefits from a cpstop, migrate_server does not
    
    echo 'Continue to execute '${migratefilename} | tee -a -i ${logfilepath}
    
fi

echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Executing...' | tee -a -i ${logfilepath}
echo '-> '${migratefile} ${command2run} ${outputfilefqdn} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

#list ${CPDIR}/log/migrate-2020.03.17*
#/opt/CPshrd-R80.40/log/migrate-2020.03.17_00.46.19.log

# MODIFIED 2021-04-09 -
# Fixed issue with files not being copied because the date is not %d but %-e for the day

export migratedtgH=`date +%Y.%m.%d_%H`
#export migrateminuteX=`date +%M` ; export migrateminuteX=${migrateminuteX:0:1}
#export migratedatevalue=${migratedtgH}${migrateminuteX}
export migratedatevalue=${migratedtgH}

#export migratelogfiledate=`date +%Y.%m.%d_%H.%M`
export migratelogfiledate=${migratedatevalue}
export migratelogfilefqfn=/var/log${CPDIR}/migrate-${migratelogfiledate}.*.*.log

echo 'Rough migrate log file :  '${migratelogfilefqfn} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

#export migratelogfiledate=`date +%Y.%m.%d_%H.%M`
export upgradereporthtmlfiledate=${migratedatevalue}
export upgradereporthtmlfilefqfn=${MDS_FWDIR}/log/upgrade_report-${upgradereporthtmlfiledate}.*.*.html

echo 'Rough upgrade_report html file :  '${upgradereporthtmlfilefqfn} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

#export upgradedtgH=`date +%d%b%Y-%H`
export upgradedtgH=`date +%-e%b%Y-%H`
export upgrademinuteX=`date +%M` ; export upgrademinuteX=${upgrademinuteX:0:1}
export upgradedatevalue=${upgradedtgH}${upgrademinuteX}

#export upgradeexporttgzfiledate=`date +%d%b%Y-%H%M%S`
#export upgradeexporttgzfiledate=`date +%-e%b%Y-%H%M%S`
export upgradeexporttgzfiledate=${upgradedatevalue}
export upgradeexporttgzfilefqfn=/var/log/upgrade-export.${upgradeexporttgzfiledate}*.tgz

echo 'Rough upgrade-export tgz file :  '${upgradeexporttgzfilefqfn} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

#export upgradelogelgfiledate=`date +%d%b%Y-%H%M%S`
#export upgradelogelgfiledate=`date +%-e%b%Y-%H%M%S`
export upgradelogelgfiledate=${upgradedatevalue}
export upgradelogelgfilefqfn=${MDS_FWDIR}/log/upgrade_log.${upgradelogelgfiledate}*.elg

echo 'Rough upgrade_log elg file :  '${upgradelogelgfilefqfn} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' | tee -a -i ${logfilepath}

#if [ $testmode -eq 0 ]; then
#    # Not test mode
#    ${migratefile} ${command2run} ${outputfilefqdn} | tee -a -i ${logfilepath}
#    export errorresult=$?
#    
#    if [ ${errorresult} -ne 0 ] ; then
#        #Error executing migration operation!
#        echo "Encountered error ${errorresult} as result from ${migratefilename}!" >> ${logfilepath}
#    fi
#else
#    # test mode
#    echo Test Mode! | tee -a -i ${logfilepath}
#fi

${migratefile} ${command2run} -skip_upgrade_tools_check ${outputfilefqdn}
export errorresult=$?

if [ ${errorresult} -ne 0 ] ; then
    #Error executing migration operation!
    echo "Encountered error ${errorresult} as result from ${migratefilename}!" | tee -a -i ${logfilepath}
fi

echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' | tee -a -i ${logfilepath}

echo 'Copy rough migrate log : '${migratelogfilefqfn}' to folder : '${outputfilepath} | tee -a -i ${logfilepath}

cp ${migratelogfilefqfn} ${outputfilepath} | tee -a -i ${logfilepath}

if [ x"${migratefilename}" = x"migrate_server" ] ; then
    # migrate doesn't generate these files, so skip
    
    echo 'Copy rough upgrade_report html : '${upgradereporthtmlfilefqfn}' to folder : '${outputfilepath} | tee -a -i ${logfilepath}
    
    cp ${upgradereporthtmlfilefqfn} ${outputfilepath} | tee -a -i ${logfilepath}
    
    echo 'Copy rough upgrade-export tgz : '${upgradeexporttgzfilefqfn}' to folder : '${outputfilepath} | tee -a -i ${logfilepath}
    
    cp ${upgradeexporttgzfilefqfn} ${outputfilepath} | tee -a -i ${logfilepath}
    
    echo 'Copy rough upgrade elg : '${upgradelogelgfilefqfn}' to folder : '${outputfilepath} | tee -a -i ${logfilepath}
    
    cp ${upgradelogelgfilefqfn} ${outputfilepath} | tee -a -i ${logfilepath}
    
fi

echo | tee -a -i ${logfilepath}
echo 'Done performing '${migratefile} ${command2run} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

if [ ${Check4EPM} -gt 0 ]; then
    echo | tee -a -i ${logfilepath}
    echo 'Executing second export for EPM...' | tee -a -i ${logfilepath}
    echo '-> '${migratefile} ${command2run2} ${outputfilefqdn2} | tee -a -i ${logfilepath}
    
    RemoveRemnantTempMigrationFolder
    
    # MODIFIED 2021-04-09 -
    # Fixed issue with files not being copied because the date is not %d but %-e for the day
    
    
    export migratedtgH=`date +%Y.%m.%d_%H`
    #export migrateminuteX=`date +%M` ; export migrateminuteX=${migrateminuteX:0:1}
    #export migratedatevalue=${migratedtgH}${migrateminuteX}
    export migratedatevalue=${migratedtgH}
    
    #export migratelogfiledate=`date +%Y.%m.%d_%H.%M`
    export migratelogfiledate=${migratedatevalue}
    export migratelogfilefqfn=/var/log${CPDIR}/migrate-${migratelogfiledate}.*.*.log
    
    echo 'Rough migrate log file :  '${migratelogfilefqfn} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    #export migratelogfiledate=`date +%Y.%m.%d_%H.%M`
    export upgradereporthtmlfiledate=${migratedatevalue}
    export upgradereporthtmlfilefqfn=${MDS_FWDIR}/log/upgrade_report-${upgradereporthtmlfiledate}.*.*.html
    
    echo 'Rough upgrade_report html file :  '${upgradereporthtmlfilefqfn} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    #export upgradedtgH=`date +%d%b%Y-%H`
    export upgradedtgH=`date +%-e%b%Y-%H`
    export upgrademinuteX=`date +%M` ; export upgrademinuteX=${upgrademinuteX:0:1}
    export upgradedatevalue=${upgradedtgH}${upgrademinuteX}
    
    #export upgradeexporttgzfiledate=`date +%d%b%Y-%H%M%S`
    #export upgradeexporttgzfiledate=`date +%-e%b%Y-%H%M%S`
    export upgradeexporttgzfiledate=${upgradedatevalue}
    export upgradeexporttgzfilefqfn=/var/log/upgrade-export.${upgradeexporttgzfiledate}*.tgz
    
    echo 'Rough upgrade-export tgz file :  '${upgradeexporttgzfilefqfn} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    #export upgradelogelgfiledate=`date +%d%b%Y-%H%M%S`
    #export upgradelogelgfiledate=`date +%-e%b%Y-%H%M%S`
    export upgradelogelgfiledate=${upgradedatevalue}
    export upgradelogelgfilefqfn=${MDS_FWDIR}/log/upgrade_log.${upgradelogelgfiledate}*.elg
    
    echo 'Rough upgrade_log elg file :  '${upgradelogelgfilefqfn} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' | tee -a -i ${logfilepath}
    
    
    #if [ $testmode -eq 0 ]; then
    #    # Not test mode
    #    ${migratefile} ${command2run2} ${outputfilefqdn2} | tee -a -i ${logfilepath}
    #    export errorresult=$?
    #    
    #    if [ ${errorresult} -ne 0 ] ; then
    #        #Error executing migration operation!
    #        echo "Encountered error ${errorresult} as result from ${migratefilename}!" >> ${logfilepath}
    #    fi
    #else
    #    # test mode
    #    echo Test Mode! | tee -a -i ${logfilepath}
    #fi
    
    ${migratefile} ${command2run2} -skip_upgrade_tools_check ${outputfilefqdn2}
    export errorresult=$?
    
    if [ ${errorresult} -ne 0 ] ; then
        #Error executing migration operation!
        echo "Encountered error ${errorresult} as result from ${migratefilename}!" | tee -a -i ${logfilepath}
    fi
    
    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' | tee -a -i ${logfilepath}
    
    echo 'Copy rough migrate log : '${migratelogfilefqfn}' to folder : '${outputfilepath} | tee -a -i ${logfilepath}
    
    cp ${migratelogfilefqfn} ${outputfilepath} | tee -a -i ${logfilepath}
    
    if [ x"${migratefilename}" = x"migrate_server" ] ; then
        # migrate doesn't generate these files, so skip
        
        echo 'Copy rough upgrade_report html : '${upgradereporthtmlfilefqfn}' to folder : '${outputfilepath} | tee -a -i ${logfilepath}
        
        cp ${upgradereporthtmlfilefqfn} ${outputfilepath} | tee -a -i ${logfilepath}
        
        echo 'Copy rough upgrade-export tgz : '${upgradeexporttgzfilefqfn}' to folder : '${outputfilepath} | tee -a -i ${logfilepath}
        
        cp ${upgradeexporttgzfilefqfn} ${outputfilepath} | tee -a -i ${logfilepath}
        
        echo 'Copy rough upgrade elg : '${upgradelogelgfilefqfn}' to folder : '${outputfilepath} | tee -a -i ${logfilepath}
        
        cp ${upgradelogelgfilefqfn} ${outputfilepath} | tee -a -i ${logfilepath}
        
    fi
    
    echo | tee -a -i ${logfilepath}
    echo 'Done performing '${migratefile} ${command2run2} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
fi

echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' | tee -a -i ${logfilepath}

# MODIFIED 2021-01-25 -

echo | tee -a -i ${logfilepath}
ls -alh ${outputfilefqdn} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
ls -alh ${outputfilepath} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' | tee -a -i ${logfilepath}

DocumentMgmtcpwdadminlist

echo | tee -a -i ${logfilepath}
if ! ${NOWAIT} ; then read -t ${WAITTIME} -n 1 -p "Any key to continue or wait ${WAITTIME} seconds : " anykey ; fi
echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}

if ${CLIparm_NOSTART} ; then
    
    echo | tee -a -i ${logfilepath}
    echo 'Clean-up, stop services...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    DocumentMgmtcpwdadminlist
    
    echo | tee -a -i ${logfilepath}
    echo 'cpstop ...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    cpstop | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'cpstop completed' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    DocumentMgmtcpwdadminlist
    
    echo | tee -a -i ${logfilepath}
    if ! ${NOWAIT} ; then read -t ${WAITTIME} -n 1 -p "Any key to continue or wait ${WAITTIME} seconds : " anykey ; fi
    echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
    
else
    
    echo | tee -a -i ${logfilepath}
    echo 'Clean-up, stop, and [re-]start services...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    DocumentMgmtcpwdadminlist
    
    echo | tee -a -i ${logfilepath}
    echo 'cpstop ...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    cpstop | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'cpstop completed' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    if ! ${NOWAIT} ; then read -t ${WAITTIME} -n 1 -p "Any key to continue or wait ${WAITTIME} seconds : " anykey ; fi
    echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
    
    echo "Short ${WAITTIME} second nap..." | tee -a -i ${logfilepath}
    sleep ${WAITTIME}
    
    echo | tee -a -i ${logfilepath}
    echo 'cpstart... re-starting services...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    cpstart | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'cpstart completed' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    DocumentMgmtcpwdadminlist
    
    if ${IsR8XVersion} ; then
        # R8X version so kick the API on
        #echo | tee -a -i ${logfilepath}
        #echo 'api start ...' | tee -a -i ${logfilepath}
        #echo | tee -a -i ${logfilepath}
        #
        #api start | tee -a -i ${logfilepath}
        #
        echo | tee -a -i ${logfilepath}
        echo 'api status' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        api status | tee -a -i ${logfilepath}
        
        echo | tee -a -i ${logfilepath}
    else
        # not R8X version so no API
        echo | tee -a -i ${logfilepath}
    fi
    
fi


echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Done!' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Backup Folder : '${outputfilepath} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

ls -alh ${outputfilepath}/*.tgz | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}


#==================================================================================================
#==================================================================================================
#
# end shell meat
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


