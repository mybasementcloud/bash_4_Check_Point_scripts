#!/bin/bash
#
# SCRIPT Subscript to Configure script output paths and folders
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
SubScriptDate=2020-02-04
SubScriptVersion=04.05.00
ScriptRevision=010
TemplateVersion=04.21.00
TemplateLevel=006
SubScriptsLevel=006
SubScriptsVersion=04.05.00
SubScriptTemplateVersion=04.05.00
#

BASHActualSubScriptVersion=v${SubScriptVersion//./x}

BASHSubScriptsVersion=v${SubScriptsVersion//./x}

#export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}
BASHActualSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

BASHSubScriptsTemplateVersion=v${SubScriptTemplateVersion//./x}
BASHSubScriptsTemplateLevel=$TemplateLevel.v$SubScriptTemplateVersion

BASHSubScriptScriptTemplateVersion=v${TemplateVersion//./x}
BASHSubScriptScriptTemplateLevel=$TemplateLevel.v$TemplateVersion


SubScriptFileNameRoot=script_output_paths_and_folders
SubScriptShortName="$SubScriptFileNameRoot.$SubScriptsLevel"
SubScriptDescription="Configure script output paths and folders"

#SubScriptName=$SubScriptFileNameRoot.sub-script.$SubScriptsLevel.v$SubScriptVersion
SubScriptName=$SubScriptFileNameRoot.sub-script.$SubScriptsLevel.v$SubScriptVersion

SubScriptHelpFileName="$SubScriptFileNameRoot.help"
SubScriptHelpFilePath="help.v$SubScriptVersion"
SubScriptHelpFile="$SubScriptHelpFilePath/$SubScriptHelpFileName"


# =================================================================================================
# Validate Sub-Script template version is correct for caller
# =================================================================================================


if [ x"$BASHExpectedSubScriptsVersion" = x"$BASHActualSubScriptsVersion" ] ; then
    # Script and Actions Script versions match, go ahead
    echo >> $logfilepath
    echo 'Verify Actions Scripts Version - OK' >> $logfilepath
    echo >> $logfilepath
else
    # Script and Actions Script versions don't match, ALL STOP!
    echo | tee -a -i $logfilepath
    echo 'Verify Actions Scripts Version - Missmatch' | tee -a -i $logfilepath
    echo 'Expected Subscript version : '$BASHExpectedSubScriptsVersion | tee -a -i $logfilepath
    echo 'Current  Subscript version : '$BASHActualSubScriptsVersion | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "Log output in file $logfilepath" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    exit 250
fi


# =================================================================================================
# =================================================================================================
# START sub script:  Configure script output paths and folders
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

    # WAITTIME in seconds for read -t commands, but check if it's already set
    if [ -z $WAITTIME ]; then
        export WAITTIME=60
    fi
    
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

# MODIFIED 2020-01-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
    
    # Lets make sure we can write to this folder
    if [ ! -r $logfilepathbase ] ; then
        mkdir -pv $logfilepathbase >> $logfilepath
        chmod 775 $logfilepathbase >> $logfilepath
    else
        chmod 775 $logfilepathbase >> $logfilepath
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
    # Handle clean-up file creation for nohup operation
    #----------------------------------------------------------------------------------------
    
    echo | tee -a -i $logfilepath

    if $CLIparm_NOHUP; then
    
        echo 'Create NOHUP Clean-up File : ' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        if [ -n $CLIparm_NOHUPScriptName ]; then
            # nohup operation script name was passed in CLI parameters
            export script2nohup=$CLIparm_NOHUPScriptName
        elif [ -n $BASHScriptnohupName ]; then
            # nohup operation script name uses local definition
            export script2nohup=$BASHScriptnohupName
        else
            # nohup operation script name $BASHScriptnohupName does not exist???
            # OK so do some script level manipulation
            export script2nohup=$BASHScriptFileNameRoot
        fi
        
        # Nonsense based on some initial research, we'll leave this for now
        #
        export script2nohuppath=$(dirname "$script2nohup")
        export script2nohupfile=$(basename -- "$script2nohup")
        export script2nohupfile="${script2nohup##*/}"
        export script2nohupfilename="${script2nohupfile##*.}"
        export script2nohupfileext="${script2nohupfile%.*}"
        
        #export script2nohupfile=${script2nohup//\"}
        
        #export script2nohupstdoutlog=$outputpathroot/.nohup.$DATEDTGS.$script2nohupfile.stdout.txt
        #export script2nohupstderrlog=$outputpathroot/.nohup.$DATEDTGS.$script2nohupfile.stderr.txt
        #export script2watchnohupwork=$outputpathroot/.nohup.$DATEDTGS.$script2nohupfile.watchme.sh
        #export script2cleannohupwork=$outputpathroot/.nohup.$DATEDTGS.$script2nohupfile.cleanup.sh
        #export script2watchdiskspace=$outputpathroot/.nohup.$DATEDTGS.$script2nohupfile.diskspace.sh
        #export script2logdisklv_log=$outputpathroot/.nohup.$DATEDTGS.$script2nohupfile.diskspace.vg_splat-lv_log.sh
        #export script2logdisklvcrnt=$outputpathroot/.nohup.$DATEDTGS.$script2nohupfile.diskspace.vg_splat-lv_current.sh
        
        export script2nohupstdoutlog=$outputpathroot/.nohup.$DATEDTG.$script2nohupfile.stdout.txt
        export script2nohupstderrlog=$outputpathroot/.nohup.$DATEDTG.$script2nohupfile.stderr.txt
        export script2watchnohupwork=$outputpathroot/.nohup.$DATEDTG.$script2nohupfile.watchme.sh
        export script2cleannohupwork=$outputpathroot/.nohup.$DATEDTG.$script2nohupfile.cleanup.sh
        export script2watchdiskspace=$outputpathroot/.nohup.$DATEDTG.$script2nohupfile.diskspace.sh
        export script2logdisklv_log=$outputpathroot/.nohup.$DATEDTG.$script2nohupfile.diskspace.vg_splat-lv_log.sh
        export script2logdisklvcrnt=$outputpathroot/.nohup.$DATEDTG.$script2nohupfile.diskspace.vg_splat-lv_current.sh
        
        echo 'NOHUP Clean-up related files and values : ' | tee -a -i $logfilepath
        echo ' $script2nohup          : '"$script2nohup" | tee -a -i $logfilepath
        echo ' $script2nohuppath      : '"$script2nohuppath" | tee -a -i $logfilepath
        echo ' $script2nohupfile      : '"$script2nohupfile" | tee -a -i $logfilepath
        echo ' $script2nohupfilename  : '"$script2nohupfilename" | tee -a -i $logfilepath
        echo ' $script2nohupfileext   : '"$script2nohupfileext" | tee -a -i $logfilepath
        echo ' $script2nohupstdoutlog : '"$script2nohupstdoutlog" | tee -a -i $logfilepath
        echo ' $script2nohupstderrlog : '"$script2nohupstderrlog" | tee -a -i $logfilepath
        echo ' $script2watchnohupwork : '"$script2watchnohupwork" | tee -a -i $logfilepath
        echo ' $script2cleannohupwork : '"$script2cleannohupwork" | tee -a -i $logfilepath
        echo ' $script2watchdiskspace : '"$script2watchdiskspace" | tee -a -i $logfilepath
        echo ' $script2logdisklv_log  : '"$script2logdisklv_log" | tee -a -i $logfilepath
        echo ' $script2logdisklvcrnt  : '"$script2logdisklvcrnt" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        touch $script2cleannohupwork >> $logfilepath
        chmod 775 $script2cleannohupwork >> $logfilepath
        
        echo '#!/bin/bash' > $script2cleannohupwork
        echo '#' >> $script2cleannohupwork
        echo  >> $script2cleannohupwork
        echo 'mv '$script2nohupstdoutlog' '$outputpathbase >> $script2cleannohupwork
        echo 'mv '$script2nohupstderrlog' '$outputpathbase >> $script2cleannohupwork
        echo 'mv '$script2watchnohupwork' '$outputpathbase >> $script2cleannohupwork
        echo 'cp '$script2cleannohupwork' '$outputpathbase >> $script2cleannohupwork
        echo 'mv '$script2watchdiskspace' '$outputpathbase >> $script2cleannohupwork
        echo 'mv '$script2logdisklv_log' '$outputpathbase >> $script2cleannohupwork
        echo 'mv '$script2logdisklvcrnt' '$outputpathbase >> $script2cleannohupwork
        echo 'echo' >> $script2cleannohupwork
        echo 'ls -alh '$outputpathbase >> $script2cleannohupwork
        echo 'echo' >> $script2cleannohupwork
        echo 'rm '$script2cleannohupwork >> $script2cleannohupwork
        echo 'echo' >> $script2cleannohupwork
        echo  >> $script2cleannohupwork
        echo
        
        echo >> $logfilepath
        echo '------------------------------------------------------------------------------' >> $logfilepath
        echo 'Dump nohup cleanup script to log file:  '$script2cleannohupwork >> $logfilepath
        echo '------------------------------------------------------------------------------' >> $logfilepath
        echo >> $logfilepath
        cat $script2cleannohupwork >> $logfilepath
        echo >> $logfilepath
        echo '------------------------------------------------------------------------------' >> $logfilepath
        echo 'Copy nohup cleanup script to log folder:  '$logfilepathbase >> $logfilepath
        echo '------------------------------------------------------------------------------' >> $logfilepath
        echo >> $logfilepath
        cp $script2cleannohupwork $logfilepathbase >> $logfilepath
        echo >> $logfilepath
        echo '------------------------------------------------------------------------------' >> $logfilepath
        echo >> $logfilepath
        echo >> $logfilepath
        
        
    else
        
        echo 'NOT in NOHUP mode!  No need for NOHUP Clean-up File ' >> $logfilepath
        echo >> $logfilepath
        
    fi
    
    
    #----------------------------------------------------------------------------------------
    # Done setting output and log paths
    #----------------------------------------------------------------------------------------
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-01-05

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
        
        if $CLIparm_NOHUP; then
            echo 'NOHUP Clean-up related files and values : ' | tee -a -i $logfilepath
            echo ' $script2nohup          : '"$script2nohup" | tee -a -i $logfilepath
            echo ' $script2nohuppath      : '"$script2nohuppath" | tee -a -i $logfilepath
            echo ' $script2nohupfile      : '"$script2nohupfile" | tee -a -i $logfilepath
            echo ' $script2nohupfilename  : '"$script2nohupfilename" | tee -a -i $logfilepath
            echo ' $script2nohupfileext   : '"$script2nohupfileext" | tee -a -i $logfilepath
            echo ' $script2nohupstdoutlog : '"$script2nohupstdoutlog" | tee -a -i $logfilepath
            echo ' $script2nohupstderrlog : '"$script2nohupstderrlog" | tee -a -i $logfilepath
            echo ' $script2watchnohupwork : '"$script2watchnohupwork" | tee -a -i $logfilepath
            echo ' $script2cleannohupwork : '"$script2cleannohupwork" | tee -a -i $logfilepath
            echo ' $script2watchdiskspace : '"$script2watchdiskspace" | tee -a -i $logfilepath
            echo ' $script2logdisklv_log  : '"$script2logdisklv_log" | tee -a -i $logfilepath
            echo ' $script2logdisklvcrnt  : '"$script2logdisklvcrnt" | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
        fi        

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


