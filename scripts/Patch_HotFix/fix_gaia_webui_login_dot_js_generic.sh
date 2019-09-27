#!/bin/bash
#
# SCRIPT execute operation to fix Gaia webUI logon problem for Chrome and FireFox
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-09-26
ScriptVersion=04.06.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.05.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}

export BASHScriptName=fix_gaia_webui_login_dot_js_generic.v$ScriptVersion
export BASHScriptShortName=fix_gaia_webui_login_dot_js_generic.v$ScriptVersion
export BASHScriptDescription="Execute operation to fix Gaia webUI logon problem for Chrome and FireFox"

export BASHScriptHelpFile="$BASHScriptName.help"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=Patch_Hotfix


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Basic Configuration
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------


export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTSG=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

echo 'Date Time Group   :  '$DATEDTGS
echo 'Date (YYYY-MM-DD) :  '$DATEYMD
echo


# -------------------------------------------------------------------------------------------------
# Other variable configuration
# -------------------------------------------------------------------------------------------------


# WAITTIME in seconds for read -t commands
export WAITTIME=60

export outputpathroot=/var/tmp/Change_Log
export outputpathbase=$outputpathroot/$DATEDTGS


# -------------------------------------------------------------------------------------------------
# Start Script
# -------------------------------------------------------------------------------------------------


if [ ! -r $outputpathroot ] 
then
    mkdir -pv $outputpathroot
fi
if [ ! -r $outputpathbase ] 
then
    mkdir -pv $outputpathbase
fi

sed -i.bak '/form.isValid/s/$/\nform.el.dom.action=formAction;\n/' /web/htdocs2/login/login.js
cp /web/htdocs2/login/login.js* $outputpathbase


echo 'Created folder :  '$outputpathbase
echo
ls -al $outputpathbase
echo


# -------------------------------------------------------------------------------------------------
# End of script
# -------------------------------------------------------------------------------------------------

echo 'Done!'
echo
