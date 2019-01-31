#!/bin/bash
#
# SCRIPT for BASH to Watch mdsstat and CPM status
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-01-30
ScriptVersion=03.02.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=03.00.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}

export BASHScriptName=watch_mdsstat.v$ScriptVersion
export BASHScriptShortName=watch_mdsstat.v$ScriptVersion
export BASHScriptDescription="Watch mdsstat and CPM status"


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
export UseJSONJQ=false


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
elif $isitR80version; then
    echo "This is an R80.X version..."
    export UseR8XAPI=$UseR8XAPI
    export UseJSONJQ=$UseJSONJQ
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
# Script Operations
# -------------------------------------------------------------------------------------------------


if $IsR8XVersion ; then
    # cpm_status.sh only exists in R8X
    watch -d -n 1 "$MDS_FWDIR/scripts/cpm_status.sh;echo;mdsstat"
    echo
else
    watch -d -n 1 "mdsstat"
    echo
fi


# -------------------------------------------------------------------------------------------------
# End of script
# -------------------------------------------------------------------------------------------------

echo 'Done!'
echo
