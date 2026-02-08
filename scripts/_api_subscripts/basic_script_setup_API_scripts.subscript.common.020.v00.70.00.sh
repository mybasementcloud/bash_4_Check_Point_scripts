#!/bin/bash
#
# (C) 2016-2026+ Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/R8X_mgmt_cli_API_bash_scripts
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
# SCRIPT Subscript for basic script setup API Scripts common action handling
#
#
ScriptVersion=00.70.00
ScriptRevision=000
ScriptSubRevision=275
ScriptDate=2025-12-12
TemplateVersion=00.70.00
APISubscriptsLevel=020
APISubscriptsVersion=00.70.00
APISubscriptsRevision=000

#

export APISubscriptsScriptVersion=v${ScriptVersion}
export APISubscriptsScriptTemplateVersion=v${TemplateVersion}

export APISubscriptsScriptVersionX=v${ScriptVersion//./x}
export APISubscriptsScriptTemplateVersionX=v${TemplateVersion//./x}

APISubScriptName=basic_script_setup_API_scripts.subscript.common.${APISubscriptsLevel}.v${APISubscriptsVersion}
export APISubScriptFileNameRoot="X"
export APISubScriptShortName="X"
export APISubScriptnohupName=${APISubScriptShortName}
export APISubScriptDescription="Subscript for basic script setup API Scripts common action handling"


# =================================================================================================
# =================================================================================================
# START subscript:  Basic Script Setup API Scripts
# =================================================================================================


echo `${dtzs}`${dtzsep} '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} '===============================================================================' | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} 'APISubScript Name:  '${APISubScriptName}'  Script Version: '${ScriptVersion}'  Revision: '${ScriptRevision}.${ScriptSubRevision} | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} 'APISubScript original call name :  '$0 | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} 'APISubScript initial parameters :  '"$@" | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} '===============================================================================' | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}


# =================================================================================================
# Validate Common Subscripts  Script version is correct for caller
# =================================================================================================


# MODIFIED 2021-10-21 -

if [ x"${APIExpectedAPISubscriptsVersion}" = x"${APISubscriptsScriptVersion}" ] ; then
    # Script and Common Subscripts Script versions match, go ahead
    echo `${dtzs}`${dtzsep} >> ${logfilepath}
    echo `${dtzs}`${dtzsep} 'Verify Common Subscripts Scripts Version - OK' >> ${logfilepath}
    echo `${dtzs}`${dtzsep} >> ${logfilepath}
else
    # Script and Subscripts Script versions don't match, ALL STOP!
    echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} 'Raw Script name        : '$0 | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} 'Subscript version name : '${APISubscriptsScriptVersion}' '${APISubScriptName} | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} 'Calling Script version : '${APIScriptVersion} | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} 'Verify Common Subscripts Scripts Version - Missmatch' | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} 'Expected Common Subscripts Script version : '${APIExpectedAPISubscriptsVersion} | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} 'Current  Common Subscripts Script version : '${APISubscriptsScriptVersion} | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
    echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
    
    exit 250
fi

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# Single Line entries
#printf 'variable :  %-25s = %s\n' "x" ${x} >> ${logfilepath}
#printf "%-35s$ : %s\n" "x" 'x' >> ${logfilepath}
# Two Line entries
#printf "%s\n" "x" >> ${logfilepath}
#printf "%-35s :: %s\n" " " 'x' >> ${logfilepath}


# -------------------------------------------------------------------------------------------------
# Handle important basics
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# 
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Handle important basics
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# START:  Local Variables
# =================================================================================================


export subscriptstemplogfilepath=/var/tmp/${ScriptName}'_'${APIScriptVersion}'_temp_'${DATEDTGS}.log


# =================================================================================================
# START Procedures:  Local Proceedures - 
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# SetupTempLogFile - Setup Temporary Log File and clear any debris
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-03-07:01 - \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

SetupTempLogFile () {
    #
    # SetupTempLogFile - Setup Temporary Log File and clear any debris
    #
    
    if [ -z "$1" ]; then
        # No explicit name passed for action
        export subscriptstemplogfilepath=/var/tmp/${ScriptName}'_'${APIScriptVersion}'_temp_'${DATEDTGS}.log
    else
        # explicit name passed for action
        export subscriptstemplogfilepath=/var/tmp/${ScriptName}'_'${APIScriptVersion}'_temp_'$1'_'${DATEDTGS}.log
    fi
    
    if [ -w ${subscriptstemplogfilepath} ] ; then
        echo -n `${dtzs}`${dtzsep} >> ${logfilepath}
        rm -v ${subscriptstemplogfilepath} >> ${logfilepath} 2>&1
    fi
    
    touch ${subscriptstemplogfilepath}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/ - MODIFIED 2023-03-07:01


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# HandleShowTempLogFile - Handle Showing of Temporary Log File based on verbose setting
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-03-07:01 - \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

HandleShowTempLogFile () {
    #
    # HandleShowTempLogFile - Handle Showing of Temporary Log File based on verbose setting
    #
    
    if ${APISCRIPTVERBOSE} ; then
        # verbose mode so show the logged results and copy to normal log file
        cat ${subscriptstemplogfilepath} | tee -a -i ${logfilepath}
    else
        # NOT verbose mode so push logged results to normal log file
        cat ${subscriptstemplogfilepath} >> ${logfilepath}
    fi
    
    echo -n `${dtzs}`${dtzsep} >> ${logfilepath}
    rm -v ${subscriptstemplogfilepath} >> ${logfilepath} 2>&1
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/ - MODIFIED 2023-03-07:01


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# ForceShowTempLogFile - Handle Showing of Temporary Log File based forced display
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-03-07:01 - \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

ForceShowTempLogFile () {
    #
    # ForceShowTempLogFile - Handle Showing of Temporary Log File based forced display
    #
    
    cat ${subscriptstemplogfilepath} | tee -a -i ${logfilepath}
    
    echo -n `${dtzs}`${dtzsep} >> ${logfilepath}
    rm -v ${subscriptstemplogfilepath} >> ${logfilepath} 2>&1
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/ -  MODIFIED 2023-03-07:01


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# CheckAPIScriptVerboseOutput - Check if verbose output is configured externally
# -------------------------------------------------------------------------------------------------

# MODIFIED 2022-04-22 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

#
# CheckAPIScriptVerboseOutput - Check if verbose output is configured externally via shell level 
# parameter setting, if it is, the check it for correct and valid values; otherwise, if set, then
# reset to false because wrong.
#

CheckAPIScriptVerboseOutput () {
    
    if [ -z ${SCRIPTVERBOSE} ] ; then
        # Verbose mode not set from shell level
        echo `${dtzs}`${dtzsep} "!! Verbose mode not set from shell level" >> ${logfilepath}
        export SCRIPTVERBOSE=false
        export APISCRIPTVERBOSE=false
        echo `${dtzs}`${dtzsep} >> ${logfilepath}
    elif [ x"`echo "${SCRIPTVERBOSE}" | tr '[:upper:]' '[:lower:]'`" = x"false" ] ; then
        # Verbose mode set OFF from shell level
        echo `${dtzs}`${dtzsep} "!! Verbose mode set OFF from shell level" >> ${logfilepath}
        export SCRIPTVERBOSE=false
        export APISCRIPTVERBOSE=false
        echo `${dtzs}`${dtzsep} >> ${logfilepath}
    elif [ x"`echo "${SCRIPTVERBOSE}" | tr '[:upper:]' '[:lower:]'`" = x"true" ] ; then
        # Verbose mode set ON from shell level
        echo `${dtzs}`${dtzsep} "!! Verbose mode set ON from shell level" >> ${logfilepath}
        export SCRIPTVERBOSE=true
        export APISCRIPTVERBOSE=true
        echo `${dtzs}`${dtzsep} >> ${logfilepath}
        echo `${dtzs}`${dtzsep} 'Script :  '$0 >> ${logfilepath}
        echo `${dtzs}`${dtzsep} 'Verbose mode enabled' >> ${logfilepath}
        echo `${dtzs}`${dtzsep} >> ${logfilepath}
    elif ${SCRIPTVERBOSE} ; then
        # Verbose mode set ON
        export APISCRIPTVERBOSE=true
        echo `${dtzs}`${dtzsep} >> ${logfilepath}
        echo `${dtzs}`${dtzsep} 'Script :  '$0 >> ${logfilepath}
        echo `${dtzs}`${dtzsep} 'Verbose mode enabled' >> ${logfilepath}
        echo `${dtzs}`${dtzsep} >> ${logfilepath}
    else
        # Verbose mode set to wrong value from shell level
        echo `${dtzs}`${dtzsep} "!! Verbose mode set to wrong value from shell level >"${SCRIPTVERBOSE}"<" >> ${logfilepath}
        echo `${dtzs}`${dtzsep} "!! Settting Verbose mode OFF, pending command line parameter checking!" >> ${logfilepath}
        export SCRIPTVERBOSE=false
        export APISCRIPTVERBOSE=false
        echo `${dtzs}`${dtzsep} >> ${logfilepath}
    fi
    
    export APISCRIPTVERBOSECHECK=true
    
    echo `${dtzs}`${dtzsep} >> ${logfilepath}
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2022-04-22


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


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
    
    # ADDED 2025-12-12 -
    
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
    elif [ -r "./_tools/JQ_v01.06.00/${JQ181FILE}" ] ; then
        # OK we have the local folder alternative
        export JQ181=./_tools/JQ_v01.06.00/${JQ181FILE}
        export JQ181NotFound=false
        export UseJSONJQ181=true
        export JQ181FQFN=./_tools/JQ_v01.06.00/${JQ181FILE}
        echo `${dtzs}`${dtzsep} "JQ v 1.8.1 found as jq-linux64 or jq, at ${JQ181FILE}" | tee -a -i ${logfilepath}
    elif [ -r "../_tools/JQ_v01.06.00/${JQ181FILE}" ] ; then
        # OK we have the parent folder alternative
        export JQ181=../_tools/JQ_v01.06.00/${JQ181FILE}
        export JQ181NotFound=false
        export UseJSONJQ181=true
        export JQ181FQFN=../_tools/JQ_v01.06.00/${JQ181FILE}
        echo `${dtzs}`${dtzsep} "JQ v 1.8.1 found as jq-linux64 or jq, at ${JQ181FILE}" | tee -a -i ${logfilepath}
    elif [ -r "../../_tools/JQ_v01.06.00/${JQ181FILE}" ] ; then
        # OK we have the parent folder alternative
        export JQ181=../../_tools/JQ_v01.06.00/${JQ181FILE}
        export JQ181NotFound=false
        export UseJSONJQ181=true
        export JQ181FQFN=../../_tools/JQ_v01.06.00/${JQ181FILE}
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


# -------------------------------------------------------------------------------------------------
# ExecuteBasicScriptSetupAPIScripts - Execute Basic Script Setup for API Scripts
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-11-16 -

ExecuteBasicScriptSetupAPIScripts () {

    # We want to leave some externally set variables as they were
    #
    #export APISCRIPTVERBOSE=false
    export APISCRIPTVERBOSECHECK=false
    
    CheckAPIScriptVerboseOutput
    
    # variable JQ points to where jq is installed
    export JQ=${CPDIR_PATH}/jq/jq
    
    ConfigureJQLocation
    
    return 0
}


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# 
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# END Procedures:  Local Proceedures
# =================================================================================================


# =================================================================================================
# START:  Basic Script Setup API Scripts
# =================================================================================================


ExecuteBasicScriptSetupAPIScripts "$@"


# =================================================================================================
# END:  Basic Script Setup API Scripts
# =================================================================================================


echo `${dtzs}`${dtzsep} '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} '===============================================================================' | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} 'API Subscript Completed :  '${APISubScriptName} | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} '===============================================================================' | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo `${dtzs}`${dtzsep} | tee -a -i ${logfilepath}


return 0


# =================================================================================================
# END subscript:  Basic Script Setup API Scripts
# =================================================================================================
# =================================================================================================


