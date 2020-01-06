#!/bin/bash
#
# SCRIPT execute operation to fix Gaia webUI logon problem for Chrome and FireFox
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2020-01-05
ScriptVersion=04.21.00
ScriptRevision=004
TemplateLevel=006
TemplateVersion=04.20.00
SubScriptsLevel=na
SubScriptsVersion=na
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=fix_gaia_webui_login_dot_js_generic
export BASHScriptShortName=fix_gaia_webui_login_dot_js_generic.v$ScriptVersion
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription=="Execute operation to fix Gaia webUI logon problem for Chrome and FireFox"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=Patch_Hotfix

export BASHScripttftptargetfolder="_template"


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
