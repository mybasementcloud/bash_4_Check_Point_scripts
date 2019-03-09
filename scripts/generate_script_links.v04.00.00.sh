#!/bin/bash
#
# SCRIPT Configure script link files and copy versioned scripts to generics
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-03-08
ScriptVersion=04.00.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.00.00
SubScriptsLevel=006
SubScriptsVersion=04.00.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}
export BASHScriptName="generate_script_links.v$ScriptVersion"
export BASHScriptShortName="generate_links"
export BASHScriptDescription="Generate Script Links"

export BASHScriptHelpFile="$BASHScriptName.help"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig
export BASHScriptsFolder=.


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

export scriptspathroot=/var/log/__customer/upgrade_export/scripts
export subscriptsfolder=_sub-scripts

export rootscriptconfigfile=__root_script_config.sh


# -------------------------------------------------------------------------------------------------
# Script Operations Control variable configuration
# -------------------------------------------------------------------------------------------------

export WAITTIME=60

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


# Configure basic information for formation of file path for command line parameter handler script
#
# cli_script_cmdlineparm_handler_root - root path to command line parameter handler script
# cli_script_cmdlineparm_handler_folder - folder for under root path to command line parameter handler script
# cli_script_cmdlineparm_handler_file - filename, without path, for command line parameter handler script
#
export cli_script_cmdlineparm_handler_root=$scriptspathroot
export cli_script_cmdlineparm_handler_folder=$subscriptsfolder
export cli_script_cmdlineparm_handler_file=cmd_line_parameters_handler.sub-script.$SubScriptsLevel.v$SubScriptsVersion.sh


# Configure basic information for formation of file path for configure script output paths and folders handler script
#
# script_output_paths_and_folders_handler_root - root path to configure script output paths and folders handler script
# script_output_paths_and_folders_handler_folder - folder for under root path to configure script output paths and folders handler script
# script_output_paths_and_folders_handler_file - filename, without path, for configure script output paths and folders handler script
#
export script_output_paths_and_folders_handler_root=$scriptspathroot
export script_output_paths_and_folders_handler_folder=$subscriptsfolder
export script_output_paths_and_folders_handler_file=script_output_paths_and_folders.sub-script.$SubScriptsLevel.v$SubScriptsVersion.sh


# Configure basic information for formation of file path for gaia version and type handler script
#
# gaia_version_type_handler_root - root path to gaia version and type handler script
# gaia_version_type_handler_folder - folder for under root path to gaia version and type handler script
# gaia_version_type_handler_file - filename, without path, for gaia version and type handler script
#
export gaia_version_type_handler_root=$scriptspathroot
export gaia_version_type_handler_folder=$subscriptsfolder
export gaia_version_type_handler_file=gaia_version_installation_type.sub-script.$SubScriptsLevel.v$SubScriptsVersion.sh


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# MODIFIED 2019-01-30 -

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

# MODIFIED 2019-03-08 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2019-03-08


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

# MODIFIED 2019-01-31 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

#CheckAndUnlockGaiaDB


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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-22

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
echo $BASHScriptDescription', script version '$ScriptVersion', revision '$ScriptRevision' from '$ScriptDate | tee -a -i $logfilepath
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

file_common_001=determine_gaia_version_and_installation_type.v04.00.00.sh
file_common_002=do_script_nohup.v04.00.00.sh

file_common_003=go_dump_folder_now.v04.00.00.sh
file_common_004=go_dump_folder_now_dtg.v04.00.00.sh
file_common_005=go_change_log_folder_now_dtg.v04.00.00.sh

file_common_006=make_dump_folder_now.v04.00.00.sh
file_common_007=make_dump_folder_now_dtg.v04.00.00.sh

ln -sf $sourcefolder/$file_common_001 $linksfolder/gaia_version_type
ln -sf $sourcefolder/$file_common_001 $workingroot/gaia_version_type

ln -sf $sourcefolder/$file_common_002 $linksfolder/do_script_nohup
ln -sf $sourcefolder/$file_common_002 $workingroot/do_script_nohup

ln -sf $sourcefolder/$file_common_003 $linksfolder/godump
ln -sf $sourcefolder/$file_common_003 $workingroot/godump
ln -sf $sourcefolder/$file_common_004 $linksfolder/godtgdump
ln -sf $sourcefolder/$file_common_004 $workingroot/godtgdump

ln -sf $sourcefolder/$file_common_005 $linksfolder/goChangeLog
ln -sf $sourcefolder/$file_common_005 $workingroot/goChangeLog

ln -sf $sourcefolder/$file_common_006 $linksfolder/mkdump
ln -sf $sourcefolder/$file_common_006 $workingroot/mkdump
ln -sf $sourcefolder/$file_common_007 $linksfolder/mkdtgdump
ln -sf $sourcefolder/$file_common_007 $workingroot/mkdtgdump


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

file_config_001=config_capture.006.v04.00.00.sh
file_config_002=show_interface_information.v04.00.00.sh

ln -sf $sourcefolder/$file_config_001 $linksfolder/config_capture
ln -sf $sourcefolder/$file_config_002 $linksfolder/interface_info

ln -sf $sourcefolder/$file_config_001 $workingroot/config_capture
ln -sf $sourcefolder/$file_config_002 $workingroot/interface_info


# =============================================================================
# =============================================================================
# FOLDER:  GAIA
# =============================================================================


export workingdir=GAIA
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder | tee -a -i $logfilepath
    chmod 775 $linksfolder | tee -a -i $logfilepath
else
    chmod 775 $linksfolder | tee -a -i $logfilepath
fi

file_GAIA_001=update_gaia_rest_api.sh
file_GAIA_002=update_gaia_dynamic_cli.sh


ln -sf $sourcefolder/$file_GAIA_001 $linksfolder/update_gaia_rest_api
ln -sf $sourcefolder/$file_GAIA_002 $linksfolder/update_gaia_dynamic_cli

if $IsR8XVersion ; then
    
    ln -sf $sourcefolder/$file_GAIA_001 $workingroot/update_gaia_rest_api
    ln -sf $sourcefolder/$file_GAIA_002 $workingroot/update_gaia_dynamic_cli
    
fi


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

file_GW_001=watch_accel_stats.v04.00.00.sh
file_GW_002=set_informative_logging_implied_rules_on_R8x.v04.00.00.sh
file_GW_003=reset_hit_count_with_backup.v04.00.00.sh
file_GW_004=show_clusterXL_information.v04.00.00.sh
file_GW_005=watch_cluster_status.v04.00.00.sh


ln -sf $sourcefolder/$file_GW_001 $linksfolder/watch_accel_stats
ln -sf $sourcefolder/$file_GW_002 $linksfolder/set_informative_logging_implied_rules_on_R8x
ln -sf $sourcefolder/$file_GW_003 $linksfolder/reset_hit_count_with_backup
ln -sf $sourcefolder/$file_GW_004 $linksfolder/cluster_info
ln -sf $sourcefolder/$file_GW_005 $linksfolder/watch_cluster_status


if [ "$sys_type_GW" == "true" ]; then
    
    ln -sf $sourcefolder/$file_GW_001 $workingroot/watch_accel_stats
    ln -sf $sourcefolder/$file_GW_002 $workingroot/set_informative_logging_implied_rules_on_R8x
    ln -sf $sourcefolder/$file_GW_003 $workingroot/reset_hit_count_with_backup
    
    if [[ $(cpconfig <<< 10 | grep cluster) == *"Disable"* ]]; then
        # is a cluster
        ln -sf $sourcefolder/$file_GW_004 $workingroot/cluster_info
        ln -sf $sourcefolder/$file_GW_005 $workingroot/watch_cluster_status
    fi
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


file_healthcheck_001=healthcheck.sh
file_healthcheck_002=run_healthcheck_to_dump_dtg.v04.00.00.sh
file_healthcheck_003=check_status_checkpoint_services.v04.00.00.sh

ln -sf $sourcefolder/$file_healthcheck_001 $linksfolder/healthcheck
ln -sf $sourcefolder/$file_healthcheck_001 $workingroot/healthcheck
ln -sf $sourcefolder/$file_healthcheck_002 $linksfolder/healthdump
ln -sf $sourcefolder/$file_healthcheck_002 $workingroot/healthdump
ln -sf $sourcefolder/$file_healthcheck_003 $linksfolder/checkpoint_service_status_check
ln -sf $sourcefolder/$file_healthcheck_003 $workingroot/checkpoint_service_status_check


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

file_MDM_001=backup_mds_ugex.v04.00.00.sh
file_MDM_002=backup_mds_w_logs_ugex.v04.00.00.sh

file_MDM_003=report_mdsstat.v04.00.00.sh
file_MDM_004=watch_mdsstat.v04.00.00.sh
file_MDM_005=show_all_domains_in_array.v04.00.00.sh

ln -sf $sourcefolder/$file_MDM_001 $linksfolder/backup_mds_ugex
ln -sf $sourcefolder/$file_MDM_002 $linksfolder/backup_mds_w_logs_ugex
ln -sf $sourcefolder/$file_MDM_003 $linksfolder/report_mdsstat
ln -sf $sourcefolder/$file_MDM_004 $linksfolder/watch_mdsstat
ln -sf $sourcefolder/$file_MDM_005 $linksfolder/show_domains_in_array

if [ "$sys_type_MDS" == "true" ]; then
    
    ln -sf $sourcefolder/$file_MDM_001 $workingroot/backup_mds_ugex
    ln -sf $sourcefolder/$file_MDM_002 $workingroot/backup_mds_w_logs_ugex
    ln -sf $sourcefolder/$file_MDM_003 $workingroot/report_mdsstat
    ln -sf $sourcefolder/$file_MDM_004 $workingroot/watch_mdsstat
    ln -sf $sourcefolder/$file_MDM_005 $workingroot/show_domains_in_array
    
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

file_patch_001=fix_gaia_webui_login_dot_js.sh
file_patch_002=fix_gaia_webui_login_dot_js_generic.sh

export need_fix_webui=false

if $IsR8XVersion ; then
    export need_fix_webui=false
else
    export need_fix_webui=true
fi

if [ "$need_fix_webui" == "true" ]; then
    
    ln -sf $sourcefolder/$file_patch_001 $linksfolder/fix_gaia_webui_login_dot_js
    ln -sf $sourcefolder/$file_patch_001 $workingroot/fix_gaia_webui_login_dot_js
    
    ln -sf $sourcefolder/$file_patch_002 $linksfolder/fix_gaia_webui_login_dot_js_generic

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

file_SESSION_001=remove_zerolocks_sessions.v03.00.00.sh
file_SESSION_002=remove_zerolocks_web_api_sessions.v03.00.00.sh
file_SESSION_003=show_zerolocks_sessions.v03.00.00.sh
file_SESSION_004=show_zerolocks_web_api_sessions.v03.00.00.sh

export do_session_cleanup=false

if $IsR8XVersion ; then
    export do_session_cleanup=true
else
    export do_session_cleanup=false
fi

if [ "$do_session_cleanup" == "true" ]; then
    
    ln -sf $sourcefolder/$file_SESSION_001 $linksfolder/remove_zerolocks_sessions
    ln -sf $sourcefolder/$file_SESSION_002 $linksfolder/remove_zerolocks_web_api_sessions
    ln -sf $sourcefolder/$file_SESSION_003 $linksfolder/show_zerolocks_sessions
    ln -sf $sourcefolder/$file_SESSION_004 $linksfolder/show_zerolocks_web_api_sessions

    if [ "$sys_type_GW" == "false" ]; then
        
        ln -sf $sourcefolder/$file_SESSION_001 $workingroot/remove_zerolocks_sessions
        ln -sf $sourcefolder/$file_SESSION_002 $workingroot/remove_zerolocks_web_api_sessions
        ln -sf $sourcefolder/$file_SESSION_003 $workingroot/show_zerolocks_sessions
        ln -sf $sourcefolder/$file_SESSION_004 $workingroot/show_zerolocks_web_api_sessions
            
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

file_SMEV_001=SmartEvent_Backup_R8X.v04.00.00.sh
file_SMEV_002=SmartEvent_Restore_R8X.v04.00.0X-NR.sh
file_SMEV_003=Reset_SmartLog_Indexing_Back_X_Days.v04.00.00.sh
file_SMEV_004=NUKE_ALL_LOGS_AND_INDEXES.v04.00.00.sh

ln -sf $sourcefolder/$file_SMEV_001 $linksfolder/SmartEvent_backup
ln -sf $sourcefolder/$file_SMEV_002 $linksfolder/SmartEvent_restore
ln -sf $sourcefolder/$file_SMEV_003 $linksfolder/Reset_SmartLog_Indexing
ln -sf $sourcefolder/$file_SMEV_004 $linksfolder/SmartEvent_NUKE_Index_and_Logs

if [ "$sys_type_SmartEvent" == "true" ]; then
    
    ln -sf $sourcefolder/$file_SMEV_001 $workingroot/SmartEvent_backup
    #ln -sf $sourcefolder/$file_SMEV_002 $workingroot/SmartEvent_restore
    #ln -sf $sourcefolder/$file_SMEV_003 $workingroot/Reset_SmartLog_Indexing
    #ln -sf $sourcefolder/$file_SMEV_004 $workingroot/SmartEvent_NUKE_Index_and_Logs
    
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

file_SMS_001=migrate_export_npm_ugex.v04.00.00.sh
file_SMS_002=migrate_export_w_logs_npm_ugex.v04.00.00.sh

file_SMS_007=migrate_export_epm_ugex.v04.00.00.sh
file_SMS_008=migrate_export_w_logs_epm_ugex.v04.00.00.sh

file_SMS_003=restart_mgmt.v04.00.00.sh
file_SMS_004=report_cpwd_admin_list.v04.00.00.sh
file_SMS_005=watch_cpwd_admin_list.v04.00.00.sh

file_SMS_006=reset_hit_count_on_R80_SMS_commands.001.v00.01.00.sh

ln -sf $sourcefolder/$file_SMS_001 $linksfolder/migrate_export_npm_ugex
ln -sf $sourcefolder/$file_SMS_002 $linksfolder/migrate_export_w_logs_npm_ugex
ln -sf $sourcefolder/$file_SMS_003 $linksfolder/restart_mgmt
ln -sf $sourcefolder/$file_SMS_004 $linksfolder/report_cpwd_admin_list
ln -sf $sourcefolder/$file_SMS_005 $linksfolder/watch_cpwd_admin_list

ln -sf $sourcefolder/$file_SMS_006 $linksfolder/reset_hit_count_on_R80_SMS_commands

ln -sf $sourcefolder/$file_SMS_004 $workingroot/report_cpwd_admin_list

if [ "$sys_type_SMS" == "true" ]; then
    
    ln -sf $sourcefolder/$file_SMS_001 $workingroot/migrate_export_npm_ugex
    ln -sf $sourcefolder/$file_SMS_002 $workingroot/migrate_export_w_logs_npm_ugex
    ln -sf $sourcefolder/$file_SMS_003 $workingroot/restart_mgmt
    ln -sf $sourcefolder/$file_SMS_005 $workingroot/watch_cpwd_admin_list
    
    ln -sf $sourcefolder/$file_SMS_006 $workingroot/reset_hit_count_on_R80_SMS_commands
    
fi

if [ $Check4EPM -gt 0 ]; then

    ln -sf $sourcefolder/$file_SMS_007 $linksfolder/migrate_export_epm_ugex
    ln -sf $sourcefolder/$file_SMS_008 $linksfolder/migrate_export_w_logs_epm_ugex

    ln -sf $sourcefolder/$file_SMS_007 $workingroot/migrate_export_epm_ugex
    ln -sf $sourcefolder/$file_SMS_008 $workingroot/migrate_export_w_logs_epm_ugex

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

file_USERCONF_001=add_alias_commands.all.v04.00.00.sh
file_USERCONF_002=update_alias_commands.all.v04.00.00.sh
file_USERCONF_003=update_alias_commands_all_users.all.v04.00.00.sh

ln -sf $sourcefolder/$file_USERCONF_001 $linksfolder/add_alias_commands
ln -sf $sourcefolder/$file_USERCONF_001 $workingroot/add_alias_commands

ln -sf $sourcefolder/$file_USERCONF_002 $linksfolder/update_alias_commands
ln -sf $sourcefolder/$file_USERCONF_002 $workingroot/update_alias_commands

ln -sf $sourcefolder/$file_USERCONF_003 $linksfolder/update_alias_commands_all_users
ln -sf $sourcefolder/$file_USERCONF_003 $workingroot/update_alias_commands_all_users


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


