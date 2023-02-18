#!/bin/bash
#
# (C) 2016-2023 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
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
# -#- Start Making Changes Here -#- 
#
# SCRIPT Fix Scripts After Copy
#
#
ScriptDate=2023-02-17
ScriptVersion=05.33.01
ScriptRevision=000
ScriptSubRevision=150
TemplateVersion=05.33.01
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


# -------------------------------------------------------------------------------------------------
# Output formating values
# -------------------------------------------------------------------------------------------------

export txtCLEAR=`tput clear`

export txtNORM=`tput sgr0`
export txtBOLD=`tput bold`
export txtDIM=`tput dim`
export txtREVERSE=`tput rev`

export txtULINEbeg=`tput smul`
export txtULINEend=`tput rmul`

export txtSTANDOUTbeg=`tput smso`
export txtSTANDOUTend=`tput rmso`

export getWindowColumns=`tput cols`
export getWindowLines=`tput lines`


#tput setab color  Set ANSI Background color
#tput setaf color  Set ANSI Foreground color
export txtBLACK=`tput setaf 0`
export txtRED=`tput setaf 1`
export txtGREEN=`tput setaf 2`
export txtYELLOW=`tput setaf 3`
export txtBLUE=`tput setaf 4`
export txtMAGENTA=`tput setaf 5`
export txtCYAN=`tput setaf 6`
export txtWHITE=`tput setaf 7`
export txtDEFAULT=`tput setaf 9`

export txtbkgBLACK=`tput setab 0`
export txtbkgRED=`tput setab 1`
export txtbkgGREEN=`tput setab 2`
export txtbkgYELLOW=`tput setab 3`
export txtbkgBLUE=`tput setab 4`
export txtbkgMAGENTA=`tput setab 5`
export txtbkgCYAN=`tput setab 6`
export txtbkgWHITE=`tput setab 7`
export txtbkgDEFAULT=`tput setab 9`


#==================================================================================================
# Announce Script, this should also be the first log entry!
#==================================================================================================


# MODIFIED 2023-02-17:01 -

echo | tee -a -i ${logfilepath}
echo ${txtCYAN}${BASHScriptName}${txtDEFAULT}', script version '${txtYELLOW}${ScriptVersion}${txtDEFAULT}', revision '${txtYELLOW}${ScriptRevision}${txtDEFAULT}', subrevision '${txtGREEN}${ScriptSubRevision}${txtDEFAULT}' from '${txtYELLOW}${ScriptDate}${txtDEFAULT} | tee -a -i ${logfilepath}
echo ${BASHScriptDescription} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Date Time Group   :  '${txtCYAN}${DATEDTGS}${txtDEFAULT} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


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
