#!/bin/bash
#
# SCRIPT for BASH to watch cp management processes
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=02.01.00
ScriptDate=2018-11-20
#

export BASHScriptVersion=v02x01x00

# Removing dependency on clish to avoid collissions when database is locked
#
#clish -i -c "lock database override" >> $gaiaversionoutputfile
#clish -i -c "lock database override" >> $gaiaversionoutputfile
#
#export gaiaversion=$(clish -i -c "show version product" | cut -d " " -f 6)

export get_platform_release=`python $MDS_FWDIR/scripts/get_platform.py -f json | ${CPDIR_PATH}/jq/jq '. | .release'`

export platform_release=${get_platform_release//\"/}
export get_platform_release_version=`echo ${get_platform_release//\"/} | cut -d " " -f 4`
export platform_release_version=${get_platform_release_version//\"/}

export gaiaversion=$platform_release_version

echo 'Gaia Version : $gaiaversion = '$gaiaversion
echo

export toolsversion=$gaiaversion

case "$gaiaversion" in
    R80 | R80.10 | R80.20.M1 | R80.20 ) 
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

