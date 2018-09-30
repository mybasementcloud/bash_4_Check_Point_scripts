#!/bin/bash
#
# SCRIPT Configure script link files and copy versioned scripts to generics
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptTemplateLevel=004
ScriptVersion=01.20.00
ScriptDate=2018-09-29
#

export BASHScriptVersion=v01x20x00
export BASHScriptTemplateLevel=$ScriptTemplateLevel
export BASHScriptName="generate_script_links.v$ScriptVersion"
export BASHScriptShortName="generate_links"
export BASHScriptDescription="Generate Script Links"


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
export rootscriptconfigfile=__root_script_config.sh


# Configure basic information for formation of file path for command line parameter handler script
#
# cli_script_cmdlineparm_handler_root - root path to command line parameter handler script
# cli_script_cmdlineparm_handler_folder - folder for under root path to command line parameter handler script
# cli_script_cmdlineparm_handler_file - filename, without path, for command line parameter handler script
#
export cli_script_cmdlineparm_handler_root=$scriptspathroot
export cli_script_cmdlineparm_handler_folder=_sub-scripts
export cli_script_cmdlineparm_handler_file=cmd_line_parameters_handler.sub-script.$ScriptTemplateLevel.v01.00.00.sh


# -------------------------------------------------------------------------------------------------
# END:  Root Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# =================================================================================================
# START:  Command Line Parameter Handling and Help
# =================================================================================================

# MODIFIED 2018-09-29 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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

export REMAINS=

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-09-29

# =================================================================================================
# -------------------------------------------------------------------------------------------------
# START:  Local Help display proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# Show local help information.  Add script specific information here to show when help requested

doshowlocalhelp () {
    #
    # Screen width template for sizing, default width of 80 characters assumed
    #
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    echo
    echo 'Local Help Information : '

    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    echo
    
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

    echo
    return 1
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-09-29

# -------------------------------------------------------------------------------------------------
# END:  Local Help display proceedure
# -------------------------------------------------------------------------------------------------
# =================================================================================================

# -------------------------------------------------------------------------------------------------
# CommandLineParameterHandler - Command Line Parameter Handler calling routine
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CommandLineParameterHandler () {
    #
    # CommandLineParameterHandler - Command Line Parameter Handler calling routine
    #
    
    echo | tee -a -i $logfilepath
    echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "Calling external Command Line Paramenter Handling Script" | tee -a -i $logfilepath
    echo " - External Script : "$cli_script_cmdlineparm_handler | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    . $cli_script_cmdlineparm_handler "$@"
    
    echo | tee -a -i $logfilepath
    echo "Returned from external Command Line Paramenter Handling Script" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    if [ "$SCRIPTVERBOSE" = "true" ] && [ "$NOWAIT" != "true" ] ; then
        echo
        read -t $WAITTIME -n 1 -p "Any key to continue.  Automatic continue after $WAITTIME seconds : " anykey
    fi
    
    echo | tee -a -i $logfilepath
    echo "Starting local execution" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo '--------------------------------------------------------------------------' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-29

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Call command line parameter handler action script
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 -

export cli_script_cmdlineparm_handler_path=$cli_script_cmdlineparm_handler_root/$cli_script_cmdlineparm_handler_folder

export cli_script_cmdlineparm_handler=$cli_script_cmdlineparm_handler_path/$cli_script_cmdlineparm_handler_file

# Check that we can finde the command line parameter handler file
#
if [ ! -r $cli_script_cmdlineparm_handler ] ; then
    # no file found, that is a problem
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

    exit 251
fi

# MODIFIED 2018-09-29 -

CommandLineParameterHandler "$@"


# -------------------------------------------------------------------------------------------------
# Local Handle request for help and return
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# Was help requested, if so show local content and return
#
if [ x"$SHOWHELP" = x"true" ] ; then
    # Show Local Help
    doshowlocalhelp "$@"
    exit 255 
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-09-29

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
# localrootscriptconfiguration - Local Root Script Configuration setup
# -------------------------------------------------------------------------------------------------

localrootscriptconfiguration () {
    #
    # Local Root Script Configuration setup
    #

    # WAITTIME in seconds for read -t commands
    export WAITTIME=60
    
    export customerpathroot=/var/log/__customer
    export customerworkpathroot=$customerpathroot/upgrade_export
    export outputpathroot=$customerworkpathroot
    export dumppathroot=$outputpathroot/dump
    export changelogpathroot=$customerworkpathroot/Change_Log
    
    echo
    return 0
}


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# HandleRootScriptConfiguration - Root Script Configuration
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

HandleRootScriptConfiguration () {
    #
    # Root Script Configuration
    #
    
    # -------------------------------------------------------------------------------------------------
    # START: Root Script Configuration
    # -------------------------------------------------------------------------------------------------
    
    if [ -r "$scriptspathroot/$rootscriptconfigfile" ] ; then
        # Found the Root Script Configuration File in the folder for scripts
        # So let's call that script to configure what we need
    
        . $scriptspathroot/$rootscriptconfigfile "$@"
        errorreturn=$?
    elif [ -r "../$rootscriptconfigfile" ] ; then
        # Found the Root Script Configuration File in the folder above the executiong script
        # So let's call that script to configure what we need
    
        . ../$rootscriptconfigfile "$@"
        errorreturn=$?
    elif [ -r "$rootscriptconfigfile" ] ; then
        # Found the Root Script Configuration File in the folder with the executiong script
        # So let's call that script to configure what we need
    
        . $rootscriptconfigfile "$@"
        errorreturn=$?
    else
        # Did not the Root Script Configuration File
        # So let's call local configuration
    
        localrootscriptconfiguration "$@"
        errorreturn=$?
    fi
    
    # -------------------------------------------------------------------------------------------------
    # END:  Root Script Configuration
    # -------------------------------------------------------------------------------------------------
    
    return $errorreturn
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-29

# -------------------------------------------------------------------------------------------------
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
    elif [ -r /opt/CPshrd-R80/jq/jq ] ; then
        export JQ=/opt/CPshrd-R80/jq/jq
    else
        echo "Missing jq, not found in ${CPDIR}/jq/jq or /opt/CPshrd-R80/jq/jq" | tee -a -i $logfilepath
        echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo "Log output in file $APICLIlogfilepath" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        exit 1
    fi
    
    echo
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-22

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# HandleLaunchInHomeFolder - Handle if folder where this was launched is the $HOME Folder
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-22 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

HandleLaunchInHomeFolder () {
    #
    # Handle if folder where this was launched is the $HOME Folder
    #
    
    export expandedpath=$(cd $startpathroot ; pwd)
    export startpathroot=$expandedpath
    export checkthispath=`echo "${expandedpath}" | grep -i "$notthispath"`
    export isitthispath=`test -z $checkthispath; echo $?`
    
    if [ $isitthispath -eq 1 ] ; then
        #Oh, Oh, we're in the home directory executing, not good!!!
        #Configure outputpathroot for $alternatepathroot folder since we can't run in /home/
        export outputpathroot=$alternatepathroot
    else
        #OK use the current folder and create working sub-folder
        export outputpathroot=$startpathroot
    fi
    
    if [ ! -r $outputpathroot ] ; then
        #not where we're expecting to be, since $outputpathroot is missing here
        #maybe this hasn't been run here yet.
        #OK, so make the expected folder and set permissions we need
        mkdir $outputpathroot
        chmod 775 $outputpathroot
    else
        #set permissions we need
        chmod 775 $outputpathroot
    fi
    
    #Now that outputroot is not in /home/ let's work on where we are working from
    
    export expandedpath=$(cd $outputpathroot ; pwd)
    export outputpathroot=${expandedpath}
    export dumppathroot=$outputpathroot/dump
    export changelogpathroot=$outputpathroot/Change_Log
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-22

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# ShowFinalOutputAndLogPaths - repeated proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29D -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

ShowFinalOutputAndLogPaths () {
    #
    # repeated procedure description
    #

    #----------------------------------------------------------------------------------------
    # Output and Log file and folder Information
    #----------------------------------------------------------------------------------------
    
    echo | tee -a -i $logfilepath

    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
        # Verbose mode ON
        
        echo "Controls : " | tee -a -i $logfilepath
        echo ' $OutputToRoot              : '"$OutputToRoot" | tee -a -i $logfilepath
        echo ' $OutputToDump              : '"$OutputToDump" | tee -a -i $logfilepath
        echo ' $OutputToChangeLog         : '"$OutputToChangeLog" | tee -a -i $logfilepath
        echo ' $OutputToOther             : '"$OutputToOther" | tee -a -i $logfilepath
        echo ' $OtherOutputFolder         : '"$OtherOutputFolder" | tee -a -i $logfilepath
        echo ' $OutputDTGSSubfolder       : '"$OutputDTGSSubfolder" | tee -a -i $logfilepath
        echo ' $OutputSubfolderScriptName : '"$OutputSubfolderScriptName" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        echo "Output and Log file, folder locations: " | tee -a -i $logfilepath
        echo ' $customerpathroot     : '"$customerpathroot" | tee -a -i $logfilepath
        echo ' $customerworkpathroot : '"$customerworkpathroot" | tee -a -i $logfilepath
        echo ' $dumppathroot         : '"$dumppathroot" | tee -a -i $logfilepath
        echo ' $changelogpathroot    : '"$changelogpathroot" | tee -a -i $logfilepath
        echo ' $outputpathroot       : '"$outputpathroot" | tee -a -i $logfilepath
        echo ' $outputpathbase       : '"$outputpathbase" | tee -a -i $logfilepath
        echo ' $logfilepath          : '"$logfilepath" | tee -a -i $logfilepath
        echo ' $logfilepathfinal     : '"$logfilepathfinal" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        read -t $WAITTIME -n 1 -p "Any key to continue : " anykey
        echo
        
    else
        # Verbose mode OFF
        
        echo "Output and Log file, folder locations: " | tee -a -i $logfilepath
        echo ' $outputpathbase       : '"$outputpathbase" | tee -a -i $logfilepath
        echo ' $logfilepath          : '"$logfilepath" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
    
        
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-29

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# FinalizeOutputAndLogPaths - Finalize Output and Log Paths
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

FinalizeOutputAndLogPaths () {
    #
    # Finalize Output and Log Paths
    #
    
    #----------------------------------------------------------------------------------------
    # Set Output file paths
    #----------------------------------------------------------------------------------------
    
    if [ -z "$CLIparm_outputpath" ]; then
        # CLI parameter for outputpath not set

        if $OutputToRoot ; then
            # output to outputpathroot
            export outputpathbase=$outputpathroot
            echo | tee -a -i $logfilepath
            echo 'Set root output to Root : '"$outputpathroot"', $outputpathbase = '"$outputpathbase" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        elif $OutputToDump ; then
            # output to dump folder
            export outputpathbase=$dumppathroot
            echo | tee -a -i $logfilepath
            echo 'Set root output to Dump : '"$dumppathroot"', $outputpathbase = '"$outputpathbase" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        elif $OutputToChangeLog ; then
            # output to Change Log
            export outputpathbase=$changelogpathroot
            echo | tee -a -i $logfilepath
            echo 'Set root output to Change Log : '"$changelogpathroot"', $outputpathbase = '"$outputpathbase" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        elif $OutputToOther ; then
            # output to other folder that should be set in $OtherOutputFolder
            #export outputpathbase=$OtherOutputFolder
        
            # need to expand this other path to ensure things work
            export expandedpath=$(cd $OtherOutputFolder ; pwd)
            export outputpathbase=$expandedpath
        
            echo | tee -a -i $logfilepath
            echo 'Set root output to Other : '"$OtherOutputFolder"', $outputpathbase = '"$outputpathbase" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        else
            # Huh, what... this should have been set, well the use dump
            # output to dumppathroot
            export outputpathbase=$dumppathroot
            echo | tee -a -i $logfilepath
            echo 'Set root output to default Dump : '"$dumppathroot"', $outputpathbase = '"$outputpathbase" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        fi
        
        # Now that we know where things are going, let's make sure we can write there
        #
        if [ ! -r $outputpathroot ] ; then
            mkdir $outputpathroot | tee -a -i $logfilepath
            chmod 775 $outputpathroot | tee -a -i $logfilepath
        else
            chmod 775 $outputpathroot | tee -a -i $logfilepath
        fi
        
        if [ ! -r $outputpathbase ] ; then
            mkdir $outputpathbase | tee -a -i $logfilepath
            chmod 775 $outputpathbase | tee -a -i $logfilepath
        else
            chmod 775 $outputpathbase | tee -a -i $logfilepath
        fi
        
        if $OutputDTGSSubfolder ; then
            # Use subfolder based on date-time group
            # this shifts the base output folder down a level
            export outputpathbase=$outputpathbase/$DATEDTGS
            
            if $OutputSubfolderScriptName ; then
                # Add script name to the Subfolder name
                export outputpathbase="$outputpathbase.$BASHScriptName"
            elif $OutputSubfolderScriptShortName ; then
                # Add short script name to the Subfolder name
                export outputpathbase="$outputpathbase.$BASHScriptShortName"
            fi
        
            if [ ! -r $outputpathbase ] ; then
                mkdir $outputpathbase | tee -a -i $logfilepath
                chmod 775 $outputpathbase | tee -a -i $logfilepath
            else
                chmod 775 $outputpathbase | tee -a -i $logfilepath
            fi
        fi
    else
        # CLI parameter for outputpath set
        export outputpathroot=$CLIparm_outputpath
        #export outputpathbase=$CLIparm_outputpath
    
        # need to expand this other path to ensure things work
        export expandedpath=$(cd $CLIparm_outputpath ; pwd)
        export outputpathbase=$expandedpath
    fi
    
    export outputhomepath=$outputpathbase
    
    if [ ! -r $outputhomepath ] ; then
        mkdir $outputhomepath | tee -a -i $logfilepath
        chmod 775 $outputhomepath | tee -a -i $logfilepath
    else
        chmod 775 $outputhomepath | tee -a -i $logfilepath
    fi
    
    #----------------------------------------------------------------------------------------
    # Set LogFile Information
    #----------------------------------------------------------------------------------------
    
    # Setup the log file fully qualified path based on final locations
    #
    if [ -z "$CLIparm_logpath" ]; then
        # CLI parameter for logfile not set
        export logfilepathfinal=$outputpathbase/$BASHScriptName.$DATEDTGS.log
    else
        # CLI parameter for logfile set
        #export logfilepathfinal=$CLIparm_logpath
    
        # need to expand this other path to ensure things work
        export expandedpath=$(cd $CLIparm_logpath ; pwd)
        export logfilepathfinal=$expandedpath
    fi
    
    # if we've been logging, move the temporary log to the final path
    #
    if [ -r $logfilepath ]; then
        mv $logfilepath $logfilepathfinal
    fi
    
    # And then set the logfilepath value to the final one
    #
    export logfilepath=$logfilepathfinal
    
    #----------------------------------------------------------------------------------------
    # Done setting output and log paths
    #----------------------------------------------------------------------------------------
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-29

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# GetGaiaVersionAndInstallationType - repeated proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-22 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

GetGaiaVersionAndInstallationType () {
    #
    # repeated procedure description
    #
    
    #----------------------------------------------------------------------------------------
    #----------------------------------------------------------------------------------------
    #
    # Gaia version and installation type identification
    #
    #----------------------------------------------------------------------------------------
    #----------------------------------------------------------------------------------------
    
    export gaiaversionoutputfile=/var/tmp/gaiaversion_$DATEDTGS.txt
    echo > $gaiaversionoutputfile
    
    # -------------------------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------------------------
    # START: Identify Gaia Version and Installation Type Details
    # -------------------------------------------------------------------------------------------------
    

    clish -i -c "lock database override" >> $gaiaversionoutputfile
    clish -i -c "lock database override" >> $gaiaversionoutputfile
    
    export gaiaversion=$(clish -i -c "show version product" | cut -d " " -f 6)
    echo 'Gaia Version : $gaiaversion = '$gaiaversion >> $gaiaversionoutputfile
    echo >> $gaiaversionoutputfile
    
    Check4SMS=0
    Check4EPM=0
    Check4MDS=0
    Check4GW=0
    
    workfile=/var/tmp/cpinfo_ver.txt
    cpinfo -y all > $workfile 2>&1
    Check4EP773003=`grep -c "Endpoint Security Management R77.30.03 " $workfile`
    Check4EP773002=`grep -c "Endpoint Security Management R77.30.02 " $workfile`
    Check4EP773001=`grep -c "Endpoint Security Management R77.30.01 " $workfile`
    Check4EP773000=`grep -c "Endpoint Security Management R77.30 " $workfile`
    Check4EP=`grep -c "Endpoint Security Management" $workfile`
    Check4SMS=`grep -c "Security Management Server" $workfile`
    Check4SMSR80x10=`grep -c "Security Management Server R80.10 " $workfile`
    Check4SMSR80x20=`grep -c "Security Management Server R80.20 " $workfile`
    Check4SMSR80x20xM1=`grep -c "Security Management Server R80.20.M1 " $workfile`
    Check4SMSR80x20xM2=`grep -c "Security Management Server R80.20.M2 " $workfile`
    rm $workfile
    
    if [ "$MDSDIR" != '' ]; then
        Check4MDS=1
    else 
        Check4MDS=0
    fi
    
    if [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
        echo "System is Multi-Domain Management Server!" >> $gaiaversionoutputfile
        Check4GW=0
    elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
        echo "System is Security Management Server!" >> $gaiaversionoutputfile
        Check4SMS=1
        Check4GW=0
    else
        echo "System is a gateway!" >> $gaiaversionoutputfile
        Check4GW=1
    fi
    echo
    
    if [ $Check4SMSR80x10 -gt 0 ]; then
        echo "Security Management Server version R80.10" >> $gaiaversionoutputfile
        export gaiaversion=R80.10
        if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
        	Check4EPM=1
            echo "Endpoint Security Server version R80.10" >> $gaiaversionoutputfile
        else
        	Check4EPM=0
        fi
    elif [ $Check4SMSR80x20 -gt 0 ]; then
        echo "Security Management Server version R80.20" >> $gaiaversionoutputfile
        export gaiaversion=R80.20
        if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
        	Check4EPM=1
            echo "Endpoint Security Server version R80.20" >> $gaiaversionoutputfile
        else
        	Check4EPM=0
        fi
    elif [ $Check4SMSR80x20xM1 -gt 0 ]; then
        echo "Security Management Server version R80.20.M1" >> $gaiaversionoutputfile
        export gaiaversion=R80.20.M1
        if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
        	Check4EPM=1
            echo "Endpoint Security Server version R80.20.M1" >> $gaiaversionoutputfile
        else
        	Check4EPM=0
        fi
    elif [ $Check4SMSR80x20xM2 -gt 0 ]; then
        echo "Security Management Server version R80.20.M2" >> $gaiaversionoutputfile
        export gaiaversion=R80.20.M2
        if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
        	Check4EPM=1
            echo "Endpoint Security Server version R80.20.M2" >> $gaiaversionoutputfile
        else
        	Check4EPM=0
        fi
    elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773003 -gt 0 ]; then
        echo "Endpoint Security Server version R77.30.03" >> $gaiaversionoutputfile
        export gaiaversion=R77.30.03
        Check4EPM=1
    elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773002 -gt 0 ]; then
        echo "Endpoint Security Server version R77.30.02" >> $gaiaversionoutputfile
        export gaiaversion=R77.30.02
        Check4EPM=1
    elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773001 -gt 0 ]; then
        echo "Endpoint Security Server version R77.30.01" >> $gaiaversionoutputfile
        export gaiaversion=R77.30.01
        Check4EPM=1
    elif [ $Check4EP773000 -gt 0 ]; then
        echo "Endpoint Security Server version R77.30" >> $gaiaversionoutputfile
        export gaiaversion=R77.30
        Check4EPM=1
    else
        echo "Not Gaia Endpoint Security Server R77.30" >> $gaiaversionoutputfile
        
        if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
        	Check4EPM=1
        else
        	Check4EPM=0
        fi
        
    fi
    
    echo >> $gaiaversionoutputfile
    echo 'Final $gaiaversion = '$gaiaversion >> $gaiaversionoutputfile
    echo >> $gaiaversionoutputfile
    
    if [ $Check4MDS -eq 1 ]; then
    	echo 'Multi-Domain Management stuff...' >> $gaiaversionoutputfile
    fi
    
    if [ $Check4SMS -eq 1 ]; then
    	echo 'Security Management Server stuff...' >> $gaiaversionoutputfile
    fi
    
    if [ $Check4EPM -eq 1 ]; then
    	echo 'Endpoint Security Management Server stuff...' >> $gaiaversionoutputfile
    fi
    
    if [ $Check4GW -eq 1 ]; then
    	echo 'Gateway stuff...' >> $gaiaversionoutputfile
    fi
    
    #echo
    #export gaia_kernel_version=$(uname -r)
    #if [ "$gaia_kernel_version" == "2.6.18-92cpx86_64" ]; then
    #    echo "OLD Kernel version $gaia_kernel_version" >> $gaiaversionoutputfile
    #elif [ "$gaia_kernel_version" == "3.10.0-514cpx86_64" ]; then
    #    echo "NEW Kernel version $gaia_kernel_version" >> $gaiaversionoutputfile
    #else
    #    echo "Kernel version $gaia_kernel_version" >> $gaiaversionoutputfile
    #fi
    #echo
    
    echo >> $gaiaversionoutputfile
    export gaia_kernel_version=$(uname -r)
    export kernelv2x06=2.6
    export kernelv3x10=3.10
    export checkthiskernel=`echo "${gaia_kernel_version}" | grep -i "$kernelv2x06"`
    export isitoldkernel=`test -z $checkthiskernel; echo $?`
    export checkthiskernel=`echo "${gaia_kernel_version}" | grep -i "$kernelv3x10"`
    export isitnewkernel=`test -z $checkthiskernel; echo $?`
    
    if [ $isitoldkernel -eq 1 ] ; then
        echo "OLD Kernel version $gaia_kernel_version" >> $gaiaversionoutputfile
    elif [ $isitnewkernel -eq 1 ]; then
        echo "NEW Kernel version $gaia_kernel_version" >> $gaiaversionoutputfile
    else
        echo "Kernel version $gaia_kernel_version" >> $gaiaversionoutputfile
    fi
    echo
    
    # Alternative approach from Health Check
    
    sys_type="N/A"
    sys_type_MDS=false
    sys_type_SMS=false
    sys_type_SmartEvent=false
    sys_type_GW=false
    sys_type_STANDALONE=false
    sys_type_VSX=false
    sys_type_UEPM=false
    sys_type_UEPM_EndpointServer=false
    sys_type_UEPM_PolicyServer=false
    
    
    #  System Type
    if [[ $(echo $MDSDIR | grep mds) ]]; then
        sys_type_MDS=true
        sys_type_SMS=false
        sys_type="MDS"
    elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallMgmt 2> /dev/null) == *"1"*  ]]; then
        sys_type_SMS=true
        sys_type_MDS=false
        sys_type="SMS"
    else
        sys_type_SMS=false
        sys_type_MDS=false
    fi
    
    # Updated to correctly identify if SmartEvent is active
    # $CPDIR/bin/cpprod_util RtIsRt -> returns wrong result for MDM
    # $CPDIR/bin/cpprod_util RtIsAnalyzerServer -> returns correct result for MDM
    
    if [[ $($CPDIR/bin/cpprod_util RtIsAnalyzerServer 2> /dev/null) == *"1"*  ]]; then
        sys_type_SmartEvent=true
        sys_type="SmartEvent"
    else
        sys_type_SmartEvent=false
    fi
    
    if [[ $($CPDIR/bin/cpprod_util FwIsVSX 2> /dev/null) == *"1"* ]]; then
    	sys_type_VSX=true
    	sys_type="VSX"
    else
    	sys_type_VSX=false
    fi
    
    if [[ $($CPDIR/bin/cpprod_util FwIsFirewallModule 2> /dev/null) == *"1"*  ]]; then
        sys_type_GW=true
        sys_type="GATEWAY"
    else
        sys_type_GW=false
    fi
    
    if [[ $($CPDIR/bin/cpprod_util FwIsStandAlone 2> /dev/null) == *"1"* ]]; then
        sys_type_STANDALONE=true
        sys_type="STANDALONE"
    else
        sys_type_STANDALONE=false
    fi
    
    if [[ $($CPDIR/bin/cpprod_util UepmIsInstalled 2> /dev/null) == *"1"* ]]; then
    	sys_type_UEPM=true
    	sys_type="UEPM"
    else
    	sys_type_UEPM=false
    fi
    
    if [[ $($CPDIR/bin/cpprod_util UepmIsEps 2> /dev/null) == *"1"* ]]; then
    	sys_type_UEPM_EndpointServer=true
    else
    	sys_type_UEPM_EndpointServer=false
    fi
    
    if [[ $($CPDIR/bin/cpprod_util UepmIsPolicyServer 2> /dev/null) == *"1"* ]]; then
    	sys_type_UEPM_PolicyServer=true
    else
    	sys_type_UEPM_PolicyServer=false
    fi
    
    echo "sys_type = "$sys_type >> $gaiaversionoutputfile
    echo >> $gaiaversionoutputfile
    echo "System Type : SMS                  :"$sys_type_SMS >> $gaiaversionoutputfile
    echo "System Type : MDS                  :"$sys_type_MDS >> $gaiaversionoutputfile
    echo "System Type : SmartEvent           :"$sys_type_SmartEvent >> $gaiaversionoutputfile
    echo "System Type : GATEWAY              :"$sys_type_GW >> $gaiaversionoutputfile
    echo "System Type : STANDALONE           :"$sys_type_STANDALONE >> $gaiaversionoutputfile
    echo "System Type : VSX                  :"$sys_type_VSX >> $gaiaversionoutputfile
    echo "System Type : UEPM                 :"$sys_type_UEPM >> $gaiaversionoutputfile
    echo "System Type : UEPM Endpoint Server :"$sys_type_UEPM_EndpointServer >> $gaiaversionoutputfile
    echo "System Type : UEPM Policy Server   :"$sys_type_UEPM_PolicyServer >> $gaiaversionoutputfile
    echo >> $gaiaversionoutputfile
    
    # -------------------------------------------------------------------------------------------------
    # END: Identify Gaia Version and Installation Type Details
    # -------------------------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------------------------
    
    echo | tee -a -i $gaiaversionoutputfile

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
    else
        # not deleting the file
        echo
    fi

    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-22

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


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
echo 'Date (YYYY-MM-DD) :  '$DATEYMD | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

# -------------------------------------------------------------------------------------------------
# JQ and json related
# -------------------------------------------------------------------------------------------------

if $UseJSONJQ ; then 
    ConfigureJQforJSON
fi


# -------------------------------------------------------------------------------------------------
# Root Script Configuration
# -------------------------------------------------------------------------------------------------

HandleRootScriptConfiguration "$@"


# -------------------------------------------------------------------------------------------------
# END:  Root Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Setup Basic Parameters
#----------------------------------------------------------------------------------------

export alternatepathroot=$customerworkpathroot

HandleLaunchInHomeFolder "$@"

FinalizeOutputAndLogPaths "$@"

ShowFinalOutputAndLogPaths "$@"


#----------------------------------------------------------------------------------------
# Gaia version and installation type identification
#----------------------------------------------------------------------------------------

if $UseGaiaVersionAndInstallation ; then
    GetGaiaVersionAndInstallationType "$@"
fi

# -------------------------------------------------------------------------------------------------
# Validate we are working on a system that handles this operation
# -------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# shell meat
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

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
    echo
    echo Error!
    echo Missing folder $workingbase
    echo
    echo Exiting!
    echo
    exit 255
else
    chmod 775 $workingbase
fi


if [ ! -r $linksbase ] ; then
    mkdir $linksbase
    chmod 775 $linksbase
else
    chmod 775 $linksbase
fi


# =============================================================================
# =============================================================================
# FOLDER:  Common
# =============================================================================


export workingdir=Common
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_gaia_version=determine_gaia_version_and_installation_type.v01.09.00.sh

file_godump=go_dump_folder_now.v00.04.00.sh
file_mkdump=make_dump_folder_now.v00.04.00.sh
file_godumpdtg=go_dump_folder_now_dtg.v00.04.00.sh
file_mkdumpdtg=make_dump_folder_now_dtg.v00.04.00.sh
file_goChgLogdtg=go_change_log_folder_now_dtg.v00.04.00.sh

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
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_configcapture=config_capture_005_v01.18.00.sh
file_interface_info=show_interface_information_v01.04.00.sh

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
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_watch_accel_stats=watch_accel_stats.v00.01.00.sh
file_set_inf_log_implied=set_informative_logging_implied_rules_on_R8x.v00.03.00.sh
file_reset_hitcount_w_bu=reset_hit_count_with_backup_001_v00.03.00.sh


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
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi


file_healthcheck=healthcheck.sh
file_healthdump=run_healthcheck_to_dump_dtg.v01.04.00.sh
file_cpservicecheck=check_status_checkpoint_services.v01.00.00.sh

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
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_backup_mds=backup_mds_ugex_001_v00.10.00.sh
file_backup_w_logs_mds=backup_w_logs_mds_ugex_001_v00.10.00.sh
file_report_mdsstat=report_mdsstat.v00.08.00.sh
file_watch_mdsstat=watch_mdsstat.v00.07.00.sh
file_show_domains_in_array=show_all_domains_in_array.v00.04.00.sh

ln -sf $sourcefolder/$file_backup_mds $linksfolder/backup_mds_ugex
ln -sf $sourcefolder/$file_backup_w_logs_mds $linksfolder/backup_w_logs_mds_ugex
ln -sf $sourcefolder/$file_report_mdsstat $linksfolder/report_mdsstat
ln -sf $sourcefolder/$file_watch_mdsstat $linksfolder/watch_mdsstat
ln -sf $sourcefolder/$file_show_domains_in_array $linksfolder/show_domains_in_array

if [ "$sys_type_MDS" == "true" ]; then
    
    ln -sf $sourcefolder/$file_backup_mds $workingroot/backup_mds_ugex
    ln -sf $sourcefolder/$file_backup_w_logs_mds $workingroot/backup_w_logs_mds_ugex
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
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
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
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_rem_zl_sessions=remove_zerolocks_sessions.v00.05.00.sh
file_rem_zl_sessions_webapi=remove_zerolocks_web_api_sessions.v00.05.00.sh
file_mdm_rem_zl_sessions=mdm_remove_zerolocks_sessions.v00.05.00.sh
file_mdm_rem_zl_sessions_webapi=mdm_remove_zerolocks_web_api_sessions.v00.05.00.sh

file_show_zl_sessions=show_zerolocks_sessions.v00.05.00.sh
file_show_zl_sessions_webapi=show_zerolocks_web_api_sessions.v00.05.00.sh
file_mdm_show_zl_sessions=mdm_show_zerolocks_sessions.v00.05.00.sh
file_mdm_show_zl_sessions_webapi=mdm_show_zerolocks_web_api_sessions.v00.05.00.sh

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

    ln -sf $sourcefolder/$file_mdm_show_zl_sessions $linksfolder/mdm_show_zerolocks_sessions
    ln -sf $sourcefolder/$file_mdm_show_zl_sessions_webapi $linksfolder/mdm_show_zerolocks_web_api_sessions
    ln -sf $sourcefolder/$file_mdm_rem_zl_sessions $linksfolder/mdm_remove_zerolocks_sessions
    ln -sf $sourcefolder/$file_mdm_rem_zl_sessions_webapi $linksfolder/mdm_remove_zerolocks_web_api_sessions
    
    if [ "$sys_type_GW" == "false" ]; then
        
        if [ "$sys_type_MDS" == "true" ]; then
            
            ln -sf $sourcefolder/$file_mdm_show_zl_sessions $workingroot/mdm_show_zerolocks_sessions
            ln -sf $sourcefolder/$file_mdm_show_zl_sessions_webapi $workingroot/mdm_show_zerolocks_web_api_sessions
            ln -sf $sourcefolder/$file_mdm_rem_zl_sessions $workingroot/mdm_remove_zerolocks_sessions
            ln -sf $sourcefolder/$file_mdm_rem_zl_sessions_webapi $workingroot/mdm_remove_zerolocks_web_api_sessions
            
        else
            
            ln -sf $sourcefolder/$file_show_zl_sessions $workingroot/show_zerolocks_sessions
            ln -sf $sourcefolder/$file_show_zl_sessions_webapi $workingroot/show_zerolocks_web_api_sessions
            ln -sf $sourcefolder/$file_rem_zl_sessions $workingroot/remove_zerolocks_sessions
            ln -sf $sourcefolder/$file_rem_zl_sessions_webapi $workingroot/remove_zerolocks_web_api_sessions
            
        fi
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
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_smev_backup=SmartEvent_Backup_R8X_v00.04.00.sh
file_smev_restore=SmartEvent_Restore_R8X_v00.00.06.sh

ln -sf $sourcefolder/$file_smev_backup $linksfolder/SmartEvent_backup
ln -sf $sourcefolder/$file_smev_restore $linksfolder/SmartEvent_restore

if [ "$sys_type_SmartEvent" == "true" ]; then
    
    ln -sf $sourcefolder/$file_smev_backup $workingroot/SmartEvent_backup
    #ln -sf $sourcefolder/$file_smev_restore $workingroot/SmartEvent_restore
    
fi


# =============================================================================
# =============================================================================
# FOLDER:  SMS
# =============================================================================


export workingdir=SMS
export sourcefolder=$workingbase/$workingdir
export linksfolder=$linksbase/$workingdir
if [ ! -r $linksfolder ] ; then
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_migrate_export_npm=migrate_export_npm_ugex_001_v00.14.00.sh
file_migrate_export_w_logs_npm=migrate_export_w_logs_npm_ugex_001_v00.14.00.sh
file_migrate_export_epm=migrate_export_epm_ugex_001_v00.14.00.sh
file_migrate_export_w_logs_epm=migrate_export_w_logs_epm_ugex_001_v00.14.00.sh
file_mgmt_report=report_cpwd_admin_list.v00.08.00.sh
file_mgmt_restart=restart_mgmt.v00.09.00.sh
file_mgmt_watch=watch_cpwd_admin_list.v00.05.00.sh
file_reset_hitcount_sms=reset_hit_count_on_R80_SMS_commands_001_v00.01.00.sh

ln -sf $sourcefolder/$file_migrate_export_npm $linksfolder/migrate_export_npm_ugex
ln -sf $sourcefolder/$file_migrate_export_w_logs_npm $linksfolder/migrate_export_w_logs_npm_ugex
ln -sf $sourcefolder/$file_mgmt_restart $linksfolder/restart_mgmt
ln -sf $sourcefolder/$file_mgmt_report $linksfolder/report_cpwd_admin_list
ln -sf $sourcefolder/$file_mgmt_watch $linksfolder/watch_cpwd_admin_list

ln -sf $sourcefolder/$file_reset_hitcount_sms $linksfolder/reset_hit_count_on_R80_SMS_commands

if [ "$sys_type_SMS" == "true" ]; then
    
    ln -sf $sourcefolder/$file_migrate_export_npm $workingroot/migrate_export_npm_ugex
    ln -sf $sourcefolder/$file_migrate_export_w_logs_npm $workingroot/migrate_export_w_logs_npm_ugex
    ln -sf $sourcefolder/$file_mgmt_restart $workingroot/restart_mgmt
    ln -sf $sourcefolder/$file_mgmt_report $workingroot/report_cpwd_admin_list
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
    mkdir $linksfolder
    chmod 775 $linksfolder
else
    chmod 775 $linksfolder
fi

file_add_allias_all=add_alias_commands.all.v00.07.00.sh

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
ls -alh $workingroot | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
ls -alh $workingbase | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
ls -alh $linksbase | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'Done with links generation!' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

# =============================================================================
# =============================================================================



#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# end shell meat
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo 'CLI Operations Completed' | tee -a -i $logfilepath


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# shell clean-up and log dump
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

echo | tee -a -i $logfilepath
echo 'Log results documented in this log file : '$logfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


