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
# SCRIPT Configure script link files and copy versioned scripts to generics
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

export BASHScriptFileNameRoot=generate_script_links
export BASHScriptShortName="generate_links"
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Generate Script Links"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}.v${ScriptVersion}

export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}
export BASHScriptHelpFileExamplesName=${BASHScriptFileNameRoot}.examples.help
export BASHScriptHelpExamplesFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileExamplesName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]||Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=.

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
        
        if ${B4CPSCRIPTVERBOSE} ; then
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
        
        if ! ${NOWAIT} ; then
            read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey
            echo
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


if [ ! -r ${linksbase} ] ; then
    mkdir -pv ${linksbase} | tee -a -i ${logfilepath}
    chmod 775 ${linksbase} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksbase} | tee -a -i ${logfilepath}
fi


if [ ! -r ${scriptsbase} ] ; then
    mkdir -pv ${scriptsbase} | tee -a -i ${logfilepath}
    chmod 775 ${scriptsbase} | tee -a -i ${logfilepath}
else
    chmod 775 ${scriptsbase} | tee -a -i ${logfilepath}
fi


if [ ! -r ${scriptsrepository} ] ; then
    mkdir -pv ${scriptsrepository} | tee -a -i ${logfilepath}
    chmod 775 ${scriptsrepository} | tee -a -i ${logfilepath}
else
    chmod 775 ${scriptsrepository} | tee -a -i ${logfilepath}
fi


if [ -r ${workingbase}/updatescripts.v${ScriptVersion}.sh ] ; then
    cp ${workingbase}/updatescripts.v${ScriptVersion}.sh ${workingroot} | tee -a -i ${logfilepath}
    chmod 775 ${workingroot}/updatescripts.v${ScriptVersion}.sh | tee -a -i ${logfilepath}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# CopyToB4CPScriptsAndLink - repeated proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED YYYY-MM-DD -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CopyToB4CPScriptsAndLink () {
    #
    # repeated procedure description
    #
    
    fileFQFP=$1
    targetFQPN=$2
    repositoryFQPN=$3
    scriptaliasname=$4
    
    repositoryfileFQFP=${repositoryFQPN}/${scriptaliasname}
    
    cp -f -v ${fileFQFP} ${repositoryfileFQFP} | tee -a -i ${logfilepath}
    
    ln -sf ${repositoryfileFQFP} ${targetFQPN}/${scriptaliasname} >> ${logfilepath}
    
    echo
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED YYYY-MM-DD

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#CopyToB4CPScriptsAndLink ${fileFQFP} $targetFQPN $repositoryFQPN $scriptaliasname

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# LinkInB4CPScripts - repeated proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED YYYY-MM-DD -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

LinkInB4CPScripts () {
    #
    # repeated procedure description
    #
    
    fileFQFP=$1
    targetFQPN=$2
    scriptaliasname=$3
    
    ln -sf ${fileFQFP} ${targetFQPN}/${scriptaliasname} >> ${logfilepath}
    
    echo
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED YYYY-MM-DD

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#LinkInB4CPScripts ${fileFQFP} $targetFQPN $scriptaliasname

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =============================================================================
# =============================================================================
# FOLDER:  Scripts root
# =============================================================================

export sourcefolder=${workingbase}
export folderstdversion=v05.28.01

file_root_001=generate_script_links.${folderstdversion}.sh
file_root_002=remove_script_links.${folderstdversion}.sh

CopyToB4CPScriptsAndLink ${sourcefolder}/${file_root_001} ${scriptsbase} ${scriptsrepository} generate_script_links
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_root_002} ${scriptsbase} ${scriptsrepository} remove_script_links


# =============================================================================
# =============================================================================
# FOLDER:  Scripts _subscripts
# =============================================================================

#
# Handle the scripts _subscripts folder
#
export subscripts_folder=_subscripts
export subscriptsstdversion=v05.28.01
export source_subscripts_folder=${workingbase}/${subscripts_folder}
export target_subscripts_folder=${scriptsrepository}/${subscripts_folder}

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo 'Handle Scripts subscripts folder' | tee -a -i ${logfilepath}
echo ' - subsscripts version       : '${subscriptsstdversion} | tee -a -i ${logfilepath}
echo ' - subsscripts folder        : '${subscripts_folder} | tee -a -i ${logfilepath}
echo ' - source subsscripts folder : '${source_subscripts_folder} | tee -a -i ${logfilepath}
echo ' - target subsscripts folder : '${target_subscripts_folder} | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

if [ ! -r ${target_subscripts_folder} ] ; then
    mkdir -pv ${target_subscripts_folder} | tee -a -i ${logfilepath}
    chmod 775 ${target_subscripts_folder} | tee -a -i ${logfilepath}
else
    chmod 775 ${target_subscripts_folder} | tee -a -i ${logfilepath}
fi

#cp -a -f -v ${source_subscripts_folder}/ ${target_subscripts_folder}/ | tee -a -i ${logfilepath}
cp -a -f -v ${source_subscripts_folder}/ ${scriptsrepository}/ | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  Scripts _api_subscripts
# =============================================================================

#
# Handle the scripts _api_subscripts folder
#
export api_subscripts_folder=_api_subscripts
export apisubscriptsstdversion=v00.60.08
export source_api_subscripts_folder=${workingbase}/${api_subscripts_folder}
#export target_api_subscripts_folder=${scriptsrepository}/${api_subscripts_folder}
export target_api_subscripts_folder=${scriptsbase}/${api_subscripts_folder}

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo 'Handle Scripts subscripts folder' | tee -a -i ${logfilepath}
echo ' - api subsscripts version       : '${apisubscriptsstdversion} | tee -a -i ${logfilepath}
echo ' - api subsscripts folder        : '${api_subscripts_folder} | tee -a -i ${logfilepath}
echo ' - source api subsscripts folder : '${source_api_subscripts_folder} | tee -a -i ${logfilepath}
echo ' - target api subsscripts folder : '${target_api_subscripts_folder} | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

if [ ! -r ${target_api_subscripts_folder} ] ; then
    mkdir -pv ${target_api_subscripts_folder} | tee -a -i ${logfilepath}
    chmod 775 ${target_api_subscripts_folder} | tee -a -i ${logfilepath}
else
    chmod 775 ${target_api_subscripts_folder} | tee -a -i ${logfilepath}
fi

#cp -a -f -v ${source_api_subscripts_folder}/ ${target_api_subscripts_folder}/ | tee -a -i ${logfilepath}
cp -a -f -v ${source_api_subscripts_folder}/ ${scriptsrepository}/ | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  _hostsetupscripts
# =============================================================================


export workingdir=_hostsetupscripts
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_hostsetupscripts_001=setuphost.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_hostsetupscripts_001} ${linksfolder}/setuphost >> ${logfilepath}

CopyToB4CPScriptsAndLink ${sourcefolder}/${file_hostsetupscripts_001} ${scriptsbase} ${scriptsrepository} setuphost


# =============================================================================
# =============================================================================
# FOLDER:  _hostupdatescripts
# =============================================================================


export workingdir=_hostupdatescripts
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_hostupdatecripts_001=update_tools.${folderstdversion}.sh
file_hostupdatecripts_002=updatescripts.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_hostupdatecripts_001} ${linksfolder}/update_tools >> ${logfilepath}
ln -sf ${sourcefolder}/${file_hostupdatecripts_002} ${linksfolder}/updatescripts >> ${logfilepath}

CopyToB4CPScriptsAndLink ${sourcefolder}/${file_hostupdatecripts_001} ${scriptsbase} ${scriptsrepository} update_tools
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_hostupdatecripts_002} ${scriptsbase} ${scriptsrepository} updatescripts



# =============================================================================
# =============================================================================
# FOLDER:  Common
# =============================================================================


export workingdir=Common
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_common_001=determine_gaia_version_and_installation_type.${folderstdversion}.sh
file_common_002=do_script_nohup.${folderstdversion}.sh

# REMOVED 2020-09-17 -
#file_common_003=go_dump_folder_now.${folderstdversion}.sh
#file_common_004=go_dump_folder_now_dtg.${folderstdversion}.sh
#file_common_005=go_change_log_folder_now_dtg.${folderstdversion}.sh
#file_common_006=make_dump_folder_now.${folderstdversion}.sh
#file_common_007=make_dump_folder_now_dtg.${folderstdversion}.sh

file_common_008=make_snapshot_and_backup_to_ftp_target.${folderstdversion}.sh
file_common_009=make_local_snapshot_and_backup.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_common_001} ${linksfolder}/gaia_version_type >> ${logfilepath}
ln -sf ${sourcefolder}/${file_common_002} ${linksfolder}/do_script_nohup >> ${logfilepath}

# REMOVED 2020-09-17 -
#ln -sf ${sourcefolder}/${file_common_003} ${linksfolder}/godump >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_common_004} ${linksfolder}/godtgdump >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_common_005} ${linksfolder}/goChangeLog >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_common_006} ${linksfolder}/mkdump >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_common_007} ${linksfolder}/mkdtgdump >> ${logfilepath}

ln -sf ${sourcefolder}/${file_common_008} ${linksfolder}/make_snapshot_and_backup_to_ftp_target >> ${logfilepath}
ln -sf ${sourcefolder}/${file_common_009} ${linksfolder}/make_local_snapshot_and_backup >> ${logfilepath}

#
# These have been replaced with alias commands or alias links
#
#ln -sf ${sourcefolder}/${file_common_001} ${workingroot}/gaia_version_type >> ${logfilepath}
ln -sf ${sourcefolder}/${file_common_002} ${workingroot}/do_script_nohup >> ${logfilepath}
#
# REMOVED 2020-09-17 -
#ln -sf ${sourcefolder}/${file_common_003} ${workingroot}/godump >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_common_004} ${workingroot}/godtgdump >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_common_005} ${workingroot}/goChangeLog >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_common_006} ${workingroot}/mkdump >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_common_007} ${workingroot}/mkdtgdump >> ${logfilepath}

ln -sf ${sourcefolder}/${file_common_008} ${workingroot}/make_snapshot_and_backup_to_ftp_target >> ${logfilepath}
ln -sf ${sourcefolder}/${file_common_009} ${workingroot}/make_local_snapshot_and_backup >> ${logfilepath}

CopyToB4CPScriptsAndLink ${sourcefolder}/${file_common_001} ${scriptsbase} ${scriptsrepository} gaia_version_type
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_common_002} ${scriptsbase} ${scriptsrepository} do_script_nohup

CopyToB4CPScriptsAndLink ${sourcefolder}/${file_common_008} ${scriptsbase} ${scriptsrepository} make_snapshot_and_backup_to_ftp_target
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_common_009} ${scriptsbase} ${scriptsrepository} make_local_snapshot_and_backup

export jsoncontrolfilename=target_ftp_host.json
export jsoncontrolfilepath=${customerworkpathroot}/json_control_files
export jsoncontrolfilefqpn=${jsoncontrolfilepath}/${jsoncontrolfilename}
if [ -r "${customerworkpathroot}/scripts/${workingdir}.CORE" ] ; then
    export jsoncontrolfilesourcepath=${customerworkpathroot}/scripts/${workingdir}.CORE
else
    export jsoncontrolfilesourcepath=${customerworkpathroot}/scripts/${workingdir}
fi
export jsoncontrolfilesourcefqpn=${jsoncontrolfilesourcepath}/${jsoncontrolfilename}

printf "%-30s : %s\n" 'jsoncontrolfilename' "${jsoncontrolfilename}" | tee -a -i ${logfilepath}
printf "%-30s : %s\n" 'jsoncontrolfilepath' "${jsoncontrolfilepath}" | tee -a -i ${logfilepath}
printf "%-30s : %s\n" 'jsoncontrolfilefqpn' "${jsoncontrolfilefqpn}" | tee -a -i ${logfilepath}
printf "%-30s : %s\n" 'jsoncontrolfilesourcepath' "${jsoncontrolfilesourcepath}" | tee -a -i ${logfilepath}
printf "%-30s : %s\n" 'jsoncontrolfilesourcefqpn' "${jsoncontrolfilesourcefqpn}" | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

if [ ! -r ${jsoncontrolfilepath} ] ; then
    mkdir -pv ${jsoncontrolfilepath} | tee -a -i ${logfilepath}
    chmod 775 ${jsoncontrolfilepath} | tee -a -i ${logfilepath}
    
    cp -v ${jsoncontrolfilesourcefqpn} ${jsoncontrolfilefqpn} | tee -a -i ${logfilepath}
    chmod 775 ${jsoncontrolfilefqpn} | tee -a -i ${logfilepath}
elif [ ! -r ${jsoncontrolfilefqpn} ] ; then
    chmod 775 ${jsoncontrolfilepath} | tee -a -i ${logfilepath}
    
    cp -v "${jsoncontrolfilesourcefqpn}" "${jsoncontrolfilefqpn}" | tee -a -i ${logfilepath}
    chmod 775 ${jsoncontrolfilefqpn} | tee -a -i ${logfilepath}
else
    chmod 775 ${jsoncontrolfilepath} | tee -a -i ${logfilepath}
    chmod 775 ${jsoncontrolfilefqpn} | tee -a -i ${logfilepath}
fi

echo | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  Config
# =============================================================================


export workingdir=Config
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_config_001=config_capture.${folderstdversion}.sh
file_config_002=show_interface_information.${folderstdversion}.sh
file_config_003=EPM_config_check.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_config_001} ${linksfolder}/config_capture >> ${logfilepath}
ln -sf ${sourcefolder}/${file_config_002} ${linksfolder}/interface_info >> ${logfilepath}

# These have been replaced with alias commands or alias links
#
#ln -sf ${sourcefolder}/${file_config_001} ${workingroot}/config_capture >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_config_002} ${workingroot}/interface_info >> ${logfilepath}

CopyToB4CPScriptsAndLink ${sourcefolder}/${file_config_001} ${scriptsbase} ${scriptsrepository} config_capture
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_config_002} ${scriptsbase} ${scriptsrepository} interface_info

if [ ${Check4EPM} -gt 0 ]; then
    
    ln -sf ${sourcefolder}/${file_config_003} ${linksfolder}/EPM_config_check >> ${logfilepath}
    
    # These have been replaced with alias commands or alias links
    #
    #ln -sf ${sourcefolder}/${file_config_003} ${workingroot}/EPM_config_check >> ${logfilepath}
    
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_config_003} ${scriptsbase} ${scriptsrepository} EPM_config_check
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  GAIA
# =============================================================================


export workingdir=GAIA
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_GAIA_001=update_gaia_rest_api.${folderstdversion}.sh
file_GAIA_002=update_gaia_dynamic_cli.${folderstdversion}.sh


ln -sf ${sourcefolder}/${file_GAIA_001} ${linksfolder}/update_gaia_rest_api >> ${logfilepath}
ln -sf ${sourcefolder}/${file_GAIA_002} ${linksfolder}/update_gaia_dynamic_cli >> ${logfilepath}

if ${IsR8XVersion} ; then
    
    ln -sf ${sourcefolder}/${file_GAIA_001} ${workingroot}/update_gaia_rest_api >> ${logfilepath}
    ln -sf ${sourcefolder}/${file_GAIA_002} ${workingroot}/update_gaia_dynamic_cli >> ${logfilepath}
    
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_GAIA_001} ${scriptsbase} ${scriptsrepository} update_gaia_rest_api
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_GAIA_002} ${scriptsbase} ${scriptsrepository} update_gaia_dynamic_cli
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  GW
# =============================================================================


export workingdir=GW
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_GW_001=watch_accel_stats.${folderstdversion}.sh
file_GW_002=set_informative_logging_implied_rules_on_R8x.${folderstdversion}.sh
file_GW_003=reset_hit_count_with_backup.${folderstdversion}.sh
file_GW_004=show_clusterXL_information.${folderstdversion}.sh
file_GW_005=watch_cluster_status.${folderstdversion}.sh
file_GW_006=enable_rad_admin_stats.${folderstdversion}.sh
file_GW_007=vpn_client_operational_info.${folderstdversion}.sh
file_GW_008=vpn_client_operational_info.standalone.${folderstdversion}.sh
file_GW_009=fix_gw_missing_updatable_objects.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_GW_001} ${linksfolder}/watch_accel_stats >> ${logfilepath}
ln -sf ${sourcefolder}/${file_GW_002} ${linksfolder}/set_informative_logging_implied_rules_on_R8x >> ${logfilepath}
ln -sf ${sourcefolder}/${file_GW_003} ${linksfolder}/reset_hit_count_with_backup >> ${logfilepath}
ln -sf ${sourcefolder}/${file_GW_004} ${linksfolder}/show_cluster_info >> ${logfilepath}
ln -sf ${sourcefolder}/${file_GW_005} ${linksfolder}/watch_cluster_status >> ${logfilepath}
ln -sf ${sourcefolder}/${file_GW_006} ${linksfolder}/enable_rad_admin_stats_and_cpview >> ${logfilepath}
ln -sf ${sourcefolder}/${file_GW_007} ${linksfolder}/vpn_client_operational_info >> ${logfilepath}
ln -sf ${sourcefolder}/${file_GW_008} ${linksfolder}/vpn_client_operational_info.standalone >> ${logfilepath}
ln -sf ${sourcefolder}/${file_GW_009} ${linksfolder}/fix_gw_missing_updatable_objects >> ${logfilepath}


if [ "${sys_type_GW}" == "true" ]; then
    
    # These have been replaced with alias commands or alias links
    #
    #ln -sf ${sourcefolder}/${file_GW_001} ${workingroot}/watch_accel_stats >> ${logfilepath}
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_GW_001} ${scriptsbase} ${scriptsrepository} watch_accel_stats
    
    ln -sf ${sourcefolder}/${file_GW_002} ${workingroot}/set_informative_logging_implied_rules_on_R8x >> ${logfilepath}
    ln -sf ${sourcefolder}/${file_GW_003} ${workingroot}/reset_hit_count_with_backup >> ${logfilepath}
    
    if [[ $(cpconfig <<< 10 | grep cluster) == *"Disable"* ]]; then 
        # is a cluster
        # These have been replaced with alias commands or alias links
        #
        #ln -sf ${sourcefolder}/${file_GW_004} ${workingroot}/show_cluster_info >> ${logfilepath}
        #ln -sf ${sourcefolder}/${file_GW_005} ${workingroot}/watch_cluster_status >> ${logfilepath}
        CopyToB4CPScriptsAndLink ${sourcefolder}/${file_GW_004} ${scriptsbase} ${scriptsrepository} show_cluster_info
        CopyToB4CPScriptsAndLink ${sourcefolder}/${file_GW_005} ${scriptsbase} ${scriptsrepository} watch_cluster_status
    fi
    
    # These have been replaced with alias commands or alias links
    #
    #ln -sf ${sourcefolder}/${file_GW_006} ${workingroot}/enable_rad_admin_stats_and_cpview >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_GW_007} ${workingroot}/vpn_client_operational_info >> ${logfilepath}
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_GW_006} ${scriptsbase} ${scriptsrepository} enable_rad_admin_stats_and_cpview
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_GW_007} ${scriptsbase} ${scriptsrepository} vpn_client_operational_info
    #ln -sf ${sourcefolder}/${file_GW_008} ${workingroot}/vpn_client_operational_info.standalone >> ${logfilepath}
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_GW_009} ${scriptsbase} ${scriptsrepository} fix_gw_missing_updatable_objects
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  GW.CORE
# =============================================================================


export workingdir=GW.CORE
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

if [ ! -r $sourcefolder ] ; then
    # This folder is not part of the distribution
    echo 'Skipping folder '$sourcefolder | tee -a -i ${logfilepath}
else
    if [ ! -r ${linksfolder} ] ; then
        mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
        chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
    else
        chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
    fi
    
    file_GW_CORE_001=fix_smcias_interfaces.${folderstdversion}.sh
    file_GW_CORE_002=set_fwkern_dot_conf_settings_on_R8x.CORE.${folderstdversion}.sh
    file_GW_CORE_003=SK106251/SK106251_IPv4_InstallSetup.${folderstdversion}.sh
    file_GW_CORE_004=enable_usfw_force_override.${folderstdversion}.sh
    
    ln -sf ${sourcefolder}/${file_GW_CORE_001} ${linksfolder}/fix_smcias_interfaces >> ${logfilepath}
    ln -sf ${sourcefolder}/${file_GW_CORE_002} ${linksfolder}/set_fwkern_dot_conf_settings_on_R8x.CORE >> ${logfilepath}
    
    ln -sf ${sourcefolder}/${file_GW_CORE_003} ${linksfolder}/setup_sk106251_check_point_dynamic_objects >> ${logfilepath}
    
    ln -sf ${sourcefolder}/${file_GW_CORE_004} ${linksfolder}/enable_usfw_force_override >> ${logfilepath}
    
    if [ "${sys_type_GW}" == "true" ] ; then
        
        #ln -sf ${sourcefolder}/${file_GW_CORE_001} ${workingroot}/fix_smcias_interfaces >> ${logfilepath}
        #ln -sf ${sourcefolder}/${file_GW_CORE_002} ${workingroot}/set_fwkern_dot_conf_settings_on_R8x.CORE >> ${logfilepath}
        
        ln -sf ${sourcefolder}/${file_GW_CORE_003} ${workingroot}/setup_sk106251_check_point_dynamic_objects >> ${logfilepath}
        
        ln -sf ${sourcefolder}/${file_GW_CORE_004} ${workingroot}/enable_usfw_force_override >> ${logfilepath}
        
    fi
fi


# =============================================================================
# =============================================================================
# FOLDER:  HCP
# =============================================================================


export workingdir=HCP
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}

if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi


#file_hcp_001=install_hcp_offline.${folderstdversion}.sh
file_hcp_002=run_hcp_and_copy_files.${folderstdversion}.sh

#ln -sf ${sourcefolder}/${file_hcp_001} ${linksfolder}/install_hcp_offline >> ${logfilepath}
ln -sf ${sourcefolder}/${file_hcp_002} ${linksfolder}/run_hcp_and_copy_files >> ${logfilepath}

# These have been replaced with alias commands or alias links
#
#ln -sf ${sourcefolder}/${file_hcp_001} ${workingroot}/install_hcp_offline >> ${logfilepath}
ln -sf ${sourcefolder}/${file_hcp_002} ${workingroot}/run_hcp_and_copy_files >> ${logfilepath}

#CopyToB4CPScriptsAndLink ${sourcefolder}/${file_hcp_001} ${scriptsbase} ${scriptsrepository} install_hcp_offline
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_hcp_002} ${scriptsbase} ${scriptsrepository} run_hcp_and_copy_files


# =============================================================================
# =============================================================================
# FOLDER:  Health_Check
# =============================================================================


export workingdir=Health_Check
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi


file_healthcheck_001=healthcheck.sh
file_healthcheck_002=run_healthcheck_to_dump_dtg.${folderstdversion}.sh
file_healthcheck_003=check_status_checkpoint_services.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_healthcheck_001} ${linksfolder}/healthcheck >> ${logfilepath}
ln -sf ${sourcefolder}/${file_healthcheck_002} ${linksfolder}/healthdump >> ${logfilepath}
ln -sf ${sourcefolder}/${file_healthcheck_003} ${linksfolder}/check_point_service_status_check >> ${logfilepath}

# These have been replaced with alias commands or alias links
#
#ln -sf ${sourcefolder}/${file_healthcheck_001} ${workingroot}/healthcheck >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_healthcheck_002} ${workingroot}/healthdump >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_healthcheck_003} ${workingroot}/check_point_service_status_check >> ${logfilepath}

CopyToB4CPScriptsAndLink ${sourcefolder}/${file_healthcheck_001} ${scriptsbase} ${scriptsrepository} healthcheck
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_healthcheck_002} ${scriptsbase} ${scriptsrepository} healthdump
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_healthcheck_003} ${scriptsbase} ${scriptsrepository} check_point_service_status_check


# =============================================================================
# =============================================================================
# FOLDER:  MDM
# =============================================================================


export workingdir=MDM
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_MDM_001=backup_mds_ugex.${folderstdversion}.sh
file_MDM_002=backup_mds_w_logs_ugex.${folderstdversion}.sh

file_MDM_003=report_mdsstat.${folderstdversion}.sh
file_MDM_004=watch_mdsstat.${folderstdversion}.sh
file_MDM_005=show_all_domains_in_array.${folderstdversion}.sh
file_MDM_006=show_sessions_all_domains.${folderstdversion}.sh

file_MDM_007=mdsm_mds_reassign_global_assignments.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_MDM_001} ${linksfolder}/backup_mds_ugex >> ${logfilepath}
ln -sf ${sourcefolder}/${file_MDM_002} ${linksfolder}/backup_mds_w_logs_ugex >> ${logfilepath}
ln -sf ${sourcefolder}/${file_MDM_003} ${linksfolder}/report_mdsstat >> ${logfilepath}
ln -sf ${sourcefolder}/${file_MDM_004} ${linksfolder}/watch_mdsstat >> ${logfilepath}
ln -sf ${sourcefolder}/${file_MDM_005} ${linksfolder}/show_all_domains_in_array >> ${logfilepath}
ln -sf ${sourcefolder}/${file_MDM_006} ${linksfolder}/show_sessions_all_domains >> ${logfilepath}
ln -sf ${sourcefolder}/${file_MDM_007} ${linksfolder}/mdsm_mds_reassign_global_assignments >> ${logfilepath}

if [ "${sys_type_MDS}" == "true" ]; then
    
    ln -sf ${sourcefolder}/${file_MDM_001} ${workingroot}/backup_mds_ugex >> ${logfilepath}
    ln -sf ${sourcefolder}/${file_MDM_002} ${workingroot}/backup_mds_w_logs_ugex >> ${logfilepath}
    
    # These have been replaced with alias commands or alias links
    #
    #ln -sf ${sourcefolder}/${file_MDM_003} ${workingroot}/report_mdsstat >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_MDM_004} ${workingroot}/watch_mdsstat >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_MDM_005} ${workingroot}/show_all_domains_in_array >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_MDM_006} ${workingroot}/show_sessions_all_domains >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_MDM_007} ${workingroot}/mdsm_mds_reassign_global_assignments >> ${logfilepath}
    
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MDM_003} ${scriptsbase} ${scriptsrepository} report_mdsstat
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MDM_004} ${scriptsbase} ${scriptsrepository} watch_mdsstat
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MDM_005} ${scriptsbase} ${scriptsrepository} show_all_domains_in_array
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MDM_006} ${scriptsbase} ${scriptsrepository} show_sessions_all_domains
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MDM_007} ${scriptsbase} ${scriptsrepository} mdsm_mds_reassign_global_assignments
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  MGMT
# =============================================================================


export workingdir=MGMT
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_MGMT_001=identify_self_referencing_symbolic_link_files.${folderstdversion}.sh
file_MGMT_002=identify_self_referencing_symbolic_link_files.Lite.${folderstdversion}.sh
file_MGMT_003=check_status_of_scheduled_ips_updates_on_management.${folderstdversion}.sh
file_MGMT_004=show_unpublished_locked_objects.v00.00.00.sh
file_MGMT_005=fix_mgmt_missing_updatable_objects.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_MGMT_001} ${linksfolder}/identify_self_referencing_symbolic_link_files >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_MGMT_002} ${linksfolder}/Lite.identify_self_referencing_symbolic_link_files >> ${logfilepath}
ln -sf ${sourcefolder}/${file_MGMT_003} ${linksfolder}/check_status_of_scheduled_ips_updates_on_management >> ${logfilepath}
ln -sf ${sourcefolder}/${file_MGMT_004} ${linksfolder}/show_unpublished_locked_objects >> ${logfilepath}
ln -sf ${sourcefolder}/${file_MGMT_005} ${linksfolder}/fix_mgmt_missing_updatable_objects >> ${logfilepath}

# These have been replaced with alias commands or alias links
#
#ln -sf ${sourcefolder}/${file_MGMT_001} ${workingroot}/identify_self_referencing_symbolic_link_files >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_MGMT_002} ${workingroot}/Lite.identify_self_referencing_symbolic_link_files >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_MGMT_003} ${workingroot}/check_status_of_scheduled_ips_updates_on_management >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_MGMT_004} ${workingroot}/show_unpublished_locked_objects >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_MGMT_005} ${workingroot}/fix_mgmt_missing_updatable_objects >> ${logfilepath}

CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MGMT_001} ${scriptsbase} ${scriptsrepository} identify_self_referencing_symbolic_link_files >> ${logfilepath}
#CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MGMT_002} ${scriptsbase} ${scriptsrepository} Lite.identify_self_referencing_symbolic_link_files >> ${logfilepath}
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MGMT_003} ${scriptsbase} ${scriptsrepository} check_status_of_scheduled_ips_updates_on_management >> ${logfilepath}
#CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MGMT_004} ${scriptsbase} ${scriptsrepository} show_unpublished_locked_objects >> ${logfilepath}
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_MGMT_005} ${scriptsbase} ${scriptsrepository} fix_mgmt_missing_updatable_objects >> ${logfilepath}

if [ "${sys_type_SMS}" == "true" ]; then
    echo
    if [ ${Check4EPM} -gt 0 ]; then
        echo    
    fi
fi

if [ "${sys_type_MDS}" == "true" ]; then
    echo
fi

if [ "${sys_type_SmartEvent}" == "true" ]; then
    echo
fi



# =============================================================================
# =============================================================================
# FOLDER:  Patch_HotFix
# =============================================================================


export workingdir=Patch_HotFix
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_patch_001=fix_gaia_webui_login_dot_js.sh
file_patch_002=fix_gaia_webui_login_dot_js_generic.sh

export need_fix_webui=false

if ${IsR8XVersion} ; then
    export need_fix_webui=false
else
    export need_fix_webui=true
fi

#if [ "$need_fix_webui" == "true" ]; then
    
    #ln -sf ${sourcefolder}/${file_patch_001} ${linksfolder}/fix_gaia_webui_login_dot_js >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_patch_001} ${workingroot}/fix_gaia_webui_login_dot_js >> ${logfilepath}
    
    #ln -sf ${sourcefolder}/${file_patch_002} ${linksfolder}/fix_gaia_webui_login_dot_js_generic >> ${logfilepath}
    
#fi


# =============================================================================
# =============================================================================
# FOLDER:  Session_Cleanup
# =============================================================================


export workingdir=Session_Cleanup
export folderstdversion=v05.60.08
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_SESSION_001=remove_zerolocks_sessions.${folderstdversion}.sh
file_SESSION_002=remove_zerolocks_web_api_sessions.${folderstdversion}.sh
file_SESSION_003=show_zerolocks_sessions.${folderstdversion}.sh
file_SESSION_004=show_zerolocks_web_api_sessions.${folderstdversion}.sh

export do_session_cleanup=false

if ${IsR8XVersion} ; then
    export do_session_cleanup=true
else
    export do_session_cleanup=false
fi

if [ "${do_session_cleanup}" == "true" ]; then
    
    ln -sf ${sourcefolder}/${file_SESSION_001} ${linksfolder}/remove_zerolocks_sessions >> ${logfilepath}
    ln -sf ${sourcefolder}/${file_SESSION_002} ${linksfolder}/remove_zerolocks_web_api_sessions >> ${logfilepath}
    ln -sf ${sourcefolder}/${file_SESSION_003} ${linksfolder}/show_zerolocks_sessions >> ${logfilepath}
    ln -sf ${sourcefolder}/${file_SESSION_004} ${linksfolder}/show_zerolocks_web_api_sessions >> ${logfilepath}
    
    if [ "${sys_type_GW}" == "false" ]; then
        
        # These have been replaced with alias commands or alias links
        #
        #ln -sf ${sourcefolder}/${file_SESSION_001} ${workingroot}/remove_zerolocks_sessions >> ${logfilepath}
        #ln -sf ${sourcefolder}/${file_SESSION_002} ${workingroot}/remove_zerolocks_web_api_sessions >> ${logfilepath}
        #ln -sf ${sourcefolder}/${file_SESSION_003} ${workingroot}/show_zerolocks_sessions >> ${logfilepath}
        #ln -sf ${sourcefolder}/${file_SESSION_004} ${workingroot}/show_zerolocks_web_api_sessions >> ${logfilepath}
        
        CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SESSION_001} ${scriptsbase} ${scriptsrepository} remove_zerolocks_sessions
        CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SESSION_002} ${scriptsbase} ${scriptsrepository} remove_zerolocks_web_api_sessions
        CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SESSION_003} ${scriptsbase} ${scriptsrepository} show_zerolocks_sessions
        CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SESSION_004} ${scriptsbase} ${scriptsrepository} show_zerolocks_web_api_sessions
    fi
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  SmartEvent
# =============================================================================


export workingdir=SmartEvent
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_SMEV_001=SmartEvent_Backup_R8X.${folderstdversion}.sh
file_SMEV_002=SmartEvent_Restore_R8X.$folderstdversion-NR.sh
file_SMEV_003=Reset_SmartLog_Indexing_Back_X_Days.${folderstdversion}.sh
file_SMEV_004=NUKE_ALL_LOGS_AND_INDEXES.${folderstdversion}.sh
file_SMEV_005=LogExporter_Backup_R8X.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_SMEV_001} ${linksfolder}/SmartEvent_Backup_R8X >> ${logfilepath}
ln -sf ${sourcefolder}/${file_SMEV_002} ${linksfolder}/SmartEvent_Restore_R8X >> ${logfilepath}
ln -sf ${sourcefolder}/${file_SMEV_003} ${linksfolder}/Reset_SmartLog_Indexing >> ${logfilepath}
ln -sf ${sourcefolder}/${file_SMEV_004} ${linksfolder}/SmartEvent_NUKE_Index_and_Logs >> ${logfilepath}

ln -sf ${sourcefolder}/${file_SMEV_005} ${linksfolder}/LogExporter_Backup_R8X >> ${logfilepath}

if [ "${sys_type_SmartEvent}" == "true" ]; then
    
    # These have been replaced with alias commands or alias links
    #
    ln -sf ${sourcefolder}/${file_SMEV_001} ${workingroot}/SmartEvent_backup >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_SMEV_002} ${workingroot}/SmartEvent_restore >> ${logfilepath}
    ln -sf ${sourcefolder}/${file_SMEV_003} ${workingroot}/Reset_SmartLog_Indexing >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_SMEV_004} ${workingroot}/SmartEvent_NUKE_Index_and_Logs >> ${logfilepath}
    
    #CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SMEV_001} ${scriptsbase} ${scriptsrepository} SmartEvent_backup >> ${logfilepath}
    #CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SMEV_002} ${scriptsbase} ${scriptsrepository} SmartEvent_restore >> ${logfilepath}
    #CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SMEV_003} ${scriptsbase} ${scriptsrepository} Reset_SmartLog_Indexing >> ${logfilepath}
    #CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SMEV_004} ${scriptsbase} ${scriptsrepository} SmartEvent_NUKE_Index_and_Logs >> ${logfilepath}
    
fi

if [ "${sys_type_SMS}" == "true" ] || [ "${sys_type_MDS}" == "true" ]; then
    
    ln -sf ${sourcefolder}/${file_SMEV_005} ${workingroot}/LogExporter_Backup_R8X >> ${logfilepath}
    
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SMEV_005} ${scriptsbase} ${scriptsrepository} LogExporter_Backup_R8X >> ${logfilepath}
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  SMS
# =============================================================================


export workingdir=SMS
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_SMS_005=report_cpwd_admin_list.${folderstdversion}.sh
file_SMS_006=watch_cpwd_admin_list.${folderstdversion}.sh
file_SMS_007=restart_mgmt.${folderstdversion}.sh

file_SMS_008=fix_api_memory.${folderstdversion}.sh

file_SMS_009=reset_hit_count_on_R80_SMS_commands.001.v00.01.00.bash

ln -sf ${sourcefolder}/${file_SMS_005} ${linksfolder}/report_cpwd_admin_list >> ${logfilepath}
ln -sf ${sourcefolder}/${file_SMS_006} ${linksfolder}/watch_cpwd_admin_list >> ${logfilepath}

# These have been replaced with alias commands or alias links
#
#ln -sf ${sourcefolder}/${file_SMS_005} ${workingroot}/report_cpwd_admin_list >> ${logfilepath}
#ln -sf ${sourcefolder}/${file_SMS_006} ${workingroot}/watch_cpwd_admin_list >> ${logfilepath}

CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SMS_005} ${scriptsbase} ${scriptsrepository} report_cpwd_admin_list
CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SMS_006} ${scriptsbase} ${scriptsrepository} watch_cpwd_admin_list

ln -sf ${sourcefolder}/${file_SMS_007} ${linksfolder}/restart_mgmt >> ${logfilepath}

ln -sf ${sourcefolder}/${file_SMS_008} ${linksfolder}/fix_api_memory >> ${logfilepath}

ln -sf ${sourcefolder}/${file_SMS_009} ${linksfolder}/reset_hit_count_on_R80_SMS_commands >> ${logfilepath}

if [ "${sys_type_SMS}" == "true" ]; then
    
    # These have been replaced with alias commands or alias links
    #
    #ln -sf ${sourcefolder}/${file_SMS_007} ${workingroot}/restart_mgmt >> ${logfilepath}
    
    CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SMS_007} ${scriptsbase} ${scriptsrepository} restart_mgmt
    
    ln -sf ${sourcefolder}/${file_SMS_009} ${workingroot}/reset_hit_count_on_R80_SMS_commands >> ${logfilepath}
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  SMS.CORE
# =============================================================================


export workingdir=SMS.CORE
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_SMS_CORE_001=CORE-G2_install_policy.$folderstdversion.raw.sh

ln -sf ${sourcefolder}/${file_SMS_CORE_001} ${linksfolder}/CORE-G2_install_policy >> ${logfilepath}

#if [ "${sys_type_SMS}" == "true" ]; then
    
    # These have been replaced with alias commands or alias links
    #
    #ln -sf ${sourcefolder}/${file_SMS_CORE_001} ${workingroot}/CORE-G2_install_policy >> ${logfilepath}
    
    #CopyToB4CPScriptsAndLink ${sourcefolder}/${file_SMS_CORE_001} ${scriptsbase} ${scriptsrepository} CORE-G2_install_policy
    
#fi


# =============================================================================
# =============================================================================
# FOLDER:  SMS.migrate_backup
# =============================================================================


export workingdir=SMS.migrate_backup
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

case "${gaiaversion}" in
    R80 | R80.10  ) 
        export IsR8XMigrate=true
        export IsR8XMigrateServer=false
        ;;
    R80.20.M1 | R80.20.M2 ) 
        export IsR8XMigrate=false
        export IsR8XMigrateServer=true
        ;;
    R80.20 | R80.30 | R80.40 ) 
        export IsR8XMigrate=true
        export IsR8XMigrateServer=true
        ;;
    R81 | R81.10 | R81.20 ) 
        export IsR8XMigrate=false
        export IsR8XMigrateServer=true
        ;;
    *)
        export IsR8XMigrate=true
        export IsR8XMigrateServer=true
        ;;
esac


if ${IsR8XMigrate}; then
    
    file_SMS_Migrate_001=migrate_export_npm_ugex.${folderstdversion}.sh
    file_SMS_Migrate_002=migrate_export_w_logs_npm_ugex.${folderstdversion}.sh
    file_SMS_Migrate_003=migrate_export_epm_ugex.${folderstdversion}.sh
    file_SMS_Migrate_004=migrate_export_w_logs_epm_ugex.${folderstdversion}.sh
    
    ln -sf ${sourcefolder}/${file_SMS_Migrate_001} ${linksfolder}/migrate_export_npm_ugex >> ${logfilepath}
    ln -sf ${sourcefolder}/${file_SMS_Migrate_002} ${linksfolder}/migrate_export_w_logs_npm_ugex >> ${logfilepath}
    
    if [ ${Check4EPM} -gt 0 ]; then
        
        ln -sf ${sourcefolder}/${file_SMS_Migrate_003} ${linksfolder}/migrate_export_epm_ugex >> ${logfilepath}
        ln -sf ${sourcefolder}/${file_SMS_Migrate_004} ${linksfolder}/migrate_export_w_logs_epm_ugex >> ${logfilepath}
        
    fi
    
    if [ "${sys_type_SMS}" == "true" ]; then
        
        ln -sf ${sourcefolder}/${file_SMS_Migrate_001} ${workingroot}/migrate_export_npm_ugex >> ${logfilepath}
        ln -sf ${sourcefolder}/${file_SMS_Migrate_002} ${workingroot}/migrate_export_w_logs_npm_ugex >> ${logfilepath}
        
        if [ ${Check4EPM} -gt 0 ]; then
            
            ln -sf ${sourcefolder}/${file_SMS_Migrate_003} ${workingroot}/migrate_export_epm_ugex >> ${logfilepath}
            ln -sf ${sourcefolder}/${file_SMS_Migrate_004} ${workingroot}/migrate_export_w_logs_epm_ugex >> ${logfilepath}
            
        fi
        
    fi
fi

if ${IsR8XMigrateServer}; then
    
    file_SMS_Migrate_011=migrate_server_export_npm_ugex.${folderstdversion}.sh
    file_SMS_Migrate_012=migrate_server_export_w_logs_npm_ugex.${folderstdversion}.sh
    file_SMS_Migrate_013=migrate_server_export_epm_ugex.${folderstdversion}.sh
    file_SMS_Migrate_014=migrate_server_export_w_logs_epm_ugex.${folderstdversion}.sh
    
    if [ "${sys_type_SMS}" == "true" ]; then
        
        ln -sf ${sourcefolder}/${file_SMS_Migrate_011} ${workingroot}/migrate_server_export_npm_ugex >> ${logfilepath}
        ln -sf ${sourcefolder}/${file_SMS_Migrate_012} ${workingroot}/migrate_server_export_w_logs_npm_ugex >> ${logfilepath}
        
        if [ ${Check4EPM} -gt 0 ]; then
            
            ln -sf ${sourcefolder}/${file_SMS_Migrate_013} ${workingroot}/migrate_server_export_epm_ugex >> ${logfilepath}
            ln -sf ${sourcefolder}/${file_SMS_Migrate_014} ${workingroot}/migrate_server_export_w_logs_epm_ugex >> ${logfilepath}
            
        fi
        
    fi
    if [ "${sys_type_MDS}" == "true" ]; then
        
        ln -sf ${sourcefolder}/${file_SMS_Migrate_011} ${workingroot}/migrate_server_export_npm_ugex >> ${logfilepath}
        ln -sf ${sourcefolder}/${file_SMS_Migrate_012} ${workingroot}/migrate_server_export_w_logs_npm_ugex >> ${logfilepath}
        
        #if [ ${Check4EPM} -gt 0 ]; then
            
            #ln -sf ${sourcefolder}/${file_SMS_Migrate_013} ${workingroot}/migrate_server_export_epm_ugex >> ${logfilepath}
            #ln -sf ${sourcefolder}/${file_SMS_Migrate_014} ${workingroot}/migrate_server_export_w_logs_epm_ugex >> ${logfilepath}
            
        #fi
        
    fi
fi


# =============================================================================
# =============================================================================
# FOLDER:  UserConfig
# =============================================================================


export workingdir=UserConfig
export folderstdversion=v05.28.01
export sourcefolder=${workingbase}/${workingdir}
export linksfolder=${linksbase}/${workingdir}
if [ ! -r ${linksfolder} ] ; then
    mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
else
    chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
fi

file_USERCONF_001=add_alias_commands.all.${folderstdversion}.sh
file_USERCONF_002=add_alias_commands_all_users.all.${folderstdversion}.sh
file_USERCONF_003=update_alias_commands.all.${folderstdversion}.sh
file_USERCONF_004=update_alias_commands_all_users.all.${folderstdversion}.sh
file_USERCONF_005=reset_all_users_home_profile_files.${folderstdversion}.sh

ln -sf ${sourcefolder}/${file_USERCONF_001} ${linksfolder}/alias_commands_add_user >> ${logfilepath}
ln -sf ${sourcefolder}/${file_USERCONF_002} ${linksfolder}/alias_commands_add_all_users >> ${logfilepath}
ln -sf ${sourcefolder}/${file_USERCONF_003} ${linksfolder}/alias_commands_update_user >> ${logfilepath}
ln -sf ${sourcefolder}/${file_USERCONF_004} ${linksfolder}/alias_commands_update_all_users >> ${logfilepath}
ln -sf ${sourcefolder}/${file_USERCONF_005} ${linksfolder}/reset_all_users_home_profile_files >> ${logfilepath}

ln -sf ${sourcefolder}/${file_USERCONF_001} ${workingroot}/alias_commands_add_user >> ${logfilepath}
ln -sf ${sourcefolder}/${file_USERCONF_002} ${workingroot}/alias_commands_add_all_users >> ${logfilepath}
ln -sf ${sourcefolder}/${file_USERCONF_003} ${workingroot}/alias_commands_update_user >> ${logfilepath}
ln -sf ${sourcefolder}/${file_USERCONF_004} ${workingroot}/alias_commands_update_all_users >> ${logfilepath}
ln -sf ${sourcefolder}/${file_USERCONF_005} ${workingroot}/reset_all_users_home_profile_files >> ${logfilepath}

#LinkInB4CPScripts ${sourcefolder}/${file_USERCONF_001} ${scriptsbase} alias_commands_add_user
#LinkInB4CPScripts ${sourcefolder}/${file_USERCONF_002} ${scriptsbase} alias_commands_add_all_users
#LinkInB4CPScripts ${sourcefolder}/${file_USERCONF_003} ${scriptsbase} alias_commands_update_user
#LinkInB4CPScripts ${sourcefolder}/${file_USERCONF_004} ${scriptsbase} alias_commands_update_all_users
#LinkInB4CPScripts ${sourcefolder}/${file_USERCONF_005} ${scriptsbase} reset_all_users_home_profile_files

#CopyToB4CPScriptsAndLink ${sourcefolder}/${file_USERCONF_001} ${scriptsbase} ${scriptsrepository} alias_commands_add_user
#CopyToB4CPScriptsAndLink ${sourcefolder}/${file_USERCONF_002} ${scriptsbase} ${scriptsrepository} alias_commands_add_all_users
#CopyToB4CPScriptsAndLink ${sourcefolder}/${file_USERCONF_003} ${scriptsbase} ${scriptsrepository} alias_commands_update_user
#CopyToB4CPScriptsAndLink ${sourcefolder}/${file_USERCONF_004} ${scriptsbase} ${scriptsrepository} alias_commands_update_all_users
#CopyToB4CPScriptsAndLink ${sourcefolder}/${file_USERCONF_005} ${scriptsbase} ${scriptsrepository} reset_all_users_home_profile_files

#
# Handle the UserConfig alias_commands[.x] folder
#
#alias_commands_folder=alias_commands
#source_alias_commands_folder=${workingbase}/$alias_commands_folder
#target_alias_commands_folder=${scriptsrepository}/$alias_commands_folder

#echo | tee -a -i ${logfilepath}
#echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
#echo 'Handle UserConfig alias_commands folder' | tee -a -i ${logfilepath}
#echo ' - alias_commands folder        : '$alias_commands_folder | tee -a -i ${logfilepath}
#echo ' - source alias_commands folder : '$source_alias_commands_folder | tee -a -i ${logfilepath}
#echo ' - target alias_commands folder : '$target_alias_commands_folder | tee -a -i ${logfilepath}
#echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
#echo | tee -a -i ${logfilepath}

#if [ ! -r $target_alias_commands_folder ] ; then
    #mkdir -pv $target_alias_commands_folder | tee -a -i ${logfilepath}
    #chmod 775 $target_alias_commands_folder | tee -a -i ${logfilepath}
#else
    #chmod 775 $target_alias_commands_folder | tee -a -i ${logfilepath}
#fi

#if [ -r $target_alias_commands_folder ] ; then
    #echo 'Remove existing alias_commands...' | tee -a -i ${logfilepath}
    #rm -f -v $target_alias_commands_folder/*.* | tee -a -i ${logfilepath}
#fi

##cp -a -f -v ${source_alias_commands_folder}/ ${target_alias_commands_folder}/ | tee -a -i ${logfilepath}
#cp -a -f -v ${source_alias_commands_folder}/ ${scriptsrepository}/ | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# =============================================================================
# =============================================================================
# FOLDER:  UserConfig.CORE_G2.NPM
# =============================================================================


#export workingdir=UserConfig.CORE_G2.NPM
#export folderstdversion=v05.28.01
#export sourcefolder=${workingbase}/${workingdir}
#export linksfolder=${linksbase}/${workingdir}

#if [ ! -r $sourcefolder ] ; then
    ## This folder is not part of the distribution
    #echo 'Skipping folder '$sourcefolder | tee -a -i ${logfilepath}
#else
    
    #if [ ! -r ${linksfolder} ] ; then
        #mkdir -pv ${linksfolder} | tee -a -i ${logfilepath}
        #chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
    #else
        #chmod 775 ${linksfolder} | tee -a -i ${logfilepath}
    #fi
    
    #file_USERCONF_005=add_alias_commands.CORE_G2.NPM.${folderstdversion}.sh
    #file_USERCONF_006=add_alias_commands_all_users.CORE_G2.NPM.${folderstdversion}.sh
    #file_USERCONF_007=update_alias_commands.CORE_G2.NPM.${folderstdversion}.sh
    #file_USERCONF_008=update_alias_commands_all_users.CORE_G2.NPM.${folderstdversion}.sh
    
    #ln -sf ${sourcefolder}/${file_USERCONF_005} ${linksfolder}/alias_commands_CORE_G2_NPM_add_user >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_USERCONF_006} ${linksfolder}/alias_commands_CORE_G2_NPM_add_all_users >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_USERCONF_007} ${linksfolder}/alias_commands_CORE_G2_NPM_update_user >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_USERCONF_008} ${linksfolder}/alias_commands_CORE_G2_NPM_update_all_users >> ${logfilepath}
    
    #ln -sf ${sourcefolder}/${file_USERCONF_005} ${workingroot}/alias_commands_CORE_G2_NPM_add_user >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_USERCONF_006} ${workingroot}/alias_commands_CORE_G2_NPM_add_all_users >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_USERCONF_007} ${workingroot}/alias_commands_CORE_G2_NPM_update_user >> ${logfilepath}
    #ln -sf ${sourcefolder}/${file_USERCONF_008} ${workingroot}/alias_commands_CORE_G2_NPM_update_all_users >> ${logfilepath}
    
#fi


# =============================================================================
# =============================================================================
# FOLDER:  
# =============================================================================

# =============================================================================
# =============================================================================

# =============================================================================
# =============================================================================

echo | tee -a -i ${logfilepath}
echo 'List folder : '$workingroot | tee -a -i ${logfilepath}
ls -alh $workingroot | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'List folder : '${workingbase} | tee -a -i ${logfilepath}
ls -alh ${workingbase} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'List folder : '${linksbase} | tee -a -i ${logfilepath}
ls -alh ${linksbase} | tee -a -i ${logfilepath}
echo 'List folder : '${scriptsbase} | tee -a -i ${logfilepath}
ls -alh ${scriptsbase} | tee -a -i ${logfilepath}
echo 'List folder : '${scriptsrepository} | tee -a -i ${logfilepath}
ls -alh ${scriptsrepository} | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo 'Done with links generation!' | tee -a -i ${logfilepath}
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


