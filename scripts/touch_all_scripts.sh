#!/bin/bash
#
# SCRIPT Fix Scripts After Copy
#
# (C) 2017-2018 Eric James Beasley
#
ScriptVersion=00.02.00
ScriptDate=2018-09-29
#

export BASHScriptVersion=v00x02x00

# =============================================================================
# =============================================================================
# 
# =============================================================================

touch *.sh
touch --reference=__root_script_config.sh *.version
touch --reference=__root_script_config.sh _sub-scripts/*.sh
touch --reference=__root_script_config.sh _template/*.sh
touch --reference=__root_script_config.sh Common/*.sh
touch --reference=__root_script_config.sh Config/*.sh
touch --reference=__root_script_config.sh GW/*.sh
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
