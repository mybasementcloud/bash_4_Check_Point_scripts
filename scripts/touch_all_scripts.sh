#!/bin/bash
#
# SCRIPT Fix Scripts After Copy
#
# (C) 2017-2018 Eric James Beasley
#
RootScriptTemplateLevel=006
RootScriptVersion=03.00.00
RootScriptDate=2018-12-18
#

RootScriptVersion=v03x00x00

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
touch --reference=__root_script_config.sh UserConfig/*.sh

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
