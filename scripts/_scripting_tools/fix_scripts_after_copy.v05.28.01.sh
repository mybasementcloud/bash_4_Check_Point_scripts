#!/bin/bash
#
# (C) 2016-2022 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
# SCRIPT Fix Scripts After Copy
#
#
ScriptDate=2022-02-24
ScriptVersion=05.28.01
ScriptRevision=000
TemplateVersion=05.28.01
TemplateLevel=006
SubScriptsLevel=NA
SubScriptsVersion=NA
#

export BASHScriptVersion=v${ScriptVersion}
export BASHScriptTemplateVersion=v${TemplateVersion}

export BASHScriptVersionX=v${ScriptVersion//./x}
export BASHScriptTemplateVersionX=v${TemplateVersion//./x}

export BASHScriptTemplateLevel=${TemplateLevel}.v${TemplateVersion}

export BASHSubScriptsVersion=v${SubScriptsVersion}
export BASHSubScriptTemplateVersion=v${TemplateVersion}
export BASHExpectedSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion}

export BASHSubScriptsVersionX=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersionX=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersionX=${SubScriptsLevel}.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=fix_scripts_after_copy
export BASHScriptShortName=${BASHScriptFileNameRoot}
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Fix Scripts After Copy"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}

export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=_scripting_tools

export BASHScripttftptargetfolder="_template"


# UPDATED 2020-09-17 -
# -------------------------------------------------------------------------------------------------
# Announce Script, this should also be the first log entry!
# -------------------------------------------------------------------------------------------------

echo
echo ${BASHScriptDescription}', script version '${ScriptVersion}', revision '${ScriptRevision}' from '${ScriptDate}
echo


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =============================================================================
# =============================================================================
# 
# =============================================================================

dos2unix *.sh
dos2unix *.help
dos2unix *.version
dos2unix _api_subscripts/*.sh
dos2unix _api_subscripts/*.version
dos2unix _api_subscripts/help.$BASHScriptVersion/*.help
dos2unix _hostsetupscripts/*.sh
dos2unix _hostsetupscripts/*.version
dos2unix _hostsetupscripts/help.$BASHScriptVersion/*.help
dos2unix _hostupdatescripts/*.sh
dos2unix _hostupdatescripts/*.version
dos2unix _hostupdatescripts/help.$BASHScriptVersion/*.help
dos2unix _subscripts/*.sh
dos2unix _subscripts/*.version
dos2unix _subscripts/help.$BASHScriptVersion/*.help
dos2unix _template/*.sh
dos2unix _template/*.version
dos2unix _template/Code_Snipets/*.sh
dos2unix _template/help.$BASHScriptVersion/*.help
dos2unix alias_commands/*.sh
dos2unix alias_commands.SAMPLE/*.sh
dos2unix Common/*.sh
dos2unix Common/help.$BASHScriptVersion/*.help
dos2unix Config/*.sh
dos2unix Config/help.$BASHScriptVersion/*.help
dos2unix Config/_research_scripts/*.sh
dos2unix GAIA/*.sh
dos2unix GAIA/help.$BASHScriptVersion/*.help
dos2unix GAIA.SAMPLE/*.sh
dos2unix GAIA.SAMPLE/help.$BASHScriptVersion/*.help
dos2unix GW/*.sh
dos2unix GW/help.$BASHScriptVersion/*.help
dos2unix GW.CORE/*.sh
dos2unix GW.CORE/help.$BASHScriptVersion/*.help
dos2unix GW.CORE/SK106251/*.sh
dos2unix GW.CORE/SMCIAS01/*.sh
dos2unix GW.CORE/SMCIAS01/*.clish
dos2unix GW.CORE/SMCIAS02/*.sh
dos2unix GW.CORE/SMCIAS02/*.clish
dos2unix Health_Check/*.sh
dos2unix Health_Check/help.$BASHScriptVersion/*.help
dos2unix help.$BASHScriptVersion/*.help
dos2unix MDM/*.sh
dos2unix MDM/help.$BASHScriptVersion/*.help
dos2unix MGMT/*.sh
dos2unix MGMT/help.$BASHScriptVersion/*.help
dos2unix Patch_HotFix/*.sh
dos2unix Session_Cleanup/*.sh
dos2unix Session_Cleanup/common/*.sh
dos2unix SmartEvent/*.sh
dos2unix SmartEvent/help.$BASHScriptVersion/*.help
dos2unix SMS/*.sh
dos2unix SMS/help.$BASHScriptVersion/*.help
dos2unix SMS.migrate_backup/*.sh
dos2unix SMS.migrate_backup/help.$BASHScriptVersion/*.help
dos2unix UserConfig/*.sh
dos2unix UserConfig/help.$BASHScriptVersion/*.help

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
