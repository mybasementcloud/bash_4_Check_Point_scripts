F#!/bin/bash
#
# SCRIPT capture configuration values for bash and clish level 005
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptTemplateLevel=006
ScriptVersion=03.01.00
ScriptDate=2019-01-03
#

export BASHScriptVersion=v03x01x00
export BASHScriptTemplateLevel=$ScriptTemplateLevel
export BASHScriptName="config_capture.v$ScriptVersion"
export BASHScriptShortName="config_capture"
export BASHScriptDescription="Configuration Capture for bash and clish level 005"

export BASHScriptHelpFile="$BASHScriptName.help"


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

export R8XRequired=false
export UseR8XAPI=false
export UseJSONJQ=false

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
export OtherOutputFolder=./host_data

# if we are date-time stamping the output location as a subfolder of the 
# output folder set this to true,  otherwise it needs to be false
#
export OutputDTGSSubfolder=true
export OutputSubfolderScriptName=false
export OutputSubfolderScriptShortName=false

export notthispath=/home/
export startpathroot=.

export localdotpath=`echo $PWD`
export currentlocalpath=$localdotpath
export workingpath=$currentlocalpath

export UseGaiaVersionAndInstallation=true
export ShowGaiaVersionResults=true
export KeepGaiaVersionResultsFile=true

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


export scriptspathroot=/var/log/__customer/upgrade_export/scripts
export subscriptsfolder=_sub-scripts
export subscriptsversion=v03.00.00

export rootscriptconfigfile=__root_script_config.sh


# Configure basic information for formation of file path for command line parameter handler script
#
# cli_script_cmdlineparm_handler_root - root path to command line parameter handler script
# cli_script_cmdlineparm_handler_folder - folder for under root path to command line parameter handler script
# cli_script_cmdlineparm_handler_file - filename, without path, for command line parameter handler script
#
export cli_script_cmdlineparm_handler_root=$scriptspathroot
export cli_script_cmdlineparm_handler_folder=$subscriptsfolder
export cli_script_cmdlineparm_handler_file=cmd_line_parameters_handler.sub-script.$ScriptTemplateLevel.$subscriptsversion.sh


# Configure basic information for formation of file path for configure script output paths and folders handler script
#
# script_output_paths_and_folders_handler_root - root path to configure script output paths and folders handler script
# script_output_paths_and_folders_handler_folder - folder for under root path to configure script output paths and folders handler script
# script_output_paths_and_folders_handler_file - filename, without path, for configure script output paths and folders handler script
#
export script_output_paths_and_folders_handler_root=$scriptspathroot
export script_output_paths_and_folders_handler_folder=$subscriptsfolder
export script_output_paths_and_folders_handler_file=script_output_paths_and_folders.sub-script.$ScriptTemplateLevel.$subscriptsversion.sh


# Configure basic information for formation of file path for gaia version and type handler script
#
# gaia_version_type_handler_root - root path to gaia version and type handler script
# gaia_version_type_handler_folder - folder for under root path to gaia version and type handler script
# gaia_version_type_handler_file - filename, without path, for gaia version and type handler script
#
export gaia_version_type_handler_root=$scriptspathroot
export gaia_version_type_handler_folder=$subscriptsfolder
export gaia_version_type_handler_file=gaia_version_installation_type.sub-script.$ScriptTemplateLevel.$subscriptsversion.sh


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# MODIFIED 2018-12-18 -

export checkR77version=`echo "${FWDIR}" | grep -i "R77"`
export checkifR77version=`test -z $checkR77version; echo $?`
if [ $checkifR77version -eq 1 ] ; then
    export isitR77version=true
else
    export isitR77version=false
fi
#echo $isitR77version

export checkR80version=`echo "${FWDIR}" | grep -i "R80"`
export checkifR80version=`test -z $checkR80version; echo $?`
if [ $checkifR80version -eq 1 ] ; then
    export isitR80version=true
else
    export isitR80version=false
fi
#echo $isitR80version

if $isitR77version; then
    echo "This is an R77.X version..."
    export UseR8XAPI=false
    export UseJSONJQ=false
elif $isitR80version; then
    echo "This is an R80.X version..."
    export UseR8XAPI=$UseR8XAPI
    export UseJSONJQ=$UseJSONJQ
else
    echo "This is not an R77.X or R80.X version ????"
fi


# -------------------------------------------------------------------------------------------------
# END:  Root Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# =================================================================================================
# START:  Command Line Parameter Handling and Help
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-10-03 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#


export SHOWHELP=false
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
elif $NOWAIT ; then
    # NOWAIT mode set ON from shell level
    export CLIparm_NOWAIT=true
elif ! $NOWAIT ; then
    # NOWAIT mode set OFF from shell level
    export CLIparm_NOWAIT=false
else
    # NOWAIT mode set to wrong value from shell level
    export CLIparm_NOWAIT=false
fi

export REMAINS=

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-10-03

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
                LOCALREMAINS="$LOCALREMAINS \"$OPT\""
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
                    LOCALREMAINS="$LOCALREMAINS \"$OPT\""
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
        for k ; do
            echo "$k $'\t' ${k}" | tee -a -i $logfilepath
        done
        echo | tee -a -i $logfilepath
        
    else
	    # Verbose mode OFF
	    
        echo >> $logfilepath
        echo "Command line parameters remains : " >> $logfilepath
        echo "Number parms $#" >> $logfilepath
        echo "remains raw : \> $@ \<" >> $logfilepath
        for k ; do
            echo "$k $'\t' ${k}" >> $logfilepath
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
     
    dumprawcliremains "$REMAINS"

    processcliremains "$REMAINS"
    
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
# GetScriptSourceFolder - Get the actual source folder for the running script
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-11-20 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-11-20


# -------------------------------------------------------------------------------------------------
# ConfigureJQforJSON - Configure JQ variable value for JSON parsing
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-11-20 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
    #elif [ -r /opt/CPshrd-R80/jq/jq ] ; then
    #    export JQ=/opt/CPshrd-R80/jq/jq
    #    export JQNotFound=false
    #    export UseJSONJQ=true
    #elif [ -r /opt/CPshrd-R80.10/jq/jq ] ; then
    #    export JQ=/opt/CPshrd-R80.10/jq/jq
    #    export JQNotFound=false
    #    export UseJSONJQ=true
    #elif [ -r /opt/CPshrd-R80.20/jq/jq ] ; then
    #    export JQ=/opt/CPshrd-R80.20/jq/jq
    #    export JQNotFound=false
    #    export UseJSONJQ=true
    else
        export JQ=
        export JQNotFound=true
        export UseJSONJQ=false

        if $UseR8XAPI ; then
            # to use the R8X API, JQ is required!
            echo "Missing jq, not found in ${CPDIR}/jq/jq, ${CPDIR_PATH}/jq/jq, or ${MDS_CPDIR}/jq/jq" | tee -a -i $logfilepath
            echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            echo "Log output in file $logfilepath" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            exit 1
        fi
    fi
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-11-20

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# SetScriptOutputPathsAndFolders - Setup and call configure script output paths and folders handler action script
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-10-03 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

SetScriptOutputPathsAndFolders () {
    #
    # Setup and call configure script output paths and folders handler action script
    #
    
    export script_output_paths_and_folders_handler_path=$script_output_paths_and_folders_handler_root/$script_output_paths_and_folders_handler_folder
    
    export script_output_paths_and_folders_handler=$script_output_paths_and_folders_handler_path/$script_output_paths_and_folders_handler_file
    
    # -------------------------------------------------------------------------------------------------
    # Check gaia version and type handler action script exists
    # -------------------------------------------------------------------------------------------------
    
    # Check that we can finde the gaia version and type handler file
    #
    if [ ! -r $script_output_paths_and_folders_handler ] ; then
        # no file found, that is a problem
        if [ "$SCRIPTVERBOSE" = "true" ] ; then
            echo | tee -a -i $logfilepath
            echo 'gaia version and type handler script file missing' | tee -a -i $logfilepath
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
            echo 'gaia version and type handler script file missing' | tee -a -i $logfilepath
            echo '  File not found : '$script_output_paths_and_folders_handler | tee -a -i $logfilepath
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-10-03

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


echo | tee -a -i $logfilepath
echo $BASHScriptDescription', script version '$ScriptVersion' from '$ScriptDate | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Date Time Group   :  '$DATEDTGS | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# Script Source Folder
# -------------------------------------------------------------------------------------------------

# We need the Script's actual source folder to find subscripts
#
GetScriptSourceFolder


# -------------------------------------------------------------------------------------------------
# JQ and json related
# -------------------------------------------------------------------------------------------------

if $UseJSONJQ ; then 
    ConfigureJQforJSON
fi


# -------------------------------------------------------------------------------------------------
# Configure script output paths and folders
# -------------------------------------------------------------------------------------------------

SetScriptOutputPathsAndFolders "$@" 


# -------------------------------------------------------------------------------------------------
# END:  Root Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Gaia version and installation type identification
#----------------------------------------------------------------------------------------

if $UseGaiaVersionAndInstallation ; then
    GetGaiaVersionAndInstallationType "$@"
fi


#==================================================================================================
#==================================================================================================
# End of template 
#==================================================================================================
#==================================================================================================
#==================================================================================================


#----------------------------------------------------------------------------------------
# Setup Basic Parameters
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Validate we are working on a system that handles this operation
# -------------------------------------------------------------------------------------------------

case "$gaiaversion" in
    R80 | R80.10 | R80.20.M1 | R80.20.M2 | R80.20.M3 | R80.20 | R80.30.M1 | R80.30.M2 | R80.30.M3 | R80.30 ) 
        export IsR8XVersion=true
        ;;
    *)
        export IsR8XVersion=false
        ;;
esac


#==================================================================================================
#==================================================================================================
#
# shell meat
#
#==================================================================================================
#==================================================================================================


#----------------------------------------------------------------------------------------
# Configure specific parameters
#----------------------------------------------------------------------------------------

export targetversion=$gaiaversion

export outputfilepath=$outputpathbase/
export outputfileprefix=$HOSTNAME'_'$targetversion
export outputfilesuffix='_'$DATEDTGS
export outputfiletype=.txt

if [ ! -r $outputfilepath ] ; then
    mkdir $outputfilepath | tee -a -i $logfilepath
    chmod 775 $outputfilepath | tee -a -i $logfilepath
else
    chmod 775 $outputfilepath | tee -a -i $logfilepath
fi


#----------------------------------------------------------------------------------------
# bash - Gaia Version information 
#----------------------------------------------------------------------------------------

export command2run=Gaia_version
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

# This was already collected earlier and saved in a dedicated file

cp $gaiaversionoutputfile $outputfilefqdn | tee -a -i $logfilepath
rm $gaiaversionoutputfile | tee -a -i $logfilepath

#----------------------------------------------------------------------------------------
# bash - backup user's home folder
#----------------------------------------------------------------------------------------

export homebackuproot=$startpathroot

export expandedpath=$(cd $homebackuproot ; pwd)
export homebackuproot=$expandedpath
export checkthispath=`echo "${expandedpath}" | grep -i "$notthispath"`
export isitthispath=`test -z $checkthispath; echo $?`

if [ $isitthispath -eq 1 ] ; then
    #Oh, Oh, we're in the home directory executing, not good!!!
    #Configure homebackuproot for $alternatepathroot folder since we can't run in /home/
    export homebackuproot=$alternatepathroot
else
    #OK use the current folder and create host_data sub-folder
    export homebackuproot=$startpathroot
fi

if [ ! -r $homebackuproot ] ; then
    #not where we're expecting to be, since $homebackuproot is missing here
    #maybe this hasn't been run here yet.
    #OK, so make the expected folder and set permissions we need
    mkdir $homebackuproot
    chmod 775 $homebackuproot
else
    #set permissions we need
    chmod 775 $homebackuproot
fi

export expandedpath=$(cd $homebackuproot ; pwd)
export homebackuproot=${expandedpath}
export homebackuppath="$homebackuproot/home.backup"

if [ ! -r $homebackuppath ] ; then
    mkdir $homebackuppath
    chmod 775 $homebackuppath
else
    chmod 775 $homebackuppath
fi

export command2run=backup-home
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile
touch "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo 'Execute '$command2run' to '$outputhomepath' with output to : '$outputfilefqdn >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"

echo "Copy /home folder to $outputhomepath" >> "$outputfilefqdn"
cp -a -v "/home/" "$outputhomepath" >> "$outputfilefqdn"

echo
echo 'Execute '$command2run' to '$homebackuppath' with output to : '$outputfilefqdn
echo >> "$outputfilefqdn"

pushd /home

echo >> "$outputfilefqdn"
echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"

echo "Copy /home folder contents to $homebackuppath" >> "$outputfilefqdn"
cp -a -v "." "$homebackuppath" >> "$outputfilefqdn"

popd

echo >> "$outputfilefqdn"
echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"

echo >> "$outputfilefqdn"

echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather licensing information
#----------------------------------------------------------------------------------------

export command2run=cplic_print
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
cplic print > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - basic information
#----------------------------------------------------------------------------------------

export command2run=basic_information
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn

touch $outputfilefqdn
echo >> "$outputfilefqdn"
echo 'Memory Utilization : free -m -t' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

free -m -t >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'Disk Utilization : df -h' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

df -h >> "$outputfilefqdn"


echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'Disk Mount : mount' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

mount >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'Volume Group information : vgdisplay -C' >> "$outputfilefqdn"
echo 'Volume Group information : vgdisplay -v' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

vgdisplay -C >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

vgdisplay -v >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather route details
#----------------------------------------------------------------------------------------

export command2run=route
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
route -vn > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather arp details
#----------------------------------------------------------------------------------------

export command2run=arp
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn

touch $outputfilefqdn
arp -vn >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
arp -av >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - generate device and system information via dmidecode
#----------------------------------------------------------------------------------------

export command2run=dmidecode
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
dmidecode > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - collect /var/log/dmesg and copy if it exists
#----------------------------------------------------------------------------------------

# /var/log/dmesg
export file2copy=dmesg
export file2copypath="/var/log/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

dmesg > $file2copypath

# Gaia should have /var/log/dmesg file
#

if [ ! -r $file2copypath ] ; then
    echo | tee -a -i $outputfilefqdn
    echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
else
    echo | tee -a -i $outputfilefqdn
    echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
    cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
 
    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo 'Dump contents of '$file2copypath' file to '$outputfilefqdn | tee -a -i $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo >> $outputfilefqdn
    cat "$file2copypath" >> $outputfilefqdn
    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo >> $outputfilefqdn
fi
echo | tee -a -i $outputfilefqdn
    

#----------------------------------------------------------------------------------------
# bash - collect /etc/modprobe.conf and copy if it exists
#----------------------------------------------------------------------------------------

# /etc/modprobe.conf
export file2copy=modprobe.conf
export file2copypath="/etc/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2copy' and document locations' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

find / -name $file2copy | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find all file variants : '$file2copy*' and document locations' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

find / -name $file2copy* | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

# Gaia should have /etc/modprobe.conf file
#

if [ ! -r $file2copypath ] ; then
    echo | tee -a -i $outputfilefqdn
    echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
else
    echo | tee -a -i $outputfilefqdn
    echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
    cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
 
    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo 'Dump contents of '$file2copypath' file to '$outputfilefqdn | tee -a -i $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo >> $outputfilefqdn
    cat "$file2copypath" >> $outputfilefqdn
    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo >> $outputfilefqdn
fi
echo | tee -a -i $outputfilefqdn
    

#----------------------------------------------------------------------------------------
# bash - gather interface details - lspci
#----------------------------------------------------------------------------------------

export command2run=lspci
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
lspci -n -v > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface details
#----------------------------------------------------------------------------------------

export command2run=ifconfig
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with output to : '$outputfilefqdn
ifconfig > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - Collect Interface Information per interface
#----------------------------------------------------------------------------------------

export command2run=interfaces_details
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export dmesgfilefqdn=$outputfilepath'dmesg'
if [ ! -r $dmesgfilefqdn ] ; then
    echo
    echo 'No dmesg file at :  '$dmesgfilefqdn
    echo 'Generating dmesg file!'
    echo
    dmesg > $dmesgfilefqdn
else
    echo
    echo 'found dmesg file at :  '$dmesgfilefqdn
    echo
fi
echo

echo > $outputfilefqdn
echo 'Executing commands for '$command2run' with output to file : '$outputfilefqdn | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

clish -i -c "lock database override" >> $outputfilefqdn
clish -i -c "lock database override" >> $outputfilefqdn

clish -i -c "show interfaces" | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

IFARRAY=()

GETINTERFACES="`clish -i -c "show interfaces"`"

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo 'Build array of interfaces : ' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

arraylength=0
while read -r line; do

    if [ $arraylength -eq 0 ]; then
    	echo -n 'Interfaces :  ' | tee -a -i $outputfilefqdn
    else
    	echo -n ', ' | tee -a -i $outputfilefqdn
    fi

    #IFARRAY+=("$line")
    if [ "$line" == 'lo' ]; then
        echo -n 'Not adding '$line | tee -a -i $outputfilefqdn
    else 
        IFARRAY+=("$line")
    	echo -n $line | tee -a -i $outputfilefqdn
    fi
	
	arraylength=${#IFARRAY[@]}
	arrayelement=$((arraylength-1))
	
done <<< "$GETINTERFACES"

echo | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

echo 'Identified Interfaces in array for detail data collection :' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

for j in "${IFARRAY[@]}"
do
    #echo "$j, ${j//\'/}"  | tee -a -i $outputfilefqdn
    echo $j | tee -a -i $outputfilefqdn
done
echo | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

export ifshortoutputfile=$outputfileprefix'_'$command2run'_short'$outputfilesuffix$outputfiletype
export ifshortoutputfilefqdn=$outputfilepath$ifshortoutputfile
touch $ifshortoutputfilefqdn
echo >> $ifshortoutputfilefqdn
echo '----------------------------------------------------------------------------------------' >> $ifshortoutputfilefqdn

for i in "${IFARRAY[@]}"
do
    
    #------------------------------------------------------------------------------------------------------------------
    # Short Information
    #------------------------------------------------------------------------------------------------------------------

    echo 'Interface : '$i >> $ifshortoutputfilefqdn
    ifconfig $i | grep -i HWaddr >> $ifshortoutputfilefqdn
    ethtool -i $i | grep -i bus >> $ifshortoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $ifshortoutputfilefqdn

    #------------------------------------------------------------------------------------------------------------------
    # Detailed Information
    #------------------------------------------------------------------------------------------------------------------

    export interfaceoutputfile=$outputfileprefix'_'$command2run'_'$i$outputfilesuffix$outputfiletype
    export interfaceoutputfilefqdn=$outputfilepath$interfaceoutputfile
    
    echo 'Executing commands for interface : '$i' with output to file : '$interfaceoutputfilefqdn | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    
    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ifconfig $i | tee -a -i $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute clish -i -c "show interface '$i'"' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    clish -i -c "show interface $i" | tee -a -i $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -i '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -i $i >> $interfaceoutputfilefqdn

    echo | tee -a -i $outputfilefqdn
    cat $interfaceoutputfilefqdn | grep bus | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -g '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -g $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -k '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -k $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -S '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -S $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute grep of dmesg for '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    cat $dmesgfilefqdn | grep -i $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    
    cat $interfaceoutputfilefqdn >> $outputfilefqdn
    echo >> $outputfilefqdn

    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
    echo >> $outputfilefqdn

   
done

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - collect /etc/sysconfig/network and backup if it exists
#----------------------------------------------------------------------------------------

# /etc/sysconfig/network
export file2copy=network
export file2copypath="/etc/sysconfig/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

# Gaia sould have /etc/sysconfig/network file
#

if [ ! -r $file2copypath ] ; then
    echo | tee -a -i $outputfilefqdn
    echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
else
    echo | tee -a -i $outputfilefqdn
    echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
    cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
 
    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo 'Dump contents of '$file2copypath' file to '$outputfilefqdn | tee -a -i $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo >> $outputfilefqdn
    cat "$file2copypath" >> $outputfilefqdn
    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo >> $outputfilefqdn
fi
echo | tee -a -i $outputfilefqdn
    

#----------------------------------------------------------------------------------------
# bash - gather interface details from /etc/sysconfig/networking
#----------------------------------------------------------------------------------------

# /etc/sysconfig/networking

export command2run=etc_sysconfig_networking
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export sourcepath=/etc/sysconfig/networking
export targetpath=$outputfilepath$command2run/

echo | tee -a -i "$outputfilefqdn"
echo 'Copy files from '$sourcepath' to '$targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

mkdir $targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cp -a -v $sourcepath $targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface details from /etc/sysconfig/network-scripts
#----------------------------------------------------------------------------------------

# /etc/sysconfig/network-scripts

export command2run=etc_sysconfig_networking_scripts
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export sourcepath=/etc/sysconfig/network-scripts
export targetpath=$outputfilepath$command2run/

echo | tee -a -i "$outputfilefqdn"
echo 'Copy files from '$sourcepath' to '$targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

mkdir $targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cp -a -v $sourcepath $targetpath | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface name rules
#----------------------------------------------------------------------------------------

export command2run=interfaces_naming_rules
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export file2copy=00-OS-XX.rules
export file2copypath="/etc/udev/rules.d/$file2copy"
export file2findpath="/"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2copy' and document locations' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

find / -name $file2copy* | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cat "$file2copypath" | tee -a -i "$outputfilefqdn"
cp "$file2copypath" "$outputfilepath" | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"


export file2copy=00-ANACONDA.rules
export file2copypath="/etc/sysconfig/$file2copy"
export file2findpath="/"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2copy' and document locations' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

find / -name $file2copy | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"

echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a -i "$outputfilefqdn"
echo | tee -a -i "$outputfilefqdn"

cat "$file2copypath" | tee -a -i "$outputfilefqdn"
cp "$file2copypath" "$outputfilepath" | tee -a -i "$outputfilefqdn"

echo | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - collect /etc/sysconfig/hwconf and backup if it exists
#----------------------------------------------------------------------------------------

# /etc/sysconfig/hwconf
export file2copy=hwconf
export file2copypath="/etc/sysconfig/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

# Gaia sould have /etc/sysconfig/hwconf file
#

if [ ! -r $file2copypath ] ; then
    echo | tee -a -i $outputfilefqdn
    echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
else
    echo | tee -a -i $outputfilefqdn
    echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
    cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
 
    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo 'Dump contents of '$file2copypath' file to '$outputfilefqdn | tee -a -i $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo >> $outputfilefqdn
    cat "$file2copypath" >> $outputfilefqdn
    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo '----------------------------------------------------------------------------' >> $outputfilefqdn
    echo >> $outputfilefqdn
fi
echo | tee -a -i $outputfilefqdn
    

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# Special files to collect and backup (at some time)
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
#    smartlog_settings.conf
#
#    user.def - sk98239 (Location of 'user.def' file on Management Server
#
#    table.def - sk98339 (Location of 'table.def' files on Management Server)
#
#    crypt.def - sk98241 (Location of 'crypt.def' files on Security Management Server)
#    crypt.def - sk108600 (VPN Site-to-Site with 3rd party)
#
#    implied_rules.def - sk92281 (Creating customized implied rules for Check Point Security Gateway - 'implied_rules.def' file)
#
#    base.def - sk95147 (Modifying definitions of packet inspection on Security Gateway for different protocols - 'base.def' file)
#
#    vpn_table.def - sk92332 (Customizing the VPN configuration for Check Point Security Gateway - 'vpn_table.def' file)
#
#    DCE RPC files - sk42402 (Legitimate DCE-RPC (MS DCOM) bind packets dropped by IPS)
#
#    rtsp.def - sk35945 (RTSP traffic is dropped when SecureXL is enabled)
#
#    ftp.def - sk61781 (FTP packet is dropped - Attack Information: The packet was modified due to a potential Bounce Attack Evasion Attempt (Telnet Options))
#


#----------------------------------------------------------------------------------------
# bash - collect $SMARTLOGDIR/conf/smartlog_settings.conf and backup if it exists
#----------------------------------------------------------------------------------------

# $SMARTLOGDIR/conf/smartlog_settings.conf
export file2copy=smartlog_settings.conf
export file2copypath="$SMARTLOGDIR/conf/$file2copy"

if [[ $sys_type_MDS = 'true' ]] ; then
    
    # HANDLE MDS and Domains

    # HANDLE MDS
    
    export outputfile=$outputfileprefix'_file_MDS_'$file2copy$outputfilesuffix
    export outputfilefqdn=$outputfilepath$outputfile

    if [ ! -r $file2copypath ] ; then
        echo | tee -a -i $outputfilefqdn
        echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    else
        echo | tee -a -i $outputfilefqdn
        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
     
        echo >> $outputfilefqdn
        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
        echo 'Dump contents of '$file2copypath' file to '$outputfilefqdn | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
        echo >> $outputfilefqdn
        cat "$file2copypath" >> $outputfilefqdn
        echo >> $outputfilefqdn
        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
        echo >> $outputfilefqdn
    fi
    echo | tee -a -i $outputfilefqdn
    
    # HANDLE MDS Domains
    


else
    # System is not MDS, so no need to cycle through domains
    
    export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix
    export outputfilefqdn=$outputfilepath$outputfile

    if [ ! -r $file2copypath ] ; then
        echo | tee -a -i $outputfilefqdn
        echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    else
        echo | tee -a -i $outputfilefqdn
        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
     
        echo >> $outputfilefqdn
        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
        echo 'Dump contents of '$file2copypath' file to '$outputfilefqdn | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
        echo >> $outputfilefqdn
        cat "$file2copypath" >> $outputfilefqdn
        echo >> $outputfilefqdn
        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
        echo >> $outputfilefqdn
    fi
    echo | tee -a -i $outputfilefqdn
    
fi


#----------------------------------------------------------------------------------------
# bash - identify user.def files - sk98239
#----------------------------------------------------------------------------------------

# $FWDIR/conf/user.def
export file2find=user.def
export file2findpath="/"
export command2run=find
export outputfile=$outputfileprefix'_'$command2run'_'$file2find$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2find' and document locations' | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

find / -name $file2find* | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/conf/user.def and backup if it exists - sk98239
#----------------------------------------------------------------------------------------

# $FWDIR/conf/user.def
#export file2copy=user.def
#export file2copypath="$FWDIR/conf/$file2copy"
#export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix
#export outputfilefqdn=$outputfilepath$outputfile
#
#if [[ $sys_type_MDS = 'true' ]] ; then
#    
#    # HANDLE MDS and Domains
#    
#else
#    # System is not MDS, so no need to cycle through domains
#    
#    if [ ! -r $file2copypath ] ; then
#        echo | tee -a -i $outputfilefqdn
#        echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
#    else
#        echo | tee -a -i $outputfilefqdn
#        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
#        echo | tee -a -i $outputfilefqdn
#        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
#        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
#     
#        echo >> $outputfilefqdn
#        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
#        echo 'Dump contents of '$file2copypath' file to '$outputfilefqdn | tee -a -i $outputfilefqdn
#        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
#        echo >> $outputfilefqdn
#        cat "$file2copypath" >> $outputfilefqdn
#        echo >> $outputfilefqdn
#        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
#        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
#        echo >> $outputfilefqdn
#    fi
#    echo | tee -a -i $outputfilefqdn
#    
#fi


#----------------------------------------------------------------------------------------
# bash - identify table.def files - sk98339
#----------------------------------------------------------------------------------------

# $FWDIR/lib/table.def
export file2find=table.def
export file2findpath="/"
export command2run=find
export outputfile=$outputfileprefix'_'$command2run'_'$file2find$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2find' and document locations' | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

find / -name $file2find* | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/lib/table.def and backup if it exists - sk98339
#----------------------------------------------------------------------------------------

# $FWDIR/lib/table.def
#export file2copy=table.def
#export file2copypath="$FWDIR/lib/$file2copy"
#export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix
#export outputfilefqdn=$outputfilepath$outputfile
#
#if [[ $sys_type_MDS = 'true' ]] ; then
#    
#    # HANDLE MDS and Domains
#    
#else
#    # System is not MDS, so no need to cycle through domains
#    
#    if [ ! -r $file2copypath ] ; then
#        echo | tee -a -i $outputfilefqdn
#        echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
#    else
#        echo | tee -a -i $outputfilefqdn
#        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
#        echo | tee -a -i $outputfilefqdn
#        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
#        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
#     
#        echo >> $outputfilefqdn
#        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
#        echo 'Dump contents of '$file2copypath' file to '$outputfilefqdn | tee -a -i $outputfilefqdn
#        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
#        echo >> $outputfilefqdn
#        cat "$file2copypath" >> $outputfilefqdn
#        echo >> $outputfilefqdn
#        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
#        echo '----------------------------------------------------------------------------' >> $outputfilefqdn
#        echo >> $outputfilefqdn
#    fi
#    echo | tee -a -i $outputfilefqdn
#    
#fi


#----------------------------------------------------------------------------------------
# bash - identify crypt.def files - sk98241 and sk108600
#----------------------------------------------------------------------------------------

#
#    crypt.def - sk98241 (Location of 'crypt.def' files on Security Management Server)
#    crypt.def - sk108600 (VPN Site-to-Site with 3rd party)
#

export file2find=crypt.def
export file2findpath="/"
export command2run=find
export outputfile=$outputfileprefix'_'$command2run'_'$file2find$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2find' and document locations' | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

find / -name $file2find* | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - identify implied_rules.def files - sk92281
#----------------------------------------------------------------------------------------

#
#    implied_rules.def - sk92281 (Creating customized implied rules for Check Point Security Gateway - 'implied_rules.def' file)
#

export file2find=implied_rules.def
export file2findpath="/"
export command2run=find
export outputfile=$outputfileprefix'_'$command2run'_'$file2find$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo 'Find file : '$file2find' and document locations' | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

find / -name $file2find* | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/boot/modules/fwkern.conf and backup if it exists
#----------------------------------------------------------------------------------------

# $FWDIR/boot/modules/fwkern.conf
export file2copy=fwkern.conf
export file2copypath="$FWDIR/boot/modules/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

if [ $Check4GW -eq 1 ]; then
    # Gateways generally could have $FWDIR/boot/modules/fwkern.conf file
    #
    
    if [ ! -r $file2copypath ] ; then
        echo | tee -a -i $outputfilefqdn
        echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    else
        echo | tee -a -i $outputfilefqdn
        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" .
     
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo 'Contents of '$file2copypath' file' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        cat "$file2copypath" | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
    fi
    echo | tee -a -i $outputfilefqdn
    
else
    # not expecting a $FWDIR/boot/modules/fwkern.conf file, but collect if it exists
    #

    if [ -r $file2copypath ] ; then
        echo | tee -a -i $outputfilefqdn
        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" .
     
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo 'Contents of '$file2copypath' file' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        cat "$file2copypath" | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
    fi
fi


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/boot/modules/vpnkern.conf and backup if it exists - SK101219
#----------------------------------------------------------------------------------------

# $FWDIR/boot/modules/vpnkern.conf
export file2copy=vpnkern.conf
export file2copypath="$FWDIR/boot/modules/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

if [ $Check4GW -eq 1 ]; then
    # Gateways generally could have $FWDIR/boot/modules/vpnkern.conf file
    #
    
    if [ ! -r $file2copypath ] ; then
        echo | tee -a -i $outputfilefqdn
        echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    else
        echo | tee -a -i $outputfilefqdn
        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" .
     
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo 'Contents of '$file2copypath' file' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        cat "$file2copypath" | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
    fi
    echo | tee -a -i $outputfilefqdn
    
else
    # not expecting a $FWDIR/boot/modules/vpnkern.conf file, but collect if it exists
    #

    if [ -r $file2copypath ] ; then
        echo | tee -a -i $outputfilefqdn
        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" .
     
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo 'Contents of '$file2copypath' file' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        cat "$file2copypath" | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
    fi
fi


#----------------------------------------------------------------------------------------
# bash - collect /opt/CPUserCheckPortal/phpincs/conf/TPAPI.ini and backup if it exists
#----------------------------------------------------------------------------------------

# /opt/CPUserCheckPortal/phpincs/conf/TPAPI.ini
export file2copy=TPAPI.ini
export file2copypath="/opt/CPUserCheckPortal/phpincs/conf/$file2copy"
export outputfile=$outputfileprefix'_file_'$file2copy$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

if [ $Check4GW -eq 1 ]; then
    # Gateways generally could have /opt/CPUserCheckPortal/phpincs/conf/TPAPI.ini file
    #
    
    if [ ! -r $file2copypath ] ; then
        echo | tee -a -i $outputfilefqdn
        echo 'No '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
    else
        echo | tee -a -i $outputfilefqdn
        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" .
     
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo 'Contents of '$file2copypath' file' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        cat "$file2copypath" | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
    fi
    echo | tee -a -i $outputfilefqdn
    
else
    # not expecting a /opt/CPUserCheckPortal/phpincs/conf/TPAPI.ini file, but collect if it exists
    #

    if [ -r $file2copypath ] ; then
        echo | tee -a -i $outputfilefqdn
        echo 'found '$file2copy' file at :  '$file2copypath | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo 'copy '$file2copy' to : '"$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" "$outputfilepath" | tee -a -i $outputfilefqdn
        cp "$file2copypath" .
     
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo 'Contents of '$file2copypath' file' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        cat "$file2copypath" | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo '----------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
        echo | tee -a -i $outputfilefqdn
    fi
fi


#----------------------------------------------------------------------------------------
# bash - GW - status of SecureXL
#----------------------------------------------------------------------------------------

if [ $Check4GW -eq 1 ]; then
    
    export command2run=fwaccel-statistics
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with output to : '$outputfilefqdn
    
    touch $outputfilefqdn
    echo >> "$outputfilefqdn"
    echo 'fwacell stat' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stat >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwacell stats' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stats >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwacell stats -s' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stats -s >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwacell stats -p' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stats -p >> "$outputfilefqdn"

    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwaccel templates' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel templates >> "$outputfilefqdn"

    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwaccel templates -S' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel templates -S >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'Get list of loaded anti spoofing ranges' >> "$outputfilefqdn"
    echo 'fwaccel ranges -l' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel ranges -l >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwaccel ranges' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel ranges >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"

fi


#----------------------------------------------------------------------------------------
# bash - Management Systems Information
#----------------------------------------------------------------------------------------

if [[ $sys_type_MDS = 'true' ]] ; then

    export command2run=cpwd_admin
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with output to : '$outputfilefqdn
    command > "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo '$FWDIR_PATH/scripts/cpm_status.sh' >> "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    
    #case "$gaiaversion" in
    #    R80 | R80.10 | R80.20.M1 | R80.20.M2 | R80.20.M3 | R80.20 | R80.30.M1 | R80.30.M2 | R80.30.M3 | R80.30 ) 
    #        # cpm_status.sh only exists in R8X
    #        $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i "$outputfilefqdn"
    #        echo | tee -a -i "$outputfilefqdn"
    #        ;;
    #    *)
    #        echo | tee -a -i "$outputfilefqdn"
    #        ;;
    #esac

    if $IsR8XVersion; then
        # cpm_status.sh only exists in R8X
        $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i "$outputfilefqdn"
        echo | tee -a -i "$outputfilefqdn"
    else
        echo | tee -a -i "$outputfilefqdn"
    fi

    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'cpwd_admin list' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    cpwd_admin list >> "$outputfilefqdn"

    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'mdsstat' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    export COLUMNS=128
    mdsstat >> "$outputfilefqdn"

elif [[ $sys_type_SMS = 'true' ]] || [[ $sys_type_SmartEvent = 'true' ]] ; then

    export command2run=cpwd_admin
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with output to : '$outputfilefqdn
    command > "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo '$MDS_FWDIR/scripts/cpm_status.sh' >> "$outputfilefqdn"
    echo | tee -a -i "$outputfilefqdn"
    
    #case "$gaiaversion" in
    #    R80 | R80.10 | R80.20.M1 | R80.20.M2 | R80.20.M3 | R80.20 | R80.30.M1 | R80.30.M2 | R80.30.M3 | R80.30 ) 
    #        # cpm_status.sh only exists in R8X
    #        $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i "$outputfilefqdn"
    #        echo | tee -a -i "$outputfilefqdn"
    #        ;;
    #    *)
    #        echo | tee -a -i "$outputfilefqdn"
    #        ;;
    #esac

    if $IsR8XVersion; then
        # cpm_status.sh only exists in R8X
        $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i "$outputfilefqdn"
        echo | tee -a -i "$outputfilefqdn"
    else
        echo | tee -a -i "$outputfilefqdn"
    fi

    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'cpwd_admin list' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    cpwd_admin list >> "$outputfilefqdn"

fi

echo | tee -a -i "$outputfilefqdn"


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#

#----------------------------------------------------------------------------------------
# bash - GW - status of Identity Awareness
#----------------------------------------------------------------------------------------

if [ $Check4GW -eq 1 ]; then
    
    export command2run=identity_awareness_details
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with output to : '$outputfilefqdn
    
    touch $outputfilefqdn

    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'pdp status show' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    pdp status show >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'pep show pdp all' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    pep show pdp all >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'pdp auth kerberos_encryption get' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    pdp auth kerberos_encryption get >> "$outputfilefqdn"
    
fi


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#

#----------------------------------------------------------------------------------------
# bash - ?what next?
#----------------------------------------------------------------------------------------

#export command2run=command
#export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
#export outputfilefqdn=$outputfilepath$outputfile

#echo
#echo 'Execute '$command2run' with output to : '$outputfilefqdn
#command > "$outputfilefqdn"

#echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
#echo >> "$outputfilefqdn"
#echo 'fwacell stats -s' >> "$outputfilefqdn"
#echo >> "$outputfilefqdn"
#
#fwaccel stats -s >> "$outputfilefqdn"
#


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# clish operations - might have issues if user is in Gaia webUI
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

export command2run=clish_commands
export clishoutputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export clishoutputfilefqdn=$outputfilepath$clishoutputfile


#----------------------------------------------------------------------------------------
# clish - save configuration to file
#----------------------------------------------------------------------------------------

export command2run=clish_config
export outputfile=$command2run'_'$outputfileprefix$outputfilesuffix
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a $clishoutputfilefqdn
echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a $clishoutputfilefqdn
echo | tee -a $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "save config" >> $clishoutputfilefqdn

clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "save configuration $outputfile" >> $clishoutputfilefqdn

clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "save config" >> $clishoutputfilefqdn

cp "$outputfile" "$outputfilefqdn" >> $clishoutputfilefqdn


#----------------------------------------------------------------------------------------
# clish - show assets
#----------------------------------------------------------------------------------------

export command2run=clish_assets
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo | tee -a $clishoutputfilefqdn
echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a $clishoutputfilefqdn
echo | tee -a $clishoutputfilefqdn
touch $outputfilefqdn

echo 'clish show asset all :' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "show asset all" >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo 'clish show asset system :' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "show asset system" >> "$outputfilefqdn"
echo >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# clish and bash - Gather version information from all possible methods
#----------------------------------------------------------------------------------------

export command2run=versions
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

touch $outputfilefqdn
echo 'Versions:' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo 'uname for kernel version : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
uname -a >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'clish : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "lock database override" >> $clishoutputfilefqdn
clish -i -c "show version all" >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
clish -i -c "show version os build" >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'cpinfo -y all : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
cpinfo -y all >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'fwm ver : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
fwm ver >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'fw ver : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
fw ver >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'cpvinfo $MDS_FWDIR/cpm-server/dleserver.jar : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
cpvinfo $MDS_FWDIR/cpm-server/dleserver.jar >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"

case "$gaiaversion" in
    R80 | R80.10 | R80.20.M1 | R80.20 ) 
        # installed_jumbo_take only exists in R7X
        echo >> "$outputfilefqdn"
        ;;
    *)
        echo >> "$outputfilefqdn"
        echo 'installed_jumbo_take : ' >> "$outputfilefqdn"
        echo >> "$outputfilefqdn"
        installed_jumbo_take >> "$outputfilefqdn"
        echo >> "$outputfilefqdn"
        ;;
esac

echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"


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

echo
echo 'List files : '$outputpathbase'/config*'
ls -alh $outputpathroot/config*
echo
echo 'List files : '$outputpathbase'/fw*'
ls -alh $outputpathroot/fw*
echo

echo
echo 'List folder : '$outputpathbase
ls -alh $outputpathbase
echo

echo
echo 'Output location for all results is here : '$outputpathbase
echo 'Host Data output for this run is here   : '$outputpathbase
echo 'Log results documented in this log file : '$logfilepath
echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


