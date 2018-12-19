#!/bin/bash
#
# SCRIPT Template for CLI Operations for command line parameters handling
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
SubScriptTemplateLevel=006
SubScriptVersion=03.00.00
SubScriptRevision=001
SubScriptDate=2018-12-17
#

BASHSubScriptVersion=v03x00x00
SubScriptName=cmd_line_parameters_handler.sub-script.$ScriptTemplateLevel.v$ScriptVersion
SubScriptShortName="cliparms.$ScriptTemplateLevel"
SubScriptDescription="Command line parameters handler"


# =================================================================================================
# Validate Sub-Script template version is correct for caller
# =================================================================================================


if [ x"$BASHScriptTemplateLevel" = x"$SubScriptTemplateLevel" ] ; then
    # Script and Actions Script versions match, go ahead
    echo >> $logfilepath
    echo 'Verify Actions Scripts Version - OK' >> $logfilepath
    echo >> $logfilepath
else
    # Script and Actions Script versions don't match, ALL STOP!
    echo | tee -a -i $logfilepath
    echo 'Verify Actions Scripts Version - Missmatch' | tee -a -i $logfilepath
    echo 'Calling Script template version : '$BASHScriptTemplateLevel | tee -a -i $logfilepath
    echo 'Actions Script template version : '$SubScriptVersion | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "Log output in file $logfilepath" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    exit 250
fi


# =================================================================================================
# =================================================================================================
# START action script:  handle command line parameters
# =================================================================================================


echo >> $logfilepath
echo 'SubscriptName:  '$SubScriptName'  Template Version: '$SubScriptTemplateLevel'  Script Version: '$SubScriptVersion' Revision:  '$SubScriptRevision >> $logfilepath
echo >> $logfilepath

# -------------------------------------------------------------------------------------------------
# Handle important basics
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# CheckScriptVerboseOutput - Check if verbose output is configured externally
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# CheckScriptVerboseOutput - Check if verbose output is configured externally via shell level 
# parameter setting, if it is, the check it for correct and valid values; otherwise, if set, then
# reset to false because wrong.
#

CheckScriptVerboseOutput () {

    if [ -z $SCRIPTVERBOSE ] ; then
        # Verbose mode not set from shell level
        echo "!! Verbose mode not set from shell level" >> $logfilepath
        export SCRIPTVERBOSE=false
        echo >> $logfilepath
    elif [ x"`echo "$SCRIPTVERBOSE" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
        # Verbose mode set OFF from shell level
        echo "!! Verbose mode set OFF from shell level" >> $logfilepath
        export SCRIPTVERBOSE=false
        echo >> $logfilepath
    elif [ x"`echo "$SCRIPTVERBOSE" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
        # Verbose mode set ON from shell level
        echo "!! Verbose mode set ON from shell level" >> $logfilepath
        export SCRIPTVERBOSE=true
        echo >> $logfilepath
        echo 'Script :  '$0 >> $logfilepath
        echo 'Verbose mode enabled' >> $logfilepath
        echo >> $logfilepath
    else
        # Verbose mode set to wrong value from shell level
        echo "!! Verbose mode set to wrong value from shell level >"$SCRIPTVERBOSE"<" >> $logfilepath
        echo "!! Settting Verbose mode OFF, pending command line parameter checking!" >> $logfilepath
        export SCRIPTVERBOSE=false
        echo >> $logfilepath
    fi
    
    export SCRIPTVERBOSECHECK=true

    echo >> $logfilepath
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2018-09-29

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# Command Line Parameter Handling Action Script should only do this if we didn't do it in the calling script

if [ x"$SCRIPTVERBOSECHECK" = x"true" ] ; then
    # Already checked status of $SCRIPTVERBOSE
    echo "Status of verbose output at start of command line handler: $SCRIPTVERBOSE"
else
    # Need to check status of $SCRIPTVERBOSE

    CheckScriptVerboseOutput

    echo "Status of verbose output at start of command line handler: $SCRIPTVERBOSE" >> $logfilepath
fi


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

# -------------------------------------------------------------------------------------------------
# dumpcliparmparseresults
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

dumpcliparmparseresults () {

	#
	# Testing - Dump acquired values
	#
    #
    # Screen width template for sizing, default width of 80 characters assumed
    #
    #                                    1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #                          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    export outstring=
    export outstring=$outstring"Parameters : \n"

    if $UseR8XAPI ; then
        
        export outstring=$outstring"CLIparm_rootuser        ='$CLIparm_rootuser' \n"
        export outstring=$outstring"CLIparm_user            ='$CLIparm_user' \n"
        export outstring=$outstring"CLIparm_password        ='$CLIparm_password' \n"
        
        export outstring=$outstring"CLIparm_websslport      ='$CLIparm_websslport' \n"
        export outstring=$outstring"CLIparm_mgmt            ='$CLIparm_mgmt' \n"
        export outstring=$outstring"CLIparm_domain          ='$CLIparm_domain' \n"
        export outstring=$outstring"CLIparm_sessionidfile   ='$CLIparm_sessionidfile' \n"
        
    fi

    export outstring=$outstring"CLIparm_logpath         ='$CLIparm_logpath' \n"
    export outstring=$outstring"CLIparm_outputpath      ='$CLIparm_outputpath' \n"
    
    export outstring=$outstring"SHOWHELP                ='$SHOWHELP' \n"
    export outstring=$outstring" \n"
    export outstring=$outstring"SCRIPTVERBOSE           ='$SCRIPTVERBOSE' \n"
    export outstring=$outstring"NOWAIT                  ='$NOWAIT' \n"
    export outstring=$outstring" \n"
    export outstring=$outstring"CLIparm_NOWAIT          ='$CLIparm_NOWAIT' \n"
    export outstring=$outstring" \n"
    export outstring=$outstring"remains                 ='$REMAINS' \n"
    
	if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
	    # Verbose mode ON
	    
	    echo | tee -a -i $logfilepath
	    echo -e $outstring | tee -a -i $logfilepath
	    echo | tee -a -i $logfilepath
	    for i ; do echo - $i | tee -a -i $logfilepath ; done
	    echo CLI parms - number "$#" parms "$@" | tee -a -i $logfilepath
	    echo | tee -a -i $logfilepath
        
    else
	    # Verbose mode OFF
	    
	    echo >> $logfilepath
	    echo -e $outstring >> $logfilepath
	    echo >> $logfilepath
	    for i ; do echo - $i >> $logfilepath ; done
	    echo CLI parms - number "$#" parms "$@" >> $logfilepath
	    echo >> $logfilepath
        
	fi

}


#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-09-29


# -------------------------------------------------------------------------------------------------
# dumprawcliparms
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

dumprawcliparms () {
    #
	if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
	    # Verbose mode ON
	    
        echo | tee -a -i $logfilepath
        echo "Command line parameters before : " | tee -a -i $logfilepath
        echo "Number parms $#" | tee -a -i $logfilepath
        echo "parms raw : \> $@ \<" | tee -a -i $logfilepath
        for k ; do
            echo "$k $'\t' ${k}" | tee -a -i $logfilepath
        done
        echo | tee -a -i $logfilepath
        
    else
	    # Verbose mode OFF
	    
        echo >> $logfilepath
        echo "Command line parameters before : " >> $logfilepath
        echo "Number parms $#" >> $logfilepath
        echo "parms raw : \> $@ \<" >> $logfilepath
        for k ; do
            echo "$k $'\t' ${k}" >> $logfilepath
        done
        echo >> $logfilepath
        
	fi

}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-09-29


# =================================================================================================
# -------------------------------------------------------------------------------------------------
# START:  Common Help display proceedure
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Help display proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-05-03-2 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
    if $UseR8XAPI ; then
        echo -n '[-r]|[-u <admin_name>]|[-p <password>]]|[-P <web ssl port>]'
        echo -n '|[-m <server_IP>]'
        echo -n '|[-d <domain>]'
        echo -n '|[-s <session_file_filepath>]'
    fi
    echo -n '|[-l <log_path>]'
    echo -n '|[-o <output_path>]'
    echo

    echo
    echo ' Script Version:  '$BASHScriptVersion'  Date:  '$ScriptDate
    echo
    echo ' Standard Command Line Parameters: '
    echo
    echo '  Show Help                  -? | --help'
    echo '  Verbose mode               -v | --verbose'
    echo

    if $UseR8XAPI ; then
    
        echo '  Authenticate as root       -r | --root'
        echo '  Set Console User Name      -u <admin_name> | --user <admin_name> |'
        echo '                             -u=<admin_name> | --user=<admin_name>'
        echo '  Set Console User password  -p <password> | --password <password> |'
        echo '                             -p=<password> | --password=<password>'
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
        echo

    fi

    echo '  Set log file path          -l <log_path> | --log-path <log_path> |'
    echo '                             -l=<log_path> | --log-path=<log_path>'
    echo '  Set output file path       -o <output_path> | --output <output_path> |'
    echo '                             -o=<output_path> | --output=<output_path>'
    echo
    echo '  No waiting in verbose mode --NOWAIT'
    echo

    if $UseR8XAPI ; then
        echo '  session_file_filepath = fully qualified file path for session file'
    fi

    echo '  log_path = fully qualified folder path for log files'
    echo '  output_path = fully qualified folder path for output files'
    
    if $UseR8XAPI ; then

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
        echo
    
    else

        #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
        #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        echo

        echo ' ]# '$ScriptName' -v -o "/var/tmp/script_ouput" -l "/var/tmp/script_logs"'

    fi
    
    #              1111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990
    #    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

    echo
    return 1
}

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-05-03-2

# -------------------------------------------------------------------------------------------------
# END:  Common Help display proceedure
# -------------------------------------------------------------------------------------------------
# =================================================================================================

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Process command line parameters and set appropriate values
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-09-29 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

if [ x"$SCRIPTVERBOSE" = x"true" ] ; then
    # Verbose mode ON
    dumprawcliparms "$@"
fi

while [ -n "$1" ]; do
    # Copy so we can modify it (can't modify $1)
    OPT="$1"

    # testing
    #echo 'OPT = '$OPT
    #

    # Detect argument termination
    if [ x"$OPT" = x"--" ]; then
        # testing
        # echo "Argument termination"
        #
        
        shift
        for OPT ; do
            REMAINS="$REMAINS \"$OPT\""
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
            '-v' | --verbose )
                export SCRIPTVERBOSE=true
                ;;
            --NOWAIT )
                CLIparm_NOWAIT=true
                export NOWAIT=true
                ;;
            # Handle immediate opts like this
            -r | --root )
                CLIparm_rootuser=true
                ;;
#           -f | --force )
#               FORCE=true
#               ;;
            # Handle --flag=value opts like this
            -u=* | --user=* )
                CLIparm_user="${OPT#*=}"
                #shift
                ;;
            -p=* | --password=* )
                CLIparm_password="${OPT#*=}"
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
            -l* | --log-path )
                CLIparm_logpath="$2"
                shift
                ;;
            -o* | --output )
                CLIparm_outputpath="$2"
                shift
                ;;
            # Anything unknown is recorded for later
            * )
                REMAINS="$REMAINS \"$OPT\""
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
eval set -- $REMAINS

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-09-29

# MODIFIED 2018-05-03-2 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

export SHOWHELP=$SHOWHELP
export CLIparm_websslport=$CLIparm_websslport
export CLIparm_rootuser=$CLIparm_rootuser
export CLIparm_user=$CLIparm_user
export CLIparm_password=$CLIparm_password
export CLIparm_mgmt=$CLIparm_mgmt
export CLIparm_domain=$CLIparm_domain
export CLIparm_sessionidfile=$CLIparm_sessionidfile
export CLIparm_logpath=$CLIparm_logpath

export CLIparm_outputpath=$CLIparm_outputpath

export CLIparm_NOWAIT=`echo "$CLIparm_NOWAIT" | tr '[:upper:]' '[:lower:]'`

export REMAINS=$REMAINS

dumpcliparmparseresults "$@"

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-05-03-2

# -------------------------------------------------------------------------------------------------
# Handle request for help (common) and exit
# -------------------------------------------------------------------------------------------------

# MODIFIED 2018-05-04 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# Was help requested, if so show it and return
#
if [ x"$SHOWHELP" = x"true" ] ; then
    # Show Help
    doshowhelp "$@"

    # Show Local Help
    if [ -r $BASHScriptHelpFile ]; then
        #we have a script specific help file!
        cat $BASHScriptHelpFile
        echo
    fi

    echo

    # don't want a log file for showing help
    rm $logfilepath

    # this is done now, so exit hard
    exit 255 
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2018-05-04

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# =================================================================================================
# END:  Command Line Parameter Handling and Help
# =================================================================================================
# =================================================================================================


# =================================================================================================
# END:  
# =================================================================================================
# =================================================================================================


