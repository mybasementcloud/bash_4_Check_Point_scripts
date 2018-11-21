#!/bin/bash
#
# SCRIPT for BASH to execute migrate export to /var/log/__customer/upgrade_export folder
# using /var/log/__customer/upgrade_export/migration_tools/<version>/migrate file
# EPM export includes standard NPM export with logs, but also another export with logs and MSI files
#
# (C) 2016-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptTemplateLevel=005
ScriptVersion=02.02.00
ScriptDate=2018-11-20
#

export BASHScriptVersion=v02x02x00
export BASHScriptTemplateLevel=$ScriptTemplateLevel
export BASHScriptName="migrate_export_epm_ugex_001_v$ScriptVersion"
export BASHScriptShortName="migrate_export_epm"
export BASHScriptDescription="migrate export EPM to local folder using version tools"

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

export UseR8XAPI=false
export UseJSONJQ=true

# setup initial log file for output logging
export logfilepath=/var/tmp/$BASHScriptName.$DATEDTGS.log
touch $logfilepath

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

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


export scriptspathroot=/var/log/__customer/upgrade_export/scripts
export subscriptsfolder=_sub-scripts
export subscriptsversion=v02.00.00

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

    if [ -r ${CPDIR}/jq/jq ] ; then
        export JQ=${CPDIR}/jq/jq
    elif [ -r ${CPDIR_PATH}/jq/jq ] ; then
        export JQ=${CPDIR_PATH}/jq/jq
    elif [ -r ${MDS_CPDIR}/jq/jq ] ; then
        export JQ=${MDS_CPDIR}/jq/jq
#    elif [ -r /opt/CPshrd-R80/jq/jq ] ; then
#        export JQ=/opt/CPshrd-R80/jq/jq
#    elif [ -r /opt/CPshrd-R80.10/jq/jq ] ; then
#        export JQ=/opt/CPshrd-R80.10/jq/jq
#    elif [ -r /opt/CPshrd-R80.20/jq/jq ] ; then
#        export JQ=/opt/CPshrd-R80.20/jq/jq
    else
        echo "Missing jq, not found in ${CPDIR}/jq/jq, ${CPDIR_PATH}/jq/jq, or ${MDS_CPDIR}/jq/jq" | tee -a -i $logfilepath
        echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo "Log output in file $logfilepath" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        exit 1
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
    R80 | R80.10 | R80.20.M1 | R80.20 ) 
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


# -------------------------------------------------------------------------------------------------
# Validate we are working on a system that handles this operation
# -------------------------------------------------------------------------------------------------

if [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
    echo "System is Security Management Server!"
    echo
    echo "Continueing with Migrate Export..."
    echo
elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
    echo "System is Multi-Domain Management Server!"
    echo
    echo "This script is not meant for MDM, exiting!"
    exit 255
else
    echo "System is a gateway!"
    echo
    echo "This script is not meant for gateways, exiting!"
    exit 255
fi


# -------------------------------------------------------------------------------------------------
# Setup script values
# -------------------------------------------------------------------------------------------------


export outputfilepath=$outputpathroot/
export outputfileprefix=ugex_$HOSTNAME'_'$gaiaversion
export outputfilesuffix='_'$DATEDTGS
export outputfiletype=.tgz

export toolsversion=$gaiaversion

export migratefilefolderroot=migration_tools/$toolsversion
export migratefilename=migrate

export migratefilepath=$outputpathroot/$migratefilefolderroot/
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

export command2run='export -n -l'
export outputfile=$outputfileprefix'_logs'$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export command2run2='export -n -l --include-uepm-msi-files'
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

read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Preparing ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if $IsR8XVersion ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

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

#if [ $testmode -eq 0 ]; then
#    # Not test mode
#    $migratefile $command2run $outputfilefqdn | tee -a -i $logfilepath
#else
#    # test mode
#    echo Test Mode! | tee -a -i $logfilepath
#fi

$migratefile $command2run $outputfilefqdn | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Done performing '$migratefile $command2run | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if [ $Check4EPM -gt 0 ]; then
    echo | tee -a -i $logfilepath
    echo 'Executing 2...' | tee -a -i $logfilepath
    echo '-> '$migratefile $command2run2 $outputfilefqdn2 | tee -a -i $logfilepath

    #if [ $testmode -eq 0 ]; then
    #    # Not test mode
    #    $migratefile $command2run2 $outputfilefqdn2 | tee -a -i $logfilepath
    #else
    #    # test mode
    #    echo Test Mode! | tee -a -i $logfilepath
    #fi
    
    $migratefile $command2run2 $outputfilefqdn2 | tee -a -i $logfilepath

    echo | tee -a -i $logfilepath
    echo 'Done performing '$migratefile $command2run2 | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
fi

echo | tee -a -i $logfilepath
ls -alh $outputfilefqdn | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if $IsR8XVersion ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Clean-up, stop, and [re-]start services...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if $IsR8XVersion ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'cpstop ...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

cpstop | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'cpstop completed' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

echo "Short $WAITTIME second nap..." | tee -a -i $logfilepath
sleep $WAITTIME

echo | tee -a -i $logfilepath
echo 'cpstart...' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

sleep $WAITTIME

cpstart | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'cpstart completed' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

if $IsR8XVersion ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath

if $IsR8XVersion ; then
    # cpm_status.sh only exists in R8X
    $MDS_FWDIR/scripts/cpm_status.sh | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    echo | tee -a -i $logfilepath
fi

cpwd_admin list | tee -a -i $logfilepath

if [ $CPVer80 -gt 0 ]; then
    # R80 version so kick the API on
    echo | tee -a -i $logfilepath
    echo 'api start ...' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    api start | tee -a -i $logfilepath
    
    echo | tee -a -i $logfilepath
    echo 'api start completed' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
else
    # not R80 version so no API
    echo | tee -a -i $logfilepath
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

echo
echo 'List folder : '$outputpathbase
ls -alh $outputpathbase
echo

echo
echo 'Output location for all results is here : '$outputpathbase
echo 'Log results documented in this log file : '$logfilepath
echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


