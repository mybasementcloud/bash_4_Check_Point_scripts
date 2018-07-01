#!/bin/bash
#
# SCRIPT for BASH to Watch mdsstat
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.07.00
ScriptDate=2018-06-30
#

export BASHScriptVersion=v00x07x00

export gaiaversion=$(clish -c "show version product" | cut -d " " -f 6)
echo 'Gaia Version : $gaiaversion = '$gaiaversion
echo

export toolsversion=$gaiaversion

if [ x"$toolsversion" = x"R80.20" ] || [ x"$toolsversion" = x"R80.10" ] || [ x"$toolsversion" = x"R80" ] ; then
    # cpm_status.sh only exists in R8X
    watch -d -n 1 "$MDS_FWDIR/scripts/cpm_status.sh;echo;mdsstat"
    echo
else
    watch -d -n 1 "mdsstat"
    echo
fi

