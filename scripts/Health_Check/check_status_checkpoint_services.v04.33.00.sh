#!/bin/bash
#
# SCRIPT Check Status of Check Point Services IAW sk83520 (https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk83520)
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
ScriptDate=2020-09-17
ScriptVersion=04.33.00
ScriptRevision=000
TemplateVersion=04.33.00
TemplateLevel=006
SubScriptsLevel=006
SubScriptsVersion=04.10.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=check_status_checkpoint_services
export BASHScriptShortName="CP_services_status"
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription="Check Status of Check Point Services"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=Health_Check

export BASHScripttftptargetfolder="CP_status_check"


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

export WAITTIME=60

# MODIFIED 2020-09-11 -
# R80       version 1.0
# R80.10    version 1.1
# R80.20.M1 version 1.2
# R80.20 GA version 1.3
# R80.20.M2 version 1.4
# R80.30    version 1.5
# R80.40    version 1.6
# R80.40 JHF 78 version 1.6.1
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
export OtherOutputFolder=./healthchecks

# if we are date-time stamping the output location as a subfolder of the 
# output folder set this to true,  otherwise it needs to be false
#
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
    workoutputfile=/var/tmp/workoutputfile.2.$DATEDTGS.txt
    echo > $workoutputfile
    
    # Screen width template for sizing, default width of 80 characters assumed
    #
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    
    echo 'Local CLI Parameters :' >> $workoutputfile
    echo >> $workoutputfile
    
    #echo 'CLIparm_local1          = '$CLIparm_local1 >> $workoutputfile
    #echo 'CLIparm_local2          = '$CLIparm_local2 >> $workoutputfile
    echo  >> $workoutputfile
    echo 'LOCALREMAINS            = '$LOCALREMAINS >> $workoutputfile
    
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
        echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
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
        echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
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

# MODIFIED 2020-09-14 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-14

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
        echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
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
        echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
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
        echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
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
        echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
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
# Document_curl - Document curl command with log of error response (the actual response)
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-01-19 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Document_curl () {
    #
    # Document_curl - Document curl command with log of error response (the actual response)
    #

    templogfile=$logfilepathbase/$BASHScriptName.$DATEDTGS.curl_ops.log
    templogerrorfile=$logfilepathbase/$BASHScriptName.$DATEDTGS.curl_ops.errout.log

    curl_cli "$@" 2> $templogerrorfile >> $templogfile
    curlerror=$?

    echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
    echo '| curl command | result = '$curlerror | tee -a -i $logfilepath
    echo '| # curl_cli '$@ | tee -a -i $logfilepath
    echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath

    cat $templogfile >> $logfilepath
    echo >> $logfilepath
    rm $templogfile >> $logfilepath

    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' >> $logfilepath

    cat $templogerrorfile >> $logfilepath
    echo >> $logfilepath
    rm $templogerrorfile >> $logfilepath

    echo '-----------------------------------------------------------------------------------------' >> $logfilepath
    echo >> $logfilepath

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

    templogfile=$logfilepathbase/$BASHScriptName.$DATEDTGS.wget_ops.log
    templogerrorfile=$logfilepathbase/$BASHScriptName.$DATEDTGS.wget_ops.errout.log

    rm index.html
    wget "$@" 2> $templogerrorfile >> $templogfile
    rm index.html
    wgeterror=$?

    echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
    echo '| wget command | result = '$wgeterror | tee -a -i $logfilepath
    echo '| # wget '$@ | tee -a -i $logfilepath
    echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath

    cat $templogfile >> $logfilepath
    echo >> $logfilepath
    rm $templogfile >> $logfilepath

    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ' >> $logfilepath

    cat $templogerrorfile >> $logfilepath
    echo >> $logfilepath
    rm $templogerrorfile >> $logfilepath

    echo '-----------------------------------------------------------------------------------------' >> $logfilepath
    echo >> $logfilepath

    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-19

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# Document_wget


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# Verify Check Point services access
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Verify Check Point services access
# -------------------------------------------------------------------------------------------------


echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Proxy settings implemented :' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

clish -i -c "show proxy" | tee -a -i $logfilepath

# curl_cli -v -k ...

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'cws.checkpoint.com : Application Control, URLF, AV, Malware' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://cws.checkpoint.com/APPI/SystemStatus/type/short
Document_curl -v http://cws.checkpoint.com/URLF/SystemStatus/type/short
Document_curl -v http://cws.checkpoint.com/AntiVirus/SystemStatus/type/short
Document_curl -v http://cws.checkpoint.com/Malware/SystemStatus/type/short

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'updates.checkpoint.com : IPS Updates' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v -k https://updates.checkpoint.com/

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'dl3.checkpoint.com : Download Service updates' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v -k http://dl3.checkpoint.com

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'usercenter.checkpoint.com : Contract Entitlement : IPS, Traditional AV, Traditional URLF' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v -k https://usercenter.checkpoint.com/usercenter/services/ProductCoverageService

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'usercenter.checkpoint.com : Contract Entitlement : Software Blades Manager Service' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v --cacert $CPDIR/conf/ca-bundle.crt https://usercenter.checkpoint.com/usercenter/services/BladesManagerService

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'resolver[1-5].chkp.ctmail.com : Suspicious Mail Outbreaks' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://resolver1.chkp.ctmail.com
Document_curl -v http://resolver2.chkp.ctmail.com
Document_curl -v http://resolver3.chkp.ctmail.com
Document_curl -v http://resolver4.chkp.ctmail.com
Document_curl -v http://resolver5.chkp.ctmail.com

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'download.ctmail.com : Anti-Spam' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://download.ctmail.com

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'te.checkpoint.com : Threat Emulation' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://te.checkpoint.com

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'teadv.checkpoint.com : Threat Emulation' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://teadv.checkpoint.com

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'threat-emulation.checkpoint.com : Threat Emulation' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://threat-emulation.checkpoint.com
Document_curl -v http://threat-emulation.checkpoint.com/tecloud/Ping

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'kav8.zonealarm.com : Archive Scanning and Deep Inspection' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://kav8.zonealarm.com/version.txt

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'kav8.checkpoint.com : Traditional AV' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://kav8.checkpoint.com

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'avupdates.checkpoint.com : Traditional AV, Legacy URLF' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://avupdates.checkpoint.com/UrlList.txt

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'sigcheck.checkpoint.com : Traditional AV, Legacy URLF, edge devices' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://sigcheck.checkpoint.com/Siglist2.txt

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'smbmgmtservice.checkpoint.com : Manage SMB Gateways' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

smp_connectivity_test smbmgmtservice.checkpoint.com | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'zerotouch.checkpoint.com : ZeroTouch Deployment (SMB)' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

test zero-touch-request | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'secureupdates.checkpoint.com : General updates server for Check Points gateways' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_wget http://secureupdates.checkpoint.com
Document_curl -v secureupdates.checkpoint.com

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'https://productcoverage.checkpoint.com/ProductCoverageService : Contract Check' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v https://productcoverage.checkpoint.com/ProductCoverageService

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'https://sc[1-5].checkpoint.com : Download of icons and screenshots from Check Point media storage servers' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

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

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'https://push.checkpoint.com : Push Notifications (since R77.10) for incoming e-mails and meeting requests on hand held devices, while the Capsule Workspace Mail app is in the background' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -vk https://push.checkpoint.com/push/ping

echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'http://downloads.checkpoint.com : Download of Endpoint Compliance Updates (Endpoint Security On Demand (ESOD) database)' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://downloads.checkpoint.com


echo | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo '-----------------------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'http://productservices.checkpoint.com : Next Generation Licensing uses this service. (Entitlement/Licensing Updates)' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

Document_curl -v http://productservices.checkpoint.com


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
    rm nul >> $logfilepath
fi

if [ -r None ] ; then
    rm None >> $logfilepath
fi

echo | tee -a -i $logfilepath
echo 'List folder : '$outputpathbase | tee -a -i $logfilepath
ls -alh $outputpathbase | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo >> $logfilepath
echo 'Output location for all results is here : '$outputpathbase >> $logfilepath
echo 'Log results documented in this log file : '$logfilepath >> $logfilepath
echo >> $logfilepath


#==================================================================================================
#==================================================================================================
#
# Archive results for easy transport
#
#==================================================================================================
#==================================================================================================


export expandedpath=$(cd $OtherOutputFolder ; pwd)
export archivepathbase=$expandedpath
export archivefiletype=.tgz
export archivefilename=$HOSTNAME'_'$targetversion_$BASHScriptName.$DATEDTGS$archivefiletype
export archivefqfn=$archivepathbase/$archivefilename

if $OutputSubfolderScriptName ; then
    # Add script name to the Subfolder name
    export archivestartfolder=$DATEDTGS.$BASHScriptName
elif $OutputSubfolderScriptShortName ; then
    # Add short script name to the Subfolder name
    export archivestartfolder=$DATEDTGS.$BASHScriptShortName
else
    export archivestartfolder=$DATEDTGS
fi

echo | tee -a -i $logfilepath
echo '----------------------------------------------------------------------------'
echo '----------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Archive of operation results' | tee -a -i $logfilepath
echo ' - from '$archivepathbase/$archivestartfolder | tee -a -i $logfilepath
echo ' - to : '$archivefqfn | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo '----------------------------------------------------------------------------' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

#tar czvf $archivefqfn --directory=$archivepathbase $outputpathbase $DATEDTGS
tar czvf $archivefqfn --directory=$archivepathbase $archivestartfolder

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

export archivetftptargetfolder=$tftptargetfolder_root/$BASHScripttftptargetfolder
export archivetftpfilefqfn=$archivetftptargetfolder/$archivefilename

if $EXPORTRESULTSTOTFPT ; then
    
    if [ ! -z $MYTFTPSERVER1 ]; then
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'Push archive file : '$archivefqfn
        echo ' - to tftp server : '$MYTFTPSERVER1
        echo ' - target path    : '$archivetftpfilefqfn
        echo '----------------------------------------------------------------------------'
        echo
        
        tftp -v -m binary $MYTFTPSERVER1 -c put $archivefqfn $archivetftpfilefqfn
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    else
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'tftp server value $MYTFTPSERVER1 not set!'
        echo '  Not executing push to that tftp server!'
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    fi
    
    if [ ! -z $MYTFTPSERVER2 ]; then
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'Push archive file : '$archivefqfn
        echo ' - to tftp server : '$MYTFTPSERVER2
        echo ' - target path    : '$archivetftpfilefqfn
        echo '----------------------------------------------------------------------------'
        echo
        
        tftp -v -m binary $MYTFTPSERVER2 -c put $archivefqfn $archivetftpfilefqfn
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    else
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'tftp server value $MYTFTPSERVER2 not set!'
        echo '  Not executing push to that tftp server!'
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    fi
    
    if [ ! -z $MYTFTPSERVER3 ]; then
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'Push archive file : '$archivefqfn
        echo ' - to tftp server : '$MYTFTPSERVER3
        echo ' - target path    : '$archivetftpfilefqfn
        echo '----------------------------------------------------------------------------'
        echo
        
        tftp -v -m binary $MYTFTPSERVER3 -c put $archivefqfn $archivetftpfilefqfn
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    else
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'tftp server value $MYTFTPSERVER3 not set!'
        echo '  Not executing push to that tftp server!'
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    fi
    
    if [ ! -z $MYTFTPSERVER ]; then
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'Push archive file : '$archivefqfn
        echo ' - to tftp server : '$MYTFTPSERVER
        echo ' - target path    : '$archivetftpfilefqfn
        echo '----------------------------------------------------------------------------'
        echo
        
        tftp -v -m binary $MYTFTPSERVER -c put $archivefqfn $archivetftpfilefqfn
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo
        
    else
        
        echo
        echo '----------------------------------------------------------------------------'
        echo '----------------------------------------------------------------------------'
        echo 'tftp server value $MYTFTPSERVER not set!'
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


echo
echo 'Output location for all results is here : '$outputpathbase
echo 'Log results documented in this log file : '$logfilepath
echo 'Archive of operation is here            : '$archivefqfn
echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


