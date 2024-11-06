#!/bin/bash
#
# (C) 2016-2024 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
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
# SCRIPT Touch Scripts
#
#
ScriptDate=2024-01-12
ScriptVersion=05.35.00
ScriptRevision=000
ScriptSubRevision=000
TemplateVersion=05.35.00
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

export BASHScriptFileNameRoot=touch_all_scripts
export BASHScriptShortName=${BASHScriptFileNameRoot}
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Touch all Scripts, Help, and Versions"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}

export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|scripts_tools|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=scripts_tools

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

touch *.sh
touch --reference=__root_script_config.sh *.version
touch --reference=__root_script_config.sh *.clish
touch --reference=__root_script_config.sh *.help
touch --reference=__root_script_config.sh Code_Snipets/*.sh
touch --reference=__root_script_config.sh help/*.help
touch --reference=__root_script_config.sh _api_subscripts/*.sh
touch --reference=__root_script_config.sh _api_subscripts/*.version
touch --reference=__root_script_config.sh _api_subscripts/help*/*.help
touch --reference=__root_script_config.sh _hostsetupscripts/*.sh
touch --reference=__root_script_config.sh _hostsetupscripts/*.version
touch --reference=__root_script_config.sh _hostsetupscripts/help*/*.help
touch --reference=__root_script_config.sh _hostupdatescripts/*.sh
touch --reference=__root_script_config.sh _hostupdatescripts/*.version
touch --reference=__root_script_config.sh _hostupdatescripts/help*/*.help
touch --reference=__root_script_config.sh _subscripts/*.sh
touch --reference=__root_script_config.sh _subscripts/*.version
touch --reference=__root_script_config.sh _subscripts/help*/*.help
touch --reference=__root_script_config.sh _template/*.sh
touch --reference=__root_script_config.sh _template/*.version
touch --reference=__root_script_config.sh _template/Code_Snipets/*.sh
touch --reference=__root_script_config.sh _template/help/*.help
touch --reference=__root_script_config.sh alias_commands/*.sh
touch --reference=__root_script_config.sh alias_commands.SAMPLE/*.sh
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

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
