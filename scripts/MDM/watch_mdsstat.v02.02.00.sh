#!/bin/bash
#
# SCRIPT for BASH to Watch mdsstat
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=02.02.00
ScriptDate=2018-12-03
#

export BASHScriptVersion=v02x02x00

# Removing dependency on clish to avoid collissions when database is locked
#
#clish -i -c "lock database override" >> $gaiaversionoutputfile
#clish -i -c "lock database override" >> $gaiaversionoutputfile
#
#export gaiaversion=$(clish -i -c "show version product" | cut -d " " -f 6)

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

echo 'Gaia Version : $gaiaversion = '$gaiaversion
echo

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
    watch -d -n 1 "$MDS_FWDIR/scripts/cpm_status.sh;echo;mdsstat"
    echo
else
    watch -d -n 1 "mdsstat"
    echo
fi

