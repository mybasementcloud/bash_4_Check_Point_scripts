#!/bin/bash
#
# SCRIPT for BASH to watch cp management processes
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptTemplateLevel=006
ScriptVersion=03.00.01
ScriptDate=2018-12-18
#

export BASHScriptVersion=v03x00x01

export R8XRequired=false
export UseR8XAPI=false
export UseJSONJQ=false


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

if $isitR77version; then

    # This is an R77.X version...
    # We don't have the luxury of python get_platform.py script
    #
    clish -i -c "lock database override"
    clish -i -c "lock database override"
    
    export gaiaversion=$(clish -i -c "show version product" | cut -d " " -f 6)
    
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


echo 'Gaia Version : $gaiaversion = '$gaiaversion
echo

export toolsversion=$gaiaversion

case "$gaiaversion" in
    R80 | R80.10 | R80.20.M1 | R80.20.M2 | R80.20.M3 | R80.20 | R80.30.M1 | R80.30.M2 | R80.30.M3 | R80.30 ) 
        export IsR8XVersion=true
        ;;
    *)
        export IsR8XVersion=false
        ;;
esac


if $IsR8XVersion ; then
    # cpm_status.sh only exists in R8X
    watch -d -n 1 "$MDS_FWDIR/scripts/cpm_status.sh;echo;cpwd_admin list"
    echo
else
    watch -d -n 1 "cpwd_admin list"
    echo
fi

