#!/bin/bash
#
# SCRIPT Subscript for handling mgmt_cli API Operations
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
SubScriptDate=2020-09-17
SubScriptVersion=04.10.00
SubScriptRevision=000
TemplateVersion=04.33.00
TemplateLevel=006
SubScriptsLevel=006
SubScriptsVersion=04.10.00
SubScriptTemplateVersion=04.10.00
#

BASHActualSubScriptVersion=v${SubScriptVersion//./x}

BASHSubScriptsVersion=v${SubScriptsVersion//./x}
BASHSubScriptsRevision=v${SubScriptRevision//./x}

#export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}
BASHActualSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

BASHSubScriptsTemplateVersion=v${SubScriptTemplateVersion//./x}
BASHSubScriptsTemplateLevel=$TemplateLevel.v$SubScriptTemplateVersion

BASHSubScriptScriptTemplateVersion=v${TemplateVersion//./x}
BASHSubScriptScriptTemplateLevel=$TemplateLevel.v$TemplateVersion


SubScriptFileNameRoot=mgmt_cli_api_operations_subscripts
SubScriptShortName="mgmt_cli_api_operations.$SubScriptsLevel"
SubScriptDescription="Subscript for handling mgmt_cli API Operations"

#SubScriptName=$SubScriptFileNameRoot.subscript.$SubScriptsLevel.v$SubScriptVersion
SubScriptName=$SubScriptFileNameRoot.subscript.$SubScriptsLevel.v$SubScriptVersion

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
# START sub script:  template sub script
# =================================================================================================


echo >> $logfilepath
echo 'Subscript Name:  '$SubScriptName'  Subcript Version: '$SubScriptVersion'  Subscript Revision:  '$SubScriptRevision'  Level:  '$SubScriptsLevel'  Template Version: '$TemplateVersion >> $logfilepath
echo >> $logfilepath


# -------------------------------------------------------------------------------------------------
# Handle important basics
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# START:  Local Proceedures - Handle important basics
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# SetupTempLogFile - Setup Temporary Log File and clear any debris
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

SetupTempLogFile () {
    #
    # SetupTempLogFile - Setup Temporary Log File and clear any debris
    #
    
    if [ -z "$1" ]; then
        # No explicit name passed for action
        export APICLItemplogfilepath=/var/tmp/$SubScriptShortName'_'$BASHActualSubScriptVersion'_temp_'$DATEDTGS.log
    else
        # explicit name passed for action
        export APICLItemplogfilepath=/var/tmp/$SubScriptShortName'_'$BASHActualSubScriptVersion'_temp_'$1'_'$DATEDTGS.log
    fi
    
    rm $localtemplogfilepath >> $logfilepath 2> $logfilepath
    
    touch $localtemplogfilepath
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# HandleShowTempLogFile - Handle Showing of Temporary Log File based on verbose setting
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

HandleShowTempLogFile () {
    #
    # HandleShowTempLogFile - Handle Showing of Temporary Log File based on verbose setting
    #
    
    if [ "$SCRIPTVERBOSE" = "true" ] ; then
        # verbose mode so show the logged results and copy to normal log file
        cat $localtemplogfilepath | tee -a -i $logfilepath
    else
        # NOT verbose mode so push logged results to normal log file
        cat $localtemplogfilepath >> $logfilepath
    fi
    
    rm $localtemplogfilepath >> $logfilepath 2> $logfilepath
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# ForceShowTempLogFile - Handle Showing of Temporary Log File based forced display
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

ForceShowTempLogFile () {
    #
    # ForceShowTempLogFile - Handle Showing of Temporary Log File based forced display
    #
    
    cat $localtemplogfilepath | tee -a -i $logfilepath
    
    rm $localtemplogfilepath >> $logfilepath 2> $logfilepath
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# GaiaWebSSLPortCheck - Check local Gaia Web SSL Port configuration for local operations
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-09-11 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# GaiaWebSSLPortCheck - Check local Gaia Web SSL Port configuration for local operations
#

GaiaWebSSLPortCheck () {

    # Removing dependency on clish to avoid collissions when database is locked
    #
    #export currentapisslport=$(clish -c "show web ssl-port" | cut -d " " -f 2)
    #
    export pythonpath=$MDS_FWDIR/Python/bin/
    export get_api_local_port=`$pythonpath/python $MDS_FWDIR/scripts/api_get_port.py -f json | $JQ '. | .external_port'`
    export api_local_port=${get_api_local_port//\"/}
    export currentapisslport=$api_local_port
    
    if [ "$SCRIPTVERBOSE" = "true" ] ; then
        echo 'Current Gaia web ssl-port : '$currentapisslport | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    else
        echo 'Current Gaia web ssl-port : '$currentapisslport >> $logfilepath
        echo >> $logfilepath
    fi
    
    return 0
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-09-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# ScriptAPIVersionCheck - Check version of the script to ensure it is able to operate at minimum expected
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# ScriptAPIVersionCheck - Check version of the script to ensure it is able to operate at minimum 
# expected to correctly execute.
#

ScriptAPIVersionCheck () {

    SetupTempLogFile

    GetAPIVersion=$(mgmt_cli show api-versions -r true -f json --port $currentapisslport | $JQ '.["current-version"]' -r)
    export CheckAPIVersion=$GetAPIVersion

    if [ $CheckAPIVersion = null ] ; then
        # show api-versions does not exist in version 1.0, so it fails and returns null
        CurrentAPIVersion=1.0
    else
        CurrentAPIVersion=$CheckAPIVersion
    fi
    
    echo 'API version = '$CurrentAPIVersion >> $logfilepath
    
    if [ $(expr $MinAPIVersionRequired '<=' $CurrentAPIVersion) ] ; then
        # API is sufficient version
        echo >> $logfilepath
    
        HandleShowTempLogFile
    
    else
        # API is not of a sufficient version to operate
        echo >> $logfilepath
        echo 'Current API Version ('$CurrentAPIVersion') does not meet minimum API version expected requirement ('$MinAPIVersionRequired')' >> $logfilepath
        echo >> $logfilepath
        echo '! termination execution !' >> $logfilepath
        echo >> $logfilepath
    
        ForceShowTempLogFile
    
        exit 250
    fi
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# END:  Local Proceedures - Handle important basics
# =================================================================================================


# =================================================================================================
# =================================================================================================
# START:  _template sub script
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# CheckStatusOfAPI - repeated proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# repeated procedure description
#

CheckStatusOfAPI () {
    #
    
    SetupTempLogFile CheckStatusOfApi
    
    # -------------------------------------------------------------------------------------------------
    # Check that the API is actually running and up so we don't run into wierd problems
    # -------------------------------------------------------------------------------------------------
    
    echo >> $localtemplogfilepath
    echo '-------------------------------------------------------------------------------------------------' >> $localtemplogfilepath
    echo 'Check API Operational Status before starting' >> $localtemplogfilepath
    echo '-------------------------------------------------------------------------------------------------' >> $localtemplogfilepath
    echo >> $localtemplogfilepath
    
    export pythonpath=$MDS_FWDIR/Python/bin/
    export get_api_local_port=`$pythonpath/python $MDS_FWDIR/scripts/api_get_port.py -f json | $JQ '. | .external_port'`
    export api_local_port=${get_api_local_port//\"/}
    export currentapisslport=$api_local_port
    
    echo 'First make sure we do not have any issues:' >> $localtemplogfilepath
    echo >> $localtemplogfilepath
    
    mgmt_cli -r true show version --port $currentapisslport >> $localtemplogfilepath
    errorresult=$?
    
    echo >> $localtemplogfilepath
    
    if [ $errorresult -ne 0 ] ; then
        #api operation NOT OK, so anything that is not a 0 result is a fail!
        echo "API is not operating as expected so API calls will probably fail!" >> $localtemplogfilepath
        echo 'Still executing api status for additional details' >> $localtemplogfilepath
    else
        #api operations status OK
        echo "API is operating as expected so api status should work as expected!" >> $localtemplogfilepath
    fi
    
    echo >> $localtemplogfilepath
    echo 'Next check api status:' >> $localtemplogfilepath
    echo >> $localtemplogfilepath
    
    # Execute the API check with api status to a temporary log file, since tee throws off the results of error checking
    api status >> $localtemplogfilepath
    errorresult=$?
    
    echo >> $localtemplogfilepath
    echo 'API status check result ( 0 = OK ) : '$errorresult >> $localtemplogfilepath
    echo >> $localtemplogfilepath
    
    HandleShowTempLogFile
    
    if [ $errorresult -ne 0 ] ; then
        #api operations status NOT OK, so anything that is not a 0 result is a fail!
        echo "API is not operating as expected so API calls will probably fail!" | tee -a -i $logfilepath
        echo 'Critical Error '$errorresult'- Exiting Script !!!!' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo "Log output in file $logfilepath" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        #return $errorresult
        #exit 1
        #Exit!
    else
        #api operations status OK
        echo "API is operating as expected so API calls should work!" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo "Current Log output in file $logfilepath" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
    echo '-------------------------------------------------------------------------------------------------' | tee -a -i $logfilepath
    
    
    # -------------------------------------------------------------------------------------------------
    # -------------------------------------------------------------------------------------------------
    
    return $errorresult
}

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#CheckStatusOfAPI
#errorresult=$?
#if [ $errorresult -ne 0 ] ; then
    #api operations status NOT OK, so anything that is not a 0 result is a fail!
    #Do something based on it not being ready or working!
    
    #exit 1
#else
    #api operations status OK
    #Do something based on it being ready and working!
    
#fi

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# =================================================================================================
# START:  Setup Login Parameters and Mgmt_CLI handler procedures
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# HandleMgmtCLIPublish - publish changes if needed
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-09 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# HandleMgmtCLIPublish - publish changes if needed
#

HandleMgmtCLIPublish () {
    #
    # HandleMgmtCLIPublish - publish changes if needed
    #
    
    # APICLIsessionerrorfile is created at login
    #export APICLIsessionerrorfile=id.`date +%Y%m%d-%H%M%S%Z`.err
    echo > $APICLIsessionerrorfile
    echo 'mgmt_cli publish operation' > $APICLIsessionerrorfile
    echo > $APICLIsessionerrorfile
    
    if [ x"$script_use_publish" = x"true" ] ; then
        echo | tee -a -i $logfilepath
        echo 'Publish changes!' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        mgmt_cli publish -s $APICLIsessionfile >> $logfilepath 2>> $APICLIsessionerrorfile
        EXITCODE=$?
        cat $APICLIsessionerrorfile >> $logfilepath
        
        echo | tee -a -i $logfilepath
    else
        echo | tee -a -i $logfilepath
        echo 'Nothing to Publish!' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        EXITCODE=0
    fi
    
    return $EXITCODE
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-09

# -------------------------------------------------------------------------------------------------
# HandleMgmtCLILogout - Logout from mgmt_cli, also cleanup session file
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-09 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# Logout from mgmt_cli, also cleanup session file
#

HandleMgmtCLILogout () {
    #
    # HandleMgmtCLILogout - Logout from mgmt_cli, also cleanup session file
    #
    
    # APICLIsessionerrorfile is created at login
    #export APICLIsessionerrorfile=id.`date +%Y%m%d-%H%M%S%Z`.err
    echo > $APICLIsessionerrorfile
    echo 'mgmt_cli logout operation' > $APICLIsessionerrorfile
    echo > $APICLIsessionerrorfile
    
    echo | tee -a -i $logfilepath
    echo 'Logout of mgmt_cli!  Then remove session file : '$APICLIsessionfile | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    mgmt_cli logout -s $APICLIsessionfile >> $logfilepath 2>> $APICLIsessionerrorfile
    EXITCODE=$?
    cat $APICLIsessionerrorfile >> $logfilepath
    
    rm $APICLIsessionfile | tee -a -i $logfilepath
    rm $APICLIsessionerrorfile | tee -a -i $logfilepath
    
    return $EXITCODE
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-09

# -------------------------------------------------------------------------------------------------
# HandleMgmtCLILogin - Login to the API via mgmt_cli login
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-09 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# Login to the API via mgmt_cli login
#

HandleMgmtCLILogin () {
    #
    # Login to the API via mgmt_cli login
    #
    
    export loginstring=
    export loginparmstring=
    
    # MODIFIED 2018-05-04 -
    export APICLIsessionerrorfile=id.`date +%Y%m%d-%H%M%S%Z`.err
    echo 'API CLI Session Error File : '$APICLIsessionerrorfile > $APICLIsessionerrorfile
    echo >> $APICLIsessionerrorfile
    echo 'mgmt_cli login operation' >> $APICLIsessionerrorfile
    echo >> $APICLIsessionerrorfile
    
    # MODIFIED 2018-05-03 -
    if [ ! -z "$CLIparm_sessionidfile" ] ; then
        # CLIparm_sessionidfile value is set so use it
        export APICLIsessionfile=$CLIparm_sessionidfile
    else
        # Updated to make session id file unique in case of multiple admins running script from same folder
        export APICLIsessionfile=id.`date +%Y%m%d-%H%M%S%Z`.txt
    fi
    
    # MODIFIED 2018-05-03 -
    export domainnamenospace=
    if [ ! -z "$domaintarget" ] ; then
        # Handle domain name that might include space if the value is set
        #export domainnamenospace="$(echo -e "${domaintarget}" | tr -d '[:space:]')"
        #export domainnamenospace=$(echo -e ${domaintarget} | tr -d '[:space:]')
        export domainnamenospace=$(echo -e ${domaintarget} | tr ' ' '_')
    else
        export domainnamenospace=
    fi
    
    if [ ! -z "$domainnamenospace" ] ; then
        # Handle domain name that might include space
        if [ ! -z "$CLIparm_sessionidfile" ] ; then
            # adjust if CLIparm_sessionidfile was set, since that might be a complete path, append the path to it 
            export APICLIsessionfile=$APICLIsessionfile.$domainnamenospace
        else
            # assume the session file is set to a local file and prefix the domain to it
            export APICLIsessionfile=$domainnamenospace.$APICLIsessionfile
        fi
    fi
    
    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
        echo | tee -a -i $logfilepath
        echo 'APICLIwebsslport  :  '$APICLIwebsslport | tee -a -i $logfilepath
        echo 'APISessionTimeout :  '$APISessionTimeout | tee -a -i $logfilepath
        echo 'Domain Target     :  '$domaintarget | tee -a -i $logfilepath
        echo 'Domain no space   :  '$domainnamenospace | tee -a -i $logfilepath
        echo 'APICLIsessionfile :  '$APICLIsessionfile | tee -a -i $logfilepath
    else
        echo >> $logfilepath
        echo 'APICLIwebsslport  :  '$APICLIwebsslport >> $logfilepath
        echo 'APISessionTimeout :  '$APISessionTimeout >> $logfilepath
        echo 'Domain Target     :  '$domaintarget >> $logfilepath
        echo 'Domain no space   :  '$domainnamenospace >> $logfilepath
        echo 'APICLIsessionfile :  '$APICLIsessionfile >> $logfilepath
    fi
    
    echo | tee -a -i $logfilepath
    echo 'mgmt_cli Login!' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    
    if [ x"$CLIparm_rootuser" = x"true" ] ; then
        # Handle if ROOT User -r true parameter
        
        echo 'Login to mgmt_cli as root user -r true and save to session file :  '$APICLIsessionfile | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        # Handle management server parameter error if combined with ROOT User
        if [ x"$CLIparm_mgmt" != x"" ] ; then
            echo | tee -a -i $logfilepath
            echo 'mgmt_cli parameter error!!!!' | tee -a -i $logfilepath
            echo 'ROOT User (-r true) parameter can not be combined with -m <Management_Server>!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            return 254
        fi
        
        export loginparmstring=' -r true'
        
        if [ x"$domaintarget" != x"" ] ; then
            # Handle domain parameter for login string
            export loginparmstring=$loginparmstring" domain \"$domaintarget\""
            
            #
            # Testing - Dump login string built from parameters
            #
            if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                echo 'Execute login with loginparmstring '\"$loginparmstring\"' As Root with Domain '\"$domaintarget\" | tee -a -i $logfilepath
                echo | tee -a -i $logfilepath
            else
                echo 'Execute login with loginparmstring '\"$loginparmstring\"' As Root with Domain '\"$domaintarget\" >> $logfilepath
                echo >> $logfilepath
            fi
            
            mgmt_cli login -r true domain "$domaintarget" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
            EXITCODE=$?
            cat $APICLIsessionerrorfile >> $logfilepath
        else
            #
            # Testing - Dump login string built from parameters
            #
            if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                echo 'Execute login with loginparmstring '\"$loginparmstring\"' As Root' | tee -a -i $logfilepath
                echo | tee -a -i $logfilepath
            else
                echo 'Execute login with loginparmstring '\"$loginparmstring\"' As Root' >> $logfilepath
                echo >> $logfilepath
            fi
            
            mgmt_cli login -r true session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
            EXITCODE=$?
            cat $APICLIsessionerrorfile >> $logfilepath
        fi
    elif [ x"$CLIparm_api_key" != x"" ] ; then
        # Handle if --api-key parameter set
        
        echo 'Login to mgmt_cli with API key '\"$CLIparm_api_key\"' and save to session file :  '$APICLIsessionfile | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        if [ x"$domaintarget" != x"" ] ; then
            # Handle domain parameter for login string
            export loginparmstring=$loginparmstring" domain \"$domaintarget\""
            
            # Handle management server parameter for mgmt_cli parms
            if [ x"$CLIparm_mgmt" != x"" ] ; then
                export mgmttarget="-m \"$CLIparm_mgmt\""
                
                if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                    echo 'Execute login using API key' | tee -a -i $logfilepath
                    echo 'Execute operations with mgmttarget '\"$mgmttarget\"' to Domain '\"$domaintarget\" | tee -a -i $logfilepath
                    echo | tee -a -i $logfilepath
                else
                    echo 'Execute login using API key' >> $logfilepath
                    echo 'Execute operations with mgmttarget '\"$mgmttarget\"' to Domain '\"$domaintarget\" >> $logfilepath
                    echo >> $logfilepath
                fi
                
                mgmt_cli login api-key "$CLIparm_api_key" domain "$domaintarget" -m "$CLIparm_mgmt" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                EXITCODE=$?
                cat $APICLIsessionerrorfile >> $logfilepath
            else
                
                if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                    echo 'Execute login using API key to Domain '\"$domaintarget\" | tee -a -i $logfilepath
                    echo | tee -a -i $logfilepath
                else
                    echo 'Execute login using API key to Domain '\"$domaintarget\" >> $logfilepath
                    echo >> $logfilepath
                fi
                
                mgmt_cli login api-key "$CLIparm_api_key" domain "$domaintarget" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                EXITCODE=$?
                cat $APICLIsessionerrorfile >> $logfilepath
            fi
        else
            # Handle management server parameter for mgmt_cli parms
            if [ x"$CLIparm_mgmt" != x"" ] ; then
                export mgmttarget="-m \"$CLIparm_mgmt\""
                
                if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                    echo 'Execute login using API key' | tee -a -i $logfilepath
                    echo 'Execute operations with mgmttarget '\"$mgmttarget\" | tee -a -i $logfilepath
                    echo | tee -a -i $logfilepath
                else
                    echo 'Execute login using API key' >> $logfilepath
                    echo 'Execute operations with mgmttarget '\"$mgmttarget\" >> $logfilepath
                    echo >> $logfilepath
                fi
                
                mgmt_cli login api-key "$CLIparm_api_key" -m "$CLIparm_mgmt" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                EXITCODE=$?
                cat $APICLIsessionerrorfile >> $logfilepath
            else
                
                if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                    echo 'Execute login using API key' | tee -a -i $logfilepath
                    echo | tee -a -i $logfilepath
                else
                    echo 'Execute login using API key' >> $logfilepath
                    echo >> $logfilepath
                fi
                
                mgmt_cli login api-key "$CLIparm_api_key" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                EXITCODE=$?
                cat $APICLIsessionerrorfile >> $logfilepath
            fi
        fi
        
    else
        # Handle User
        
        echo 'Login to mgmt_cli as '$APICLIadmin' and save to session file :  '$APICLIsessionfile | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
        if [ x"$APICLIadmin" != x"" ] ; then
            export loginparmstring=$loginparmstring" user $APICLIadmin"
        else
            echo | tee -a -i $logfilepath
            echo 'mgmt_cli parameter error!!!!' | tee -a -i $logfilepath
            echo 'Admin User variable not set!!!' | tee -a -i $logfilepath
            echo | tee -a -i $logfilepath
            return 254
        fi
        
        if [ x"$CLIparm_password" != x"" ] ; then
            # Handle password parameter
            export loginparmstring=$loginparmstring" password \"$CLIparm_password\""
            
            if [ x"$domaintarget" != x"" ] ; then
                # Handle domain parameter for login string
                export loginparmstring=$loginparmstring" domain \"$domaintarget\""
                
                # Handle management server parameter for mgmt_cli parms
                if [ x"$CLIparm_mgmt" != x"" ] ; then
                    export mgmttarget="-m \"$CLIparm_mgmt\""
                    
                    #
                    # Testing - Dump login string built from parameters
                    #
                    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Password and Domain and Management' | tee -a -i $logfilepath
                        echo 'Execute operations with mgmttarget '\"$mgmttarget\"' to Domain '\"$domaintarget\" | tee -a -i $logfilepath
                        echo | tee -a -i $logfilepath
                    else
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Password and Domain and Management' >> $logfilepath
                        echo 'Execute operations with mgmttarget '\"$mgmttarget\"' to Domain '\"$domaintarget\" >> $logfilepath
                        echo >> $logfilepath
                    fi
                    
                    mgmt_cli login user $APICLIadmin password "$CLIparm_password" domain "$domaintarget" -m "$CLIparm_mgmt" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                    EXITCODE=$?
                    cat $APICLIsessionerrorfile >> $logfilepath
                else
                    #
                    # Testing - Dump login string built from parameters
                    #
                    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Password and Domain '\"$domaintarget\" | tee -a -i $logfilepath
                        echo | tee -a -i $logfilepath
                    else
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Password and Domain '\"$domaintarget\" >> $logfilepath
                        echo >> $logfilepath
                    fi
                    
                    mgmt_cli login user $APICLIadmin password "$CLIparm_password" domain "$domaintarget" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                    EXITCODE=$?
                    cat $APICLIsessionerrorfile >> $logfilepath
                fi
            else
                # Handle management server parameter for mgmt_cli parms
                if [ x"$CLIparm_mgmt" != x"" ] ; then
                    export mgmttarget='-m \"$CLIparm_mgmt\"'
                    
                    #
                    # Testing - Dump login string built from parameters
                    #
                    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Password and Management' | tee -a -i $logfilepath
                        echo 'Execute operations with mgmttarget '\"$mgmttarget\" | tee -a -i $logfilepath
                        echo | tee -a -i $logfilepath
                    else
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Password and Management' >> $logfilepath
                        echo 'Execute operations with mgmttarget '\"$mgmttarget\" >> $logfilepath
                        echo >> $logfilepath
                    fi
                    
                    mgmt_cli login user $APICLIadmin password "$CLIparm_password" -m "$CLIparm_mgmt" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                    EXITCODE=$?
                    cat $APICLIsessionerrorfile >> $logfilepath
                else
                    #
                    # Testing - Dump login string built from parameters
                    #
                    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Password' | tee -a -i $logfilepath
                        echo | tee -a -i $logfilepath
                    else
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Password' >> $logfilepath
                        echo >> $logfilepath
                    fi
                    
                    mgmt_cli login user $APICLIadmin password "$CLIparm_password" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                    EXITCODE=$?
                    cat $APICLIsessionerrorfile >> $logfilepath
                fi
            fi
        else
            # Handle NO password parameter
            
            if [ x"$domaintarget" != x"" ] ; then
                # Handle domain parameter for login string
                export loginparmstring=$loginparmstring" domain \"$domaintarget\""
                
                # Handle management server parameter for mgmt_cli parms
                if [ x"$CLIparm_mgmt" != x"" ] ; then
                    export mgmttarget="-m \"$CLIparm_mgmt\""
                    
                    #
                    # Testing - Dump login string built from parameters
                    #
                    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Domain and Management' | tee -a -i $logfilepath
                        echo 'Execute operations with mgmttarget '\"$mgmttarget\"' to Domain '\"$domaintarget\" | tee -a -i $logfilepath
                        echo | tee -a -i $logfilepath
                    else
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Domain and Management' >> $logfilepath
                        echo 'Execute operations with mgmttarget '\"$mgmttarget\"' to Domain '\"$domaintarget\" >> $logfilepath
                        echo >> $logfilepath
                    fi
                    
                    mgmt_cli login user $APICLIadmin domain "$domaintarget" -m "$CLIparm_mgmt" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                    EXITCODE=$?
                    cat $APICLIsessionerrorfile >> $logfilepath
                else
                    #
                    # Testing - Dump login string built from parameters
                    #
                    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Domain '\"$domaintarget\" | tee -a -i $logfilepath
                        echo | tee -a -i $logfilepath
                    else
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Domain '\"$domaintarget\" >> $logfilepath
                        echo >> $logfilepath
                    fi
                    
                    mgmt_cli login user $APICLIadmin domain "$domaintarget" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                    EXITCODE=$?
                    cat $APICLIsessionerrorfile >> $logfilepath
                fi
            else
                # Handle management server parameter for mgmt_cli parms
                if [ x"$CLIparm_mgmt" != x"" ] ; then
                    export mgmttarget='-m \"$CLIparm_mgmt\"'
                    
                    #
                    # Testing - Dump login string built from parameters
                    #
                    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Management' | tee -a -i $logfilepath
                        echo 'Execute operations with mgmttarget '\"$mgmttarget\" | tee -a -i $logfilepath
                        echo | tee -a -i $logfilepath
                    else
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User with Management' >> $logfilepath
                        echo 'Execute operations with mgmttarget '\"$mgmttarget\" >> $logfilepath
                        echo >> $logfilepath
                    fi
                    
                    mgmt_cli login user $APICLIadmin -m "$CLIparm_mgmt" session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                    EXITCODE=$?
                    cat $APICLIsessionerrorfile >> $logfilepath
                else
                    #
                    # Testing - Dump login string built from parameters
                    #
                    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User' | tee -a -i $logfilepath
                        echo | tee -a -i $logfilepath
                    else
                        echo 'Execute login with loginparmstring '\"$loginparmstring\"' As User' >> $logfilepath
                        echo >> $logfilepath
                    fi
                    
                    mgmt_cli login user $APICLIadmin session-timeout $APISessionTimeout --port $APICLIwebsslport -f json > $APICLIsessionfile 2>> $APICLIsessionerrorfile
                    EXITCODE=$?
                    cat $APICLIsessionerrorfile >> $logfilepath
                fi
            fi
        fi
    fi
    
    if [ "$EXITCODE" != "0" ] ; then
        
        echo | tee -a -i $logfilepath
        echo 'mgmt_cli login error!  EXITCODE = '$EXITCODE | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        cat $APICLIsessionfile | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        return 255
        
    else
        
        echo "mgmt_cli login success!" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        cat $APICLIsessionfile | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        
    fi
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-09

# -------------------------------------------------------------------------------------------------
# SetupLogin2MgmtCLI - Setup Login to Management CLI
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-09 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

SetupLogin2MgmtCLI () {
    #
    # setup the mgmt_cli login fundamentals
    #
    
    #export APICLIwebsslport=$currentapisslport
    
    if [ ! -z "$CLIparm_mgmt" ] ; then
        # working with remote management server
        if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
            echo 'Working with remote management server' | tee -a -i $logfilepath
        fi
        
        # MODIFIED 2020-09-09 -
        # Stipulate that if running on the actual management host, use it's web ssl-port value
        # unless we're running with the management server setting CLIparm_mgmt, then use the
        # passed parameter from the CLI or default to 443
        #
        if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
            echo | tee -a -i $logfilepath
            echo 'Initial $APICLIwebsslport   = '$APICLIwebsslport | tee -a -i $logfilepath
            echo 'Current $CLIparm_websslport = '$CLIparm_websslport | tee -a -i $logfilepath
        fi
        
        if [ ! -z "$CLIparm_websslport" ] ; then
            if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                echo 'Working with web ssl-port from CLI parms' | tee -a -i $logfilepath
            fi
            export APICLIwebsslport=$CLIparm_websslport
        else
            # Default back to expected SSL port, since we won't know what the remote management server configuration for web ssl-port is.
            # This may change once Gaia API is readily available and can be checked.
            if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                echo 'Remote management cannot currently be queried for web ssl-port, so defaulting to 443' | tee -a -i $logfilepath
            fi
            export APICLIwebsslport=443
        fi
    else
        # not working with remote management server
        if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
            echo 'Not working with remote management server' | tee -a -i $logfilepath
        fi
        
        # MODIFIED 2020-09-09 -
        # Stipulate that if running on the actual management host, use it's web ssl-port value
        # unless we're running with the management server setting CLIparm_mgmt, then use the
        # passed parameter from the CLI or default to 443
        #
        if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
            echo | tee -a -i $logfilepath
            echo 'Initial $APICLIwebsslport   = '$APICLIwebsslport | tee -a -i $logfilepath
            echo 'Current $CLIparm_websslport = '$CLIparm_websslport | tee -a -i $logfilepath
            echo 'Current $currentapisslport  = '$currentapisslport | tee -a -i $logfilepath
        fi
        
        if [ ! -z "$CLIparm_websslport" ] ; then
            if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                echo 'Working with web ssl-port from CLI parms' | tee -a -i $logfilepath
            fi
            export APICLIwebsslport=$CLIparm_websslport
        else
            if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
                echo 'Working with web ssl-port harvested from Gaia' | tee -a -i $logfilepath
            fi
            export APICLIwebsslport=$currentapisslport
        fi
    fi
    
    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
        echo 'Final $APICLIwebsslport     = '$APICLIwebsslport | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
    fi
    # ADDED 2020-09-09 -
    # Handle login session-timeout parameter
    #
    
    export APISessionTimeout=600
    
    MinAPISessionTimeout=10
    MaxAPISessionTimeout=3600
    DefaultAPISessionTimeout=600
    
    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
        echo | tee -a -i $logfilepath
        echo 'Initial $APISessionTimeout      = '$APISessionTimeout | tee -a -i $logfilepath
        echo 'Current $CLIparm_sessiontimeout = '$CLIparm_sessiontimeout | tee -a -i $logfilepath
    fi
    
    if [ ! -z $CLIparm_sessiontimeout ]; then
        # CLI Parameter for session-timeout was passed
        if [ $CLIparm_sessiontimeout -lt $MinAPISessionTimeout ] ||  [ $CLIparm_sessiontimeout -gt $MaxAPISessionTimeout ]; then
            # parameter is outside of range for MinAPISessionTimeout to MaxAPISessionTimeout
            echo 'Value of $CLIparm_sessiontimeout ('$CLIparm_sessiontimeout') is out side of allowed range!' | tee -a -i $logfilepath
            echo 'Allowed session-timeout value range is '$MinAPISessionTimeout' to '$MaxAPISessionTimeout | tee -a -i $logfilepath
            export APISessionTimeout=$DefaultAPISessionTimeout
        else
            # parameter is within range for MinAPISessionTimeout to MaxAPISessionTimeout
            export APISessionTimeout=$CLIparm_sessiontimeout
        fi
    else
        # CLI Parameter for session-timeout not set
        export APISessionTimeout=$DefaultAPISessionTimeout
    fi
    
    if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
        echo | tee -a -i $logfilepath
        echo 'Final $APISessionTimeout       = '$APISessionTimeout | tee -a -i $logfilepath
    fi
    
    # MODIFIED 2018-05-03 -
    
    # ================================================================================================
    # NOTE:  APICLIadmin value must be set to operate this script, removing this varaiable will lead
    #        to logon failure with mgmt_cli logon.  Root User (-r) parameter is handled differently,
    #        so DO NOT REMOVE OR CLEAR this variable.  Adjust the export APICLIadmin= line to reflect
    #        the default administrator name for the environment
    #
    #        The value for APICLIadmin now is set by the value of DefaultMgmtAdmin found at the top 
    #        of the script in the 'Root script declarations' section.
    #
    # ================================================================================================
    if [ ! -z "$CLIparm_user" ] ; then
        export APICLIadmin=$CLIparm_user
    elif [ ! -z "$DefaultMgmtAdmin" ] ; then
        export APICLIadmin=$DefaultMgmtAdmin
    else
        #export APICLIadmin=administrator
        #export APICLIadmin=admin
        export APICLIadmin=$DefaultMgmtAdmin
    fi
    
    # Clear variables that need to be set later
    
    export mgmttarget=
    export domaintarget=
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-09

# -------------------------------------------------------------------------------------------------
# Login2MgmtCLI - Process Login to Management CLI
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Login2MgmtCLI () {
    #
    # Execute the mgmt_cli login and address results
    #
    
    HandleMgmtCLILogin
    SUBEXITCODE=$?
    
    if [ "$SUBEXITCODE" != "0" ] ; then
    
        echo | tee -a -i $logfilepath
        echo "Terminating script..." | tee -a -i $logfilepath
        echo "Exitcode $SUBEXITCODE" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo "Log output in file $logfilepath" | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        return $SUBEXITCODE
        
    else
        echo | tee -a -i $logfilepath
    fi
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# APIMgmtCLIINIT - 
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

APIMgmtCLIINIT () {
    #
    
    # -------------------------------------------------------------------------------------------------
    # Make sure API is up and running if we are doing API work
    # -------------------------------------------------------------------------------------------------
    
    # MODIFIED 2020-09-11 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
    #
    
    CheckStatusOfAPI
    errorresult=$?
    if [ $errorresult -ne 0 ] ; then
        #api operations status NOT OK, so anything that is not a 0 result is a fail!
        #Do something based on it not being ready or working!
        
        echo "API Error!" | tee -a -i $logfilepath
        echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
        echo | tee -a -i $logfilepath
        echo 'Log output in file   : '"$logfilepath" | tee -a -i $logfilepath
        
        exit 1
    else
        #api operations status OK
        #Do something based on it being ready and working!
        
        echo "API OK, proceeding!" >> $logfilepath
    fi
    
    GaiaWebSSLPortCheck
    
    export CheckAPIVersion=
    
    ScriptAPIVersionCheck
    
    #
    # /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-09-11
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# =================================================================================================
# END:  Setup Login Parameters and Mgmt_CLI handler procedures
# =================================================================================================
# =================================================================================================

export mcao_script_action=$1

# Commands to execute specific actions in this script:
# INIT        - Initialize the API operations with checks of wether API is running, get port, API minimum version
# SETUP       - Execute setup of API login based on CLI parameters passed and processed previously
# LOGIN       - Execute API login based on CLI parameters passed and processed previously
# PUBLISH     - Execute API publish based on previous login and session file
# LOGOUT      - Execute API logout based on previous login and session file
# APISTATUS   - Execute just the API Status check

case "mcao_script_action" in
    INIT ) 
        # Handle Initialization
        APIMgmtCLIINIT "$@"
        ;;
    SETUP ) 
        # Handle Setup
        SetupLogin2MgmtCLI "$@"
        ;;
    LOGIN ) 
        # Handle Login
        Login2MgmtCLI "$@"
        ;;
    PUBLISH ) 
        # Handle Publish
        HandleMgmtCLIPublish "$@"
        ;;
    LOGOUT ) 
        # Handle Logout
        HandleMgmtCLILogout "$@"
        ;;
    APISTATUS ) 
        # Handle API Status Check
        CheckStatusOfAPI
        errorresult=$?
        ;;
    *)
        # Handle missing parameter
        ;;
esac


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# =================================================================================================
# END:  _template sub script
# =================================================================================================
# =================================================================================================

return 0


# =================================================================================================
# END:  
# =================================================================================================
# =================================================================================================


