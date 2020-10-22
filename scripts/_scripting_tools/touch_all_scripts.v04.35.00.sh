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
ScriptDate=2020-10-21
ScriptVersion=04.38.00
ScriptRevision=002
TemplateVersion=04.38.00
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

export BASHScriptFileNameRoot=touch_all_scripts
export BASHScriptShortName=$BASHScriptFileNameRoot
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription="Touch all Scripts, Help, and Versions"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=_scripting_tools
export BASHScriptsFolder=.

export BASHScripttftptargetfolder="_template"


# UPDATED 2020-09-17 -
# -------------------------------------------------------------------------------------------------
# Announce Script, this should also be the first log entry!
# -------------------------------------------------------------------------------------------------

echo
echo $BASHScriptDescription', script version '$ScriptVersion', revision '$ScriptRevision' from '$ScriptDate
echo


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =============================================================================
# =============================================================================
# 
# =============================================================================

touch *.sh
touch --reference=__root_script_config.sh *.version
touch --reference=__root_script_config.sh *.clish
touch --reference=__root_script_config.sh *.help
touch --reference=__root_script_config.sh Code_Snipets/*.sh
touch --reference=__root_script_config.sh help/*.help
touch --reference=__root_script_config.sh _subscripts/*.sh
touch --reference=__root_script_config.sh _subscripts/*.version
touch --reference=__root_script_config.sh _subscripts/help*/*.help
touch --reference=__root_script_config.sh _template/*.sh
touch --reference=__root_script_config.sh _template/*.version
touch --reference=__root_script_config.sh _template/Code_Snipets/*.sh
touch --reference=__root_script_config.sh _template/help/*.help
touch --reference=__root_script_config.sh Common/*.sh
touch --reference=__root_script_config.sh Common/help*/*.help
touch --reference=__root_script_config.sh Config/*.sh
touch --reference=__root_script_config.sh Config/help*/*.help
touch --reference=__root_script_config.sh GAIA/*.sh
touch --reference=__root_script_config.sh GAIA/help*/*.help
touch --reference=__root_script_config.sh GW/*.sh
touch --reference=__root_script_config.sh GW/help*/*.help
touch --reference=__root_script_config.sh GW.CORE/*.sh
touch --reference=__root_script_config.sh GW.CORE/help*/*.help
touch --reference=__root_script_config.sh GW.CORE/SK106251/*.sh
touch --reference=__root_script_config.sh GW.CORE/SK106251/*.clish
touch --reference=__root_script_config.sh GW.CORE/SMCIAS01/*.sh
touch --reference=__root_script_config.sh GW.CORE/SMCIAS01/*.clish
touch --reference=__root_script_config.sh GW.CORE/SMCIAS02/*.sh
touch --reference=__root_script_config.sh GW.CORE/SMCIAS02/*.clish
touch --reference=__root_script_config.sh Health_Check/check_status_checkpoint_services.*.sh
touch --reference=__root_script_config.sh Health_Check/run_healthcheck_to_dump_dtg.*.sh
touch --reference=__root_script_config.sh Health_Check/help*/*.help
touch --reference=__root_script_config.sh MDM/*.sh
touch --reference=__root_script_config.sh MDM/help*/*.help
touch --reference=__root_script_config.sh MGMT/*.sh
touch --reference=__root_script_config.sh MGMT/help*/*.help
touch --reference=__root_script_config.sh Patch_HotFix/*.sh
#touch --reference=__root_script_config.sh Session_Cleanup/*.sh
#touch --reference=__root_script_config.sh Session_Cleanup/common/*.sh
touch --reference=__root_script_config.sh SmartEvent/*.sh
touch --reference=__root_script_config.sh SmartEvent/help*/*.help
touch --reference=__root_script_config.sh SMS/*.sh
touch --reference=__root_script_config.sh SMS/help*/*.help
touch --reference=__root_script_config.sh SMS.migrate_backup/*.sh
touch --reference=__root_script_config.sh SMS.migrate_backup/help*/*.help
touch --reference=__root_script_config.sh UserConfig/*.sh
touch --reference=__root_script_config.sh UserConfig/help*/*.help
touch --reference=__root_script_config.sh UserConfig.CORE_G2.NPM/*.sh
touch --reference=__root_script_config.sh UserConfig.CORE_G2.NPM/help*/*.help

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
