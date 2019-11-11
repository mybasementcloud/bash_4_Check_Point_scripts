#!/bin/bash
#
# SCRIPT Fix Scripts After Copy
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-10-05
ScriptVersion=04.12.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.11.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHScriptFileNameRoot=touch_all_scripts
export BASHScriptShortName=$BASHScriptFileNameRoot
export BASHScriptDescription="Touch all Scripts, Help, and Versions"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|Health_Check|MDM|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|UserConfig|UserConfig.CORE_G2.NPM
export BASHScriptsFolder=.



# =============================================================================
# =============================================================================
# 
# =============================================================================

touch *.sh
touch --reference=__root_script_config.sh *.version
touch --reference=__root_script_config.sh *.help
touch --reference=__root_script_config.sh Code_Snipets/*.sh
touch --reference=__root_script_config.sh help/*.help
touch --reference=__root_script_config.sh _sub-scripts/*.sh
touch --reference=__root_script_config.sh _sub-scripts/help*/*.help
touch --reference=__root_script_config.sh _template/*.sh
touch --reference=__root_script_config.sh _template/Code_Snipets/*.sh
touch --reference=__root_script_config.sh _template/help/*.sh
touch --reference=__root_script_config.sh Common/*.sh
touch --reference=__root_script_config.sh Common/help*/*.help
touch --reference=__root_script_config.sh Config/*.sh
touch --reference=__root_script_config.sh Config/help*/*.help
touch --reference=__root_script_config.sh GAIA/*.sh
touch --reference=__root_script_config.sh GAIA/help*/*.help
touch --reference=__root_script_config.sh GW/*.sh
touch --reference=__root_script_config.sh GW/help*/*.help
touch --reference=__root_script_config.sh Health_Check/check_status_checkpoint_services.*.sh
touch --reference=__root_script_config.sh Health_Check/run_healthcheck_to_dump_dtg.*.sh
touch --reference=__root_script_config.sh Health_Check/help*/*.help
touch --reference=__root_script_config.sh MDM/*.sh
touch --reference=__root_script_config.sh MDM/help*/*.help
touch --reference=__root_script_config.sh Patch_HotFix/*.sh
touch --reference=__root_script_config.sh Session_Cleanup/*.sh
touch --reference=__root_script_config.sh SmartEvent/*.sh
touch --reference=__root_script_config.sh SmartEvent/help*/*.help
touch --reference=__root_script_config.sh SMS/*.sh
touch --reference=__root_script_config.sh SMS/help*/*.help
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
