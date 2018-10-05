#!/bin/bash
#
# SCRIPT for BASH to Watch mdsstat
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=02.00.00
ScriptDate=2018-10-04
#

export BASHScriptVersion=v01x07x00

export gaiaversion=$(clish -i -c "show version product" | cut -d " " -f 6)
echo 'Gaia Version : $gaiaversion = '$gaiaversion
echo

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
    watch -d -n 1 "$MDS_FWDIR/scripts/cpm_status.sh;echo;mdsstat"
    echo
else
    watch -d -n 1 "mdsstat"
    echo
fi

