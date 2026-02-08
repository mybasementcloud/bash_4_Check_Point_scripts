#!/bin/bash
#
# (C) 2016-2026+ Eric James Beasley, mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
# AUTHOR REQUIRES ALL UTILIZATION FOR TRAINING OF AI OF ANY TYPE TO BE REQUESTED IN WRITING AND
# APPROVED IN WRITING VERIFIABLY BEFORE ANY SUCH AI TRAINING SHALL COMMENCE.
#
#
# -#- Start Making Changes Here -#- 
#
# Sample
#
# SCRIPT Root Script Configuration Parameters
#
#
ScriptDate=2026-02-08
ScriptVersion=05.38.00
ScriptRevision=000
ScriptSubRevision=275
TemplateVersion=05.38.00
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.38.00
#

RootScriptVersion=v${ScriptVersion}
RootScriptVersionX=v${ScriptVersion//./x}
#RootScriptName=__root_script_config.v$RootScriptVersion

RootScriptName=__root_script_config
RootScriptShortName=__root_script_config
RootScriptDescription="Root Script Configuration Parameters"


# =================================================================================================
# =================================================================================================
# START __root script:  Basic Script Setup Operations
# =================================================================================================


if ${SCRIPTVERBOSE} ; then
    echo | tee -a -i ${logfilepath}
    echo '__Root Script Name:  '${RootScriptName}'  __Root Script Version: '${RootScriptVersion}'  __Root Script Revision:  '${ScriptRevision}'  __Root Script Subrevision:  '${ScriptSubRevision} | tee -a -i ${logfilepath}
    echo ${RootScriptDescription}'  Subscript Level:  '${SubScriptsLevel}'  Template Version: '${TemplateVersion} | tee -a -i ${logfilepath}
    echo '__Root Script Starting...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
else
    echo >> ${logfilepath}
    echo '__Root Script Name:  '${RootScriptName}'  __Root Script Version: '${RootScriptVersion}'  __Root Script Revision:  '${ScriptRevision}'  __Root Script Subrevision:  '${ScriptSubRevision} >> ${logfilepath}
    echo ${RootScriptDescription}'  Subscript Level:  '${SubScriptsLevel}'  Template Version: '${TemplateVersion} >> ${logfilepath}
    echo '__Root Script Starting...' >> ${logfilepath}
    echo >> ${logfilepath}
fi


# =============================================================================
# Standard paths and folders
# =============================================================================


export customerpathroot=/var/log/__customer
export customerdownloadpathroot=${customerpathroot}/download
export downloadpathroot=${customerdownloadpathroot}
export customerscriptspathroot=${customerpathroot}/_scripts
export scriptspathmain=${customerscriptspathroot}
export scriptspathb4CP=${scriptspathmain}/bash_4_Check_Point
export customerworkpathroot=${customerpathroot}/upgrade_export
export outputpathroot=${customerworkpathroot}
export dumppathroot=${customerworkpathroot}/dump
export changelogpathroot=${customerworkpathroot}/Change_Log

export customerapipathroot=${customerpathroot}/devops
export customerapiwippathroot=${customerpathroot}/devops.dev

export customerdevopspathroot=${customerpathroot}/devops
export customerdevopsdevpathroot=${customerpathroot}/devops.dev
export customerdevopsresultspathroot=${customerpathroot}/devops.results


# =============================================================================
# Date and Time related values and formulas
# =============================================================================


export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

export DATEUTC=`date -u +%Y-%m-%d-%H%M%Z`
export DATEUTCDTG=`date -u +%Y-%m-%d-%H%M%Z`
export DATEUTCDTGS=`date -u +%Y-%m-%d-%H%M%S%Z`
export DATEUTCYMD=`date -u +%Y-%m-%d`


# WAITTIME in seconds for read -t commands
export WAITTIME=15


# =============================================================================
# Output formating values
# =============================================================================


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


export dtzs='date -u +%Y%m%d-%T-%Z'
export dtzsep=' | '


# -------------------------------------------------------------------------------------------------
# UI Display Prefix Parameters, check if user has set environment preferences
# -------------------------------------------------------------------------------------------------


export dot_enviroinfo_file='.environment_info.json'
export dot_enviroinfo_path=${customerpathroot}
export dot_enviroinfo_fqpn=
if [ -r "./${dot_enviroinfo}" ] ; then
    export dot_enviroinfo_path='.'
    export dot_enviroinfo_fqpn=${dot_enviroinfo_path}/${dot_enviroinfo_file}
elif [ -r "../${dot_enviroinfo}" ] ; then
    export dot_enviroinfo_path='..'
    export dot_enviroinfo_fqpn=${dot_enviroinfo_path}/${dot_enviroinfo_file}
elif [ -r "${scriptspathroot}/${dot_enviroinfo}" ] ; then
    export dot_enviroinfo_path=${scriptspathroot}
    export dot_enviroinfo_fqpn=${dot_enviroinfo_path}/${dot_enviroinfo_file}
elif [ -r "${customerpathroot}/${dot_enviroinfo}" ] ; then
    export dot_enviroinfo_path=${customerpathroot}
    export dot_enviroinfo_fqpn=${dot_enviroinfo_path}/${dot_enviroinfo_file}
else
    export dot_enviroinfo_path='.'
    export dot_enviroinfo_fqpn=${dot_enviroinfo_path}/${dot_enviroinfo_file}
fi

if [ -r ${dot_enviroinfo_fqpn} ] ; then
    getdtzs=`cat ${dot_enviroinfo_fqpn} | jq -r ."script_ui_config"."dtzs"`
    readdtzs=${getdtzs}
    if [ x"${readdtzs}" != x"" ] ; then
        export dtzs=${readdtzs}
    fi
    getdtzsep=`cat ${dot_enviroinfo_fqpn} | jq -r ."script_ui_config"."dtzsep"`
    readdtzsep=${getdtzsep}
    if [ x"${readdtzsep}" != x"" ] ; then
        export dtzsep=${readdtzsep}
    fi
fi


# =============================================================================
# JSON Query JQ and version specific JQ16 values
# =============================================================================

# MODIFIED 2026-01-14 -

# -------------------------------------------------------------------------------------------------
# ConfigureJQLocation - Configure the value of JQ based on installation
# -------------------------------------------------------------------------------------------------

# MODIFIED 2025-12-12 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# ConfigureJQLocation - Configure the value of JQ based on installation
#

# MODIFIED 2025-12-12 -
ConfigureJQLocation () {
    #
    # Configure JQ variable value for JSON parsing
    #
    # variable JQ points to where jq is installed
    #
    # Apparently MDM, MDS, and Domains don't agree on who sets CPDIR, so better to check!
    
    #export JQ=${CPDIR}/jq/jq
    
    
    # =============================================================================
    # JSON Query JQ and version specific JQ16 values
    # =============================================================================
    
    export JQNotFound=true
    export UseJSONJQ=false
    
    # As of template version v04.21.00 we also added jq version 1.6 to the mix and it lives in the customer path root /tools/JQ folder by default
    # As of template version v00.70.00.000.275 jq is in /tools/JQ as jq=linux64 and is version 1.8.1
    #export JQPATH=${customerpathroot}/_tools/JQ
    export JQPATH=${customerpathroot}/_tools/JQ
    export JQFILE=jq-linux64
    export JQFQFN=${JQPATH}/${JQFILE}
    
    # JQ points to where the default jq is installed, probably version 1.4
    if [ -r ${JQFQFN} ] ; then
        # OK we have the easy-button alternative
        export JQFILE=jq-linux64
        export JQ=${JQFQFN}
        export JQNotFound=false
        export UseJSONJQ=true
        export JQFQFN=${JQFQFN}
        echo `${dtzs}`${dtzsep} "jq-linux64 or jq, found as ${JQFQFN}" | tee -a -i ${logfilepath}
    elif [ -r "./_tools/JQ/${JQFILE}" ] ; then
        # OK we have the local folder alternative
        export JQFILE=jq-linux64
        export JQ=./_tools/JQ/${JQFILE}
        export JQNotFound=false
        export UseJSONJQ=true
        export JQFQFN=./_tools/JQ/${JQFILE}
        echo `${dtzs}`${dtzsep} "jq-linux64 or jq, found as ${JQFQFN}" | tee -a -i ${logfilepath}
    elif [ -r "../_tools/JQ/${JQFILE}" ] ; then
        # OK we have the parent folder alternative
        export JQFILE=jq-linux64
        export JQ=../_tools/JQ/${JQFILE}
        export JQNotFound=false
        export UseJSONJQ=true
        export JQFQFN=../_tools/JQ/${JQFILE}
        echo `${dtzs}`${dtzsep} "jq-linux64 or jq, found as ${JQFQFN}" | tee -a -i ${logfilepath}
    elif [ -r "../../_tools/JQ/${JQFILE}" ] ; then
        # OK we have the parent folder alternative
        export JQFILE=jq-linux64
        export JQ=../../_tools/JQ/${JQFILE}
        export JQNotFound=false
        export UseJSONJQ=true
        export JQFQFN=../../_tools/JQ/${JQFILE}
        echo `${dtzs}`${dtzsep} "jq-linux64 or jq, found as ${JQFQFN}" | tee -a -i ${logfilepath}
    elif [ -r ${CPDIR}/jq/jq ] ; then
        export JQFILE=jq
        #export JQ=${CPDIR}/jq/${JQFILE}
        export JQ=${CPDIR}/jq/jq
        export JQNotFound=false
        export UseJSONJQ=true
        export JQFQFN=${CPDIR}/jq/${JQFILE}
        echo `${dtzs}`${dtzsep} "jq-linux64 or jq, found as ${JQFQFN}" | tee -a -i ${logfilepath}
    elif [ -r ${CPDIR_PATH}/jq/jq ] ; then
        export JQFILE=jq
        #export JQ=${CPDIR_PATH}/jq/${JQFILE}
        export JQ=${CPDIR_PATH}/jq/jq
        export JQNotFound=false
        export UseJSONJQ=true
        export JQFQFN=${CPDIR_PATH}/jq/${JQFILE}
        echo `${dtzs}`${dtzsep} "jq-linux64 or jq, found as ${JQFQFN}" | tee -a -i ${logfilepath}
    elif [ -r ${MDS_CPDIR}/jq/jq ] ; then
        export JQFILE=jq
        #export JQ=${MDS_CPDIR}/jq/${JQFILE}
        export JQ=${MDS_CPDIR}/jq/jq
        export JQNotFound=false
        export UseJSONJQ=true
        export JQFQFN=${MDS_CPDIR}/jq/${JQFILE}
        echo `${dtzs}`${dtzsep} "jq-linux64 or jq, found as ${JQFQFN}" | tee -a -i ${logfilepath}
    else
        export JQFILE=jq
        export JQ=
        export JQNotFound=true
        export UseJSONJQ=false
        export JQFQFN=
        echo `${dtzs}`${dtzsep} "JQ NOT found!" | tee -a -i ${logfilepath}
    fi
    
    # JQ16 points to where jq 1.6 is installed, which is not generally part of Gaia, even R80.40EA (2020-01-20)
    export JQ16NotFound=true
    export UseJSONJQ16=false
    
    # As of template version v04.21.00 we also added jq version 1.6 to the mix and it lives in the customer path root /tools/JQ folder by default
    # As of template version v00.70.00.000.275 JQ 1.6 is in /tools/JQ_v01.06.00
    #export JQ16PATH=${customerpathroot}/_tools/JQ
    export JQ16PATH=${customerpathroot}/_tools/JQ_v01.06.00
    export JQ16FILE=jq-linux64
    export JQ16FQFN=${JQ16PATH}/${JQ16FILE}
    
    if [ -r ${JQ16FQFN} ] ; then
        # OK we have the easy-button alternative
        export JQ16=${JQ16FQFN}
        export JQ16NotFound=false
        export UseJSONJQ16=true
        export JQ16FQFN=${JQ16FQFN}
        echo `${dtzs}`${dtzsep} "JQ v 1.6 found as jq-linux64 or jq, at ${JQ16FQFN}" | tee -a -i ${logfilepath}
    elif [ -r "./_tools/JQ_v01.06.00/${JQ16FILE}" ] ; then
        # OK we have the local folder alternative
        export JQ16=./_tools/JQ_v01.06.00/${JQ16FILE}
        export JQ16NotFound=false
        export UseJSONJQ16=true
        export JQ16FQFN=./_tools/JQ_v01.06.00/${JQ16FILE}
        echo `${dtzs}`${dtzsep} "JQ v 1.6 found as jq-linux64 or jq, at ${JQ16FQFN}" | tee -a -i ${logfilepath}
    elif [ -r "../_tools/JQ_v01.06.00/${JQ16FILE}" ] ; then
        # OK we have the parent folder alternative
        export JQ16=../_tools/JQ_v01.06.00/${JQ16FILE}
        export JQ16NotFound=false
        export UseJSONJQ16=true
        export JQ16FQFN=../_tools/JQ_v01.06.00/${JQ16FILE}
        echo `${dtzs}`${dtzsep} "JQ v 1.6 found as jq-linux64 or jq, at ${JQ16FQFN}" | tee -a -i ${logfilepath}
    elif [ -r "../../_tools/JQ_v01.06.00/${JQ16FILE}" ] ; then
        # OK we have the parent folder alternative
        export JQ16=../../_tools/JQ_v01.06.00/${JQ16FILE}
        export JQ16NotFound=false
        export UseJSONJQ16=true
        export JQ16FQFN=../../_tools/JQ_v01.06.00/${JQ16FILE}
        echo `${dtzs}`${dtzsep} "JQ v 1.6 found as jq-linux64 or jq, at ${JQ16FQFN}" | tee -a -i ${logfilepath}
    else
        # nope, not part of the package, so clear the values
        export JQ16=
        export JQ16NotFound=true
        export UseJSONJQ16=false
        export JQ16FQFN=
        echo `${dtzs}`${dtzsep} "JQ v 1.6 NOT found!" | tee -a -i ${logfilepath}
    fi
    
    # MODIFIED 2026-02-01:01 -
    
    # JQ181 points to where jq 1.8.1 is installed, which is not generally part of Gaia, even R82
    export JQ181NotFound=true
    export UseJSONJQ181=false
    
    # As of template version v00.70.00.000.275 JQ 1.8.1 is in /tools/JQ_v01.08.01
    #export JQ181PATH=${customerpathroot}/_tools/JQ_v01.08.01
    export JQ181PATH=${customerpathroot}/_tools/JQ_v01.08.01
    export JQ181FILE=jq-linux64
    export JQ181FQFN=${JQ181PATH}/${JQ181FILE}
    
    if [ -r ${JQ181FQFN} ] ; then
        # OK we have the easy-button alternative
        export JQ181=${JQ181FQFN}
        export JQ181NotFound=false
        export UseJSONJQ181=true
        export JQ181FQFN=${JQ181FQFN}
        echo `${dtzs}`${dtzsep} "JQ v 1.8.1 found as jq-linux64 or jq, at ${JQ181FILE}" | tee -a -i ${logfilepath}
    elif [ -r "./_tools/JQ_v01.08.01/${JQ181FILE}" ] ; then
        # OK we have the local folder alternative
        export JQ181=./_tools/JQ_v01.08.01/${JQ181FILE}
        export JQ181NotFound=false
        export UseJSONJQ181=true
        export JQ181FQFN=./_tools/JQ_v01.08.01/${JQ181FILE}
        echo `${dtzs}`${dtzsep} "JQ v 1.8.1 found as jq-linux64 or jq, at ${JQ181FILE}" | tee -a -i ${logfilepath}
    elif [ -r "../_tools/JQ_v01.08.01/${JQ181FILE}" ] ; then
        # OK we have the parent folder alternative
        export JQ181=../_tools/JQ_v01.08.01/${JQ181FILE}
        export JQ181NotFound=false
        export UseJSONJQ181=true
        export JQ181FQFN=../_tools/JQ_v01.08.01/${JQ181FILE}
        echo `${dtzs}`${dtzsep} "JQ v 1.8.1 found as jq-linux64 or jq, at ${JQ181FILE}" | tee -a -i ${logfilepath}
    elif [ -r "../../_tools/JQ_v01.08.01/${JQ181FILE}" ] ; then
        # OK we have the parent folder alternative
        export JQ181=../../_tools/JQ_v01.08.01/${JQ181FILE}
        export JQ181NotFound=false
        export UseJSONJQ181=true
        export JQ181FQFN=../../_tools/JQ_v01.08.01/${JQ181FILE}
        echo `${dtzs}`${dtzsep} "JQ v 1.8.1 found as jq-linux64 or jq, at ${JQ181FILE}" | tee -a -i ${logfilepath}
    else
        # nope, not part of the package, so clear the values
        export JQ181=
        export JQ181NotFound=true
        export UseJSONJQ181=false
        export JQ181FQFN=
        echo `${dtzs}`${dtzsep} "JQ v 1.8.1 NOT found!" | tee -a -i ${logfilepath}
    fi
    
    if ${JQNotFound} ; then
        echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
        echo `${dtzs}`${dtzsep} "Missing jq-linux64 or jq, not found in ${JQPATH}, ${CPDIR}/jq, ${CPDIR_PATH}/jq, or ${MDS_CPDIR}/jq" | tee -a -i ${logfilepath}
        echo `${dtzs}`${dtzsep} 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
        echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
        echo `${dtzs}`${dtzsep} "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
        echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
        exit 1
    fi
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2025-12-12


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


export JQNotFound=true
export UseJSONJQ=false

export JQ16NotFound=true
export UseJSONJQ16=false

export JQ181NotFound=true
export UseJSONJQ181=false

ConfigureJQLocation


# =============================================================================
# TFTP Export values
# =============================================================================

#
# Set EXPORTRESULTSTOTFPT to:
#   true    to export results from operation to one of the following defined target folders on the identified TFTP servers
#   false   to skip export of results to identified TFTP servers
#
# This section expects definition of the following external variables.  These are usually part of the user profile setup in the ${HOME} folder
#  MYTFTPSERVER     default TFTP/FTP server to use for TFTP/FTP operations, usually set to one of the following
#  MYTFTPSERVER1    first TFTP/FTP server to use for TFTP/FTP operations
#  MYTFTPSERVER2    second TFTP/FTP server to use for TFTP/FTP operations
#  MYTFTPSERVER3    third TFTP/FTP server to use for TFTP/FTP operations
#
#  MYTFTPSERVER* values are assumed to be an IPv4 Address (0.0.0.0 to 255.255.255.255) that represents a valid TFTP/FTP target host.
#  Setting one of the MYTFTPSERVER* to blank ignores that host.  Future scripts may include checks to see if the host actually has a reachable TFTP/FTP server
#
export EXPORTRESULTSTOTFPT=true
export tftptargetfolder_root=/_GAIA_CONFIG


# =============================================================================
# More root script configuration values?
# =============================================================================

# =============================================================================
# =============================================================================
# 
# =============================================================================

# =============================================================================
# =============================================================================
