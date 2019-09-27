#!/bin/bash
#
# SCRIPT Fix Scripts After Copy
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-08-24
ScriptVersion=04.05.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.05.00
#

export BASHScriptVersion=v${ScriptVersion//./x}

# =============================================================================
# =============================================================================
# 
# =============================================================================

touch *.sh
touch --reference=__root_script_config.sh *.version
touch --reference=__root_script_config.sh _sub-scripts/*.sh
touch --reference=__root_script_config.sh _template/*.sh
touch --reference=__root_script_config.sh _template/Code_Snipets/*.sh
touch --reference=__root_script_config.sh Common/*.sh
touch --reference=__root_script_config.sh Config/*.sh
touch --reference=__root_script_config.sh GW/*.sh
touch --reference=__root_script_config.sh Health_Check/check_status_checkpoint_services.*.sh
touch --reference=__root_script_config.sh Health_Check/run_healthcheck_to_dump_dtg.*.sh
touch --reference=__root_script_config.sh MDM/*.sh
touch --reference=__root_script_config.sh Patch_HotFix/*.sh
touch --reference=__root_script_config.sh Session_Cleanup/*.sh
touch --reference=__root_script_config.sh SmartEvent/*.sh
touch --reference=__root_script_config.sh SMS/*.sh
touch --reference=__root_script_config.sh SMS/*.help
touch --reference=__root_script_config.sh UserConfig/*.sh
touch --reference=__root_script_config.sh UserConfig.CORE_G2.NPM/*.sh

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
