#!/bin/bash
#
# (C) 2016-2024 Eric James Beasley, mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
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
# SCRIPT Template for bash scripts, light, no logging enablement, level - 006
#
#
ScriptDate=2024-06-12
ScriptVersion=05.37.00
ScriptRevision=000
ScriptSubRevision=125
TemplateVersion=05.37.00
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

export BASHScriptFileNameRoot=_template_bash_scripts_light
export BASHScriptShortName=_template_light.${TemplateLevel}.v${ScriptVersion}
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Template Light for bash scripts"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}

export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}
export BASHScriptHelpFileExamplesName=${BASHScriptFileNameRoot}.examples.help
export BASHScriptHelpExamplesFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileExamplesName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|scripts_tools|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=_template

export BASHScripttftptargetfolder="_template"


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Basic Configuration
# -------------------------------------------------------------------------------------------------


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


# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------


export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

export DATEUTC=`date -u +%Y-%m-%d-%H%M%Z`
export DATEUTCDTG=`date -u +%Y-%m-%d-%H%M%Z`
export DATEUTCDTGS=`date -u +%Y-%m-%d-%H%M%S%Z`
export DATEUTCYMD=`date -u +%Y-%m-%d`


# -------------------------------------------------------------------------------------------------
# Other variable configuration
# -------------------------------------------------------------------------------------------------


WAITTIME=20

B4CPSCRIPTVERBOSE=false


# -------------------------------------------------------------------------------------------------
# END: Basic Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# CheckAndUnlockGaiaDB - Check and Unlock Gaia database
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-09-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CheckAndUnlockGaiaDB () {
    #
    # CheckAndUnlockGaiaDB - Check and Unlock Gaia database
    #
    
    echo -n 'Unlock gaia database : '
    
    export gaiadbunlocked=false
    
    until ${gaiadbunlocked} ; do
        
        export checkgaiadblocked=`clish -i -c "lock database override" | grep -i "owned"`
        export isclishowned=`test -z ${checkgaiadblocked}; echo $?`
        
        if [ ${isclishowned} -eq 1 ]; then 
            echo -n '.'
            export gaiadbunlocked=false
        else
            echo -n '!'
            export gaiadbunlocked=true
        fi
        
    done
    
    echo; echo
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-09-11

#CheckAndUnlockGaiaDB

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# Start of Script Operations
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Local Operations variables
# -------------------------------------------------------------------------------------------------


targetfolder=/var/log/__customer/upgrade_export


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
# script plumbing 1
# -------------------------------------------------------------------------------------------------


# do something


# -------------------------------------------------------------------------------------------------
# Closing operations and log file information
# -------------------------------------------------------------------------------------------------


# Something to cleanup

# -------------------------------------------------------------------------------------------------
# End of script Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

echo
echo 'Script Completed, exiting...';echo
