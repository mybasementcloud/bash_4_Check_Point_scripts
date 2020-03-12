#!/bin/bash
#
# SCRIPT Fix Scripts After Copy
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
#
ScriptDate=2020-03-11
ScriptVersion=04.26.00
ScriptRevision=001
TemplateVersion=04.26.00
TemplateLevel=006
SubScriptsLevel=NA
SubScriptsVersion=NA
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=fix_scripts_after_copy
export BASHScriptShortName=$BASHScriptFileNameRoot
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription=="Fix Scripts After Copy"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
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
dos2unix _sub-scripts/*.version
dos2unix _sub-scripts/help/*.help
dos2unix _template/*.sh
dos2unix _template/*.version
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
dos2unix GW.CORE/*.sh
dos2unix GW.CORE/help/*.help
dos2unix Health_Check/*.sh
dos2unix Health_Check/help/*.help
dos2unix MDM/*.sh
dos2unix MDM/help/*.help
dos2unix MGMT/*.sh
dos2unix MGMT/help/*.help
dos2unix Patch_HotFix/*.sh
dos2unix Session_Cleanup/*.sh
dos2unix Session_Cleanup/common/*.sh
dos2unix SmartEvent/*.sh
dos2unix SmartEvent/help/*.help
dos2unix SMS/*.sh
dos2unix SMS/*.help
dos2unix SMS.migrate_backup/*.sh
dos2unix SMS.migrate_backup/*.help
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
