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
# SCRIPT Check Status of Check Point Services IAW sk83520 (https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk83520)
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

export BASHScriptFileNameRoot=check_status_checkpoint_services
export BASHScriptShortName="CP_services_status"
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Check Status of Check Point Services"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}.v${ScriptVersion}

export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}
export BASHScriptHelpFileExamplesName=${BASHScriptFileNameRoot}.examples.help
export BASHScriptHelpExamplesFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileExamplesName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=Health_Check

export BASHScripttftptargetfolder="CP_status_check"


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
export OtherOutputFolder=./healthchecks

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
# shell meat
#
#==================================================================================================
#==================================================================================================


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
    
    echo '-----------------------------------------------------------------------------------------' >> ${logfilepath}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
    echo '| DNS Server Primary   :  '${DNS_primary} | tee -a -i ${logfilepath}
    echo '| DNS Server Secondary :  '${DNS_secondary} | tee -a -i ${logfilepath}
    echo '| DNS Server Tertiary  :  '${DNS_tertiary} | tee -a -i ${logfilepath}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
    echo '-----------------------------------------------------------------------------------------' >> ${logfilepath}
    echo tee -a -i ${logfilepath}
    
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
    
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
    echo '| nslookup address :  '${1}  | tee -a -i ${logfilepath}
    
    if [ x"${DNS_primary}" != x"" ] ; then
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo '| nslookup command with DNS Server Primary :  '${DNS_primary} | tee -a -i ${logfilepath}
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        
        nslookup ${1} ${DNS_primary} | tee -a -i ${logfilepath}
    else
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo '| DNS Server Primary ['${DNS_primary}'] NOT DEFINED!' | tee -a -i ${logfilepath}
    fi
    
    if [ x"${DNS_secondary}" != x"" ] ; then
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo '| nslookup command with DNS Server Secondary :  '${DNS_secondary} | tee -a -i ${logfilepath}
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        
        nslookup ${1} ${DNS_secondary} | tee -a -i ${logfilepath}
    else
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo '| DNS Server Secondary ['${DNS_secondary}'] NOT DEFINED!' | tee -a -i ${logfilepath}
    fi
    
    if [ x"${DNS_tertiary}" != x"" ] ; then
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo '| nslookup command with DNS Server Tertiary :  '${DNS_tertiary} | tee -a -i ${logfilepath}
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        
        nslookup ${1} ${DNS_tertiary} | tee -a -i ${logfilepath}
    else
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo '| DNS Server Tertiary ['${DNS_tertiary}'] NOT DEFINED!' | tee -a -i ${logfilepath}
    fi
    
    echo '-----------------------------------------------------------------------------------------' >> ${logfilepath}
    echo >> ${logfilepath}
    
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
    
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
    echo '| curl command | result = '$curlerror | tee -a -i ${logfilepath}
    echo '| # curl_cli '$@ | tee -a -i ${logfilepath}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
    
    cat $templogfile >> ${logfilepath}
    echo >> ${logfilepath}
    rm $templogfile >> ${logfilepath}
    
    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' >> ${logfilepath}
    
    cat $templogerrorfile >> ${logfilepath}
    echo >> ${logfilepath}
    rm $templogerrorfile >> ${logfilepath}
    
    echo '-----------------------------------------------------------------------------------------' >> ${logfilepath}
    echo >> ${logfilepath}
    
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

# MODIFIED 2019-01-19 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Document_wget () {
    #
    # Document_wget - Document wget command with log of error response (the actual response)
    #

    templogfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.wget_ops.log
    templogerrorfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.wget_ops.errout.log

    rm index.html
    wget "$@" 2> $templogerrorfile >> $templogfile
    rm index.html
    wgeterror=$?

    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
    echo '| wget command | result = '$wgeterror | tee -a -i ${logfilepath}
    echo '| # wget '$@ | tee -a -i ${logfilepath}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}

    cat $templogfile >> ${logfilepath}
    echo >> ${logfilepath}
    rm $templogfile >> ${logfilepath}

    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ' >> ${logfilepath}

    cat $templogerrorfile >> ${logfilepath}
    echo >> ${logfilepath}
    rm $templogerrorfile >> ${logfilepath}

    echo '-----------------------------------------------------------------------------------------' >> ${logfilepath}
    echo >> ${logfilepath}

    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-19

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# Document_wget


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# Verify Check Point services access
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


CheckAndUnlockGaiaDB

export DNS_primary=
export DNS_secondary=
export DNS_tertiary=

Populate_DNS_Servers


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Verify Check Point services access
# -------------------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Proxy settings implemented :' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

clish -i -c "show proxy" | tee -a -i ${logfilepath}


echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'cws.checkpoint.com : Application Control, URLF, AV, Malware' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup cws.checkpoint.com

Document_curl -v http://cws.checkpoint.com/APPI/SystemStatus/type/short
Document_curl -v http://cws.checkpoint.com/URLF/SystemStatus/type/short
Document_curl -v http://cws.checkpoint.com/AntiVirus/SystemStatus/type/short
Document_curl -v http://cws.checkpoint.com/Malware/SystemStatus/type/short

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'updates.checkpoint.com : IPS Updates' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup updates.checkpoint.com

Document_curl -v -k https://updates.checkpoint.com/

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'crl.globalsign.com : CRL that updates service certificate uses' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup crl.globalsign.com

Document_curl -v http://crl.globalsign.com/

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'dl3.checkpoint.com : Download Service updates' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup dl3.checkpoint.com

Document_curl -v -k http://dl3.checkpoint.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'usercenter.checkpoint.com : Contract Entitlement : IPS, Traditional AV, Traditional URLF' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup usercenter.checkpoint.com

Document_curl -v -k https://usercenter.checkpoint.com/usercenter/services/ProductCoverageService

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'usercenter.checkpoint.com : Contract Entitlement : Software Blades Manager Service' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup usercenter.checkpoint.com

Document_curl -v --cacert ${CPDIR}/conf/ca-bundle.crt https://usercenter.checkpoint.com/usercenter/services/BladesManagerService

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'resolver[1-5].chkp.ctmail.com : Suspicious Mail Outbreaks' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup resolver1.chkp.ctmail.com
Document_nslookup resolver2.chkp.ctmail.com
Document_nslookup resolver3.chkp.ctmail.com
Document_nslookup resolver4.chkp.ctmail.com
Document_nslookup resolver5.chkp.ctmail.com

Document_curl -v http://resolver1.chkp.ctmail.com
Document_curl -v http://resolver2.chkp.ctmail.com
Document_curl -v http://resolver3.chkp.ctmail.com
Document_curl -v http://resolver4.chkp.ctmail.com
Document_curl -v http://resolver5.chkp.ctmail.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'download.ctmail.com : Anti-Spam' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup download.ctmail.com

Document_curl -v http://download.ctmail.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'te.checkpoint.com : Threat Emulation' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup te.checkpoint.com

#Document_curl -v http://te.checkpoint.com
Document_curl -vk https://te.checkpoint.com/tecloud/Ping

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'teadv.checkpoint.com : Threat Emulation' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup teadv.checkpoint.com

Document_curl -v http://teadv.checkpoint.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'threat-emulation.checkpoint.com : Threat Emulation' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup threat-emulation.checkpoint.comm

Document_curl -v http://threat-emulation.checkpoint.com
Document_curl -v http://threat-emulation.checkpoint.com/tecloud/Ping

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'ptcs.checkpoint.com : Threat Emulation' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup ptcs.checkpoint.com

Document_curl -v https://ptcs.checkpoint.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'ptcd.checkpoint.com : Threat Emulation' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup ptcd.checkpoint.com

Document_curl -v https://ptcd.checkpoint.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'kav8.zonealarm.com : Archive Scanning and Deep Inspection' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup kav8.zonealarm.com

Document_curl -v http://kav8.zonealarm.com/version.txt

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'kav8.checkpoint.com : Traditional AV' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup kav8.checkpoint.com

Document_curl -v http://kav8.checkpoint.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'avupdates.checkpoint.com : Traditional AV, Legacy URLF' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup avupdates.checkpoint.com

Document_curl -v http://avupdates.checkpoint.com/UrlList.txt

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'sigcheck.checkpoint.com : Traditional AV, Legacy URLF, edge devices' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup sigcheck.checkpoint.com

Document_curl -v http://sigcheck.checkpoint.com/Siglist2.txt

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'smbmgmtservice.checkpoint.com : Manage SMB Gateways' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup smbmgmtservice.checkpoint.com

smp_connectivity_test smbmgmtservice.checkpoint.com | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'zerotouch.checkpoint.com : ZeroTouch Deployment (SMB)' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup zerotouch.checkpoint.com

test zero-touch-request | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'secureupdates.checkpoint.com : General updates server for Check Points gateways' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup secureupdates.checkpoint.com

Document_wget http://secureupdates.checkpoint.com
Document_curl -v secureupdates.checkpoint.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'https://productcoverage.checkpoint.com/ProductCoverageService : Contract Check' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup productcoverage.checkpoint.com

Document_curl -v https://productcoverage.checkpoint.com/ProductCoverageService

#echo | tee -a -i ${logfilepath}
#echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
#echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
#echo | tee -a -i ${logfilepath}
#echo 'https://cloudinfra-gw-us.portal.checkpoint.com : Cloud Infrastructure Check' | tee -a -i ${logfilepath}
#echo | tee -a -i ${logfilepath}

#Document_nslookup cloudinfra-gw-us.portal.checkpoint.com

#Document_curl -v https://cloudinfra-gw-us.portal.checkpoint.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'https://sc[1-5].checkpoint.com : Download of icons and screenshots from Check Point media storage servers' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup sc1.checkpoint.com
Document_nslookup sc2.checkpoint.com
Document_nslookup sc3.checkpoint.com
Document_nslookup sc4.checkpoint.com
Document_nslookup sc5.checkpoint.com

Document_curl -v https://sc1.checkpoint.com/sc/images/checkmark.gif
Document_curl -v https://sc1.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png
Document_curl -v https://sc1.checkpoint.com/za/images/facetime/large_png/60096017_lrg.png

Document_curl -v https://sc2.checkpoint.com/sc/images/checkmark.gif
Document_curl -v https://sc2.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png
Document_curl -v https://sc2.checkpoint.com/za/images/facetime/large_png/60096017_lrg.png

Document_curl -v https://sc3.checkpoint.com/sc/images/checkmark.gif
Document_curl -v https://sc3.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png
Document_curl -v https://sc3.checkpoint.com/za/images/facetime/large_png/60096017_lrg.png

Document_curl -v https://sc4.checkpoint.com/sc/images/checkmark.gif
Document_curl -v https://sc4.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png
Document_curl -v https://sc4.checkpoint.com/za/images/facetime/large_png/60096017_lrg.png

Document_curl -v https://sc5.checkpoint.com/sc/images/checkmark.gif
Document_curl -v https://sc5.checkpoint.com/za/images/facetime/large_png/60342479_lrg.png
Document_curl -v https://sc5.checkpoint.com/za/images/facetime/large_png/60096017_lrg.png

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'https://push.checkpoint.com : Push Notifications (since R77.10) for incoming e-mails and meeting requests on hand held devices, while the Capsule Workspace Mail app is in the background' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup push.checkpoint.com

Document_curl -vk https://push.checkpoint.com/push/ping

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'http://downloads.checkpoint.com : Download of Endpoint Compliance Updates (Endpoint Security On Demand (ESOD) database)' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup downloads.checkpoint.com

Document_curl -v http://downloads.checkpoint.com


echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'http://productservices.checkpoint.com : Next Generation Licensing uses this service. (Entitlement/Licensing Updates)' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup productservices.checkpoint.com

Document_curl -v http://productservices.checkpoint.com


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# Harmony Endpoint, SandBlast Agent specific checks
# https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk116590
# sk116590 - How to verify that SandBlast Agent can access Check Point servers?
#
# NOT ALL Checks are implemented, since documentation in SK is "lite"
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo 'Harmony Endpoint, SandBlast Agent specific checks' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}


echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  te.checkpoint.com : Threat Emulation' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup te.checkpoint.com

Document_curl -v -k http://te.checkpoint.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  gwevents.checkpoint.com : Threat Emulation blade telemetry - Statistics collection' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup gwevents.checkpoint.com

Document_curl -v -k gwevents.checkpoint.com

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  cws.checkpoint.com : Anti-Bot blade - Bot Detection' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup cws.checkpoint.com

Document_curl -v http://cws.checkpoint.com/Malware/SystemStatus/type/short

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  malw-cws.checkpoint.com : Anti-Bot blade - Bot Detection' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup malw-cws.checkpoint.com

Document_curl -v http://malw-cws.checkpoint.com/Malware/SystemStatus/type/short

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  secureupdates.checkpoint.com : Anti-Bot blade - Signatures database updates' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup secureupdates.checkpoint.com

Document_curl -v -k http://secureupdates.checkpoint.com/AMW/Version

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  sc1.checkpoint.com : Anti-Bot blade - Retrieve URL for bot detection server' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup sc1.checkpoint.com

Document_curl -v -k http://sc1.checkpoint.com/EPcws/TCUrlsFormat.txt

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  kav8.zonealarm.com : Anti-Malware blade - Signatures database updates' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup kav8.zonealarm.com

Document_curl -v http://kav8.zonealarm.com/v6/index/u1313g.xml

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  dnl-[01..19].geo.kaspersky.com : Anti-Malware blade - Signatures database updates' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

for i in `seq 1 19` ; do
    if [ ${i} -le 9 ] ; then
        Document_nslookup dnl-0${i}.geo.kaspersky.com
        
        Document_curl -v http://dnl-0${i}.geo.kaspersky.com/index/u1313g.xml
    else
        Document_nslookup dnl-${i}.geo.kaspersky.com
        
        Document_curl -v http://dnl-${i}.geo.kaspersky.com/index/u1313g.xml
    fi
done

#echo | tee -a -i ${logfilepath}
#echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
#echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
#echo | tee -a -i ${logfilepath}
#echo 'HEP/SBA:  ksn*.kaspersky-labs.com : Anti-Malware blade - Cloud Reputation Services' | tee -a -i ${logfilepath}
#echo | tee -a -i ${logfilepath}

#telnet ksn-crypto-file-geo.kaspersky-labs.com 443 | tee -a -i ${logfilepath}
#telnet ksn-crypto-url-geo.kaspersky-labs.com 443 | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  rep.checkpoint.com/Phishing : Phishing Service - File Reputation service' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup rep.checkpoint.com

Document_curl -v -k https://rep.checkpoint.com/Phishing/status

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  rep.checkpoint.com/file-rep/service : Threat Cloud Reputation Service - ThreatCloud File Reputation service' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup rep-cws.checkpoint.com

Document_curl -v -k POST https://rep-cws.checkpoint.com/file-rep/SystemStatus/type/short

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  sba-data-collection.iaas.checkpoint.com :  Data Collection service' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup sba-data-collection.iaas.checkpoint.comm

Document_curl -v -k POST https://sba-data-collection.iaas.checkpoint.com/upload

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  datatube-prod.azurewebsites.net/health :  EDR - Threat Hunting data upload' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup datatube-prod.azurewebsites.net

Document_curl -v -k -X GET https://datatube-prod.azurewebsites.net/health

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  us-east4-chkp-gcp-rnd-threat-hunt-box.cloudfunctions.net/prod-gcp-contractprovider/health :  EDR - Threat Hunting cloud function domain' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup us-east4-chkp-gcp-rnd-threat-hunt-box.cloudfunctions.net

Document_curl -v -k -X GET https://us-east4-chkp-gcp-rnd-threat-hunt-box.cloudfunctions.net/prod-gcp-contractprovider/health

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'HEP/SBA:  cloudinfra-gw.portal.checkpoint.com/auth/external Expect (401 UNAUTHORIZED) :  EDR - Cloud Infra' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

Document_nslookup cloudinfra-gw.portal.checkpoint.com

Document_curl -v -k -X POST https://cloudinfra-gw.portal.checkpoint.com/auth/external


# -------------------------------------------------------------------------------------------------
# END: Verify Check Point services access
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#


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


