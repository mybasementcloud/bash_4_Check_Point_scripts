#!/bin/bash
#
# Identify Self Referencing Symbolic Link Files (Lite) - All combined, no dependent scripts
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
ScriptDate=2020-10-20
ScriptVersion=04.36.00
ScriptRevision=000
TemplateVersion=04.36.00
TemplateLevel=006
SubScriptsLevel=NA
SubScriptsVersion=NA
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=identify_self_referencing_symbolic_link_files.Lite
export BASHScriptShortName=id_self_referencing_symlinks
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription="Identify Self Referencing Symbolic Link Files (Lite)"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=_template

export BASHScripttftptargetfolder="_template"


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Basic Configuration
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------


export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`


# -------------------------------------------------------------------------------------------------
# Other variable configuration
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
# local scripts variables configuration
# -------------------------------------------------------------------------------------------------


targetfolder=/var/log/tmp/scripts


# -------------------------------------------------------------------------------------------------
# logfile configuration
# -------------------------------------------------------------------------------------------------


# setup initial log file for output logging
export logfilefolder=$targetfolder/dump/$DATEDTGS.$BASHScriptShortName
export logfilepath=$logfilefolder/$BASHScriptName.$DATEDTGS.log

if [ ! -w $logfilefolder ]; then
    mkdir -pv $logfilefolder
fi

touch $logfilepath


# -------------------------------------------------------------------------------------------------
# CheckAndUnlockGaiaDB - Check and Unlock Gaia database
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

#CheckAndUnlockGaiaDB

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Gaia Version
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-10-19 -

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
    export isitR8Xversion=true
else
    export isitR8Xversion=false
fi
#echo $isitR8Xversion

if $isitR77version; then
    echo "This is an R77.X version..."
    export UseR8XAPI=false
    export UseJSONJQ=false
    export UseJSONJQ16=false
elif $isitR8Xversion; then
    echo "This is an R80.X version..."
    export UseR8XAPI=$UseR8XAPI
    export UseJSONJQ=$UseJSONJQ
    export UseJSONJQ16=$UseJSONJQ16
else
    echo "This is not an R77.X or R80.X version ????"
fi


# Removing dependency on clish to avoid collissions when database is locked
# And then finding out R77.30 and earlier don't work with that solution...

# MODIFIED 2019-01-18 -

if $isitR77version; then
    
    # This is an R77.X version...
    # We don't have the luxury of python get_platform.py script
    #
    export productversion=$(clish -i -c "show version product" | cut -d " " -f 6)
    
    # Keep the first string before next space in returned product version, since that could be owned 
    # if clish is owned elsewhere
    #
    export gaiaversion=$(echo $productversion | cut -d " " -f 1)
    
    # check if clish is owned and if it is, try a different alternative to get the version
    #
    export checkgaiaversion=`echo "${gaiaversion}" | grep -i "owned"`
    export isclishowned=`test -z $checkgaiaversion; echo $?`
    if [ $isclishowned -eq 1 ]; then 
        cpreleasefile=/etc/cp-release
        export gaiaversion=$(cat $cpreleasefile | cut -d " " -f 4)
    fi
    
elif $isitR8Xversion; then
    
    # Requires that $JQ is properly defined in the script
    # so $UseJSONJQ = true must be set on template version 2.0.0 and higher
    #
    # Test string, use this to validate if there are problems:
    #
    #export pythonpath=$MDS_FWDIR/Python/bin/;echo $pythonpath;echo
    #$pythonpath/python --help
    #$pythonpath/python --version
    #
    
    export productversion=$(clish -i -c "show version product" | cut -d " " -f 6)
    
    # Keep the first string before next space in returned product version, since that could be owned 
    # if clish is owned elsewhere
    #
    export gaiaversion=$(echo $productversion | cut -d " " -f 1)
    
    # check if clish is owned and if it is, try a different alternative to get the version
    #
    export checkgaiaversion=`echo "${gaiaversion}" | grep -i "owned"`
    export isclishowned=`test -z $checkgaiaversion; echo $?`
    if [ $isclishowned -eq 1 ]; then 
        cpreleasefile=/etc/cp-release
        if [ -r $cpreleasefile ] ; then
            # OK we have the easy-button alternative
            export gaiaversion=$(cat $cpreleasefile | cut -d " " -f 4)
        else
            # OK that's not going to work without the file
            
            # Requires that $JQ is properly defined in the script
            # so $UseJSONJQ = true must be set on template version 0.32.0 and higher
            #
            export pythonpath=$MDS_FWDIR/Python/bin/
            if $UseJSONJQ ; then
                export get_platform_release=`$pythonpath/python $MDS_FWDIR/scripts/get_platform.py -f json | $JQ '. | .release'`
            else
                export get_platform_release=`$pythonpath/python $MDS_FWDIR/scripts/get_platform.py -f json | ${CPDIR_PATH}/jq/jq '. | .release'`
            fi
            
            export platform_release=${get_platform_release//\"/}
            export get_platform_release_version=`echo ${get_platform_release//\"/} | cut -d " " -f 4`
            export platform_release_version=${get_platform_release_version//\"/}
            
            export gaiaversion=$platform_release_version
        fi
    fi
    
else
    
    # This is not an R77.X or R80.X version ????
    # Maybe the R80.X approach works...
    
    # Requires that $JQ is properly defined in the script
    # so $UseJSONJQ = true must be set on template version 2.0.0 and higher
    #
    # Test string, use this to validate if there are problems:
    #
    #export pythonpath=$MDS_FWDIR/Python/bin/;echo $pythonpath;echo
    #$pythonpath/python --help
    #$pythonpath/python --version
    #
    
    export productversion=$(clish -i -c "show version product" | cut -d " " -f 6)
    
    # Keep the first string before next space in returned product version, since that could be owned 
    # if clish is owned elsewhere
    #
    export gaiaversion=$(echo $productversion | cut -d " " -f 1)
    
    # check if clish is owned and if it is, try a different alternative to get the version
    #
    export checkgaiaversion=`echo "${gaiaversion}" | grep -i "owned"`
    export isclishowned=`test -z $checkgaiaversion; echo $?`
    if [ $isclishowned -eq 1 ]; then 
        cpreleasefile=/etc/cp-release
        if [ -r $cpreleasefile ] ; then
            # OK we have the easy-button alternative
            export gaiaversion=$(cat $cpreleasefile | cut -d " " -f 4)
        else
            # OK that's not going to work without the file
            
            # Requires that $JQ is properly defined in the script
            # so $UseJSONJQ = true must be set on template version 0.32.0 and higher
            #
            export pythonpath=$MDS_FWDIR/Python/bin/
            if $UseJSONJQ ; then
                export get_platform_release=`$pythonpath/python $MDS_FWDIR/scripts/get_platform.py -f json | $JQ '. | .release'`
            else
                export get_platform_release=`$pythonpath/python $MDS_FWDIR/scripts/get_platform.py -f json | ${CPDIR_PATH}/jq/jq '. | .release'`
            fi
            
            export platform_release=${get_platform_release//\"/}
            export get_platform_release_version=`echo ${get_platform_release//\"/} | cut -d " " -f 4`
            export platform_release_version=${get_platform_release_version//\"/}
            
            export gaiaversion=$platform_release_version
        fi
    fi
    
fi


echo 'Gaia Version : $gaiaversion = '$gaiaversion
echo


# -------------------------------------------------------------------------------------------------
# Script Version Operations
# -------------------------------------------------------------------------------------------------


export toolsversion=$gaiaversion


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
# Start of Script Operations
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# local command line parameter variables configuration
# -------------------------------------------------------------------------------------------------


export CLIparm_l01_StartFolder=
export CLIparm_l02_KillCircLinks=

export KillCircularSymLinks=false

export SHOWHELP=false

# -------------------------------------------------------------------------------------------------
# processlocalcliparms - Local command line parameter processor
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-02-06 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

processlocalcliparms () {
    #
    
    echo
    
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
                --KILL | --kill )
                    export CLIparm_l02_KillCircLinks=true
                    export KillCircularSymLinks=true
                    ;;
                # Handle --flag=value opts like this
                --Path=* )
                    CLIparm_l01_StartFolder="${OPT#*=}"
                    #shift
                    ;;
                # and --flag value opts like this
                --Path )
                    CLIparm_l01_StartFolder="$2"
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
    
    export CLIparm_l01_StartFolder=$CLIparm_l01_StartFolder
    export CLIparm_l02_KillCircLinks=$CLIparm_l02_KillCircLinks
    export KillCircularSymLinks=$KillCircularSymLinks

}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-02-06

# -------------------------------------------------------------------------------------------------
# END:  Common Help display proceedure
# -------------------------------------------------------------------------------------------------
# =================================================================================================

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------



# -------------------------------------------------------------------------------------------------
# Help display proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-02-06 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# Show help information

doshowhelp () {
    #
    # Screen width template for sizing, default width of 80 characters assumed
    #
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    echo
    echo ' Script:  '$0'  Script Version:  '$BASHScriptVersion'  Date:  '$ScriptDate'  Revision:  '$ScriptRevision
    echo
    echo ' Standard Command Line Parameters: '
    echo
    echo '  Show Help                  -? | --help'
    echo
    echo '  Starting Folder Path       --Path <Starting_Folder_Path> | --Path=<Starting_Folder_Path>'
    echo
    echo '  Remove Circular SymLinks   --KILL | --kill'
    echo
    echo '  Example:  '
    echo ' ]# '$0' --Path "${RTDIR}/log_indexes/" --KILL'
    
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

    echo
    return 1
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-02-06

# -------------------------------------------------------------------------------------------------
# END:  Common Help display proceedure
# -------------------------------------------------------------------------------------------------
# =================================================================================================

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

processlocalcliparms "$@"

if $SHOWHELP ; then
    # Show Help
    doshowhelp "$@"
    # don't want a log file for showing help
    #rm $logfilepath
    # this is done now, so exit hard
    exit 255 
fi


# -------------------------------------------------------------------------------------------------
# Script intro
# -------------------------------------------------------------------------------------------------


echo | tee -a -i $logfilepath
echo $BASHScriptDescription', script version '$ScriptVersion', revision '$ScriptRevision' from '$ScriptDate | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Date Time Group   :  '$DATEDTGS | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# script plumbing 1
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

export outputpathbase=$logfilefolder

#----------------------------------------------------------------------------------------
# Configure specific parameters
#----------------------------------------------------------------------------------------

export targetversion=$gaiaversion

export outputfilepath=$outputpathbase/
export outputfileprefix=$HOSTNAME'_'$targetversion
export outputfilesuffix='_'$DATEDTGS
export outputfiletype=.txt

if [ ! -r $outputfilepath ] ; then
    mkdir -pv $outputfilepath
    chmod 775 $outputfilepath
else
    chmod 775 $outputfilepath
fi


export command2run=id_self_ref_symlinks
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

export command2run2=files_with_self_ref_symlinks
export outputfile2=$outputfileprefix'_'$command2run2$outputfilesuffix$outputfiletype
export outputfilefqdn2=$outputfilepath$outputfile2

echo | tee -a -i "$outputfilefqdn"
echo 'Execute '$command2run' with output to : '$outputfilefqdn | tee -a -i "$outputfilefqdn"

echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"

echo '----------------------------------------------------------------------------' >> "$outputfilefqdn2"
echo 'Files with Self-referencing SymLinks:' >> "$outputfilefqdn2"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn2"


#----------------------------------------------------------------------------------------
# Loop through target folder root to identify all symbolic link files
#----------------------------------------------------------------------------------------

#sourcerootfolder=${RTDIR}/log_indexes/

if [ -z $CLIparm_l01_StartFolder ]; then
    export sourcerootfolder=.
else
    if [ -r $CLIparm_l01_StartFolder ]; then
        export sourcerootfolder=
        export sourcerootfolder=${CLIparm_l01_StartFolder%/}/
    else
        export sourcerootfolder=.
    fi
fi


targetfile=
targetactualfile=


echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo 'Starting operations in this folder:  '$sourcerootfolder | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"

pushd $sourcerootfolder >> "$outputfilefqdn"

echo >> "$outputfilefqdn"

echo 'Starting Work path :  '`pwd` | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
ls -alhi >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

for f in $(find . -type l); do 
    
    targetlinktype=`stat -L -c %F $f`
    targetfile=$f
    targetactualfile=`readlink $f`
    
    echo 'Target Link Type = '$targetlinktype'  Target Link File :  '$targetfile'  Target Actual File :  '$targetactualfile | tee -a -i "$outputfilefqdn"
    
    if [ "$targetlinktype" = "directory" ]; then
        echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
        echo 'Drop in to actual link folder: '$targetactualfile >> "$outputfilefqdn"
        
        pushd $targetactualfile >> "$outputfilefqdn"
        
        echo >> "$outputfilefqdn"
        
        echo 'Current path :  '`pwd` >> "$outputfilefqdn"
        ls -alhi >> "$outputfilefqdn"
        echo >> "$outputfilefqdn"
        
        for g in $(find . -type l); do 
            
            locallinktype=`stat -L -c %F $g`
            
            if [ "$locallinktype" = "directory" ]; then
                localfile=$g
                localactualpath=`pwd`
                localactualfile=`readlink $g`
                localfilename=${g##*/}
                
                echo 'Local Link Type = '$locallinktype'  Local Link File Name (as found):  '$localfilename '('$localfile')  Local Actual File :  '$localactualfile | tee -a -i "$outputfilefqdn"
                ls -alhi $g >> "$outputfilefqdn"
                
                echo >> "$outputfilefqdn"
                
                tempdumpfile=/var/log/tmp/dumpfile.$DATEDTGS.txt
                find . -type l -follow -print 2>> "$tempdumpfile" >> "$outputfilefqdn"
                cat $tempdumpfile >> "$outputfilefqdn"
                localactuallinkloops=`cat $tempdumpfile | grep -i "$g"`
                localactuallinkloopscheck=`test -z localactuallinkloops; echo $?`
                localactuallinkloopscheckresult=$localactuallinkloopscheck
                echo 'Loop Check Result ('$localactuallinkloopscheck'):  '$localactuallinkloops | tee -a -i "$outputfilefqdn"
                rm $tempdumpfile
                
                if [ $localactuallinkloopscheckresult ] ; then 
                    echo 'Loop Check True - Link points to itself!!!!'
                    
                    echo $targetactualfile$localfilename >> "$outputfilefqdn2"
                    
                    if $KillCircularSymLinks ; then
                        echo 'Remove Circular SymLink File!' | tee -a -i "$outputfilefqdn"
                        #echo 'testing....'
                        rm $g >> "$outputfilefqdn"
                    else
                        echo 'Keep Circular SymLink File!' >> "$outputfilefqdn"
                    fi
                else
                    echo 'Loop Check false - Not directly self referencing'
                fi
                
                if [ $localactualpath/ = $localactualfile ]; then 
                    echo 'Link points to itself!!!!'
                else
                    echo 'Not directly self referencing, but may still represent a loop!'
                fi
                
            else
                echo 'Not A directory!' $g >> "$outputfilefqdn"
            fi
            
            echo >> "$outputfilefqdn"
            
        done;
        
        popd >> "$outputfilefqdn"
        
        echo 'Returned path :  '`pwd` >> "$outputfilefqdn"
        
        echo >> "$outputfilefqdn"
        echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
        
    else
        echo 'Not a directory!  '$f'  Skipping...' >> "$outputfilefqdn"
    fi
    
done;
echo >> "$outputfilefqdn"

popd >> "$outputfilefqdn"

echo 'Returned path :  '`pwd` >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"
echo '----------------------------------------------------------------------------' | tee -a -i "$outputfilefqdn"

echo '----------------------------------------------------------------------------' >> "$outputfilefqdn2"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn2"



# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Closing operations and log file information
# -------------------------------------------------------------------------------------------------


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


# -------------------------------------------------------------------------------------------------
# End of script Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

echo
echo 'Script Completed, exiting...';echo
