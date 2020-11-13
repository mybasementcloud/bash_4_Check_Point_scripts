#!/bin/bash
#
# SCRIPT Remove script link files
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
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
ScriptDate=2020-11-12
ScriptVersion=04.43.00
ScriptRevision=000
TemplateVersion=04.43.00
TemplateLevel=006
SubScriptsLevel=006
SubScriptsVersion=04.25.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=${TemplateLevel}.v${TemplateVersion}

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=remove_script_links
export BASHScriptShortName="remove_links"
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Remove Script Links"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}.v${ScriptVersion}

export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=.

export BASHScripttftptargetfolder="_template"


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
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
export OutputToDump=true
export OutputToChangeLog=false
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
export OutputYMSubfolder=true
export OutputDTGSSubfolder=true
export OutputSubfolderScriptName=false
export OutputSubfolderScriptShortName=true

export OutputDTGTZinUTC=false


# -------------------------------------------------------------------------------------------------
# Local initial logfile variables
# -------------------------------------------------------------------------------------------------


export logfilefolderroot=/var/log/tmp
export logfilefoldername=${BASHScriptName}


# -------------------------------------------------------------------------------------------------
# logfile configuration
# -------------------------------------------------------------------------------------------------


# setup initial log file for output logging
export logfilefolder=${logfilefolderroot}/${logfilefoldername}
if $OutputDTGTZinUTC ; then
    export logfilepath=${logfilefolder}/${BASHScriptName}.${HOSTNAME}.${DATEUTCDTGS}.log
else
    export logfilepath=${logfilefolder}/${BASHScriptName}.${HOSTNAME}.${DATEDTGS}.log
fi

if ${OutputEnableLogFile} ; then
    # We are logging, so create the initial working folder and log file
    if [ ! -w ${logfilefolder} ]; then
        mkdir -pv ${logfilefolder}
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


export notthispath=/home/
export startpathroot=.

export localdotpath=`echo ${PWD}`
export currentlocalpath=${localdotpath}
export workingpath=${currentlocalpath}


# -------------------------------------------------------------------------------------------------
# Gaia and installation type handling
# -------------------------------------------------------------------------------------------------


export UseGaiaVersionAndInstallation=true
export ShowGaiaVersionResults=true
export KeepGaiaVersionResultsFile=false


# -------------------------------------------------------------------------------------------------
# Configure variables for subscripts calls
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-11 -

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
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# MOVED 2020-11-12 -
# -------------------------------------------------------------------------------------------------
# Announce Script, this should also be the first log entry!
# -------------------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo ${BASHScriptDescription}', script version '${ScriptVersion}', revision '${ScriptRevision}' from '${ScriptDate} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Date Time Group   :  '${DATEDTGS} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# -------------------------------------------------------------------------------------------------
# Quick Gaia main train version check for R8X release
# -------------------------------------------------------------------------------------------------


# MODIFIED/MOVED 2020-11-12 -

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

# MODIFIED 2020-09-11 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
export CLIparm_logpath=

export CLIparm_outputpath=

export CLIparm_NOWAIT=

# ADDED 2020-08-19 -
export CLIparm_api_key=
export CLIparm_use_api_key=false

# --NOWAIT
#
if [ -z "${NOWAIT}" ]; then
    # NOWAIT mode not set from shell level
    export CLIparm_NOWAIT=false
elif [ x"`echo "${NOWAIT}" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    # NOWAIT mode set OFF from shell level
    export CLIparm_NOWAIT=false
elif [ x"`echo "${NOWAIT}" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
    # NOWAIT mode set ON from shell level
    export CLIparm_NOWAIT=true
else
    # NOWAIT mode set to wrong value from shell level
    export CLIparm_NOWAIT=false
fi

export CLIparm_NOSTART=false

# --NOSTART
#
if [ -z "${NOSTART}" ]; then
    # NOSTART mode not set from shell level
    export CLIparm_NOSTART=false
elif [ x"`echo "${NOSTART}" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    # NOSTART mode set OFF from shell level
    export CLIparm_NOSTART=false
elif [ x"`echo "${NOSTART}" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
    # NOSTART mode set ON from shell level
    export CLIparm_NOSTART=true
else
    # NOSTART mode set to wrong value from shell level
    export CLIparm_NOSTART=false
fi

export CLIparm_NOHUP=false
export CLIparm_NOHUPScriptName=
export CLIparm_NOHUPDTG=

export REMAINS=

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-09-11

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
    
    if [ x"${SCRIPTVERBOSE}" = x"true" ] ; then
        # Verbose mode ON
        
        echo | tee -a -i ${logfilepath}
        cat ${workoutputfile} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        for i ; do echo - $i | tee -a -i ${logfilepath} ; done
        echo | tee -a -i ${logfilepath}
        echo CLI parms - number "$#" parms "$@" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if [ "${NOWAIT}" != "true" ] ; then
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


#==================================================================================================
#==================================================================================================
#==================================================================================================
# Start of template 
#==================================================================================================
#==================================================================================================


# =================================================================================================
# =================================================================================================
# START:  Command Line Parameter Handling and Help
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# dumprawcliremains
# -------------------------------------------------------------------------------------------------

dumprawcliremains () {
    #
    if [ x"${SCRIPTVERBOSE}" = x"true" ] ; then
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

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CommandLineParameterHandler () {
    #
    # CommandLineParameterHandler - Command Line Parameter Handler calling routine
    #
    
    # -------------------------------------------------------------------------------------------------
    # Check Command Line Parameter Handlerr action script exists
    # -------------------------------------------------------------------------------------------------
    
    # MODIFIED 2020-11-11 -
    
    export cli_script_cmdlineparm_handler_path=${cli_script_cmdlineparm_handler_root}/${cli_script_cmdlineparm_handler_folder}
    
    export cli_script_cmdlineparm_handler=${cli_script_cmdlineparm_handler_path}/${cli_script_cmdlineparm_handler_file}
    
    # Check that we can find the command line parameter handler file
    #
    if [ ! -r ${cli_script_cmdlineparm_handler} ] ; then
        # no file found, that is a problem
        
        echo | tee -a -i ${logfilepath}
        echo 'Command Line Parameter handler script file missing' | tee -a -i ${logfilepath}
        echo '  File not found : '${cli_script_cmdlineparm_handler} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if [ "${SCRIPTVERBOSE}" = "true" ] ; then
            echo 'Other parameter elements : ' | tee -a -i ${logfilepath}
            echo '  Root of folder path : '${cli_script_cmdlineparm_handler_root} | tee -a -i ${logfilepath}
            echo '  Folder in Root path : '${cli_script_cmdlineparm_handler_folder} | tee -a -i ${logfilepath}
            echo '  Folder Root path    : '${cli_script_cmdlineparm_handler_path} | tee -a -i ${logfilepath}
            echo '  Script Filename     : '${cli_script_cmdlineparm_handler_file} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        fi
        echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if [ "${NOWAIT}" != "true" ] ; then
            read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey
            echo
        fi
        
        exit 251
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Call Command Line Parameter Handlerr action script exists
    # -------------------------------------------------------------------------------------------------
    
    if [ "${SCRIPTVERBOSE}" = "true" ] ; then
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo "Calling external Command Line Paramenter Handling Script" | tee -a -i ${logfilepath}
        echo " - External Script : "${cli_script_cmdlineparm_handler} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    . ${cli_script_cmdlineparm_handler} "$@"
    
    if [ "${SCRIPTVERBOSE}" = "true" ] ; then
        echo | tee -a -i ${logfilepath}
        echo "Returned from external Command Line Paramenter Handling Script" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if [ "${NOWAIT}" != "true" ] ; then
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Call command line parameter handler action script
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -

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


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
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
# GetScriptSourceFolder - Get the actual source folder for the running script
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-14 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
    
    echo >> ${logfilepath}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-14


# -------------------------------------------------------------------------------------------------
# ConfigureJQforJSON - Configure JQ variable value for JSON parsing
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-11-11 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

ConfigureJQforJSON () {
    #
    # Configure JQ variable value for JSON parsing
    #
    # variable JQ points to where jq is installed
    #
    # Apparently MDM, MDS, and Domains don't agree on who sets CPDIR, so better to check!
    
    #export JQ=${CPDIR}/jq/jq
    
    export JQNotFound=false
    
    # points to where jq is installed
    if [ -r ${CPDIR}/jq/jq ] ; then
        export JQ=${CPDIR}/jq/jq
        export JQNotFound=false
        export UseJSONJQ=true
    elif [ -r ${CPDIR_PATH}/jq/jq ] ; then
        export JQ=${CPDIR_PATH}/jq/jq
        export JQNotFound=false
        export UseJSONJQ=true
    elif [ -r ${MDS_CPDIR}/jq/jq ] ; then
        export JQ=${MDS_CPDIR}/jq/jq
        export JQNotFound=false
        export UseJSONJQ=true
    else
        export JQ=
        export JQNotFound=true
        export UseJSONJQ=false
        
        if ${UseR8XAPI} ; then
            # to use the R8X API, JQ is required!
            echo "Missing jq, not found in ${CPDIR}/jq/jq, ${CPDIR_PATH}/jq/jq, or ${MDS_CPDIR}/jq/jq !" | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            exit 1
        fi
    fi
    
    # JQ16 points to where jq 1.6 is installed, which is not generally part of Gaia, even R80.40EA (2020-01-20)
    export JQ16NotFound=true
    export UseJSONJQ16=false
    
    # As of template version v04.21.00 we also added jq version 1.6 to the mix and it lives in the customer path root /tools/JQ folder by default
    export JQ16PATH=${customerpathroot}/_tools/JQ
    export JQ16FILE=jq-linux64
    export JQ16FQFN=${JQ16PATH}/${JQ16FILE}
    
    if [ -r ${JQ16FQFN} ] ; then
        # OK we have the easy-button alternative
        export JQ16=${JQ16FQFN}
        export JQ16NotFound=false
        export UseJSONJQ16=true
    elif [ -r "./_tools/JQ/${JQ16FILE}" ] ; then
        # OK we have the local folder alternative
        export JQ16=./_tools/JQ/${JQ16FILE}
        export JQ16NotFound=false
        export UseJSONJQ16=true
    elif [ -r "../_tools/JQ/${JQ16FILE}" ] ; then
        # OK we have the parent folder alternative
        export JQ16=../_tools/JQ/${JQ16FILE}
        export JQ16NotFound=false
        export UseJSONJQ16=true
    else
        export JQ16=
        export JQ16NotFound=true
        export UseJSONJQ16=false
        
        if ${UseR8XAPI} ; then
            if $JQ16Required ; then
                # to use the R8X API, JQ is required!
                echo 'Missing jq version 1.6, not found in '${JQ16FQFN}', '"./_tools/JQ/${JQ16FILE}"', or '"../_tools/JQ/${JQ16FILE}"' !' | tee -a -i ${logfilepath}
                echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
                echo | tee -a -i ${logfilepath}
                echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
                echo | tee -a -i ${logfilepath}
                exit 1
            else
                echo 'Missing jq version 1.6, not found in '${JQ16FQFN}', '"./_tools/JQ/${JQ16FILE}"', or '"../_tools/JQ/${JQ16FILE}"' !' | tee -a -i ${logfilepath}
                echo 'However it is not required for this operation' | tee -a -i ${logfilepath}
                echo | tee -a -i ${logfilepath}
            fi
        fi
    fi
    
    return 0
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-11-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# SetScriptOutputPathsAndFolders - Setup and call configure script output paths and folders handler action script
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-01-30 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

SetScriptOutputPathsAndFolders () {
    #
    # Setup and call configure script output paths and folders handler action script
    #
    
    export script_output_paths_and_folders_handler_path=${script_output_paths_and_folders_handler_root}/${script_output_paths_and_folders_handler_folder}
    
    export script_output_paths_and_folders_handler=${script_output_paths_and_folders_handler_path}/${script_output_paths_and_folders_handler_file}
    
    # -------------------------------------------------------------------------------------------------
    # Check output paths and folders handler action script exists
    # -------------------------------------------------------------------------------------------------
    
    # Check that we can finde the output paths and folders handler action script file
    #
    if [ ! -r ${script_output_paths_and_folders_handler} ] ; then
        # no file found, that is a problem
        if [ "${SCRIPTVERBOSE}" = "true" ] ; then
            echo | tee -a -i ${logfilepath}
            echo 'output paths and folders handler action script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${script_output_paths_and_folders_handler} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Other parameter elements : ' | tee -a -i ${logfilepath}
            echo '  Root of folder path : '${script_output_paths_and_folders_handler_root} | tee -a -i ${logfilepath}
            echo '  Folder in Root path : '${script_output_paths_and_folders_handler_folder} | tee -a -i ${logfilepath}
            echo '  Folder Root path    : '${script_output_paths_and_folders_handler_path} | tee -a -i ${logfilepath}
            echo '  Script Filename     : '${script_output_paths_and_folders_handler_file} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        else
            echo | tee -a -i ${logfilepath}
            echo 'output paths and folders handler action script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${script_output_paths_and_folders_handler} | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        fi
        
        exit 251
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Call output paths and folders handler action script
    # -------------------------------------------------------------------------------------------------
    
    #
    # output paths and folders handler action script calling routine
    #
    
    if [ "${SCRIPTVERBOSE}" = "true" ] ; then
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo "Calling external Configure script output paths and folders Handling Script" | tee -a -i ${logfilepath}
        echo " - External Script : "${script_output_paths_and_folders_handler} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    . ${script_output_paths_and_folders_handler} "$@"
    
    if [ "${SCRIPTVERBOSE}" = "true" ] ; then
        echo | tee -a -i ${logfilepath}
        echo "Returned from external Configure script output paths and folders Handling Script" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if [ "${NOWAIT}" != "true" ] ; then
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-30

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# GetGaiaVersionAndInstallationType - Setup and call gaia version and type handler action script
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-10-03 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

GetGaiaVersionAndInstallationType () {
    #
    # Setup and call gaia version and type handler action script
    #
    
    export gaia_version_type_handler_path=${gaia_version_type_handler_root}/${gaia_version_type_handler_folder}
    
    export gaia_version_type_handler=${gaia_version_type_handler_path}/${gaia_version_type_handler_file}
    
    # -------------------------------------------------------------------------------------------------
    # Check gaia version and type handler action script exists
    # -------------------------------------------------------------------------------------------------
    
    # Check that we can finde the gaia version and type handler file
    #
    if [ ! -r ${gaia_version_type_handler} ] ; then
        # no file found, that is a problem
        if [ "${SCRIPTVERBOSE}" = "true" ] ; then
            echo | tee -a -i ${logfilepath}
            echo 'gaia version and type handler script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${gaia_version_type_handler} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Other parameter elements : ' | tee -a -i ${logfilepath}
            echo '  Root of folder path : '${gaia_version_type_handler_root} | tee -a -i ${logfilepath}
            echo '  Folder in Root path : '${gaia_version_type_handler_folder} | tee -a -i ${logfilepath}
            echo '  Folder Root path    : '${gaia_version_type_handler_path} | tee -a -i ${logfilepath}
            echo '  Script Filename     : '${gaia_version_type_handler_file} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        else
            echo | tee -a -i ${logfilepath}
            echo 'gaia version and type handler script file missing' | tee -a -i ${logfilepath}
            echo '  File not found : '${gaia_version_type_handler} | tee -a -i ${logfilepath}
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
        fi
        
        exit 251
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Call gaia version and type handler action script
    # -------------------------------------------------------------------------------------------------
    
    #
    # gaia version and type handler calling routine
    #
    
    if [ "${SCRIPTVERBOSE}" = "true" ] ; then
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo "Calling external Gaia Version and Installation Type Handling Script" | tee -a -i ${logfilepath}
        echo " - External Script : "${gaia_version_type_handler} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    . ${gaia_version_type_handler} "$@"
    
    if [ "${SCRIPTVERBOSE}" = "true" ] ; then
        echo | tee -a -i ${logfilepath}
        echo "Returned from external Gaia Version and Installation Type Handling Script" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        if [ "${NOWAIT}" != "true" ] ; then
            read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey
            echo
        fi
        
        echo | tee -a -i ${logfilepath}
        echo "Continueing local execution" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo '--------------------------------------------------------------------------' | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Handle results from gaia version and type handler action script locally
    # -------------------------------------------------------------------------------------------------
    
    if ${ShowGaiaVersionResults} ; then
        # show the results of this operation on the screen, not just the log file
        cat ${gaiaversionoutputfile} | tee -a -i ${logfilepath}
        echo | tee -a -i ${gaiaversionoutputfile}
    else
        # only log the results of this operation
        cat ${gaiaversionoutputfile} >> ${logfilepath}
        echo >> ${logfilepath}
    fi
    
    # now remove the working file
    if ! ${KeepGaiaVersionResultsFile} ; then
        # not keeping version results file
        rm ${gaiaversionoutputfile}
    fi

    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-10-03

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# END:  Root Procedures
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Root Operations
# -------------------------------------------------------------------------------------------------


# MOVED 2020-09-14 -


# -------------------------------------------------------------------------------------------------
# Script Source Folder
# -------------------------------------------------------------------------------------------------

# We need the Script's actual source folder to find subscripts
#
GetScriptSourceFolder


# -------------------------------------------------------------------------------------------------
# JQ and json related
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-01-03 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

if ${UseJSONJQ} || ${UseJSONJQ16} ; then 
    ConfigureJQforJSON
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-01-03


#----------------------------------------------------------------------------------------
# Gaia version and installation type identification
#----------------------------------------------------------------------------------------

if ${UseGaiaVersionAndInstallation} ; then
    GetGaiaVersionAndInstallationType "$@"
fi


# -------------------------------------------------------------------------------------------------
# Configure script output paths and folders
# -------------------------------------------------------------------------------------------------

SetScriptOutputPathsAndFolders "$@" 


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
    R81 ) 
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


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# Scripts link generation and setup
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


export workingroot=${customerworkpathroot}
export workingbase=${workingroot}/scripts
export linksbase=${workingbase}/.links
export scriptsbase=${scriptspathb4CP}
export scriptsrepository=${scriptsbase}/scripts_repository


if [ ! -r ${workingbase} ] ; then
    echo | tee -a -i ${logfilepath}
    echo Error! | tee -a -i ${logfilepath}
    echo Missing folder ${workingbase} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo Exiting! | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    exit 255
else
    chmod 775 ${workingbase} | tee -a -i ${logfilepath}
fi


chmod 775 ${linksbase} | tee -a -i ${logfilepath}


chmod 775 ${scriptsbase} | tee -a -i ${logfilepath}


echo | tee -a -i ${logfilepath}
echo 'Start with links clean-up!' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  _hostsetupscripts
# =============================================================================


export workingdir=_hostsetupscripts
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

#rm ${workingroot}/setuphost >> ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  _hostupdatescripts
# =============================================================================


export workingdir=_hostupdatescripts
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

#rm ${workingroot}/update_tools | tee -a -i ${logfilepath}
#rm ${workingroot}/updatescripts | tee -a -i ${logfilepath}
#rm ${workingroot}/updatescripts.sample | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  Common
# =============================================================================


export workingdir=Common
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/gaia_version_type | tee -a -i ${logfilepath}

rm ${workingroot}/do_script_nohup | tee -a -i ${logfilepath}

# REMOVED 2020-09-17 -
rm ${workingroot}/godump | tee -a -i ${logfilepath}
rm ${workingroot}/godtgdump | tee -a -i ${logfilepath}
rm ${workingroot}/goChangeLog | tee -a -i ${logfilepath}
rm ${workingroot}/mkdump | tee -a -i ${logfilepath}
rm ${workingroot}/mkdtgdump | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  Config
# =============================================================================


export workingdir=Config
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/config_capture | tee -a -i ${logfilepath}
rm ${workingroot}/interface_info | tee -a -i ${logfilepath}
rm ${workingroot}/EPM_config_check | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  GAIA
# =============================================================================


export workingdir=GAIA
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

if ${IsR8XVersion} ; then
    
    rm ${workingroot}/update_gaia_rest_api | tee -a -i ${logfilepath}
    rm ${workingroot}/update_gaia_dynamic_cli | tee -a -i ${logfilepath}
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  GW
# =============================================================================


export workingdir=GW
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/watch_accel_stats | tee -a -i ${logfilepath}
rm ${workingroot}/set_informative_logging_implied_rules_on_R8x | tee -a -i ${logfilepath}
rm ${workingroot}/reset_hit_count_with_backup | tee -a -i ${logfilepath}
rm ${workingroot}/cluster_info | tee -a -i ${logfilepath}
rm ${workingroot}/show_cluster_info | tee -a -i ${logfilepath}
rm ${workingroot}/watch_cluster_info | tee -a -i ${logfilepath}
rm ${workingroot}/enable_rad_admin_stats_and_cpview | tee -a -i ${logfilepath}
rm ${workingroot}/vpn_client_operational_info | tee -a -i ${logfilepath}
rm ${workingroot}/vpn_client_operational_info.standalone | tee -a -i ${logfilepath}
rm ${workingroot}/fix_gw_missing_updatable_objects | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  GW.CORE
# =============================================================================


export workingdir=GW.CORE
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

if [ ! -r $sourcefolder ] ; then
    # This folder is not part of the distribution
    echo 'Skipping folder '$sourcefolder | tee -a -i ${logfilepath}
else
    rm ${workingroot}/fix_smcias_interfaces | tee -a -i ${logfilepath}
    rm ${workingroot}/set_fwkern_dot_conf_settings_on_R8x.CORE | tee -a -i ${logfilepath}
    rm ${workingroot}/setup_sk106251_check_point_dynamic_objects | tee -a -i ${logfilepath}
fi


# =============================================================================
# =============================================================================
# FOLDER:  Health_Check
# =============================================================================


export workingdir=Health_Check
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/healthcheck | tee -a -i ${logfilepath}
rm ${workingroot}/healthdump | tee -a -i ${logfilepath}
rm ${workingroot}/check_point_service_status_check | tee -a -i ${logfilepath}

# Legacy Naming Clean-up
rm ${workingroot}/checkpoint_service_status_check | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  MDM
# =============================================================================


export workingdir=MDM
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/backup_mds_ugex | tee -a -i ${logfilepath}
rm ${workingroot}/backup_w_logs_mds_ugex | tee -a -i ${logfilepath}
rm ${workingroot}/report_mdsstat | tee -a -i ${logfilepath}
rm ${workingroot}/watch_mdsstat | tee -a -i ${logfilepath}
rm ${workingroot}/show_domains_in_array | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  MGMT
# =============================================================================


export workingdir=MGMT
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/identify_self_referencing_symbolic_link_files | tee -a -i ${logfilepath}
rm ${workingroot}/Lite.identify_self_referencing_symbolic_link_files | tee -a -i ${logfilepath}
rm ${workingroot}/check_status_of_scheduled_ips_updates_on_management | tee -a -i ${logfilepath}
rm ${workingroot}/show_unpublished_locked_objects | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  Patch_HotFix
# =============================================================================


export workingdir=Patch_HotFix
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

export need_fix_webui=false

rm ${workingroot}/fix_gaia_webui_login_dot_js | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  Session_Cleanup
# =============================================================================


export workingdir=Session_Cleanup
export folderstdversion=v04.50.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/mdm_show_zerolocks_sessions | tee -a -i ${logfilepath}
rm ${workingroot}/mdm_show_zerolocks_web_api_sessions | tee -a -i ${logfilepath}
rm ${workingroot}/mdm_remove_zerolocks_sessions | tee -a -i ${logfilepath}
rm ${workingroot}/mdm_remove_zerolocks_web_api_sessions | tee -a -i ${logfilepath}
rm ${workingroot}/show_zerolocks_sessions | tee -a -i ${logfilepath}
rm ${workingroot}/show_zerolocks_web_api_sessions | tee -a -i ${logfilepath}
rm ${workingroot}/remove_zerolocks_sessions | tee -a -i ${logfilepath}
rm ${workingroot}/remove_zerolocks_web_api_sessions | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  SmartEvent
# =============================================================================


export workingdir=SmartEvent
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/SmartEvent_backup | tee -a -i ${logfilepath}
#rm ${workingroot}/SmartEvent_restore | tee -a -i ${logfilepath}
#rm ${workingroot}/Reset_SmartLog_Indexing | tee -a -i ${logfilepath}
#rm ${workingroot}/Reset_SmartEvent_Indexing | tee -a -i ${logfilepath}
#rm ${workingroot}/SmartEvent_NUKE_Index_and_Logs | tee -a -i ${logfilepath}
rm ${workingroot}/LogExporter_Backup | tee -a -i ${logfilepath}
rm ${workingroot}/LogExporter_Backup_R8X | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  SMS
# =============================================================================


export workingdir=SMS
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/report_cpwd_admin_list | tee -a -i ${logfilepath}
rm ${workingroot}/watch_cpwd_admin_list | tee -a -i ${logfilepath}
rm ${workingroot}/restart_mgmt | tee -a -i ${logfilepath}
rm ${workingroot}/reset_hit_count_on_R80_SMS_commands | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  SMS.CORE
# =============================================================================


export workingdir=SMS.CORE
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

#if [ "${sys_type_SMS}" == "true" ]; then
    
    #rm ${workingroot}/CORE-G2_install_policy | tee -a -i ${logfilepath}
    
#fi


# =============================================================================
# =============================================================================
# FOLDER:  SMS.migrate_backup
# =============================================================================


export workingdir=SMS.migrate_backup
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/migrate_export_npm_ugex | tee -a -i ${logfilepath}
rm ${workingroot}/migrate_export_w_logs_npm_ugex | tee -a -i ${logfilepath}
rm ${workingroot}/migrate_export_epm_ugex | tee -a -i ${logfilepath}
rm ${workingroot}/migrate_export_w_logs_epm_ugex | tee -a -i ${logfilepath}

rm ${workingroot}/migrate_server_export_npm_ugex | tee -a -i ${logfilepath}
rm ${workingroot}/migrate_server_export_w_logs_npm_ugex | tee -a -i ${logfilepath}
rm ${workingroot}/migrate_server_export_epm_ugex | tee -a -i ${logfilepath}
rm ${workingroot}/migrate_server_export_w_logs_epm_ugex | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  UserConfig
# =============================================================================


export workingdir=UserConfig
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

rm ${workingroot}/alias_commands_add_user | tee -a -i ${logfilepath}
rm ${workingroot}/alias_commands_add_all_users | tee -a -i ${logfilepath}
rm ${workingroot}/alias_commands_update_user | tee -a -i ${logfilepath}
rm ${workingroot}/alias_commands_update_all_users | tee -a -i ${logfilepath}

# Legacy Naming Clean-up
rm -f ${workingroot}/add_alias_commands | tee -a -i ${logfilepath}
rm -f ${workingroot}/update_alias_commands | tee -a -i ${logfilepath}
rm -f ${workingroot}/update_alias_commands_all_users | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  UserConfig.CORE_G2.NPM
# =============================================================================


export workingdir=UserConfig.CORE_G2.NPM
export folderstdversion=v04.43.00
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

if [ ! -r $sourcefolder ] ; then
    # This folder is not part of the distribution
    echo 'Skipping folder '$sourcefolder | tee -a -i ${logfilepath}
else
    
    rm ${workingroot}/alias_commands_CORE_G2_NPM_add_user
    rm ${workingroot}/alias_commands_CORE_G2_NPM_add_all_users
    rm ${workingroot}/alias_commands_CORE_G2_NPM_update_user
    rm ${workingroot}/alias_commands_CORE_G2_NPM_update_all_users
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  
# =============================================================================

# =============================================================================
# =============================================================================
# FOLDER:  ${scriptsbase} and ${linksbase}
# =============================================================================


# =============================================================================
# =============================================================================

rm -f -r -d ${linksbase} | tee -a -i ${logfilepath}

# =============================================================================
# =============================================================================

#rm -f -r -d ${scriptsbase} | tee -a -i ${logfilepath}

# =============================================================================
# =============================================================================

echo | tee -a -i ${logfilepath}
echo 'List folder : '$workingroot | tee -a -i ${logfilepath}
ls -alh $workingroot | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'List folder : '${workingbase} | tee -a -i ${logfilepath}
ls -alh ${workingbase} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Done with links clean-up!' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

# =============================================================================
# =============================================================================



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


