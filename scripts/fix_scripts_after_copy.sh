#!/bin/bash
#
# SCRIPT Fix Scripts After Copy
#
# (C) 2017-2018 Eric James Beasley
#
ScriptTemplateLevel=005
ScriptVersion=02.01.00
ScriptDate=2018-12-03
#

export BASHScriptVersion=v02x01x00

# =============================================================================
# =============================================================================
# 
# =============================================================================

dos2unix *.sh
dos2unix *.version
dos2unix _sub-scripts/*.sh
dos2unix _template/*.sh
dos2unix _template/Code_Snipets/*.sh
dos2unix Common/*.sh
dos2unix Config/*.sh
dos2unix GW/*.sh
dos2unix Health_Check/*.sh
dos2unix MDM/*.sh
dos2unix Patch_HotFix/*.sh
dos2unix Session_Cleanup/*.sh
dos2unix Session_Cleanup/common/*.sh
dos2unix SmartEvent/*.sh
dos2unix SMS/*.sh
dos2unix UserConfig/*.sh

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
