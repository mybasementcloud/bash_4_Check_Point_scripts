#!/bin/bash
#
# SCRIPT for BASH to execute migrate export to /var/log/__customer/upgrade_export folder
# using /var/log/__customer/upgrade_export/migration_tools/<version>/migrate file
# EPM export includes standard NPM export and adds export of EP Client MSI files
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
ScriptDate=2020-10-21
ScriptVersion=04.37.00
ScriptRevision=001
TemplateVersion=04.37.00
TemplateLevel=006
SubScriptsLevel=006
SubScriptsVersion=04.12.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=migrate_server_export_epm_ugex
export BASHScriptShortName="migrate_server_export_epm"
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription="migrate_server export EPM with EP Client MSI to local folder using version tools"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=SMS

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


# -------------------------------------------------------------------------------------------------
# Script key folders and files variable configuration
# -------------------------------------------------------------------------------------------------

export customerpathroot=/var/log/__customer
export customerworkpathroot=$customerpathroot/upgrade_export

export scriptspathroot=$customerworkpathroot/scripts

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


# setup initial log file for output logging
export logfilepath=/var/tmp/$BASHScriptName.$DATEDTGS.log
touch $logfilepath

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

# MODIFIED 2020-10-21 -
# if we are date-time stamping the output location as a subfolder of the 
# output folder set this to true,  otherwise it needs to be false
#
# OutputYearSubfolder             : true|false : Add a folder level with just the year (YYYY)
# OutputYMSubfolder               : true|false : Add a folder level with the year-month (YYYY-MM)
# OutputDTGSSubfolder             : true|false : Add a folder level with Date Time Group with Seconds (YYYY-MM-DD-HHmmSS)
# Append script name to output subfolder, only one of these should be true, ignored if both are false
# OutputSubfolderScriptName       : true|false : Add full script name to folder name of output folder
#                                 :: setting this value true will override OutputSubfolderScriptShortName
# OutputSubfolderScriptShortName  : true|false : Add short script name to folder name of output folder
#
export OutputYearSubfolder=false
export OutputYMSubfolder=false
export OutputDTGSSubfolder=true
export OutputSubfolderScriptName=false
export OutputSubfolderScriptShortName=true

export notthispath=/home/
export startpathroot=.

export localdotpath=`echo $PWD`
export currentlocalpath=$localdotpath
export workingpath=$currentlocalpath

export UseGaiaVersionAndInstallation=true
export ShowGaiaVersionResults=true
export KeepGaiaVersionResultsFile=false


# MOVED 2020-09-17 -
# -------------------------------------------------------------------------------------------------
# Announce Script, this should also be the first log entry!
# -------------------------------------------------------------------------------------------------

echo | tee -a -i $logfilepath
echo $BASHScriptDescription', script version '$ScriptVersion', revision '$ScriptRevision' from '$ScriptDate | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Date Time Group   :  '$DATEDTGS | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# Configure basic information for formation of file path for command line parameter handler script
#
# cli_script_cmdlineparm_handler_root - root path to command line parameter handler script
# cli_script_cmdlineparm_handler_folder - folder for under root path to command line parameter handler script
# cli_script_cmdlineparm_handler_file - filename, without path, for command line parameter handler script
#
export cli_script_cmdlineparm_handler_root=$scriptspathroot
export cli_script_cmdlineparm_handler_folder=$subscriptsfolder
export cli_script_cmdlineparm_handler_file=cmd_line_parameters_handler.subscript.$SubScriptsLevel.v$SubScriptsVersion.sh


# Configure basic information for formation of file path for configure script output paths and folders handler script
#
# script_output_paths_and_folders_handler_root - root path to configure script output paths and folders handler script
# script_output_paths_and_folders_handler_folder - folder for under root path to configure script output paths and folders handler script
# script_output_paths_and_folders_handler_file - filename, without path, for configure script output paths and folders handler script
#
export script_output_paths_and_folders_handler_root=$scriptspathroot
export script_output_paths_and_folders_handler_folder=$subscriptsfolder
export script_output_paths_and_folders_handler_file=script_output_paths_and_folders.subscript.$SubScriptsLevel.v$SubScriptsVersion.sh


# Configure basic information for formation of file path for gaia version and type handler script
#
# gaia_version_type_handler_root - root path to gaia version and type handler script
# gaia_version_type_handler_folder - folder for under root path to gaia version and type handler script
# gaia_version_type_handler_file - filename, without path, for gaia version and type handler script
#
export gaia_version_type_handler_root=$scriptspathroot
export gaia_version_type_handler_folder=$subscriptsfolder
export gaia_version_type_handler_file=gaia_version_installation_type.subscript.$SubScriptsLevel.v$SubScriptsVersion.sh


# Configure basic information for API mgmt_cli operations handler script
#
# mgmt_cli_api_ops_handler_root - root path to API mgmt_cli operations handler script
# mgmt_cli_api_ops_handler_folder - folder for under root path to API mgmt_cli operations handler script
# mgmt_cli_api_ops_handler_file - filename, without path, for API mgmt_cli operations handler script
#
export mgmt_cli_api_ops_handler_root=$scriptspathroot
export mgmt_cli_api_ops_handler_folder=$subscriptsfolder
export mgmt_cli_api_ops_handler_file=mgmt_cli_api_operations.subscript.$SubScriptsLevel.v$SubScriptsVersion.sh


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------



# MODIFIED 2020-09-11 -

export checkR77version=`echo "${FWDIR}" | grep -i "R77"`
export checkifR77version=`test -z $checkR77version; echo $?`
if [ $checkifR77version -eq 1 ] ; then
    export isitR77version=true
else
    export isitR77version=false
fi
#echo $isitR77version

export checkR8Xversion=`echo "${FWDIR}" | grep -i "R8"`
export checkifR8Xversion=`test -z $checkR8Xversion; echo $?`
if [ $checkifR8Xversion -eq 1 ] ; then
    export isitR8Xversion=true
else
    export isitR8Xversion=false
fi
#echo $isitR8Xversion

if $isitR77version; then
    echo "This is an R77.X version..." >> $logfilepath
    export UseR8XAPI=false
    export UseJSONJQ=false
    export UseJSONJQ16=false
elif $isitR8Xversion; then
    echo "This is an R8X version..." >> $logfilepath
    export UseR8XAPI=$UseR8XAPI
    export UseJSONJQ=$UseJSONJQ
    export UseJSONJQ16=$UseJSONJQ16
else
    echo "This is not an R77.X or R8X version ????" >> $logfilepath
fi


# -------------------------------------------------------------------------------------------------
# END:  Root Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# =================================================================================================
# START:  Command Line Parameter Handling and Help
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-01-05 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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

# --NOWAIT
#
if [ -z "$NOWAIT" ]; then
    # NOWAIT mode not set from shell level
    export CLIparm_NOWAIT=false
elif [ x"`echo "$NOWAIT" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    # NOWAIT mode set OFF from shell level
    export CLIparm_NOWAIT=false
elif [ x"`echo "$NOWAIT" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
    # NOWAIT mode set ON from shell level
    export CLIparm_NOWAIT=true
else
    # NOWAIT mode set to wrong value from shell level
    export CLIparm_NOWAIT=false
fi

export CLIparm_NOSTART=false

# --NOSTART
#
if [ -z "$NOSTART" ]; then
    # NOSTART mode not set from shell level
    export CLIparm_NOSTART=false
elif [ x"`echo "$NOSTART" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    # NOSTART mode set OFF from shell level
    export CLIparm_NOSTART=false
elif [ x"`echo "$NOSTART" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
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
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-01-05

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
        echo 'OPT = '$OPT
        #
            
        # Detect argument termination
        if [ x"$OPT" = x"--" ]; then
            
            shift
            for OPT ; do
                # MODIFIED 2019-03-08
                #LOCALREMAINS="$LOCALREMAINS \"$OPT\""
                LOCALREMAINS="$LOCALREMAINS $OPT"
            done
            break
        fi
        # Parse current opt
        while [ x"$OPT" != x"-" ] ; do
            case "$OPT" in
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
                    #LOCALREMAINS="$LOCALREMAINS \"$OPT\""
                    LOCALREMAINS="$LOCALREMAINS $OPT"
                    break
                    ;;
            esac
            # Check for multiple short options
            # NOTICE: be sure to update this pattern to match valid options
            # Remove any characters matching "-", and then the values between []'s
            #NEXTOPT="${OPT#-[upmdsor?]}" # try removing single short opt
            NEXTOPT="${OPT#-[vrf?]}" # try removing single short opt
            if [ x"$OPT" != x"$NEXTOPT" ] ; then
                OPT="-$NEXTOPT"  # multiple short opts, keep going
            else
                break  # long form, exit inner loop
            fi
        done
        # Done with that param. move to next
        shift
    done
    # Set the non-parameters back into the positional parameters ($1 $2 ..)
    eval set -- $LOCALREMAINS
    
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
    workoutputfile=/var/tmp/workoutputfile.2.$DATEDTGS.txt
    echo > $workoutputfile

    # Screen width template for sizing, default width of 80 characters assumed
    #
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

    echo 'Local CLI Parameters :' >> $workoutputfile
    echo >> $workoutputfile

    echo 'CLIparm_l01_toolvername   = '$CLIparm_l01_toolvername >> $workoutputfile
    echo 'CLIparm_l02_toolpath      = '$CLIparm_l02_toolpath >> $workoutputfile
    echo 'CLIparm_l03_NOCPSTART     = '$CLIparm_l03_NOCPSTART >> $workoutputfile
    echo 'CLIparm_l04_targetversion = '$CLIparm_l04_targetversion >> $workoutputfile
    echo 'CLIparm_l05_forcemigrate  = '$CLIparm_l05_forcemigrate >> $workoutputfile
    echo  >> $workoutputfile
    echo 'FORCEUSEMIGRATE           = '$FORCEUSEMIGRATE >> $workoutputfile
    echo  >> $workoutputfile
    echo 'DOCPSTART                 = '$DOCPSTART >> $workoutputfile
    echo  >> $workoutputfile
    echo 'LOCALREMAINS              = '$LOCALREMAINS >> $workoutputfile
    
    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
        # Verbose mode ON
        
        echo | tee -a -i $logfilepath
        cat $workoutputfile | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        for i ; do echo - $i | tee -a -i $logfilepath ; done
        echo | tee -a -i $logfilepath
        echo CLI parms - number "$#" parms "$@" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        if [ "$NOWAIT" != "true" ] ; then
            read -t $WAITTIME -n 1 -p "Any key to continue.  Automatic continue after $WAITTIME seconds : " anykey
            echo
        fi
        
        echo | tee -a -i $logfilepath
        echo "End of local execution" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath

    else
        # Verbose mode OFF
        
        echo >> $logfilepath
        cat $workoutputfile >> $logfilepath
        echo >> $logfilepath
        for i ; do echo - $i >> $logfilepath ; done
        echo >> $logfilepath
        echo CLI parms - number "$#" parms "$@" >> $logfilepath
        echo >> $logfilepath
        
    fi

    rm $workoutputfile
}


#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2019-12-06


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
    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
        # Verbose mode ON
        
        echo | tee -a -i $logfilepath
        echo "Command line parameters remains : " | tee -a -i $logfilepath
        echo "Number parms $#" | tee -a -i $logfilepath
        echo "remains raw : \> $@ \<" | tee -a -i $logfilepath
        
        parmnum=0
        for k ; do
            echo -e "$parmnum \t ${k}" | tee -a -i $logfilepath
            parmnum=`expr $parmnum + 1`
        done
        
        echo | tee -a -i $logfilepath
        
    else
        # Verbose mode OFF
        
        echo >> $logfilepath
        echo "Command line parameters remains : " >> $logfilepath
        echo "Number parms $#" >> $logfilepath
        echo "remains raw : \> $@ \<" >> $logfilepath
        
        parmnum=0
        for k ; do
            echo -e "$parmnum \t ${k}" >> $logfilepath
            parmnum=`expr $parmnum + 1`
        done
        
        echo >> $logfilepath
        
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
    
    export configured_handler_root=$cli_script_cmdlineparm_handler_root
    export actual_handler_root=$configured_handler_root
    
    if [ "$configured_handler_root" == "." ] ; then
        if [ $ScriptSourceFolder != $localdotpath ] ; then
            # Script is not running from it's source folder, might be linked, so since we expect the handler folder
            # to be relative to the script source folder, use the identified script source folder instead
            export actual_handler_root=$ScriptSourceFolder
        else
            # Script is running from it's source folder
            export actual_handler_root=$configured_handler_root
        fi
    else
        # handler root path is not period (.), so stipulating fully qualified path
        export actual_handler_root=$configured_handler_root
    fi
    
    export cli_script_cmdlineparm_handler_path=$actual_handler_root/$cli_script_cmdlineparm_handler_folder
    export cli_script_cmdlineparm_handler=$cli_script_cmdlineparm_handler_path/$cli_script_cmdlineparm_handler_file
    
    # Check that we can finde the command line parameter handler file
    #
    if [ ! -r $cli_script_cmdlineparm_handler ] ; then
        # no file found, that is a problem
        if [ "$SCRIPTVERBOSE" = "true" ] ; then
            echo | tee -a -i $logfilepath
            echo 'Command Line Parameter handler script file missing' | tee -a -i $logfilepath
            echo '  File not found : '$cli_script_cmdlineparm_handler | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo 'Other parameter elements : ' | tee -a -i $logfilepath
            echo '  Configured Root path    : '$configured_handler_root | tee -a -i $logfilepath
            echo '  Actual Script Root path : '$actual_handler_root | tee -a -i $logfilepath
            echo '  Root of folder path : '$cli_script_cmdlineparm_handler_root | tee -a -i $logfilepath
            echo '  Folder in Root path : '$cli_script_cmdlineparm_handler_folder | tee -a -i $logfilepath
            echo '  Folder Root path    : '$cli_script_cmdlineparm_handler_path | tee -a -i $logfilepath
            echo '  Script Filename     : '$cli_script_cmdlineparm_handler_file | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo "Log output in file $logfilepath" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        else
            echo | tee -a -i $logfilepath
            echo 'Command Line Parameter handler script file missing' | tee -a -i $logfilepath
            echo '  File not found : '$cli_script_cmdlineparm_handler | tee -a -i $logfilepath
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo "Log output in file $logfilepath" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        fi
        
        exit 251
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Call Command Line Parameter Handlerr action script exists
    # -------------------------------------------------------------------------------------------------
    
    if [ "$SCRIPTVERBOSE" = "true" ] ; then
        echo | tee -a -i $logfilepath
        echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo "Calling external Command Line Paramenter Handling Script" | tee -a -i $logfilepath
        echo " - External Script : "$cli_script_cmdlineparm_handler | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
    
    . $cli_script_cmdlineparm_handler "$@"
    
    if [ "$SCRIPTVERBOSE" = "true" ] ; then
        echo | tee -a -i $logfilepath
        echo "Returned from external Command Line Paramenter Handling Script" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        if [ "$NOWAIT" != "true" ] ; then
            read -t $WAITTIME -n 1 -p "Any key to continue.  Automatic continue after $WAITTIME seconds : " anykey
            echo
        fi
        
        echo | tee -a -i $logfilepath
        echo "Starting local execution" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
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
if [ -n "$REMAINS" ]; then
     
    dumprawcliremains $REMAINS
    
    processcliremains $REMAINS
    
    # MODIFIED 2019-03-08
    
    dumpcliparmparselocalresults $REMAINS
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

# MODIFIED 2020-10-21 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CheckAndUnlockGaiaDB () {
    #
    # CheckAndUnlockGaiaDB - Check and Unlock Gaia database
    #
    
    echo -n 'Unlock gaia database : '
    
    export gaiadbunlocked=false
    
    until $gaiadbunlocked ; do
        
        export checkgaiadblocked=`clish -i -c "lock database override" | grep -i "owned"`
        export isclishowned=`test -z $checkgaiadblocked; echo $?`
        
        if [ $isclishowned -eq 1 ]; then 
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-10-21

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
    
    echo >> $logfilepath
    
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        TARGET="$(readlink "$SOURCE")"
        if [[ $TARGET == /* ]]; then
            echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'" >> $logfilepath
            SOURCE="$TARGET"
        else
            DIR="$( dirname "$SOURCE" )"
            echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')" >> $logfilepath
            SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
        fi
    done
    
    echo "SOURCE is '$SOURCE'" >> $logfilepath
    
    RDIR="$( dirname "$SOURCE" )"
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    if [ "$DIR" != "$RDIR" ]; then
        echo "DIR '$RDIR' resolves to '$DIR'" >> $logfilepath
    fi
    echo "DIR is '$DIR'" >> $logfilepath
    
    export ScriptSourceFolder=$DIR
    
    echo >> $logfilepath
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-14


# -------------------------------------------------------------------------------------------------
# ConfigureJQforJSON - Configure JQ variable value for JSON parsing
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-14 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
        
        if $UseR8XAPI ; then
            # to use the R8X API, JQ is required!
            echo "Missing jq, not found in ${CPDIR}/jq/jq, ${CPDIR_PATH}/jq/jq, or ${MDS_CPDIR}/jq/jq !" | tee -a -i $logfilepath
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo "Log output in file $logfilepath" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            exit 1
        fi
    fi
    
    # JQ16 points to where jq 1.6 is installed, which is not generally part of Gaia, even R80.40EA (2020-01-20)
    export JQ16NotFound=true
    export UseJSONJQ16=false
    
    # As of template version v04.21.00 we also added jq version 1.6 to the mix and it lives in the customer path root /tools/JQ folder by default
    export JQ16PATH=$customerpathroot/_tools/JQ
    export JQ16FILE=jq-linux64
    export JQ16FQFN=$JQ16PATH/$JQ16FILE
    
    if [ -r $JQ16FQFN ] ; then
        # OK we have the easy-button alternative
        export JQ16=$JQ16FQFN
        export JQ16NotFound=false
        export UseJSONJQ16=true
    elif [ -r "./_tools/JQ/$JQ16FILE" ] ; then
        # OK we have the local folder alternative
        export JQ16=./_tools/JQ/$JQ16FILE
        export JQ16NotFound=false
        export UseJSONJQ16=true
    elif [ -r "../_tools/JQ/$JQ16FILE" ] ; then
        # OK we have the parent folder alternative
        export JQ16=../_tools/JQ/$JQ16FILE
        export JQ16NotFound=false
        export UseJSONJQ16=true
    else
        export JQ16=
        export JQ16NotFound=true
        export UseJSONJQ16=false
        
        if $UseR8XAPI ; then
            if $JQ16Required ; then
                # to use the R8X API, JQ is required!
                echo 'Missing jq version 1.6, not found in '$JQ16FQFN', '"./_tools/JQ/$JQ16FILE"', or '"../_tools/JQ/$JQ16FILE"' !' | tee -a -i $logfilepath
                echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
                echo | tee -a -i $logfilepath
                echo "Log output in file $logfilepath" | tee -a -i $logfilepath
                echo | tee -a -i $logfilepath
                exit 1
            else
                echo 'Missing jq version 1.6, not found in '$JQ16FQFN', '"./_tools/JQ/$JQ16FILE"', or '"../_tools/JQ/$JQ16FILE"' !' | tee -a -i $logfilepath
                echo 'However it is not required for this operation' | tee -a -i $logfilepath
                echo | tee -a -i $logfilepath
            fi
        fi
    fi
    
    return 0
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-09-14

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
    
    export script_output_paths_and_folders_handler_path=$script_output_paths_and_folders_handler_root/$script_output_paths_and_folders_handler_folder
    
    export script_output_paths_and_folders_handler=$script_output_paths_and_folders_handler_path/$script_output_paths_and_folders_handler_file
    
    # -------------------------------------------------------------------------------------------------
    # Check output paths and folders handler action script exists
    # -------------------------------------------------------------------------------------------------
    
    # Check that we can finde the output paths and folders handler action script file
    #
    if [ ! -r $script_output_paths_and_folders_handler ] ; then
        # no file found, that is a problem
        if [ "$SCRIPTVERBOSE" = "true" ] ; then
            echo | tee -a -i $logfilepath
            echo 'output paths and folders handler action script file missing' | tee -a -i $logfilepath
            echo '  File not found : '$script_output_paths_and_folders_handler | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo 'Other parameter elements : ' | tee -a -i $logfilepath
            echo '  Root of folder path : '$script_output_paths_and_folders_handler_root | tee -a -i $logfilepath
            echo '  Folder in Root path : '$script_output_paths_and_folders_handler_folder | tee -a -i $logfilepath
            echo '  Folder Root path    : '$script_output_paths_and_folders_handler_path | tee -a -i $logfilepath
            echo '  Script Filename     : '$script_output_paths_and_folders_handler_file | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo "Log output in file $logfilepath" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        else
            echo | tee -a -i $logfilepath
            echo 'output paths and folders handler action script file missing' | tee -a -i $logfilepath
            echo '  File not found : '$script_output_paths_and_folders_handler | tee -a -i $logfilepath
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo "Log output in file $logfilepath" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        fi
        
        exit 251
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Call output paths and folders handler action script
    # -------------------------------------------------------------------------------------------------
    
    #
    # output paths and folders handler action script calling routine
    #
    
    if [ "$SCRIPTVERBOSE" = "true" ] ; then
        echo | tee -a -i $logfilepath
        echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo "Calling external Configure script output paths and folders Handling Script" | tee -a -i $logfilepath
        echo " - External Script : "$script_output_paths_and_folders_handler | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
    
    . $script_output_paths_and_folders_handler "$@"
    
    if [ "$SCRIPTVERBOSE" = "true" ] ; then
        echo | tee -a -i $logfilepath
        echo "Returned from external Configure script output paths and folders Handling Script" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        if [ "$NOWAIT" != "true" ] ; then
            read -t $WAITTIME -n 1 -p "Any key to continue.  Automatic continue after $WAITTIME seconds : " anykey
            echo
        fi
        
        echo | tee -a -i $logfilepath
        echo "Continueing local execution" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
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
    
    # MODIFIED 2018-11-20 -
    
    export configured_handler_root=$gaia_version_type_handler_root
    export actual_handler_root=$configured_handler_root
    
    if [ "$configured_handler_root" == "." ] ; then
        if [ $ScriptSourceFolder != $localdotpath ] ; then
            # Script is not running from it's source folder, might be linked, so since we expect the handler folder
            # to be relative to the script source folder, use the identified script source folder instead
            export actual_handler_root=$ScriptSourceFolder
        else
            # Script is running from it's source folder
            export actual_handler_root=$configured_handler_root
        fi
    else
        # handler root path is not period (.), so stipulating fully qualified path
        export actual_handler_root=$configured_handler_root
    fi
    
    export gaia_version_type_handler_path=$actual_handler_root/$gaia_version_type_handler_folder
    export gaia_version_type_handler=$gaia_version_type_handler_path/$gaia_version_type_handler_file
    
    # -------------------------------------------------------------------------------------------------
    # Check gaia version and type handler action script exists
    # -------------------------------------------------------------------------------------------------
    
    # Check that we can finde the gaia version and type handler file
    #
    if [ ! -r $gaia_version_type_handler ] ; then
        # no file found, that is a problem
        if [ "$SCRIPTVERBOSE" = "true" ] ; then
            echo | tee -a -i $logfilepath
            echo 'gaia version and type handler script file missing' | tee -a -i $logfilepath
            echo '  File not found : '$gaia_version_type_handler | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo 'Other parameter elements : ' | tee -a -i $logfilepath
            echo '  Root of folder path : '$gaia_version_type_handler_root | tee -a -i $logfilepath
            echo '  Folder in Root path : '$gaia_version_type_handler_folder | tee -a -i $logfilepath
            echo '  Folder Root path    : '$gaia_version_type_handler_path | tee -a -i $logfilepath
            echo '  Script Filename     : '$gaia_version_type_handler_file | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo "Log output in file $logfilepath" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        else
            echo | tee -a -i $logfilepath
            echo 'gaia version and type handler script file missing' | tee -a -i $logfilepath
            echo '  File not found : '$gaia_version_type_handler | tee -a -i $logfilepath
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo "Log output in file $logfilepath" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        fi
        
        exit 251
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Call gaia version and type handler action script
    # -------------------------------------------------------------------------------------------------
    
    #
    # gaia version and type handler calling routine
    #
    
    if [ "$SCRIPTVERBOSE" = "true" ] ; then
        echo | tee -a -i $logfilepath
        echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo "Calling external Gaia Version and Installation Type Handling Script" | tee -a -i $logfilepath
        echo " - External Script : "$gaia_version_type_handler | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
    
    . $gaia_version_type_handler "$@"
    
    if [ "$SCRIPTVERBOSE" = "true" ] ; then
        echo | tee -a -i $logfilepath
        echo "Returned from external Gaia Version and Installation Type Handling Script" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        if [ "$NOWAIT" != "true" ] ; then
            read -t $WAITTIME -n 1 -p "Any key to continue.  Automatic continue after $WAITTIME seconds : " anykey
            echo
        fi
        
        echo | tee -a -i $logfilepath
        echo "Continueing local execution" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
    
    # -------------------------------------------------------------------------------------------------
    # Handle results from gaia version and type handler action script locally
    # -------------------------------------------------------------------------------------------------
    
    if $ShowGaiaVersionResults ; then
        # show the results of this operation on the screen, not just the log file
        cat $gaiaversionoutputfile | tee -a -i $gaiaversionoutputfile
        echo | tee -a -i $gaiaversionoutputfile
    else
        # only log the results of this operation
        cat $gaiaversionoutputfile >> $logfilepath
        echo >> $logfilepath
    fi
    
    # now remove the working file
    if ! $KeepGaiaVersionResultsFile ; then
        # not keeping version results file
        rm $gaiaversionoutputfile
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

if $UseJSONJQ || UseJSONJQ16; then 
    ConfigureJQforJSON
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-01-03


#----------------------------------------------------------------------------------------
# Gaia version and installation type identification
#----------------------------------------------------------------------------------------

if $UseGaiaVersionAndInstallation ; then
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

case "$gaiaversion" in
    R80 | R80.10 | R80.20.M1 | R80.20.M2 | R80.20 | R80.30 | R80.40 | R81 ) 
        export IsR8XVersion=true
        ;;
    *)
        export IsR8XVersion=false
        ;;
esac

if $R8XRequired && ! $IsR8XVersion; then
    # we expect to run on R8X versions, so this is not where we want to execute
    echo "System is running Gaia version '$gaiaversion', which is not supported!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "This script is not meant for versions prior to R80, exiting!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo 'Output location for all results is here : '$outputpathbase | tee -a -i $logfilepath
    echo 'Log results documented in this log file : '$logfilepath | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
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
    
    echo | tee -a -i $logfilepath
    echo 'Check Point management services and processes' | tee -a -i $logfilepath
    if $IsR8XVersion ; then
        # cpm_status.sh only exists in R8X
        echo '$MDS_FWDIR/scripts/cpm_status.sh' | tee -a -i $logfilepath
        $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
    
    echo 'cpwd_admin list' | tee -a -i $logfilepath
    cpwd_admin list | tee -a -i $logfilepath

    echo | tee -a -i $logfilepath
    
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
    
    if $IsR8XVersion ; then
        # cpm_status.sh only exists in R8X
        watchcommands=$watchcommands";echo;echo;echo '$MDS_FWDIR/scripts/cpm_status.sh';$MDS_FWDIR/scripts/cpm_status.sh"
    fi
    
    watchcommands=$watchcommands";echo;echo;echo 'cpwd_admin list';cpwd_admin list"
    
    if $CLIparm_NOWAIT ; then
        echo 'Not watching and waiting...'
    else
        watch -d -n 1 "$watchcommands"
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
    
    #export migration_work_folder="/var/log/opt/CPsuite-$gaiaversion/fw1/tmp/migrate"
    export migration_work_folder="$FWDIR/tmp/migrate"
    
    if [ -d $migration_work_folder ] ; then
        # found previous migrations work folder, that needs to go...
        echo 'Found Previous Migrations work Folder :  '$migration_work_folder | tee -a -i $logfilepath
        echo >> $logfilepath
        ls -Alsh $migration_work_folder >> $logfilepath
        echo | tee -a -i $logfilepath
        
        echo 'Removing Previous Migrations work Folder :  '$migration_work_folder | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        rm -R -v -I $migration_work_folder | tee -a -i $logfilepath
        
        echo | tee -a -i $logfilepath
        echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
    else
        
        echo 'No Previous Migrations work Folder found in '$migration_work_folder | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
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
# Validate we are working on a system that handles this operation
# -------------------------------------------------------------------------------------------------
if [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
    echo "System is Security Management Server!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "Continueing with Migrate Export..." | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
    echo "System is Multi-Domain Management Server!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "This script is not meant for MDM, exiting!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo '!! CRITICAL ERROR!!' | tee -a -i $logfilepath
    echo ' EXITING...' | tee -a -i $logfilepath
    echo ' LOGFILE : ' $logfilepath | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    exit 255
else
    echo "System is a gateway!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "This script is not meant for gateways, exiting!" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo '!! CRITICAL ERROR!!' | tee -a -i $logfilepath
    echo ' EXITING...' | tee -a -i $logfilepath
    echo ' LOGFILE : ' $logfilepath | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    exit 255
fi


# -------------------------------------------------------------------------------------------------
# Setup script values
# -------------------------------------------------------------------------------------------------


#export outputfilepath=$outputpathroot/
export outputfilepath=$logfilepathbase/
export outputfileprefix=ugex_server_$HOSTNAME'_'$gaiaversion
export outputfilesuffix='_'$DATEDTGS
export outputfiletype=.tgz

export toolsversion=$gaiaversion

if [ -z $CLIparm_l04_targetversion ]; then
    export toolsversion=$gaiaversion
else
    export toolsversion=$CLIparm_l04_targetversion
fi

if [ $gaiaversion != $toolsversion ] ; then
    export EXPORTVERSIONDIFFERENT=true
else
    export EXPORTVERSIONDIFFERENT=false
fi

if [ -z $CLIparm_l01_toolvername ]; then
    if $EXPORTVERSIONDIFFERENT ; then
        export outputfileprefix=ugex_server_$HOSTNAME'_'$gaiaversion'_export_to_'$toolsversion
    else
        export outputfileprefix=ugex_server_$HOSTNAME'_'$gaiaversion
    fi
else
    if $EXPORTVERSIONDIFFERENT ; then
        export outputfileprefix=ugex_server_$HOSTNAME'_'$gaiaversion'_export_to_'$toolsversion'_using_'$CLIparm_l01_toolvername
    else
        export outputfileprefix=ugex_server_$HOSTNAME'_'$gaiaversion'_export_using_'$CLIparm_l01_toolvername
    fi
fi

case "$toolsversion" in
    R80.20 | R80.20.M1 | R80.20.M2 | R80.30 | R80.40 ) 
        # /opt/CPsuite-R80.30/fw1/scripts/migrate_server
        # /opt/CPupgrade-tools-R80.30/scripts/migrate_server
        # /opt/CPsuite-R80.40/fw1/scripts/migrate_server
        # /opt/CPupgrade-tools-R80.40/scripts/migrate_server
        
        
        if [ -z $CLIparm_l02_toolpath ]; then
            if [ -r "/opt/CPupgrade-tools-$toolsversion" ]; then
                export migratefilefolderroot=/opt/CPupgrade-tools-$toolsversion
                export migratefilepath=$migratefilefolderroot/scripts/
            elif [ -r "/opt/CPupgrade-tools-$gaiaversion" ]; then
                export migratefilefolderroot=/opt/CPupgrade-tools-$gaiaversion
                export migratefilepath=$migratefilefolderroot/scripts/
            elif [ -r "/opt/CPsuite-$toolsversion" ]; then
                export migratefilefolderroot=/opt/CPsuite-$toolsversion
                export migratefilepath=$migratefilefolderroot/fw1/scripts/
            else
                export migratefilefolderroot=/opt/CPsuite-$gaiaversion
                export migratefilepath=$migratefilefolderroot/fw1/scripts/
            fi
        else
            if [ -r $CLIparm_l02_toolpath ]; then
                export migratefilefolderroot=
                export migratefilepath=${CLIparm_l02_toolpath%/}/
            else
                if [ -r "/opt/CPupgrade-tools-$toolsversion" ]; then
                    export migratefilefolderroot=/opt/CPupgrade-tools-$toolsversion
                    export migratefilepath=$migratefilefolderroot/scripts/
                elif [ -r "/opt/CPupgrade-tools-$gaiaversion" ]; then
                    export migratefilefolderroot=/opt/CPupgrade-tools-$gaiaversion
                    export migratefilepath=$migratefilefolderroot/scripts/
                elif [ -r "/opt/CPsuite-$toolsversion" ]; then
                    export migratefilefolderroot=/opt/CPsuite-$toolsversion
                    export migratefilepath=$migratefilefolderroot/fw1/scripts/
                else
                    export migratefilefolderroot=/opt/CPsuite-$gaiaversion
                    export migratefilepath=$migratefilefolderroot/fw1/scripts/
                fi
            fi
        fi
        
        export migratefilename=migrate_server
        ;;
    *)  
        echo 'Export Version NOT SUPPORTED:  '$toolsversion | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo '!! CRITICAL ERROR!!' | tee -a -i $logfilepath
        echo ' EXITING...' | tee -a -i $logfilepath
        echo ' LOGFILE : ' $logfilepath | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        exit 255
        ;;
esac

export migratefile=$migratefilepath$migratefilename

if [ ! -r $migratefilepath ]; then
    echo '!! CRITICAL ERROR!!' | tee -a -i $logfilepath
    echo '  Missing migrate file folder!' | tee -a -i $logfilepath
    echo '  Missing folder : '$migratefilepath | tee -a -i $logfilepath
    echo ' EXITING...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    exit 255
fi

if [ ! -r $migratefile ]; then
    echo '!! CRITICAL ERROR!!' | tee -a -i $logfilepath
    echo '  Missing migrate executable file !' | tee -a -i $logfilepath
    echo '  Missing executable file : '$migratefile | tee -a -i $logfilepath
    echo ' EXITING...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    exit 255
fi

echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Execute fw logswitch' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

fw logswitch | tee -a -i $logfilepath
fw logswitch -audit | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Migration Tools Folder to use:  '$migratefilepath | tee -a -i $logfilepath
echo 'Migration Export Tools to use:  '$migratefile | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

RemoveRemnantTempMigrationFolder


#
#    [host:0]# /opt/CPupgrade-tools-R80.30/scripts/migrate_server -h
#    
#    Use the migrate utility to export and import Check Point
#    Security Management Server database.
#    
#    Usage: /opt/CPupgrade-tools-R80.30/scripts/migrate_server <ACTION> [OPTIONS] <FILE>
#    
#            ACTION (required parameter):
#    
#            export - exports database of Management Server or Multi-Domain Server.
#            import - imports database of Management Server or Multi-Domain Server.
#            verify - verifies database of Management Server or Multi-Domain Server.
#    
#            Options (optional parameters):
#            '-h'                           show this message.
#            '-v <target version>'          Import version.
#            '-skip_upgrade_tools_check'    does not check for updated upgrade tools.
#            '-l'                           Export/import logs without log indexes.
#            '-x'                           Export/import logs with log indexes.
#                                           Note: only closed logs are exported/imported.
#            '-n'                           Run non-interactively.
#            '--exclude-uepm-postgres-db'   skip over backup/restore of PostgreSQL.
#            '--include-uepm-msi-files'     export/import the uepm msi files.
#    
#            <FILE> (required parameter only for import):
#    
#            Name of archived file to export/import database to/from.
#            Path to archive should exist.
#    
#    Note:
#    Run the utility either from the current directory or using
#    an absolute path.
#
    
case "$gaiaversion" in
    R80.20.M1 | R80.20.M2 | R80.20 | R80.30 | R80.40 ) 
        export IsMigrateWIndexes=true
        ;;
    *)
        export IsMigrateWIndexes=false
        ;;
esac

if $IsMigrateWIndexes ; then
    # Migrate supports export of indexes
    #export command2run='export -n -x'
    export command2run='export -n'
else
    # Migrate does not supports export of indexes
    #export command2run='export -n -l'
    export command2run='export -n'
fi

export command2run=$command2run' -v '$gaiaversion

export outputfile=$outputfileprefix$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

if $IsMigrateWIndexes ; then
    # Migrate supports export of indexes
    #export command2run2='export -n -x --include-uepm-msi-files'
    export command2run2='export -n --include-uepm-msi-files'
else
    # Migrate does not supports export of indexes
    #export command2run2='export -n -l --include-uepm-msi-files'
    export command2run2='export -n --include-uepm-msi-files'
fi

export command2run2=$command2run2' -v '$gaiaversion

export outputfile2=$outputfileprefix'_msi_logs'$outputfilesuffix$outputfiletype
export outputfilefqdn2=$outputfilepath$outputfile2

echo | tee -a -i $logfilepath
echo 'Execute command : '$migratefile $command2run | tee -a -i $logfilepath
echo ' with ouptut to : '$outputfilefqdn | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ $Check4EPM -gt 0 ]; then
    echo 'Execute command 2 : '$migratefile $command2run2 | tee -a -i $logfilepath
    echo ' with ouptut 2 to : '$outputfilefqdn2 | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
fi

if ! $CLIparm_NOWAIT ; then read -t $WAITTIME -n 1 -p "Any key to continue : " anykey ; fi
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Preparing ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

DocumentMgmtcpwdadminlist

echo | tee -a -i $logfilepath
echo 'cpstop ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

cpstop | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'cpstop completed' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Executing...' | tee -a -i $logfilepath
echo '-> '$migratefile $command2run $outputfilefqdn | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

#list $CPDIR/log/migrate-2020.03.17*
#/opt/CPshrd-R80.40/log/migrate-2020.03.17_00.46.19.log

#export migratelogfiledate=`date +%Y.%m.%d_%H.%M`
#export migratelogfilefqfn=/var/log$CPDIR/migrate-$migratelogfiledate.*.log
export migratelogfiledate=`date +%Y.%m.%d_%H`
export migratelogfilefqfn=/var/log$CPDIR/migrate-$migratelogfiledate.*.*.log

echo 'Rough migrate log file :  '$migratelogfilefqfn | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

#if [ $testmode -eq 0 ]; then
#    # Not test mode
#    $migratefile $command2run $outputfilefqdn | tee -a -i $logfilepath
#else
#    # test mode
#    echo Test Mode! | tee -a -i $logfilepath
#fi

$migratefile $command2run $outputfilefqdn | tee -a -i $logfilepath

echo 'Copy rough migrate log : '$migratelogfilefqfn' to folder : '$outputfilepath | tee -a -i $logfilepath

cp $migratelogfilefqfn $outputfilepath | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Done performing '$migratefile $command2run | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ $Check4EPM -gt 0 ]; then
    echo | tee -a -i $logfilepath
    echo 'Executing 2...' | tee -a -i $logfilepath
    echo '-> '$migratefile $command2run2 $outputfilefqdn2 | tee -a -i $logfilepath
    
    RemoveRemnantTempMigrationFolder
    
    #export migratelogfiledate=`date +%Y.%m.%d_%H.%M`
    #export migratelogfilefqfn=/var/log$CPDIR/migrate-$migratelogfiledate.*.log
    export migratelogfiledate=`date +%Y.%m.%d_%H`
    export migratelogfilefqfn=/var/log$CPDIR/migrate-$migratelogfiledate.*.*.log
    
    echo 'Rough migrate log file :  '$migratelogfilefqfn | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    #if [ $testmode -eq 0 ]; then
    #    # Not test mode
    #    $migratefile $command2run2 $outputfilefqdn2 | tee -a -i $logfilepath
    #else
    #    # test mode
    #    echo Test Mode! | tee -a -i $logfilepath
    #fi
    
    $migratefile $command2run2 $outputfilefqdn2 | tee -a -i $logfilepath
    
    echo 'Copy rough migrate log : '$migratelogfilefqfn' to folder : '$outputfilepath | tee -a -i $logfilepath
    
    cp $migratelogfilefqfn $outputfilepath | tee -a -i $logfilepath
    
    echo | tee -a -i $logfilepath
    echo 'Done performing '$migratefile $command2run2 | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
fi

echo | tee -a -i $logfilepath
ls -alh $outputfilefqdn | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

DocumentMgmtcpwdadminlist

echo | tee -a -i $logfilepath
if ! $CLIparm_NOWAIT ; then read -t $WAITTIME -n 1 -p "Any key to continue : " anykey ; fi
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Clean-up, stop, and [re-]start services...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if $CLIparm_NOSTART ; then
    
    echo | tee -a -i $logfilepath
    echo 'cpstop ...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    cpstop | tee -a -i $logfilepath
    
    echo | tee -a -i $logfilepath
    echo 'cpstop completed' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    echo | tee -a -i $logfilepath
    if ! $CLIparm_NOWAIT ; then read -t $WAITTIME -n 1 -p "Any key to continue : " anykey ; fi
    echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
   
    
else
    
    DocumentMgmtcpwdadminlist
    
    echo | tee -a -i $logfilepath
    echo 'cpstop ...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    cpstop | tee -a -i $logfilepath
    
    echo | tee -a -i $logfilepath
    echo 'cpstop completed' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    echo | tee -a -i $logfilepath
    if ! $CLIparm_NOWAIT ; then read -t $WAITTIME -n 1 -p "Any key to continue : " anykey ; fi
    echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
    
    echo "Short $WAITTIME second nap..." | tee -a -i $logfilepath
    sleep $WAITTIME
    
    echo | tee -a -i $logfilepath
    echo 'cpstart...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    cpstart | tee -a -i $logfilepath
    
    echo | tee -a -i $logfilepath
    echo 'cpstart completed' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    WatchMgmtcpwdadminlist    

    if $IsR8XVersion ; then
        # R80 version so kick the API on
        #echo | tee -a -i $logfilepath
        #echo 'api start ...' | tee -a -i $logfilepath
        #echo | tee -a -i $logfilepath
        #
        #api start | tee -a -i $logfilepath
        #
        echo | tee -a -i $logfilepath
        echo 'api status' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    
        api status | tee -a -i $logfilepath
    
        echo | tee -a -i $logfilepath
    else
        # not R80 version so no API
        echo | tee -a -i $logfilepath
    fi

fi

    
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Done!' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Backup Folder : '$outputfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

ls -alh $outputfilepath/*.tgz | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath


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
    rm nul >> $logfilepath
fi

if [ -r None ] ; then
    rm None >> $logfilepath
fi

echo | tee -a -i $logfilepath
echo 'List folder : '$outputpathbase | tee -a -i $logfilepath
ls -alh $outputpathbase | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Output location for all results is here : '$outputpathbase | tee -a -i $logfilepath
echo 'Log results documented in this log file : '$logfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo
echo 'Script Completed, exiting...';echo


