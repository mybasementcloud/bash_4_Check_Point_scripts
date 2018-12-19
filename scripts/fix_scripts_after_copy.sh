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
