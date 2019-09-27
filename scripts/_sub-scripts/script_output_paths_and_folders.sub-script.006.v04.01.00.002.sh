#!/bin/bash
#
# SCRIPT Subscript to Configure script output paths and folders
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
SubScriptDate=2019-05-12
SubScriptsLevel=006
SubScriptVersion=04.01.00
SubScriptRevision=002
TemplateVersion=04.03.00
TemplateLevel=006
#

BASHSubScriptVersion=v${SubScriptVersion//./x}
BASHScriptTemplateVersion=v${TemplateVersion//./x}
SubScriptsVersion=$SubScriptsLevel.v${SubScriptVersion//./x}

SubScriptName=script_output_paths_and_folders.sub-script.$SubScriptsLevel.v$SubScriptVersion
SubScriptShortName="script_output_paths_and_folders.$SubScriptsLevel"
SubScriptDescription="Configure script output paths and folders"


# =================================================================================================
# Validate Sub-Script template version is correct for caller
# =================================================================================================


if [ x"$BASHExpectedSubScriptsVersion" = x"$SubScriptsVersion" ] ; then
    # Script and Actions Script versions match, go ahead
    echo >> $logfilepath
    echo 'Verify Actions Scripts Version - OK' >> $logfilepath
    echo >> $logfilepath
else
    # Script and Actions Script versions don't match, ALL STOP!
    echo | tee -a -i $logfilepath
    echo 'Verify Actions Scripts Version - Missmatch' | tee -a -i $logfilepath
    echo 'Expected Subscript version : '$BASHExpectedSubScriptsVersion | tee -a -i $logfilepath
    echo 'Current  Subscript version : '$SubScriptsVersion | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "Log output in file $logfilepath" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    exit 250
fi


# =================================================================================================
# =================================================================================================
# START action script:  Determine Gaia version and Installation type
# =================================================================================================


echo >> $logfilepath
echo 'Subscript Name:  '$SubScriptName'  Subcript Version: '$SubScriptVersion'  Level:  '$SubScriptsLevel'  Revision:  '$SubScriptRevision'  Template Version: '$TemplateVersion >> $logfilepath
echo >> $logfilepath


# -------------------------------------------------------------------------------------------------
# Handle important basics
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# =================================================================================================
# START Procedures:  Configure script output paths and folders
# =================================================================================================


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
    export dumppathroot=$customerworkpathroot/dump
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
        echo 'In home directory folder : '$startpathroot >> $logfilepath
        export outputpathroot=$alternatepathroot
    else
        #OK use the current folder and create working sub-folder
        echo 'NOT in home directory folder : '$startpathroot >> $logfilepath
        # let's not change the configuration provided
        #export outputpathroot=$startpathroot
    fi
    
    if [ ! -r $outputpathroot ] ; then
        #not where we're expecting to be, since $outputpathroot is missing here
        #maybe this hasn't been run here yet.
        #OK, so make the expected folder and set permissions we need
        mkdir -pv $outputpathroot >> $logfilepath
        chmod 775 $outputpathroot >> $logfilepath
    else
        #set permissions we need
        chmod 775 $outputpathroot >> $logfilepath
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
        
        if [ ! -r $outputpathroot ] ; then
            mkdir -pv $outputpathroot >> $logfilepath
            chmod 775 $outputpathroot >> $logfilepath
        else
            chmod 775 $outputpathroot >> $logfilepath
        fi
        
        if $OutputToRoot ; then
            # output to outputpathroot
            export outputpathbase=$outputpathroot

            echo 'Set root output to Root : '"$outputpathroot"', $outputpathbase = '"$outputpathbase" >> $logfilepath

        elif $OutputToDump ; then
            # output to dump folder
            
            # Check if the expected dump folder exists and if not, create it and set access rights
            if [ ! -r $dumppathroot ] ; then
                mkdir -pv $dumppathroot >> $logfilepath
                chmod 775 $dumppathroot >> $logfilepath
            else
                chmod 775 $dumppathroot >> $logfilepath
            fi
            
            export outputpathbase=$dumppathroot

            echo 'Set root output to Dump : '"$dumppathroot"', $outputpathbase = '"$outputpathbase" >> $logfilepath

        elif $OutputToChangeLog ; then
            # output to Change Log
            
            # Check if the expected change log folder exists and if not, create it and set access rights
            if [ ! -r $changelogpathroot ] ; then
                mkdir -pv $changelogpathroot >> $logfilepath
                chmod 775 $changelogpathroot >> $logfilepath
            else
                chmod 775 $changelogpathroot >> $logfilepath
            fi
            
            export outputpathbase=$changelogpathroot

            echo 'Set root output to Change Log : '"$changelogpathroot"', $outputpathbase = '"$outputpathbase" >> $logfilepath

        elif $OutputToOther ; then
            # output to other folder that should be set in $OtherOutputFolder
            #export outputpathbase=$OtherOutputFolder
        
            # Check if the expected other folder exists and if not, create it and set access rights
            if [ ! -r $OtherOutputFolder ] ; then
                mkdir -pv $OtherOutputFolder >> $logfilepath
                chmod 775 $OtherOutputFolder >> $logfilepath
            else
                chmod 775 $OtherOutputFolder >> $logfilepath
            fi
            
            # need to expand this other path to ensure things work
            export expandedpath=$(cd $OtherOutputFolder ; pwd)
            export outputpathbase=$expandedpath
        
            echo 'Set root output to Other : '"$OtherOutputFolder"', $outputpathbase = '"$outputpathbase" >> $logfilepath

        else
            # Huh, what... this should have been set, well the use dump
            # output to dumppathroot
            
            # Check if the expected dump folder exists and if not, create it and set access rights
            if [ ! -r $dumppathroot ] ; then
                mkdir -pv $dumppathroot >> $logfilepath
                chmod 775 $dumppathroot >> $logfilepath
            else
                chmod 775 $dumppathroot >> $logfilepath
            fi
            
            export outputpathbase=$dumppathroot

            echo 'Set root output to default Dump : '"$dumppathroot"', $outputpathbase = '"$outputpathbase" >> $logfilepath

        fi
        
        # Now that we know where things are going, let's make sure we can write there
        #

        if [ ! -r $outputpathbase ] ; then
            mkdir -pv $outputpathbase >> $logfilepath
            chmod 775 $outputpathbase >> $logfilepath
        else
            chmod 775 $outputpathbase >> $logfilepath
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
                mkdir -pv $outputpathbase >> $logfilepath
                chmod 775 $outputpathbase >> $logfilepath
            else
                chmod 775 $outputpathbase >> $logfilepath
            fi
        fi

        echo >> $logfilepath

    else
        # CLI parameter for outputpath set
        export outputpathroot=$CLIparm_outputpath
        #export outputpathbase=$CLIparm_outputpath
    
        # need to expand this other path to ensure things work
        #export expandedpath=$(cd $CLIparm_outputpath ; pwd)
        export expandedpath=$(cd $outputpathroot ; pwd)
        export outputpathbase=$expandedpath

        echo 'Set root output to Other : '"$CLIparm_outputpath"', $outputpathroot = '"$outputpathroot"', $outputpathbase = '"$outputpathbase" >> $logfilepath
        echo >> $logfilepath

        if [ ! -r $outputpathbase ] ; then
            mkdir -pv $outputpathbase >> $logfilepath
            chmod 775 $outputpathbase >> $logfilepath
        else
            chmod 775 $outputpathbase >> $logfilepath
        fi
    fi
    
    export outputhomepath=$outputpathbase
    
    if [ ! -r $outputhomepath ] ; then
        mkdir -pv $outputhomepath >> $logfilepath
        chmod 775 $outputhomepath >> $logfilepath
    else
        chmod 775 $outputhomepath >> $logfilepath
    fi
    
    #----------------------------------------------------------------------------------------
    # Set LogFile Information
    #----------------------------------------------------------------------------------------
    
    # MODIFIED 2019-01-19 -

    export logfilepathbase=$outputpathbase
    export logfilepathfirst=$logfilepath

    # Setup the log file fully qualified path based on final locations
    #
    if [ -z "$CLIparm_logpath" ]; then
        # CLI parameter for logfile not set
        export logfilepathbase=$outputpathbase
    else
        # CLI parameter for logfile set
        #export logfilepathbase=$CLIparm_logpath
    
        # need to expand this other path to ensure things work
        export expandedpath=$(cd $CLIparm_logpath ; pwd)
        export logfilepathbase=$expandedpath
    fi
    
    export logfilepathfinal=$logfilepathbase/$BASHScriptName.$DATEDTGS.log

    # if we've been logging, move the temporary log to the final path
    #
    if [ -r $logfilepath ]; then
        mv $logfilepath $logfilepathfinal >> $logfilepath
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
# ShowFinalOutputAndLogPaths - repeated proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-01-19 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

ShowFinalOutputAndLogPaths () {
    #
    # repeated procedure description
    #

    #----------------------------------------------------------------------------------------
    # Output and Log file and folder Information
    #----------------------------------------------------------------------------------------
    
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
        echo ' $logfilepathbase      : '"$logfilepathbase" | tee -a -i $logfilepath
        echo ' $logfilepath          : '"$logfilepath" | tee -a -i $logfilepath
        echo ' $logfilepathfirst     : '"$logfilepathfirst" | tee -a -i $logfilepath
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-19

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# END Procedures:  Configure script output paths and folders
# =================================================================================================
# =================================================================================================


# =================================================================================================
# =================================================================================================
# START:  Configure script output paths and folders
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# Root Script Configuration
# -------------------------------------------------------------------------------------------------

HandleRootScriptConfiguration "$@"


#----------------------------------------------------------------------------------------
# Setup root folder and path values
#----------------------------------------------------------------------------------------

export alternatepathroot=$customerworkpathroot

HandleLaunchInHomeFolder "$@"

FinalizeOutputAndLogPaths "$@"

ShowFinalOutputAndLogPaths "$@"


# =================================================================================================
# END:  Configure script output paths and folders
# =================================================================================================
# =================================================================================================

return 0


# =================================================================================================
# END  
# =================================================================================================
# =================================================================================================


