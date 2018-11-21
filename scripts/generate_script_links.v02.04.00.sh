#!/bin/bash
#
# SCRIPT Configure script link files and copy versioned scripts to generics
#
# (C) 2016-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptTemplateLevel=005
ScriptVersion=02.04.00
ScriptDate=2018-11-20
#

export BASHScriptVersion=v02x04x00
export BASHScriptTemplateLevel=$ScriptTemplateLevel
export BASHScriptName="generate_script_links.v$ScriptVersion"
export BASHScriptShortName="generate_links"
export BASHScriptDescription="Generate Script Links"

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
export UseJSONJQ=false

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

# MODIFIED 2018-10-03 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CommandLineParameterHandler () {
    #
    # CommandLineParameterHandler - Command Line Parameter Handler calling routine
    #
    
    # -------------------------------------------------------------------------------------------------
    # Check Command Line Parameter Handlerr action script exists
    # -------------------------------------------------------------------------------------------------
    
    # MODIFIED 2018-10-03 -
    
    export cli_script_cmdlineparm_handler_path=$cli_script_cmdlineparm_handler_root/$cli_script_cmdlineparm_handler_folder
    
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
# ConfigureJQforJSON - Configure JQ variable value for JSON parsing
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-22 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-22

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
    
    export gaia_version_type_handler_path=$gaia_version_type_handler_root/$gaia_version_type_handler_folder
    
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


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# Scripts link generation and setup
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


export workingroot=$customerworkpathroot
export workingbase=$workingroot/scripts
export linksbase=$workingbase/.links


if [ ! -r $workingbase ] ; then
    echo | tee -a -i $logfilepath
    echo Error! | tee -a -i $logfilepath
    echo Missing folder $workingbase | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo Exiting! | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    exit 255
else
    chmod 775 $workingbase | tee -a -i $logfilepath
fi


if [ ! -r $linksbase ] ; then
    mkdir $linksbase | tee -a -i $logfilepath
    chmod 775 $linksbase | tee -a -i $logfilepath
else
    chmod 775 $linksbase | tee -a -i $logfilepath
fi

if [ -r $workingbase/updatescripts.sh ] ; then
    chmod 775 $workingbase/updatescripts.sh | tee -a -i $logfilepath
    cp $workingbase/updatescripts.sh $workingroot | tee -a -i $logfilepath
fi




# =============================================================================
# =============================================================================
# FOLDER:  Common
# =============================================================================


export workingdir=Common
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_gaia_version=determine_gaia_version_and_installation_type.v02.01.00.sh

file_godump=go_dump_folder_now.v00.05.00.sh
file_mkdump=make_dump_folder_now.v00.05.00.sh
file_godumpdtg=go_dump_folder_now_dtg.v00.05.00.sh
file_mkdumpdtg=make_dump_folder_now_dtg.v00.05.00.sh
file_goChgLogdtg=go_change_log_folder_now_dtg.v00.05.00.sh

ln -sf $sourcefolder/$file_gaia_version $linksfolder/gaia_version_type
ln -sf $sourcefolder/$file_gaia_version $workingroot/gaia_version_type

ln -sf $sourcefolder/$file_godump $linksfolder/godump
ln -sf $sourcefolder/$file_godump $workingroot/godump
ln -sf $sourcefolder/$file_godumpdtg $linksfolder/godtgdump
ln -sf $sourcefolder/$file_godumpdtg $workingroot/godtgdump

ln -sf $sourcefolder/$file_goChgLogdtg $linksfolder/goChangeLog
ln -sf $sourcefolder/$file_goChgLogdtg $workingroot/goChangeLog

ln -sf $sourcefolder/$file_mkdump $linksfolder/mkdump
ln -sf $sourcefolder/$file_mkdump $workingroot/mkdump
ln -sf $sourcefolder/$file_mkdumpdtg $linksfolder/mkdtgdump
ln -sf $sourcefolder/$file_mkdumpdtg $workingroot/mkdtgdump


# =============================================================================
# =============================================================================
# FOLDER:  Config
# =============================================================================


export workingdir=Config
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_configcapture=config_capture_005_v02.03.00.sh
file_interface_info=show_interface_information_v02.01.00.sh

ln -sf $sourcefolder/$file_configcapture $linksfolder/config_capture
ln -sf $sourcefolder/$file_interface_info $linksfolder/interface_info
ln -sf $sourcefolder/$file_configcapture $workingroot/config_capture
ln -sf $sourcefolder/$file_interface_info $workingroot/interface_info


# =============================================================================
# =============================================================================
# FOLDER:  GW
# =============================================================================


export workingdir=GW
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_watch_accel_stats=watch_accel_stats.v02.01.00.sh
file_set_inf_log_implied=set_informative_logging_implied_rules_on_R8x.v02.01.00.sh
file_reset_hitcount_w_bu=reset_hit_count_with_backup_001_v02.01.00.sh


ln -sf $sourcefolder/$file_watch_accel_stats $linksfolder/watch_accel_stats
ln -sf $sourcefolder/$file_set_inf_log_implied $linksfolder/set_informative_logging_implied_rules_on_R8x

ln -sf $sourcefolder/$file_reset_hitcount_w_bu $linksfolder/reset_hit_count_with_backup

if [ "$sys_type_GW" == "true" ]; then
    
    ln -sf $sourcefolder/$file_watch_accel_stats $workingroot/watch_accel_stats
    ln -sf $sourcefolder/$file_set_inf_log_implied $workingroot/set_informative_logging_implied_rules_on_R8x
    
    ln -sf $sourcefolder/$file_reset_hitcount_w_bu $workingroot/reset_hit_count_with_backup
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  Health_Check
# =============================================================================


export workingdir=Health_Check
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi


file_healthcheck=healthcheck.sh
file_healthdump=run_healthcheck_to_dump_dtg.v02.01.00.sh
file_cpservicecheck=check_status_checkpoint_services.v02.01.00.sh

ln -sf $sourcefolder/$file_healthcheck $linksfolder/healthcheck
ln -sf $sourcefolder/$file_healthcheck $workingroot/healthcheck
ln -sf $sourcefolder/$file_healthdump $linksfolder/healthdump
ln -sf $sourcefolder/$file_healthdump $workingroot/healthdump
ln -sf $sourcefolder/$file_cpservicecheck $linksfolder/checkpoint_service_status_check
ln -sf $sourcefolder/$file_cpservicecheck $workingroot/checkpoint_service_status_check


# =============================================================================
# =============================================================================
# FOLDER:  MDM
# =============================================================================


export workingdir=MDM
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_backup_mds=backup_mds_ugex_001_v02.02.00.sh
file_backup_mds_w_logs=backup_mds_w_logs_ugex_001_v02.02.00.sh
file_report_mdsstat=report_mdsstat.v02.01.00.sh
file_watch_mdsstat=watch_mdsstat.v02.01.00.sh
file_show_domains_in_array=show_all_domains_in_array.v02.01.00.sh

ln -sf $sourcefolder/$file_backup_mds $linksfolder/backup_mds_ugex
ln -sf $sourcefolder/$file_backup_mds_w_logs $linksfolder/backup_mds_w_logs_ugex
ln -sf $sourcefolder/$file_report_mdsstat $linksfolder/report_mdsstat
ln -sf $sourcefolder/$file_watch_mdsstat $linksfolder/watch_mdsstat
ln -sf $sourcefolder/$file_show_domains_in_array $linksfolder/show_domains_in_array

if [ "$sys_type_MDS" == "true" ]; then
    
    ln -sf $sourcefolder/$file_backup_mds $workingroot/backup_mds_ugex
    ln -sf $sourcefolder/$file_backup_mds_w_logs $workingroot/backup_mds_w_logs_ugex
    ln -sf $sourcefolder/$file_report_mdsstat $workingroot/report_mdsstat
    ln -sf $sourcefolder/$file_watch_mdsstat $workingroot/watch_mdsstat
    ln -sf $sourcefolder/$file_show_domains_in_array $workingroot/show_domains_in_array
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  Patch_HotFix
# =============================================================================


export workingdir=Patch_HotFix
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_patch_fix_webui_standard=fix_gaia_webui_login_dot_js.sh
file_patch_fix_webui_generic=fix_gaia_webui_login_dot_js_generic.sh

export need_fix_webui=false

case "$gaiaversion" in
    R80.20.M1 | R80.20 ) 
        export need_fix_webui=false
        ;;
    *)
        export need_fix_webui=true
        ;;
esac

if [ "$need_fix_webui" == "true" ]; then
    
    ln -sf $sourcefolder/$file_patch_fix_webui_standard $linksfolder/fix_gaia_webui_login_dot_js
    ln -sf $sourcefolder/$file_patch_fix_webui_standard $workingroot/fix_gaia_webui_login_dot_js
    
    ln -sf $sourcefolder/$file_patch_fix_webui_generic $linksfolder/fix_gaia_webui_login_dot_js_generic

fi


# =============================================================================
# =============================================================================
# FOLDER:  Session_Cleanup
# =============================================================================


export workingdir=Session_Cleanup
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_rem_zl_sessions=remove_zerolocks_sessions.v02.00.00.sh
file_rem_zl_sessions_webapi=remove_zerolocks_web_api_sessions.v02.00.00.sh
file_show_zl_sessions=show_zerolocks_sessions.v02.00.00.sh
file_show_zl_sessions_webapi=show_zerolocks_web_api_sessions.v02.00.00.sh

export do_session_cleanup=false

case "$gaiaversion" in
    R80 | R80.10 | R80.20.M1 | R80.20 ) 
        export do_session_cleanup=true
        ;;
    *)
        export do_session_cleanup=false
        ;;
esac

if [ "$do_session_cleanup" == "true" ]; then
    
    ln -sf $sourcefolder/$file_show_zl_sessions $linksfolder/show_zerolocks_sessions
    ln -sf $sourcefolder/$file_show_zl_sessions_webapi $linksfolder/show_zerolocks_web_api_sessions
    ln -sf $sourcefolder/$file_rem_zl_sessions $linksfolder/remove_zerolocks_sessions
    ln -sf $sourcefolder/$file_rem_zl_sessions_webapi $linksfolder/remove_zerolocks_web_api_sessions

    if [ "$sys_type_GW" == "false" ]; then
        
        ln -sf $sourcefolder/$file_show_zl_sessions $workingroot/show_zerolocks_sessions
        ln -sf $sourcefolder/$file_show_zl_sessions_webapi $workingroot/show_zerolocks_web_api_sessions
        ln -sf $sourcefolder/$file_rem_zl_sessions $workingroot/remove_zerolocks_sessions
        ln -sf $sourcefolder/$file_rem_zl_sessions_webapi $workingroot/remove_zerolocks_web_api_sessions
            
    fi
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  SmartEvent
# =============================================================================


export workingdir=SmartEvent
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_smev_backup=SmartEvent_Backup_R8X_v02.01.00.sh
file_smev_restore=SmartEvent_Restore_R8X_v02.01.06.sh
file_smev_reset_indexing=Reset_SmartLog_Indexing_Back_X_Days_v02.01.00.sh
file_smev_nuke=NUKE_ALL_LOGS_AND_INDEXES_v02.01.00.sh

ln -sf $sourcefolder/$file_smev_backup $linksfolder/SmartEvent_backup
ln -sf $sourcefolder/$file_smev_restore $linksfolder/SmartEvent_restore
ln -sf $sourcefolder/$file_smev_reset_indexing $linksfolder/Reset_SmartEvent_Indexing
ln -sf $sourcefolder/$file_smev_nuke $linksfolder/SmartEvent_NUKE_Index_and_Logs

if [ "$sys_type_SmartEvent" == "true" ]; then
    
    ln -sf $sourcefolder/$file_smev_backup $workingroot/SmartEvent_backup
    #ln -sf $sourcefolder/$file_smev_restore $workingroot/SmartEvent_restore
    #ln -sf $sourcefolder/$file_smev_reset_indexing $workingroot/Reset_SmartLog_Indexing
    #ln -sf $sourcefolder/$file_smev_nuke $workingroot/SmartEvent_NUKE_Index_and_Logs
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  SMS
# =============================================================================


export workingdir=SMS
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_migrate_export_npm=migrate_export_npm_ugex_001_v02.02.00.sh
file_migrate_export_w_logs_npm=migrate_export_w_logs_npm_ugex_001_v02.02.00.sh
file_migrate_export_epm=migrate_export_epm_ugex_001_v02.02.00.sh
file_migrate_export_w_logs_epm=migrate_export_w_logs_epm_ugex_001_v02.02.00.sh
file_mgmt_report=report_cpwd_admin_list.v02.01.00.sh
file_mgmt_restart=restart_mgmt.v02.01.00.sh
file_mgmt_watch=watch_cpwd_admin_list.v02.01.00.sh
file_reset_hitcount_sms=reset_hit_count_on_R80_SMS_commands_001_v00.01.00.sh

ln -sf $sourcefolder/$file_migrate_export_npm $linksfolder/migrate_export_npm_ugex
ln -sf $sourcefolder/$file_migrate_export_w_logs_npm $linksfolder/migrate_export_w_logs_npm_ugex
ln -sf $sourcefolder/$file_mgmt_restart $linksfolder/restart_mgmt
ln -sf $sourcefolder/$file_mgmt_report $linksfolder/report_cpwd_admin_list
ln -sf $sourcefolder/$file_mgmt_watch $linksfolder/watch_cpwd_admin_list

ln -sf $sourcefolder/$file_reset_hitcount_sms $linksfolder/reset_hit_count_on_R80_SMS_commands

ln -sf $sourcefolder/$file_mgmt_report $workingroot/report_cpwd_admin_list

if [ "$sys_type_SMS" == "true" ]; then
    
    ln -sf $sourcefolder/$file_migrate_export_npm $workingroot/migrate_export_npm_ugex
    ln -sf $sourcefolder/$file_migrate_export_w_logs_npm $workingroot/migrate_export_w_logs_npm_ugex
    ln -sf $sourcefolder/$file_mgmt_restart $workingroot/restart_mgmt
    ln -sf $sourcefolder/$file_mgmt_watch $workingroot/watch_cpwd_admin_list
    
    ln -sf $sourcefolder/$file_reset_hitcount_sms $workingroot/reset_hit_count_on_R80_SMS_commands
    
fi

if [ $Check4EPM -gt 0 ]; then

    ln -sf $sourcefolder/$file_migrate_export_epm $linksfolder/migrate_export_epm_ugex
    ln -sf $sourcefolder/$file_migrate_export_w_logs_epm $linksfolder/migrate_export_w_logs_epm_ugex

    ln -sf $sourcefolder/$file_migrate_export_epm $workingroot/migrate_export_epm_ugex
    ln -sf $sourcefolder/$file_migrate_export_w_logs_epm $workingroot/migrate_export_w_logs_epm_ugex

fi


# =============================================================================
# =============================================================================
# FOLDER:  UserConfig
# =============================================================================


export workingdir=UserConfig
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_add_allias_all=add_alias_commands.all.v02.01.00.sh

ln -sf $sourcefolder/$file_add_allias_all $linksfolder/add_alias_commands
ln -sf $sourcefolder/$file_add_allias_all $workingroot/add_alias_commands

ln -sf $sourcefolder/$file_add_allias_all $linksfolder/add_alias_commands.all


# =============================================================================
# =============================================================================
# FOLDER:  
# =============================================================================

# =============================================================================
# =============================================================================

# =============================================================================
# =============================================================================

echo | tee -a -i $logfilepath
echo 'List folder : '$workingroot | tee -a -i $logfilepath
ls -alh $workingroot | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'List folder : '$workingbase | tee -a -i $logfilepath
ls -alh $workingbase | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'List folder : '$linksbase | tee -a -i $logfilepath
ls -alh $linksbase | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Done with links generation!' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

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

echo
echo 'List folder : '$outputpathbase
ls -alh $outputpathbase
echo
echo 'Output location for all results is here : '$outputpathbase
echo 'Log results documented in this log file : '$logfilepath
echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


