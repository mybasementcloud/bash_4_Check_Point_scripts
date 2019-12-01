#!/bin/bash
#
# SCRIPT Fix Scripts After Copy
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-11-22
ScriptVersion=04.15.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.15.00
SubScriptsLevel=NA
SubScriptsVersion=NA
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=fix_scripts_after_copy
export BASHScriptShortName=$BASHScriptFileNameRoot
export BASHScriptDescription="Fix Scripts After Copy"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=.

export BASHScripttftptargetfolder="_template"



# =============================================================================
# =============================================================================
# 
# =============================================================================

dos2unix *.sh
dos2unix *.help
dos2unix *.version
dos2unix _sub-scripts/*.sh
dos2unix _sub-scripts/help/*.help
dos2unix _template/*.sh
dos2unix _template/Code_Snipets/*.sh
dos2unix _template/help/*.help
dos2unix Common/*.sh
dos2unix Common/help/*.help
dos2unix Config/*.sh
dos2unix Config/help/*.help
dos2unix GAIA/*.sh
dos2unix GAIA/help/*.help
dos2unix GW/*.sh
dos2unix GW/help/*.help
dos2unix Health_Check/*.sh
dos2unix Health_Check/help/*.help
dos2unix MDM/*.sh
dos2unix MDM/help/*.help
dos2unix Patch_HotFix/*.sh
dos2unix Session_Cleanup/*.sh
dos2unix Session_Cleanup/common/*.sh
dos2unix SmartEvent/*.sh
dos2unix SmartEvent/help/*.help
dos2unix SMS/*.sh
dos2unix SMS/*.help
dos2unix UserConfig/*.sh
dos2unix UserConfig/help/*.help
dos2unix UserConfig.CORE_G2.NPM/*.sh
dos2unix UserConfig.CORE_G2.NPM/help/*.help

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
