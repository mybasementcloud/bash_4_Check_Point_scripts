#!/bin/bash
#
# SCRIPT Template for CLI Operations for command line parameters handling
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
SubScriptDate=2020-12-22
SubScriptVersion=05.02.00
SubScriptRevision=000
TemplateVersion=05.02.00
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.02.00
SubScriptTemplateVersion=05.02.00
#

BASHActualSubScriptVersion=v${SubScriptVersion}
BASHActualSubScriptVersionX=v${SubScriptVersion//./x}

BASHSubScriptsVersion=v${SubScriptsVersion}
BASHSubScriptsRevision=v${SubScriptRevision}

BASHSubScriptsVersionX=v${SubScriptsVersion//./x}
BASHSubScriptsRevisionX=v${SubScriptRevision//./x}

#export BASHExpectedSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion//./x}
BASHActualSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion}
BASHActualSubScriptsVersionX=${SubScriptsLevel}.v${SubScriptsVersion//./x}

BASHSubScriptsTemplateVersion=v${SubScriptTemplateVersion}
BASHSubScriptsTemplateVersionX=v${SubScriptTemplateVersion//./x}
BASHSubScriptsTemplateLevel=${TemplateLevel}.v${SubScriptTemplateVersion}
BASHSubScriptsTemplateLevelX=${TemplateLevel//./x}.v${SubScriptTemplateVersion//./x}

BASHSubScriptScriptTemplateVersion=v${TemplateVersion}
BASHSubScriptScriptTemplateLevel=${TemplateLevel}.v${TemplateVersion}
BASHSubScriptScriptTemplateVersionX=v${TemplateVersion//./x}
BASHSubScriptScriptTemplateLevelX=${TemplateLevel//./x}.v${TemplateVersion//./x}


SubScriptFileNameRoot=cmd_line_parameters_handler
SubScriptShortName="cliparms.${SubScriptsLevel}"
SubScriptDescription="Command line parameters handler"

#SubScriptName=$SubScriptFileNameRoot.subscript.${SubScriptsLevel}.v${SubScriptVersion}
SubScriptName=$SubScriptFileNameRoot.subscript.${SubScriptsLevel}.v${SubScriptVersion}

SubScriptHelpFileName=${SubScriptFileNameRoot}.help
SubScriptHelpFilePath=help.v${SubScriptVersion}
SubScriptHelpFile=${SubScriptHelpFilePath}/${SubScriptHelpFileName}


# =================================================================================================
# =================================================================================================
# START sub script:  Handle Command Line Parameters
# =================================================================================================


if ${SCRIPTVERBOSE} ; then
    echo | tee -a -i ${logfilepath}
    echo 'Subscript Name:  '${SubScriptName}'  Subscript Version: '${SubScriptVersion}'  Subscript Revision:  '${SubScriptRevision}'  Level:  '${SubScriptsLevel}'  Template Version: '${TemplateVersion} | tee -a -i ${logfilepath}
    echo ${SubScriptDescription} | tee -a -i ${logfilepath}
    echo 'Subscript Starting...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
else
    echo >> ${logfilepath}
    echo 'Subscript Name:  '${SubScriptName}'  Subscript Version: '${SubScriptVersion}'  Subscript Revision:  '${SubScriptRevision}'  Level:  '${SubScriptsLevel}'  Template Version: '${TemplateVersion} >> ${logfilepath}
    echo ${SubScriptDescription}>> ${logfilepath}
    echo 'Subscript Starting...' >> ${logfilepath}
    echo >> ${logfilepath}
fi


# =================================================================================================
# Validate Sub-Script template version is correct for caller
# =================================================================================================


# MODIFIED 2020-11-19 -

if [ x"${BASHExpectedSubScriptsVersion}" = x"${BASHActualSubScriptsVersion}" ] ; then
    # Script and Actions Script versions match, go ahead
    echo >> ${logfilepath}
    echo 'Verify Actions Scripts Version - OK' >> ${logfilepath}
    echo >> ${logfilepath}
else
    # Script and Actions Script versions don't match, ALL STOP!
    echo | tee -a -i ${logfilepath}
    echo 'Verify Actions Scripts Version - Missmatch' | tee -a -i ${logfilepath}
    echo 'Raw Script name            : '$0 | tee -a -i ${logfilepath}
    echo 'Subscript version name     : '${SubScriptsVersion}' '${SubScriptName} | tee -a -i ${logfilepath}
    echo 'Calling Script version     : '${ScriptVersion} | tee -a -i ${logfilepath}
    echo 'Expected Subscript version : '${BASHExpectedSubScriptsVersion} | tee -a -i ${logfilepath}
    echo 'Current  Subscript version : '${BASHActualSubScriptsVersion} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 250
fi


# =================================================================================================
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# Handle important basics
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# START Procedures:  Local Proceedures - 
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# CheckScriptVerboseOutput - Check if verbose output is configured externally
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# CheckScriptVerboseOutput - Check if verbose output is configured externally via shell level 
# parameter setting, if it is, the check it for correct and valid values; otherwise, if set, then
# reset to false because wrong.
#

CheckScriptVerboseOutput () {
    
    export B4CPSCRIPTVERBOSECHECK=false
    
    if [ -z ${SCRIPTVERBOSE} ] ; then
        # Verbose mode not set from shell level
        echo "!! Verbose mode not set from shell level" >> ${logfilepath}
        export B4CPSCRIPTVERBOSE=false
        echo >> ${logfilepath}
    elif [ x"`echo "${SCRIPTVERBOSE}" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
        # Verbose mode set OFF from shell level
        echo "!! Verbose mode set OFF from shell level" >> ${logfilepath}
        export B4CPSCRIPTVERBOSE=false
        echo >> ${logfilepath}
    elif [ x"`echo "${SCRIPTVERBOSE}" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
        # Verbose mode set ON from shell level
        echo "!! Verbose mode set ON from shell level" >> ${logfilepath}
        export B4CPSCRIPTVERBOSE=true
        echo >> ${logfilepath}
        echo 'Script :  '$0 >> ${logfilepath}
        echo 'Verbose mode enabled' >> ${logfilepath}
        echo >> ${logfilepath}
    elif ${SCRIPTVERBOSE} ; then
        # Verbose mode set ON
        export B4CPSCRIPTVERBOSE=true
        echo >> ${logfilepath}
        echo 'Script :  '$0 >> ${logfilepath}
        echo 'Verbose mode enabled' >> ${logfilepath}
        echo >> ${logfilepath}
    elif ${SCRIPTVERBOSE} ; then
        # Verbose mode set ON
        export B4CPSCRIPTVERBOSE=true
        echo >> ${logfilepath}
        echo 'Script :  '$0 >> ${logfilepath}
        echo 'Verbose mode enabled' >> ${logfilepath}
        echo >> ${logfilepath}
    elif ${SCRIPTVERBOSE} ; then
        # Verbose mode set ON
        export B4CPSCRIPTVERBOSE=true
        echo >> ${logfilepath}
        echo 'Script :  '$0 >> ${logfilepath}
        echo 'Verbose mode enabled' >> ${logfilepath}
        echo >> ${logfilepath}
    else
        # Verbose mode set to wrong value from shell level
        echo "!! Verbose mode set to wrong value from shell level >"${SCRIPTVERBOSE}"<" >> ${logfilepath}
        echo "!! Settting Verbose mode OFF, pending command line parameter checking!" >> ${logfilepath}
        export B4CPSCRIPTVERBOSE=false
        export SCRIPTVERBOSE=false
        echo >> ${logfilepath}
    fi
    
    export B4CPSCRIPTVERBOSECHECK=true
    
    echo >> ${logfilepath}
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------



# =================================================================================================
# END Procedures:  Local Proceedures
# =================================================================================================


# MODIFIED 2019-01-18 -
# Command Line Parameter Handling Action Script should only do this if we didn't do it in the calling script

if ${B4CPSCRIPTVERBOSECHECK} ; then
    # Already checked status of ${B4CPSCRIPTVERBOSE}
    echo "Status of verbose output at start of command line handler: ${B4CPSCRIPTVERBOSE}"
else
    # Need to check status of ${B4CPSCRIPTVERBOSE}
    
    CheckScriptVerboseOutput
    
    echo "Status of verbose output at start of command line handler: ${B4CPSCRIPTVERBOSE}" >> ${logfilepath}
fi


# =================================================================================================
# -------------------------------------------------------------------------------------------------
# START:  command line parameter processing proceedures
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# dumpcliparmparseresults
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-05-31 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

dumpcliparmparseresults () {
    #
    # Testing - Dump acquired values
    #
    #
    
    workoutputfile=/var/tmp/workoutputfile.1.${DATEDTGS}.txt
    echo > ${workoutputfile}
    
    # Screen width template for sizing, default width of 80 characters assumed
    #
    #                  1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    
    echo 'CLI Parameters :' >> ${workoutputfile}
    echo >> ${workoutputfile}
    
    if ${UseR8XAPI} ; then
        
        echo 'CLIparm_rootuser        = '${CLIparm_rootuser} >> ${workoutputfile}
        echo 'CLIparm_user            = '${CLIparm_user} >> ${workoutputfile}
        echo 'CLIparm_password        = '${CLIparm_password} >> ${workoutputfile}
        
        echo 'CLIparm_api_key         = '${CLIparm_api_key} >> ${workoutputfile}
        echo 'CLIparm_use_api_key     = '${CLIparm_use_api_key} >> ${workoutputfile}
        
        echo 'CLIparm_websslport      = '${CLIparm_websslport} >> ${workoutputfile}
        echo 'CLIparm_mgmt            = '${CLIparm_mgmt} >> ${workoutputfile}
        echo 'CLIparm_domain          = '${CLIparm_domain} >> ${workoutputfile}
        echo 'CLIparm_sessionidfile   = '${CLIparm_sessionidfile} >> ${workoutputfile}
        echo 'CLIparm_sessiontimeout  = '${CLIparm_sessiontimeout} >> ${workoutputfile}
        
    fi
    
    # Screen width template for sizing, default width of 80 characters assumed
    #
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    
    echo 'CLIparm_logpath         = '${CLIparm_logpath} >> ${workoutputfile}
    echo 'CLIparm_outputpath      = '${CLIparm_outputpath} >> ${workoutputfile}
    
    echo  >> ${workoutputfile}
    echo 'SHOWHELP                = '${SHOWHELP} >> ${workoutputfile}
    echo 'SCRIPTVERBOSE           = '${SCRIPTVERBOSE} >> ${workoutputfile}
    echo 'B4CPSCRIPTVERBOSE       = '${B4CPSCRIPTVERBOSE} >> ${workoutputfile}
    echo 'NOWAIT                  = '${NOWAIT} >> ${workoutputfile}
    echo 'CLIparm_NOWAIT          = '${CLIparm_NOWAIT} >> ${workoutputfile}
    
    echo  >> ${workoutputfile}
    echo 'NOSTART                 = '${NOSTART} >> ${workoutputfile}
    echo 'CLIparm_NOSTART         = '${CLIparm_NOSTART} >> ${workoutputfile}
    
    echo  >> ${workoutputfile}
    echo 'CLIparm_NOHUP           = '${CLIparm_NOHUP} >> ${workoutputfile}
    echo 'CLIparm_NOHUPScriptName = '${CLIparm_NOHUPScriptName} >> ${workoutputfile}
    echo 'CLIparm_NOHUPDTG        = '${CLIparm_NOHUPDTG} >> ${workoutputfile}
    
    echo  >> ${workoutputfile}
    echo 'remains                 = '${REMAINS} >> ${workoutputfile}
    
    if ${B4CPSCRIPTVERBOSE} ; then
        # Verbose mode ON
        
        echo | tee -a -i ${logfilepath}
        cat ${workoutputfile} | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        echo "Number parms $#" | tee -a -i ${logfilepath}
        echo "parms raw : \> $@ \<" | tee -a -i ${logfilepath}
        
        parmnum=0
        for k ; do
            echo -e "${parmnum} \t ${k}" | tee -a -i ${logfilepath}
            parmnum=`expr ${parmnum} + 1`
        done
        
        echo | tee -a -i ${logfilepath}
    else
        # Verbose mode OFF
        
        echo >> ${logfilepath}
        cat ${workoutputfile} >> ${logfilepath}
        echo "Number parms $#" >> ${logfilepath}
        echo "parms raw : \> $@ \<" >> ${logfilepath}
        
        parmnum=0
        for k ; do
            echo -e "${parmnum} \t ${k}" >> ${logfilepath}
            parmnum=`expr ${parmnum} + 1`
        done
        
        echo >> ${logfilepath}
    fi
    
    rm ${workoutputfile}
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2019-05-31


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# dumprawcliparms
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-05-31 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

dumprawcliparms () {
    #
    if ${B4CPSCRIPTVERBOSE} ; then
        # Verbose mode ON
        
        echo | tee -a -i ${logfilepath}
        echo "Command line parameters before : " | tee -a -i ${logfilepath}
        echo "Number parms $#" | tee -a -i ${logfilepath}
        echo "parms raw : \> $@ \<" | tee -a -i ${logfilepath}
        
        parmnum=0
        for k ; do
            echo -e "${parmnum} \t ${k}" | tee -a -i ${logfilepath}
            parmnum=`expr ${parmnum} + 1`
        done
        
        echo | tee -a -i ${logfilepath}
        
    else
        # Verbose mode OFF
        
        echo >> ${logfilepath}
        echo "Command line parameters before : " >> ${logfilepath}
        echo "Number parms $#" >> ${logfilepath}
        echo "parms raw : \> $@ \<" >> ${logfilepath}
        
        parmnum=0
        for k ; do
            echo -e "${parmnum} \t ${k}" >> ${logfilepath}
            parmnum=`expr ${parmnum} + 1`
        done
        
        echo >> ${logfilepath}
        
    fi

}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2019-05-31


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# START:  Common Help display proceedure
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-19 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# Show help information

doshowhelp () {
    #
    # Screen width template for sizing, default width of 80 characters assumed
    #
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    echo
    echo -n $0' [-?][-v]|'
    if ${UseR8XAPI} ; then
        echo -n '|[-r]|[[-u <admin_name>]|[-p <password>]]|[--api-key <api_key_value>]'
        echo -n '|[-P <web ssl port>]'
        echo -n '|[-m <server_IP>]'
        echo -n '|[-d <domain>]'
        echo -n '|[-s <session_file_filepath>]|[--session-timeout <session_time_out>]'
    fi
    echo -n '|[-l <log_path>]'
    echo -n '|[-o <output_path>]'
    
    # Finish the line started above!
    echo
    
    echo
    echo ' Script Version:  '$BASHScriptVersion'  Date:  '${ScriptDate}
    echo
    echo ' Standard Command Line Parameters: '
    echo
    echo '  Show Help                  -? | --help'
    echo '  Verbose mode               -v | --verbose'
    echo
    
    # Handle Local Help file here, since the values are more specific to the script
    # MODIFIED 2020-02-11
    localhelpfile=${scriptspathroot}/$BASHScriptsFolder/${BASHScriptHelpFile}
    
    # Show Local Help
    if [ -r $localhelpfile ]; then
        #we have a script specific help file!
        cat $localhelpfile
        echo
    fi
    
    
    if ${UseR8XAPI} ; then
        
        echo '  Authenticate as root       -r | --root'
        echo '  Set Console User Name      -u <admin_name> | --user <admin_name> |'
        echo '                             -u=<admin_name> | --user=<admin_name>'
        echo '  Set Console User password  -p <password> | --password <password> |'
        echo '                             -p=<password> | --password=<password>'
        echo
        echo '  Set Console User API Key    --api-key "<api_key_value>" | '
        echo '                              --api-key="<api_key_value>"'
        echo
        echo '  Set [web ssl] Port         -P <web-ssl-port> | --port <web-ssl-port> |'
        echo '                             -P=<web-ssl-port> | --port=<web-ssl-port>'
        echo '  Set Management Server IP   -m <server_IP> | --management <server_IP> |'
        echo '                             -m=<server_IP> | --management=<server_IP>'
        echo '  Set Management Domain      -d <domain> | --domain <domain> |'
        echo '                             -d=<domain> | --domain=<domain>'
        echo '  Set session file path      -s <session_file_filepath> |'
        echo '                             --session-file <session_file_filepath> |'
        echo '                             -s=<session_file_filepath> |'
        echo '                             --session-file=<session_file_filepath>'
        echo '  Set session timeout value  --session-timeout <session_time_out> |'
        echo '                             --session-timeout=<session_time_out>'
        echo '      Default = 600 seconds, allowed range of values 10 - 3600 seconds'
        echo
        
    fi
    
    echo '  Set log file path          -l <log_path> | --log-path <log_path> |'
    echo '                             -l=<log_path> | --log-path=<log_path>'
    echo '  Set output file path       -o <output_path> | --output <output_path> |'
    echo '                             -o=<output_path> | --output=<output_path>'
    echo
    echo '  No waiting in verbose mode --NOWAIT'
    echo
    
    echo '  Check Point services:      '
    echo '      DO NOT start services  --NOSTART'
    echo '      Start services         --RESTART'
    echo
    
    echo '  Operating in nohup mode    --NOHUP'
    echo '  nohup script as called     --NOHUP-Script <NOHUP_SCRIPT_NAME> | --NOHUP-Script=<NOHUP_SCRIPT_NAME>'
    echo '  nohup date-time-group      --NOHUP-DTG <NOHUP_SCRIPT_DATE_TIME_GROUP> | --NOHUP-DTG=<NOHUP_SCRIPT_DATE_TIME_GROUP>'
    echo
    
    if ${UseR8XAPI} ; then
        echo '  session_file_filepath = fully qualified file path for session file'
    fi
    echo '  log_path = fully qualified folder path for log files'
    echo '  output_path = fully qualified folder path for output files'
    
    if ${UseR8XAPI} ; then
        #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
        #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        echo
        echo ' NOTE:  Only use Management Server IP (-m) parameter if operating from a '
        echo '        different host than the management host itself.'
        echo
        echo ' NOTE:  Use the Domain Name (text) with the Domain (-d) parameter when'
        echo '        Operating in Multi Domain Management environment.'
        echo '        Use the "Global" domain for the global domain objects.'
        echo '          Quotes NOT required!'
        echo '        Use the "System Data" domain for system domain objects.'
        echo '          Quotes REQUIRED!'
        echo
        
        echo ' Example: General :'
        echo
        echo ' ]# '$ScriptName' -u fooAdmin -p voodoo -P 4434 -m 192.168.1.1 -d fooville -s "/var/tmp/id.txt" -l "/var/tmp/script_dump"'
        echo
        echo ' ]# '$ScriptName' -u fooAdmin -p voodoo -P 4434 -d Global -s "/var/tmp/id.txt"'
        echo ' ]# '$ScriptName' -u fooAdmin -p voodoo -P 4434 -d "System Data" -s "/var/tmp/id.txt"'
        echo ' ]# '$ScriptName' -r -v --NOWAIT P 4434 -d "System Data" -s "/var/tmp/id.txt" --NOHUP --NOHUP-Script=Dump_Domains_to_Array'
        echo
        echo ' ]# '$ScriptName' --api-key '\"'@#ohtobeanapikey%'\"' -P 4434'
        
    else
        
        #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
        #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        
        echo
    fi
    
    echo ' ]# '$ScriptName' -v -o "/var/tmp/script_ouput" -l "/var/tmp/script_logs"'
    echo ' ]# '$ScriptName' -v --NOWAIT --NOSTART'
    echo ' ]# '$ScriptName' -v --NOWAIT --NOHUP'
    echo ' ]# '$ScriptName' -v --NOWAIT --NOHUP --NOHUP-Script=Gaia_Version_Type'
    echo ' ]# '$ScriptName' -v --NOWAIT --NOHUP --NOHUP-Script=Gaia_Version_Type --NOHUP-DTG=2020-09-11-1111GMT'
    
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    
    echo
    return 1
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-11-19


# -------------------------------------------------------------------------------------------------
# END:  Common Help display proceedure
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Process command line parameters for enabling verbose output
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-09-02 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

ProcessCommandLIneParameterVerboseEnable () {
    
    while [ -n "$1" ]; do
        # Copy so we can modify it (can't modify $1)
        OPT="$1"
        
        #echo OPT = ${OPT}
        
        # Parse current opt
        while [ x"${OPT}" != x"-" ] ; do
            case "${OPT}" in
                # Help and Standard Operations
                '-v' | --verbose )
                    export B4CPSCRIPTVERBOSE=true
                    ;;
                # Anything else is ignored
                * )
                    break
                    ;;
            esac
            # Check for multiple short options
            # NOTICE: be sure to update this pattern to match valid options
            # Remove any characters matching "-", and then the values between []'s
            #NEXTOPT="${OPT#-[upmdsor?]}" # try removing single short opt
            NEXTOPT="${OPT#-[vrf?]}" # try removing single short opt
            if [ x"${OPT}" != x"${NEXTOPT}" ] ; then
                OPT="-${NEXTOPT}"  # multiple short opts, keep going
            else
                break  # long form, exit inner loop
            fi
        done
        # Done with that param. move to next
        shift
    done
    # Set the non-parameters back into the positional parameters ($1 $2 ..)
    
    
    return 0
}

# -------------------------------------------------------------------------------------------------
# Procedure Call:  Process command line parameters for enabling verbose output
# -------------------------------------------------------------------------------------------------

#ProcessCommandLIneParameterVerboseEnable $@

# -------------------------------------------------------------------------------------------------
# END Procedure:  Process command line parameters for enabling verbose output
# -------------------------------------------------------------------------------------------------

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-09-02


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Process command line parameters and set appropriate values
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-09-02 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

ProcessCommandLineParametersAndSetValues () {
    
    # MODIFIED 2020-11-19 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
    #
    
    #rawcliparmdump=false
    #if ${B4CPSCRIPTVERBOSE} ; then
        #Verbose mode ON
        #dumprawcliparms "$@"
        #rawcliparmdump=true
    #fi
    
    while [ -n "$1" ]; do
        # Copy so we can modify it (can't modify $1)
        OPT="$1"
        
        # testing
        #echo 'OPT = '${OPT}
        #
        
        # Detect argument termination
        if [ x"${OPT}" = x"--" ]; then
            # testing
            # echo "Argument termination"
            #
            
            shift
            for OPT ; do
                # MODIFIED 2019-03-08
                #REMAINS="${REMAINS} \"${OPT}\""
                REMAINS="${REMAINS} ${OPT}"
            done
            break
        fi
        
        # Parse current opt
        while [ x"${OPT}" != x"-" ] ; do
            case "${OPT}" in
                # Help and Standard Operations
                '-?' | --help )
                    SHOWHELP=true
                    ;;
                # Handle immediate opts like this
                '-v' | --verbose )
                    export B4CPSCRIPTVERBOSE=true
                    #if ! $rawcliparmdump; then
                        #dumprawcliparms "$@"
                        #rawcliparmdump=true
                    #fi
                    ;;
                -r | --root )
                    CLIparm_rootuser=true
                    ;;
                #-f | --force )
                    #FORCE=true
                    #;;
                --NOWAIT )
                    CLIparm_NOWAIT=true
                    export NOWAIT=true
                    ;;
                # Handle --flag=value opts like this
                -u=* | --user=* )
                    CLIparm_user="${OPT#*=}"
                    #shift
                    ;;
                -p=* | --password=* )
                    CLIparm_password="${OPT#*=}"
                    #shift
                    ;;
                --api-key=* )
                    CLIparm_api_key="${OPT#*=}"
                    # For internal storage, remove the quotes surrounding the api-key, 
                    # will add back on utilization
                    CLIparm_api_key=${CLIparm_api_key//\"}
                    CLIparm_use_api_key=true
                    #shift
                    ;;
                -P=* | --port=* )
                    CLIparm_websslport="${OPT#*=}"
                    #shift
                    ;;
                -m=* | --management=* )
                    CLIparm_mgmt="${OPT#*=}"
                    #shift
                    ;;
                -d=* | --domain=* )
                    CLIparm_domain="${OPT#*=}"
                    CLIparm_domain=${CLIparm_domain//\"}
                    #shift
                    ;;
                -s=* | --session-file=* )
                    CLIparm_sessionidfile="${OPT#*=}"
                    #shift
                    ;;
                --session-timeout=* )
                    CLIparm_sessiontimeout="${OPT#*=}"
                    CLIparm_sessiontimeout=${CLIparm_sessiontimeout//\"}
                    #shift
                    ;;
                -l=* | --log-path=* )
                    CLIparm_logpath="${OPT#*=}"
                    #shift
                    ;;
                -o=* | --output=* )
                    CLIparm_outputpath="${OPT#*=}"
                    #shift
                    ;;
                # and --flag value opts like this
                -u* | --user )
                    CLIparm_user="$2"
                    shift
                    ;;
                -p* | --password )
                    CLIparm_password="$2"
                    shift
                    ;;
                --api-key )
                    CLIparm_api_key="$2"
                    # For internal storage, remove the quotes surrounding the api-key, 
                    # will add back on utilization
                    CLIparm_api_key=${CLIparm_api_key//\"}
                    CLIparm_use_api_key=true
                    shift
                    ;;
                -P* | --port )
                    CLIparm_websslport="$2"
                    shift
                    ;;
                -m* | --management )
                    CLIparm_mgmt="$2"
                    shift
                    ;;
                -d* | --domain )
                    CLIparm_domain="$2"
                    CLIparm_domain=${CLIparm_domain//\"}
                    shift
                    ;;
                -s* | --session-file )
                    CLIparm_sessionidfile="$2"
                    shift
                    ;;
                --session-timeout )
                    CLIparm_sessiontimeout=$2
                    CLIparm_sessiontimeout=${CLIparm_sessiontimeout//\"}
                    #shift
                    ;;
                -l* | --log-path )
                    CLIparm_logpath="$2"
                    shift
                    ;;
                -o* | --output )
                    CLIparm_outputpath="$2"
                    shift
                    ;;
                # 
                # This section is specific to this script focus
                # 
                --NOSTART )
                    CLIparm_NOSTART=true
                    export NOSTART=true
                    ;;
                --RESTART )
                    CLIparm_NOSTART=false
                    export NOSTART=false
                    ;;
                --NOHUP )
                    CLIparm_NOHUP=true
                    ;;
                # Handle --flag=value opts like this
                # and --flag value opts like this
                --NOHUP-Script=* )
                    CLIparm_NOHUPScriptName="${OPT#*=}"
                    #shift
                    ;;
                --NOHUP-Script )
                    CLIparm_NOHUPScriptName="$2"
                    shift
                    ;;
                --NOHUP-DTG=* )
                    CLIparm_NOHUPDTG="${OPT#*=}"
                    #shift
                    ;;
                --NOHUP-DTG )
                    CLIparm_NOHUPDTG="$2"
                    shift
                    ;;
                # Anything unknown is recorded for later
                * )
                    # MODIFIED 2019-05-31
                    #REMAINS="${REMAINS} \"${OPT}\""
                    REMAINS="${REMAINS} ${OPT}"
                    break
                    ;;
            esac
            # Check for multiple short options
            # NOTICE: be sure to update this pattern to match valid options
            # Remove any characters matching "-", and then the values between []'s
            #NEXTOPT="${OPT#-[upmdsor?]}" # try removing single short opt
            NEXTOPT="${OPT#-[vrf?]}" # try removing single short opt
            if [ x"${OPT}" != x"${NEXTOPT}" ] ; then
                OPT="-${NEXTOPT}"  # multiple short opts, keep going
            else
                break  # long form, exit inner loop
            fi
        done
        # Done with that param. move to next
        shift
    done
    # Set the non-parameters back into the positional parameters ($1 $2 ..)
    eval set -- ${REMAINS}
    
    #
    # /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-11-19
    # MODIFIED 2020-11-19 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
    #
    
    # This section of values is common to _subscripts and _api_subscripts
    
    export REMAINS=${REMAINS}
    
    export SHOWHELP=${SHOWHELP}
    export CLIparm_websslport=${CLIparm_websslport}
    export CLIparm_rootuser=${CLIparm_rootuser}
    export CLIparm_user=${CLIparm_user}
    export CLIparm_password=${CLIparm_password}
    export CLIparm_mgmt=${CLIparm_mgmt}
    export CLIparm_domain=${CLIparm_domain}
    export CLIparm_sessionidfile=${CLIparm_sessionidfile}
    export CLIparm_sessiontimeout=${CLIparm_sessiontimeout}
    export CLIparm_logpath=${CLIparm_logpath}
    
    # ADDED 2020-08-19 -
    export CLIparm_api_key=${CLIparm_api_key}
    export CLIparm_use_api_key=${CLIparm_use_api_key}
    
    export CLIparm_outputpath=${CLIparm_outputpath}
    
    export NOWAIT=${NOWAIT}
    export CLIparm_NOWAIT=${CLIparm_NOWAIT}
    
    #
    # /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-11-19
    # MODIFIED 2020-11-19 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
    #
    
    export NOSTART=${NOSTART}
    export CLIparm_NOSTART=${CLIparm_NOSTART}
    
    export CLIparm_NOHUP=${CLIparm_NOHUP}
    export CLIparm_NOHUPScriptName=${CLIparm_NOHUPScriptName}
    export CLIparm_NOHUPDTG=${CLIparm_NOHUPDTG}
    
    #
    # /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-11-19
    
    return 0
}


# -------------------------------------------------------------------------------------------------
# Procedure Call:  Process command line parameters and set appropriate values
# -------------------------------------------------------------------------------------------------

#ProcessCommandLineParametersAndSetValues $@

# -------------------------------------------------------------------------------------------------
# END Procedure:  Process command line parameters and set appropriate values
# -------------------------------------------------------------------------------------------------

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-09-02


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# END:  command line parameter processing proceedures
# -------------------------------------------------------------------------------------------------
# =================================================================================================


# =================================================================================================
# =================================================================================================
# START:  Command Line Parameter Handling and Help
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# START Define command line parameters and set appropriate values
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-19 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
# --api-key "<api_key_value>" | --api-key="<api_key_value>" 
# -m <server_IP> | --management <server_IP> | -m=<server_IP> | --management=<server_IP>
# -d <domain> | --domain <domain> | -d=<domain> | --domain=<domain>
# -s <session_file_filepath> | --session-file <session_file_filepath> | -s=<session_file_filepath> | --session-file=<session_file_filepath>
# --session-timeout <session_time_out> 10-3600
# -l <log_path> | --log-path <log_path> | -l=<log_path> | --log-path=<log_path>'
#
# -o <output_path> | --output <output_path> | -o=<output_path> | --output=<output_path> 
#
# --NOWAIT
#
# --NOSTART
# --RESTART
#
# --NOHUP
# --NOHUP-Script <NOHUP_SCRIPT_NAME> | --NOHUP-Script=<NOHUP_SCRIPT_NAME>
# --NOHUP-DTG <NOHUP_SCRIPT_DATE_TIME_GROUP> | --NOHUP-DTG=<NOHUP_SCRIPT_DATE_TIME_GROUP>
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
export CLIparm_sessiontimeout=
export CLIparm_logpath=

export CLIparm_outputpath=

# ADDED 2020-08-19 -
export CLIparm_api_key=
export CLIparm_use_api_key=false

# --NOWAIT
#

export CLIparm_NOWAIT=false

if [ -z "${NOWAIT}" ]; then
    # NOWAIT mode not set from shell level
    export CLIparm_NOWAIT=false
    export NOWAIT=false
elif [ x"`echo "${NOWAIT}" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    # NOWAIT mode set OFF from shell level
    export CLIparm_NOWAIT=false
    export NOWAIT=false
elif [ x"`echo "${NOWAIT}" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
    # NOWAIT mode set ON from shell level
    export CLIparm_NOWAIT=true
    export NOWAIT=true
else
    # NOWAIT mode set to wrong value from shell level
    export CLIparm_NOWAIT=false
    export NOWAIT=false
fi

# --NOSTART
#

export CLIparm_NOSTART=false

if [ -z "${NOSTART}" ]; then
    # NOSTART mode not set from shell level
    export CLIparm_NOSTART=false
    export NOSTART=false
elif [ x"`echo "${NOSTART}" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
    # NOSTART mode set OFF from shell level
    export CLIparm_NOSTART=false
    export NOSTART=false
elif [ x"`echo "${NOSTART}" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
    # NOSTART mode set ON from shell level
    export CLIparm_NOSTART=true
    export NOSTART=true
else
    # NOSTART mode set to wrong value from shell level
    export CLIparm_NOSTART=false
    export NOSTART=false
fi

export CLIparm_NOHUP=false
export CLIparm_NOHUPScriptName=
export CLIparm_NOHUPDTG=

export REMAINS=

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-11-19


# -------------------------------------------------------------------------------------------------
# END Define command line parameters and set appropriate values
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#echo 'Process Command Line Parameter Verbose Enabled' >> ${templogfilepath}
ProcessCommandLIneParameterVerboseEnable "$@"

#echo 'Process Command Line Parameters and Set Values' >> ${templogfilepath}
ProcessCommandLineParametersAndSetValues "$@"

dumpcliparmparseresults "$@"


# -------------------------------------------------------------------------------------------------
# Handle request for help (common) and exit
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-11-19 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# Was help requested, if so show it and return
#
if ${SHOWHELP} ; then
    # Show Help
    doshowhelp "$@"
    echo
    
    # don't want a log file for showing help
    #rm ${logfilepath}
    
    # this is done now, so exit hard
    exit 255 
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-11-19

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# END:  Command Line Parameter Handling and Help
# =================================================================================================
# =================================================================================================


if ${B4CPSCRIPTVERBOSE} ; then
    echo | tee -a -i ${logfilepath}
    echo 'Subscript Completed :  '${SubScriptName} | tee -a -i ${logfilepath}
else
    echo >> ${logfilepath}
    echo 'Subscript Completed :  '${SubScriptName} >> ${logfilepath}
fi


return 0


# =================================================================================================
# END subscript:  Handle Command Line Parameters
# =================================================================================================
# =================================================================================================


