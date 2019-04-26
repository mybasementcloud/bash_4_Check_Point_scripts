#!/bin/bash
#
# SCRIPT Fix Scripts After Copy
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-03-08
ScriptVersion=04.00.00
ScriptRevision=000
TemplateLevel=006
TemplateVersion=04.00.00
#

export BASHScriptVersion=v${ScriptVersion//./x}

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
