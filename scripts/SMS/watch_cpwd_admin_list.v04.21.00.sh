#!/bin/bash
#
# SCRIPT for BASH to watch cp management processes
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2020-01-05
ScriptVersion=04.21.00
ScriptRevision=004
TemplateLevel=006
TemplateVersion=04.20.00
SubScriptsLevel=006
SubScriptsVersion=04.05.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=watch_cpwd_admin_list
export BASHScriptShortName=watch_cpwd_admin_list.v$ScriptVersion
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription=="Watch cp management processes"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=_template

export BASHScripttftptargetfolder="_template"


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

export R8XRequired=false
export UseR8XAPI=false
export UseJSONJQ=true
export UseJSONJQ16=true
export JQ16Required=false


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
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Gaia Version
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
    export UseJSONJQ16=false
elif $isitR80version; then
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

elif $isitR80version; then

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
    R80 | R80.10 | R80.20.M1 | R80.20.M2 | R80.20 | R80.30.M1 | R80.30.M2 | R80.30 | R80.40.M1 | R80.40.M2 | R80.40 ) 
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
# Script Operations
# -------------------------------------------------------------------------------------------------

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
    
    #if $CLIparm_NOWAIT ; then
    #    echo 'Not watching and waiting...'
    #else
    #    watch -d -n 1 "$watchcommands"
    #fi

    watch -d -n 1 "$watchcommands"
    
    DocumentMgmtcpwdadminlist
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-04-20

#WatchMgmtcpwdadminlist

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

DocumentMgmtcpwdadminlist

WatchMgmtcpwdadminlist


# -------------------------------------------------------------------------------------------------
# End of script
# -------------------------------------------------------------------------------------------------

echo
echo 'Script Completed, exiting...';echo

