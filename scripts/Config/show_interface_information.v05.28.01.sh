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
# SCRIPT Collect and show interface related information for all interfaces
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

export BASHScriptFileNameRoot=show_interface_information
export BASHScriptShortName="interface_info"
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Collect and show interface related information for all interfaces"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}.v${ScriptVersion}

export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}
export BASHScriptHelpFileExamplesName=${BASHScriptFileNameRoot}.examples.help
export BASHScriptHelpExamplesFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileExamplesName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=Config

export BASHScripttftptargetfolder="host_interface_info"


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
export OtherOutputFolder=./host_interface_info

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

#export CLIparm_local1=

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# processcliremains - Local command line parameter processor
# -------------------------------------------------------------------------------------------------

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
# START :  Collect and Capture Interface(s) Configuration and Information data
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


#==================================================================================================
# -------------------------------------------------------------------------------------------------
# START :  Operational Procedures
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# CopyFileAndDump2FQDNOutputfile - Copy identified file at path to output file path and also dump to output file
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
    
    if [ ! -r ${file2copypath} ] ; then
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'NO File Found at Path! :  ' | tee -a -i ${outputfilefqfn}
        echo ' - File : '${file2copy} | tee -a -i ${outputfilefqfn}
        echo ' - Path : '"${file2copypath}" | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    else
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'Found File at Path :  ' | tee -a -i ${outputfilefqfn}
        echo ' - File : '${file2copy} | tee -a -i ${outputfilefqfn}
        echo ' - Path : '"${file2copypath}" | tee -a -i ${outputfilefqfn}
        echo 'Copy File at Path to Target : ' | tee -a -i ${outputfilefqfn}
        echo ' - File at Path : '"${file2copypath}" | tee -a -i ${outputfilefqfn}
        echo ' - to Target    : '"${outputfilefqdn}" | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        cp "${file2copypath}" "${outputfilefqdn}" >> ${outputfilefqfn}
        
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
        echo 'Dump contents of Source File to Logging File :' | tee -a -i ${outputfilefqfn}
        echo ' - Source File  : '"${file2copypath}" | tee -a -i ${outputfilefqfn}
        echo ' - Logging File : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        cat "${file2copypath}" >> ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    fi
    echo | tee -a -i ${outputfilefqfn}
    
    echo
    return 0
}
#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

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
# END :  Operational Procedures
# -------------------------------------------------------------------------------------------------
#==================================================================================================


#----------------------------------------------------------------------------------------
# bash - Gaia Version information 
#----------------------------------------------------------------------------------------

export command2folder=
export command2run=Gaia_version
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

# This was already collected earlier and saved in a dedicated file

cp ${gaiaversionoutputfile} ${outputfilefqfn} | tee -a -i ${logfilepath}
rm ${gaiaversionoutputfile} | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
# bash - First Time Wizard (FTW) execution Completed
#----------------------------------------------------------------------------------------

export command2folder=installation
export command2run=FTW_Completed

DoCommandAndDocument ls -la /etc/.wizard_accepted
DoCommandAndDocument tail -n 10 /var/log/ftw_install.log


#----------------------------------------------------------------------------------------
# bash - gather arp details
#----------------------------------------------------------------------------------------

export command2folder=network
export command2run=arp

DoCommandAndDocument arp -vn
DoCommandAndDocument arp -av


#----------------------------------------------------------------------------------------
# bash - gather route details
#----------------------------------------------------------------------------------------

export command2folder=network
export command2run=route

DoCommandAndDocument route -vn


#----------------------------------------------------------------------------------------
# bash - collect /etc/routed*.conf and copy if it exists
#----------------------------------------------------------------------------------------

export command2folder=network
# /etc/routed*.conf
export file2copy=routed.conf
export file2copypath="/etc/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2copy=routed0.conf
export file2copypath="/etc/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2find=routed*.conf

FindFilesAndCollectIntoArchiveAllVariants


#----------------------------------------------------------------------------------------
# bash - generate device and system information via dmidecode
#----------------------------------------------------------------------------------------

export command2folder=hardware
export command2run=dmidecode

DoCommandAndDocument dmidecode


#----------------------------------------------------------------------------------------
# bash - collect /var/log/dmesg and copy if it exists
#----------------------------------------------------------------------------------------

export command2folder=hardware
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

# /var/log/dmesg
export file2copy=dmesg
export file2copypath=${outputfilefqdn}${file2copy}

export dmesgfilefqfn=${outputfilefqdn}${file2copy}

dmesg > ${dmesgfilefqfn}

#export outputfilenameaddon=
#CopyFileAndDump2FQDNOutputfile


#----------------------------------------------------------------------------------------
# bash - generate hardware informatation via lshw only if not old kernel
#----------------------------------------------------------------------------------------

export command2folder=hardware
export command2run=lshw

if [ ${isitoldkernel} -ne 1 ] ; then

    DoCommandAndDocument lshw

fi


#----------------------------------------------------------------------------------------
# bash - collect /etc/modprobe.conf and copy if it exists
#----------------------------------------------------------------------------------------

export command2folder=hardware
# /etc/modprobe.conf
export file2copy=modprobe.conf
export file2copypath="/etc/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2find=modprobe.conf

FindFilesAndCollectIntoArchiveAllVariants


#----------------------------------------------------------------------------------------
# bash - gather interface details - lspci
#----------------------------------------------------------------------------------------

export command2folder=hardware
export command2run=lspci

DoCommandAndDocument lspci -n -v


#----------------------------------------------------------------------------------------
# bash - gather interface details
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=ifconfig

DoCommandAndDocument ifconfig


#----------------------------------------------------------------------------------------
# bash - gather interfaces via ls
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=ls_sys_class_net

DoCommandAndDocument ls -1 /sys/class/net


#----------------------------------------------------------------------------------------
# bash - gather interface statistics via netstat -s
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=netstat_dash_s

DoCommandAndDocument netstat -s

#----------------------------------------------------------------------------------------
# bash - gather interface statistics via netstat -i
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=netstat_dash_i

DoCommandAndDocument netstat -i

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# InterfacesDoCommandAndDocument - For Interfaces execute command and document results to dedicated file
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-01-31 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

InterfacesDoCommandAndDocument () {
    #
    # For Interfaces execute command and document results to dedicated file
    #
    
    echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
    echo 'Execute : '"$@" >> ${interfaceoutputfilefqfn}
    echo >> ${interfaceoutputfilefqfn}
    
    "$@" >> ${interfaceoutputfilefqfn}
    
    echo >> ${interfaceoutputfilefqfn}
    echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#InterfacesDoCommandAndDocument


#----------------------------------------------------------------------------------------
# bash - Collect Interface Information per interface
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=interfaces_details
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

if [ ! -r ${dmesgfilefqfn} ] ; then
    echo | tee -a -i ${outputfilefqfn}
    echo 'No dmesg file at :  '${dmesgfilefqfn} | tee -a -i ${outputfilefqfn}
    echo 'Generating dmesg file!' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    dmesg > ${dmesgfilefqfn}
else
    echo | tee -a -i ${outputfilefqfn}
    echo 'found dmesg file at :  '${dmesgfilefqfn} | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
fi
echo | tee -a -i ${outputfilefqfn}

echo > ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}
echo 'Execute Commands with output to Output Path : ' | tee -a -i ${outputfilefqfn}
echo ' - Execute Commands   : '${command2run} | tee -a -i ${outputfilefqfn}
echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'clish -i -c "show interfaces"' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

CheckAndUnlockGaiaDB

clish -i -c "show interfaces" | tee -a -i ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

IFARRAY=()

GETINTERFACES="`clish -i -c "show interfaces"`"

echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'Build array of interfaces : ' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

case "${gaiaversion}" in
    R81 | R81.10 | R81.20 ) 
        export HasR8XDockerVersion=true
        ;;
    *)
        export HasR8XDockerVersion=false
        ;;
esac

arraylength=0

if ${HasR8XDockerVersion} ; then
    
    if [ ${arraylength} -eq 0 ]; then
        echo -n 'Interfaces :  ' | tee -a -i ${outputfilefqfn}
    else
        echo -n ', ' | tee -a -i ${outputfilefqfn}
    fi
    
    IFARRAY+=("docker0")
    
    arraylength=${#IFARRAY[@]}
    arrayelement=$((arraylength-1))
fi

while read -r line; do
    
    if [ ${arraylength} -eq 0 ]; then
        echo -n 'Interfaces :  ' | tee -a -i ${outputfilefqfn}
    else
        echo -n ', ' | tee -a -i ${outputfilefqfn}
    fi
    
    #IFARRAY+=("${line}")
    if [ "${line}" == 'lo' ]; then
        echo -n 'Not adding '${line} | tee -a -i ${outputfilefqfn}
    else 
        IFARRAY+=("${line}")
        echo -n ${line} | tee -a -i ${outputfilefqfn}
    fi
    
    arraylength=${#IFARRAY[@]}
    arrayelement=$((arraylength-1))
    
done <<< "${GETINTERFACES}"

echo | tee -a -i ${outputfilefqfn}

echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

echo 'Identified Interfaces in array for detail data collection :' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

for j in "${IFARRAY[@]}"
do
    #echo "${j}, ${j//\'/}"  | tee -a -i ${outputfilefqfn}
    echo ${j} | tee -a -i ${outputfilefqfn}
done
echo | tee -a -i ${outputfilefqfn}

echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

export ifshortoutputfile=${outputfileprefix}'_'${command2run}'_short'${outputfilesuffix}${outputfiletype}
#export ifshortoutputfilefqfn=${outputfilepath}${ifshortoutputfile}
if [ -z ${command2folder} ] ; then
    export ifshortoutputfilefqfn=${outputfilepath}${ifshortoutputfile}
else
    export ifshortoutputfilefqfn=${outputfilepath}${command2folder}/${ifshortoutputfile}
fi

touch ${ifshortoutputfilefqfn}
echo | tee -a -i ${ifshortoutputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${ifshortoutputfilefqfn}

for i in "${IFARRAY[@]}"
do
    
    export currentinterface=${i}
    
    export chkinterface4=`expr substr ${i} 1 4`
    
    #Check if the interface is a bond interface
    
    export bondckeck=`[[ 'bond' = ${chkinterface4} ]]; echo $?`
    if [ ${bondckeck} -eq 0 ] ; then
        export interfaceisbond=true
    else
        export interfaceisbond=false
    fi
    
    #------------------------------------------------------------------------------------------------------------------
    # Short Information
    #------------------------------------------------------------------------------------------------------------------
    
    echo 'Interface : '${i} | tee -a -i ${ifshortoutputfilefqfn}
    ifconfig ${i} | grep -i HWaddr | tee -a -i ${ifshortoutputfilefqfn}
    if ${interfaceisbond} ; then
        echo 'bond interface' | tee -a -i ${ifshortoutputfilefqfn}
    else
        ethtool -i ${i} | grep -i bus | tee -a -i ${ifshortoutputfilefqfn}
    fi
    echo '----------------------------------------------------------------------------------------' | tee -a -i ${ifshortoutputfilefqfn}
    
    #------------------------------------------------------------------------------------------------------------------
    # Detailed Information
    #------------------------------------------------------------------------------------------------------------------
    
    export interfaceoutputfile=${outputfileprefix}'_'${command2run}'_'$i${outputfilesuffix}${outputfiletype}
    #export interfaceoutputfilefqfn=${outputfilepath}${interfaceoutputfile}
    if [ -z ${command2folder} ] ; then
        export interfaceoutputfilefqfn=${outputfilepath}${interfaceoutputfile}
    else
        export interfaceoutputfilefqfn=${outputfilepath}${command2folder}/${interfaceoutputfile}
    fi
    
    echo 'Executing commands for interface : '${currentinterface}' with output to file : '${interfaceoutputfilefqfn} | tee -a -i ${outputfilefqfn}
    #echo | tee -a -i ${outputfilefqfn}
    
    if ${HasR8XDockerVersion} ; then
        # Currently R81+ with docker installation does not have clish visibility for docker0
        
        InterfacesDoCommandAndDocument ifconfig ${i}
        
    else
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Execute clish -i -c "show interface '${i}'"' >> ${interfaceoutputfilefqfn}
        echo >> ${interfaceoutputfilefqfn}
        
        clish -i -c "show interface ${i}" >> ${interfaceoutputfilefqfn}
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        
        InterfacesDoCommandAndDocument ifconfig ${i}
        
    fi
    
    #------------------------------------------------------------------------------------------------------------------
    # Detailed Information not available for bond interfaces
    #------------------------------------------------------------------------------------------------------------------
    
    if ${interfaceisbond} ; then
        # bond interface, skip details not relevant for bond interfaces
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Interface '${i}' is bond interface so no further details relevant or available!' >> ${interfaceoutputfilefqfn}
        echo 'Interface '${i}' is bond interface so no further details relevant or available!' | tee -a -i ${ifshortoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo >> ${interfaceoutputfilefqfn}
        
    else
        # not a bond interface, so drill down available details for the interface
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Interface '${i}' is not a bond, so drill into further details!' >> ${interfaceoutputfilefqfn}
        echo 'Interface '${i}' is not a bond, so drill into further details!' | tee -a -i ${ifshortoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        
        if ! ${HasR8XDockerVersion} ; then
            # Currently R81+ with docker installation does not have clish visibility for docker0
            
            echo >> ${interfaceoutputfilefqfn}
            echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
            echo 'Execute clish -i -c "show interface '${i}' rx-ringsize"' >> ${interfaceoutputfilefqfn}
            echo >> ${interfaceoutputfilefqfn}
            
            clish -i -c "show interface ${i} rx-ringsize" >> ${interfaceoutputfilefqfn}
            
            echo >> ${interfaceoutputfilefqfn}
            echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
            echo 'Execute clish -i -c "show interface '${i}' tx-ringsize"' >> ${interfaceoutputfilefqfn}
            echo >> ${interfaceoutputfilefqfn}
            
            clish -i -c "show interface ${i} tx-ringsize" >> ${interfaceoutputfilefqfn}
            
            echo >> ${interfaceoutputfilefqfn}
            echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
            echo 'Execute clish -i -c show interface '${i}' multi-queue verbose"' >> ${interfaceoutputfilefqfn}
            echo >> ${interfaceoutputfilefqfn}
            
            clish -i -c "show interface ${i} multi-queue verbose" >> ${interfaceoutputfilefqfn}
            
            echo >> ${interfaceoutputfilefqfn}
            echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
            
        fi
        
        InterfacesDoCommandAndDocument ethtool ${i}
        InterfacesDoCommandAndDocument ethtool -a ${i}
        InterfacesDoCommandAndDocument ethtool -i ${i}
        InterfacesDoCommandAndDocument ethtool -m ${i}
        InterfacesDoCommandAndDocument ethtool -m raw on ${i}
        InterfacesDoCommandAndDocument ethtool -P ${i}
        InterfacesDoCommandAndDocument ethtool -g ${i}
        InterfacesDoCommandAndDocument ethtool -k ${i}
        InterfacesDoCommandAndDocument ethtool -S ${i}
        InterfacesDoCommandAndDocument ethtool --phy-statistics ${i}
        InterfacesDoCommandAndDocument ethtool -d ${i}
        InterfacesDoCommandAndDocument ethtool -e ${i}
        InterfacesDoCommandAndDocument netstat --interfaces=${i}
        
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Execute grep of driver for '${i} >> ${interfaceoutputfilefqfn}
        echo >> ${interfaceoutputfilefqfn}
        
        export interfacedriver=`ethtool -i ${i} | grep -i "driver:" | cut -d " " -f 2`
        InterfacesDoCommandAndDocument modinfo $interfacedriver
        
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Execute grep of dmesg for '${i} >> ${interfaceoutputfilefqfn}
        echo >> ${interfaceoutputfilefqfn}
        
        cat ${dmesgfilefqfn} | grep -i ${i} >> ${interfaceoutputfilefqfn}
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        
    fi
    
    #------------------------------------------------------------------------------------------------------------------
    # Dump Detailed interface Information into consolidated interface file
    #------------------------------------------------------------------------------------------------------------------
    
    cat ${interfaceoutputfilefqfn} >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
done

echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}


#----------------------------------------------------------------------------------------
# bash - collect /etc/sysconfig/network and backup if it exists
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
# /etc/sysconfig/network
export file2copy=network
export file2copypath="/etc/sysconfig/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2find=modprobe.conf


#----------------------------------------------------------------------------------------
# bash - gather interface details from /etc/sysconfig/networking
#----------------------------------------------------------------------------------------

# /etc/sysconfig/networking

export command2folder=network_interfaces
export command2run=etc_sysconfig_networking
export sourcepath=/etc/sysconfig/networking

CopyFiles2CaptureFolder

#----------------------------------------------------------------------------------------
# bash - gather interface details from /etc/sysconfig/network-scripts
#----------------------------------------------------------------------------------------

# /etc/sysconfig/network-scripts

export command2folder=network_interfaces
export command2run=etc_sysconfig_networking_scripts
export sourcepath=/etc/sysconfig/network-scripts

CopyFiles2CaptureFolder

#----------------------------------------------------------------------------------------
# bash - gather interface name rules
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=interfaces_naming_rules
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

export file2copy=00-OS-XX.rules
export file2copypath="/etc/udev/rules.d/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2find=${file2copy}

FindFilesAndCollectIntoArchiveAllVariants


export file2copy=00-ANACONDA.rules
export file2copypath="/etc/sysconfig/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2find=${file2copy}

FindFilesAndCollectIntoArchiveAllVariants


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#


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
        #mkdir -pv ${outputfilepath}${command2folder} | tee -a -i ${logfilepath}
        #chmod 775 ${outputfilepath}${command2folder} | tee -a -i ${logfilepath}
    #else
        #chmod 775 ${outputfilepath}${command2folder} | tee -a -i ${logfilepath}
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
#


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# clish operations - might have issues if user is in Gaia webUI
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a ${logfilepath}
echo 'Execute clish opertations with common log in : '${clishoutputfilefqfn} | tee -a ${logfilepath}
echo | tee -a ${logfilepath}

export command2folder=
export command2run=clish_commands
export clishoutputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
export clishoutputfilefqfn=${outputfilepath}$clishoutputfile

echo | tee -a ${clishoutputfilefqfn}
echo 'Execute clish opertations with common log in : '${clishoutputfilefqfn} | tee -a ${clishoutputfilefqfn}
echo | tee -a ${clishoutputfilefqfn}


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
echo 'Execute '${command2run}' with output to : '$configfilefqfn | tee -a ${outputfilefqfn}
echo | tee -a ${outputfilefqfn}

CheckAndUnlockGaiaDB

clish -i -s -c "save configuration ${configfile}" >> ${outputfilefqfn}

cp "${configfile}" "$configfilefqfn" >> ${outputfilefqfn}
cp "${configfile}" "$configfilefqfn.txt" >> ${outputfilefqfn}

cat ${outputfilefqfn} >> ${clishoutputfilefqfn}


#----------------------------------------------------------------------------------------
# bash - generate hardware status information
#----------------------------------------------------------------------------------------

export command2folder=hardware
export command2run=hardware_status
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

echo | tee -a ${clishoutputfilefqfn}
echo 'Execute Command with output to Output Path : ' | tee -a -i ${clishoutputfilefqfn}
echo ' - Execute Command    : '${command2run} | tee -a -i ${clishoutputfilefqfn}
echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${clishoutputfilefqfn}
echo | tee -a ${clishoutputfilefqfn}

echo >> ${outputfilefqfn}
echo 'Execute Command with output to Output Path : ' >> ${outputfilefqfn}
echo ' - Execute Command    : '${command2run} >> ${outputfilefqfn}
echo ' - Output Path        : '${outputfilefqfn} >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo 'clish show asset all :' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

CheckAndUnlockGaiaDB

clish -i -c "show asset all" >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo 'clish show sysenv all :' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

CheckAndUnlockGaiaDB

clish -i -c "show sysenv all" >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

cat ${outputfilefqfn} >> ${clishoutputfilefqfn}

export command2folder=hardware
export command2run=hardware_status
DoCommandAndDocument cpstat os -f power_supply


#----------------------------------------------------------------------------------------
# clish and bash - Gather version information from all possible methods
#----------------------------------------------------------------------------------------

export command2folder=
export command2run=versions
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

echo | tee -a ${clishoutputfilefqfn}
echo 'Execute Command with output to Output Path : ' | tee -a -i ${clishoutputfilefqfn}
echo ' - Execute Command    : '${command2run} | tee -a -i ${clishoutputfilefqfn}
echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${clishoutputfilefqfn}
echo | tee -a ${clishoutputfilefqfn}

echo >> ${outputfilefqfn}
echo 'Execute Command with output to Output Path : ' >> ${outputfilefqfn}
echo ' - Execute Command    : '${command2run} >> ${outputfilefqfn}
echo ' - Output Path        : '${outputfilefqfn} >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

touch ${outputfilefqfn}
echo 'Versions:' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo 'uname for kernel version : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
uname -a >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'clish : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

CheckAndUnlockGaiaDB

clish -i -c "show version all" >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
clish -i -c "show version os build" >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'cpinfo -y all : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
cpinfo -y all >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'fwm ver : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
fwm ver >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'fw ver : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
fw ver >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'cpvinfo ${MDS_FWDIR}/cpm-server/dleserver.jar : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
cpvinfo ${MDS_FWDIR}/cpm-server/dleserver.jar >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}

if ${IsR8XVersion}; then
    # installed_jumbo_take only exists in R7X
    echo >> ${outputfilefqfn}
else
    echo >> ${outputfilefqfn}
    echo 'installed_jumbo_take : ' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    installed_jumbo_take >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
fi

echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

cat ${outputfilefqfn} >> ${clishoutputfilefqfn}


#----------------------------------------------------------------------------------------
# clish and bash - Gather ClusterXL information from all possible methods if it is a cluster
#----------------------------------------------------------------------------------------

export command2folder=gateway
export command2run=ClusterXL
export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}

echo | tee -a -i ${clishoutputfilefqfn}
echo 'ClusterXL information - if relevant' | tee -a -i ${clishoutputfilefqfn}
echo | tee -a -i ${clishoutputfilefqfn}

if [ "${sys_type_GW}" == "true" ]; then
    
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
    
    echo 'A Gateway so maybe ClusterXL' | tee -a -i ${clishoutputfilefqfn}
    
    if [[ $(cpconfig <<< 10 | grep cluster) == *"Disable"* ]]; then
        # is a cluster
        echo 'A cluster member.' | tee -a -i ${clishoutputfilefqfn}
        echo | tee -a -i ${clishoutputfilefqfn}
        
        touch ${outputfilefqfn}
        
        DoCommandAndDocument cphaprob state
        DoCommandAndDocument cphaprob mmagic
        DoCommandAndDocument cphaprob -a if
        DoCommandAndDocument cphaprob -ia list
        DoCommandAndDocument cphaprob -l list
        DoCommandAndDocument cphaprob syncstat
        DoCommandAndDocument cpstat ha -f all
        
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'Execute Command with output to Output Path : ' | tee -a -i ${outputfilefqfn}
        echo ' - Execute Command    : '${command2run} | tee -a -i ${outputfilefqfn}
        echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'Sync Status : fw ctl pstat | grep -A50 Sync:' | tee -a -i ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        
        fw ctl pstat | grep -A50 Sync: >> ${outputfilefqfn}
        
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo | tee -a -i ${outputfilefqfn}
        
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'Execute Command with output to Output Path : ' | tee -a -i ${outputfilefqfn}
        echo ' - Execute Command    : '${command2run} | tee -a -i ${outputfilefqfn}
        echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'clish -c "show routed cluster-state detailed"' >> ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        
        CheckAndUnlockGaiaDB
        
        clish -c "show routed cluster-state detailed" >> ${outputfilefqfn}
        
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo | tee -a -i ${outputfilefqfn}
        
        cat ${outputfilefqfn} >> ${clishoutputfilefqfn}
    else
        # is not a cluster
        echo 'Not a cluster member.' | tee -a -i ${clishoutputfilefqfn}
        echo | tee -a -i ${clishoutputfilefqfn}
    fi
else
    
    echo 'Not a Gateway so no ClusterXL' | tee -a -i ${clishoutputfilefqfn}
    
fi


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
# END :  Collect and Capture Interface(s) Configuration and Information data
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

echo
echo '----------------------------------------------------------------------------'
echo '----------------------------------------------------------------------------'
echo


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
    
    if [ ! -z ${MYTFTPSERVER1} ]; then
        
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
    
    if [ ! -z ${MYTFTPSERVER2} ]; then
        
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
    
    if [ ! -z ${MYTFTPSERVER3} ]; then
        
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


