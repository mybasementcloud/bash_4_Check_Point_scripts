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
# SCRIPT Template for bash scripts subscripts or action scripts - Config Caputure Details Action Script - system_common
#
#
SubScriptDate=2024-06-12
SubScriptVersion=05.37.00
SubScriptRevision=000
SubScriptSubRevision=125
TemplateVersion=05.37.00
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.37.00
SubScriptTemplateVersion=05.37.00
#

BASHActualSubScriptVersion=v${SubScriptVersion}
BASHActualSubScriptVersionX=v${SubScriptVersion//./x}

BASHSubScriptsVersion=v${SubScriptsVersion}
BASHSubScriptsRevision=v${SubScriptRevision}

BASHSubScriptsVersionX=v${SubScriptsVersion//./x}
BASHSubScriptsRevisionX=v${SubScriptRevision//./x}

#export BASHExpectedSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion//./x}
BASHActualSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion}
BASHActualSubScriptsVersionX=${SubScriptsLevel}.v${SubScriptsVersion//./x}

BASHSubScriptsTemplateVersion=v${SubScriptTemplateVersion}
BASHSubScriptsTemplateVersionX=v${SubScriptTemplateVersion//./x}
BASHSubScriptsTemplateLevel=${TemplateLevel}.v${SubScriptTemplateVersion}
BASHSubScriptsTemplateLevelX=${TemplateLevel//./x}.v${SubScriptTemplateVersion//./x}

BASHSubScriptScriptTemplateVersion=v${TemplateVersion}
BASHSubScriptScriptTemplateLevel=${TemplateLevel}.v${TemplateVersion}
BASHSubScriptScriptTemplateVersionX=v${TemplateVersion//./x}
BASHSubScriptScriptTemplateLevelX=${TemplateLevel//./x}.v${TemplateVersion//./x}


SubScriptFileNameRoot=config_details_capture.action_script.system_common
SubScriptShortName="config_details_capture.system_common.${SubScriptsLevel}"
SubScriptDescription="Template for bash scripts subscripts or action scripts - Config Caputure Details Action Script - system_common"

#SubScriptName=$SubScriptFileNameRoot.subscript.${SubScriptsLevel}.v${SubScriptVersion}
#SubScriptName=$SubScriptFileNameRoot.subscript.${SubScriptsLevel}.v${SubScriptVersion}
SubScriptName=$SubScriptFileNameRoot.v${SubScriptVersion}

SubScriptHelpFileName=${SubScriptFileNameRoot}.help
SubScriptHelpFilePath=help.v${SubScriptVersion}
SubScriptHelpFile=${SubScriptHelpFilePath}/${SubScriptHelpFileName}


# =================================================================================================
# =================================================================================================
# START sub script:  _template sub script
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# Announce SubScript, this should also be the first log entry!
# -------------------------------------------------------------------------------------------------


# MODIFIED 2023-02-17:01 -

if ${SCRIPTVERBOSE} ; then
    echo | tee -a -i ${logfilepath}
    echo 'Subscript Name:  '${txtCYAN}${SubScriptName}${txtDEFAULT}'  Subscript Version: '${txtYELLOW}${SubScriptVersion}${txtDEFAULT}'  Subscript Revision:  '${txtYELLOW}${SubScriptRevision}${txtDEFAULT}'  Subscript Subrevision:  '${txtGREEN}${SubScriptSubRevision}${txtDEFAULT}'  Level:  '${txtYELLOW}${SubScriptsLevel}${txtDEFAULT}'  Template Version: '${txtYELLOW}${TemplateVersion}${txtDEFAULT} | tee -a -i ${logfilepath}
    echo ${SubScriptDescription} | tee -a -i ${logfilepath}
    echo 'Subscript Starting...' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
else
    echo >> ${logfilepath}
    echo 'Subscript Name:  '${txtCYAN}${SubScriptName}${txtDEFAULT}'  Subscript Version: '${txtYELLOW}${SubScriptVersion}${txtDEFAULT}'  Subscript Revision:  '${txtYELLOW}${SubScriptRevision}${txtDEFAULT}'  Subscript Subrevision:  '${txtGREEN}${SubScriptSubRevision}${txtDEFAULT}'  Level:  '${txtYELLOW}${SubScriptsLevel}${txtDEFAULT}'  Template Version: '${txtYELLOW}${TemplateVersion}${txtDEFAULT} >> ${logfilepath}
    echo ${SubScriptDescription}>> ${logfilepath}
    echo 'Subscript Starting...' >> ${logfilepath}
    echo >> ${logfilepath}
fi


# =================================================================================================
# Validate Sub-Script template version is correct for caller
# =================================================================================================


# MODIFIED 2020-11-19 -

if [ x"${BASHExpectedSubScriptsVersion}" = x"${BASHActualSubScriptsVersion}" ] ; then
    # Script and Actions Script versions match, go ahead
    echo >> ${logfilepath}
    echo 'Verify Actions Scripts Version - OK' >> ${logfilepath}
    echo >> ${logfilepath}
else
    # Script and Actions Script versions don't match, ALL STOP!
    echo | tee -a -i ${logfilepath}
    echo 'Verify Actions Scripts Version - Missmatch' | tee -a -i ${logfilepath}
    echo 'Raw Script name            : '$0 | tee -a -i ${logfilepath}
    echo 'Subscript version name     : '${SubScriptsVersion}' '${SubScriptName} | tee -a -i ${logfilepath}
    echo 'Calling Script version     : '${ScriptVersion} | tee -a -i ${logfilepath}
    echo 'Expected Subscript version : '${BASHExpectedSubScriptsVersion} | tee -a -i ${logfilepath}
    echo 'Current  Subscript version : '${BASHActualSubScriptsVersion} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'Critical Error - Exiting Script !!!!' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo "Log output in file ${logfilepath}" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 250
fi


# =================================================================================================
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# Handle important basics
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# START Procedures:  Local Proceedures - 
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# SetupTempLogFile - Setup Temporary Log File and clear any debris
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-19 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

SetupTempLogFile () {
    #
    # SetupTempLogFile - Setup Temporary Log File and clear any debris
    #
    
    if [ -z "$1" ]; then
        # No explicit name passed for action
        export APICLItemplogfilepath=/var/tmp/${SubScriptShortName}'_'${BASHActualSubScriptVersion}'_temp_'${DATEDTGS}.log
    else
        # explicit name passed for action
        export APICLItemplogfilepath=/var/tmp/${SubScriptShortName}'_'${BASHActualSubScriptVersion}'_temp_'$1'_'${DATEDTGS}.log
    fi
    
    rm ${localtemplogfilepath} >> ${logfilepath} 2> ${logfilepath}
    
    touch ${localtemplogfilepath}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-11-19


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# HandleShowTempLogFile - Handle Showing of Temporary Log File based on verbose setting
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-19 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

HandleShowTempLogFile () {
    #
    # HandleShowTempLogFile - Handle Showing of Temporary Log File based on verbose setting
    #
    
    if ${B4CPSCRIPTVERBOSE} ; then
        # verbose mode so show the logged results and copy to normal log file
        cat ${localtemplogfilepath} | tee -a -i ${logfilepath}
    else
        # NOT verbose mode so push logged results to normal log file
        cat ${localtemplogfilepath} >> ${logfilepath}
    fi
    
    rm ${localtemplogfilepath} >> ${logfilepath} 2> ${logfilepath}
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-11-19


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# ForceShowTempLogFile - Handle Showing of Temporary Log File based forced display
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-19 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

ForceShowTempLogFile () {
    #
    # ForceShowTempLogFile - Handle Showing of Temporary Log File based forced display
    #
    
    cat ${localtemplogfilepath} | tee -a -i ${logfilepath}
    
    rm ${localtemplogfilepath} >> ${logfilepath} 2> ${logfilepath}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2020-11-19


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# procedure_name - procedure description
# -------------------------------------------------------------------------------------------------


procedure_name () {
    #
    # procedure description
    #
    
    return 0
}


# -------------------------------------------------------------------------------------------------
# procedure_name - Procedure Call Example
# -------------------------------------------------------------------------------------------------

#procedure_name ${parameter1} ${parameter2}


# -------------------------------------------------------------------------------------------------
# END:  procedure_name - 
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# END Procedures:  Local Proceedures - 
# =================================================================================================


#==================================================================================================
# -------------------------------------------------------------------------------------------------
# START :  Operational Procedures
# -------------------------------------------------------------------------------------------------


#
# -#- Start Making Changes Here -#- 
#


# -------------------------------------------------------------------------------------------------
# CopyFileAndDump2FQDNOutputfile - Copy identified file at path to output file path and also dump to output file
# -------------------------------------------------------------------------------------------------

# MODIFIED 2022-03-08 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CopyFileAndDump2FQDNOutputfile () {
    #
    # Copy identified file at path to output file path and also dump to output file
    #
    
    export outputfile=${outputfileprefix}'_file_'${outputfilenameaddon}${file2copy}${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    if [[ -d "${file2copypathfqfp}" ]]; then
        echo "${file2copypathfqfp} is a directory" | tee -a -i ${outputfilefqfn}
        if [[ -f "${file2copypathfqfp}/${file2copy}" ]]; then
            echo "${file2copypathfqfp}/${file2copy} is a file" | tee -a -i ${outputfilefqfn}
            export file2copypathfqfp="${file2copypathfqfp}/${file2copy}"
        else
            echo "${file2copypathfqfp}/${file2copy} is not valid" | tee -a -i ${outputfilefqfn}
            return 1
        fi
    elif [[ -f "${file2copypathfqfp}" ]]; then
        echo "${file2copypathfqfp} is a file" | tee -a -i ${outputfilefqfn}
    else
        echo "${file2copypathfqfp} is not valid" | tee -a -i ${outputfilefqfn}
        return 1
    fi
    
    if [ ! -r ${file2copypathfqfp} ] ; then
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'NO File Found at Path! :  ' | tee -a -i ${outputfilefqfn}
        echo ' - File : '${file2copy} | tee -a -i ${outputfilefqfn}
        echo ' - Path : '"${file2copypathfqfp}" | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    else
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'Found File at Path :  ' | tee -a -i ${outputfilefqfn}
        echo ' - File : '${file2copy} | tee -a -i ${outputfilefqfn}
        echo ' - Path : '"${file2copypathfqfp}" | tee -a -i ${outputfilefqfn}
        echo 'Copy File at Path to Target : ' | tee -a -i ${outputfilefqfn}
        echo ' - File at Path : '"${file2copypathfqfp}" | tee -a -i ${outputfilefqfn}
        echo ' - to Target    : '"${outputfilefqdn}" | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        cp "${file2copypathfqfp}" "${outputfilefqdn}" >> ${outputfilefqfn}
        
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
        echo 'Dump contents of Source File to Logging File :' | tee -a -i ${outputfilefqfn}
        echo ' - Source File  : '"${file2copypathfqfp}" | tee -a -i ${outputfilefqfn}
        echo ' - Logging File : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        cat "${file2copypathfqfp}" >> ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    fi
    echo | tee -a -i ${outputfilefqfn}
    
    echo
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2022-03-08

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# CopyFileAndDump2FQDNOutputfile

# -------------------------------------------------------------------------------------------------
# FindFilesAndCollectIntoArchive - Document identified file locations to output file path and also collect into archive
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

FindFilesAndCollectIntoArchive () {
    #
    # Document identified file locations to output file path and also collect into archive
    #
    
    export file2findpath="/"
    export file2findname=${file2find/\*/(star)}
    export command2run=find
    export outputfile=${outputfileprefix}'_'${command2run}'_'${file2findname}${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Find file : '${file2find}' and document locations' | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    find / -name "${file2find}" 2> /dev/null >> ${outputfilefqfn}
    
    export archivefile='archive_'${file2findname}${outputfilesuffix}'.tgz'
    export archivefqfn=${outputfilefqdn}${archivefile}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Archive all found Files to Target Archive' | tee -a -i ${outputfilefqfn}
    echo ' - Found Files    : '${file2find} | tee -a -i ${outputfilefqfn}
    echo ' - Target Archive : '${archivefqfn} | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    tar czvf ${archivefqfn} --exclude=${customerworkpathroot}* $(find / -name "${file2find}" 2> /dev/null) >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#FindFilesAndCollectIntoArchive


# -------------------------------------------------------------------------------------------------
# FindFilesAndCollectIntoArchiveAllVariants - Document identified file locations to output file path and also collect into archive all variants
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

FindFilesAndCollectIntoArchiveAllVariants () {
    #
    # Document identified file locations to output file path and also collect into archive all variants
    #
    
    export file2findpath="/"
    export file2findname=${file2find/\*/(star)}
    export command2run=find
    export outputfile=${outputfileprefix}'_'${command2run}'_'${file2findname}'_all_variants'${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Find file : '${file2find}'* and document locations' | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    find / -name "${file2find}*" 2> /dev/null >> ${outputfilefqfn}
    
    export archivefile='archive_'${file2findname}'_all_variants'${outputfilesuffix}'.tgz'
    export archivefqfn=${outputfilefqdn}${archivefile}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Archive all found Files* to Target Archive' | tee -a -i ${outputfilefqfn}
    echo ' - Found Files    : '${file2find}'*' | tee -a -i ${outputfilefqfn}
    echo ' - Target Archive : '${archivefqfn} | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    tar czvf ${archivefqfn} --exclude=${customerworkpathroot}* $(find / -name "${file2find}*" 2> /dev/null) >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#export file2find=cpm.elg

#FindFilesAndCollectIntoArchiveAllVariants


# -------------------------------------------------------------------------------------------------
# FindFilesAndCollectIntoArchiveSpecific - Document identified file locations to output file path and also collect into archive specific variants
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

FindFilesAndCollectIntoArchiveSpecific () {
    #
    # Document identified file locations to output file path and also collect into archive specific variants
    #
    
    export file2findpath="/"
    export file2findname=${file2find/\*/(star)}
    export command2run=find
    export outputfile=${outputfileprefix}'_'${command2run}'_'${file2findname}'_specific_variants'${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Find file : '${file2find}'* and document locations' | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    find / -name "${file2find}*" 2> /dev/null >> ${outputfilefqfn}
    
    export archivefile='archive_'${file2findname}'_specific_variants'${outputfilesuffix}'.tgz'
    export archivefqfn=${outputfilefqdn}${archivefile}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Archive all found Files* to Target Archive' | tee -a -i ${outputfilefqfn}
    echo ' - Found Files    : '${file2findname} | tee -a -i ${outputfilefqfn}
    echo ' - Exclude        : '${file2findstartpath}'/' | tee -a -i ${outputfilefqfn}
    echo ' - Start Path     : '${file2findexclude}'/*' | tee -a -i ${outputfilefqfn}
    echo ' - Target Archive : '${archivefqfn} | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    tar czvf ${archivefqfn} --exclude=${file2findexclude}/* $(find ${file2findstartpath}/ -name "${file2find}*" 2> /dev/null) >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#export file2find=cpm.elg
#export file2findstartpath=${MDS_FWDIR}/log
#export file2findexclude=${MDS_FWDIR}/log/imported_logs

#FindFilesAndCollectIntoArchiveSpecific


# -------------------------------------------------------------------------------------------------
# CopyFiles2CaptureFolder - repeated proceedure
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CopyFiles2CaptureFolder () {
    #
    # repeated procedure description
    #
    
    export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
        export targetpath=${outputfilefqdn}${command2run}/
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
        export targetpath=${outputfilefqdn}${command2run}/
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Copy files from Source to Target' | tee -a -i ${outputfilefqfn}
    echo ' - Source : '${sourcepath} | tee -a -i ${outputfilefqfn}
    echo ' - Target : '${targetpath} | tee -a -i ${outputfilefqfn}
    echo ' - Log to : '"${outputfilefqfn}" | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    mkdir -pv ${targetpath} >> "${outputfilefqfn}" 2>&1
    
    echo >> ${outputfilefqfn}
    
    cp -a -v ${sourcepath} ${targetpath} | tee -a -i ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#CopyFiles2CaptureFolder


# -------------------------------------------------------------------------------------------------
# DoCommandAndDocument - Execute command and document results to dedicated file
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-10-05 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

DoCommandAndDocument () {
    #
    # repeated procedure description
    #
    
    export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
    if [ -z ${command2folder} ] ; then
        export outputfilefqdn=${outputfilepath}
        export outputfilefqfn=${outputfilepath}${outputfile}
    else
        export outputfilefqdn=${outputfilepath}${command2folder}/
        export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    fi
    
    if [ ! -r ${outputfilefqdn} ] ; then
        mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    else
        chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    fi
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Execute Command with output to Output Path : ' | tee -a -i ${outputfilefqfn}
    echo ' - Execute Command    : '${command2run} | tee -a -i ${outputfilefqfn}
    echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    echo ' - Command with Parms # '"$@" | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    "$@" >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED YYYY-MM-DD

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#DoCommandAndDocument


# -------------------------------------------------------------------------------------------------
# Populate DNS Servers - Populate DNS Servers for nslookup operations
# -------------------------------------------------------------------------------------------------

# MODIFIED 2021-08-30 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Populate_DNS_Servers () {
    #
    # Populate_DNS_Servers - Populate DNS Servers for nslookup operations
    #
    
    export DNS_primary=
    export DNS_secondary=
    export DNS_tertiary=
    
    export get_DNS_primary=`clish -c "show dns primary"`
    export get_DNS_secondary=`clish -c "show dns secondary"`
    export get_DNS_tertiary=`clish -c "show dns tertiary"`
    export DNS_primary=${get_DNS_primary}
    export DNS_secondary=${get_DNS_secondary}
    export DNS_tertiary=${get_DNS_tertiary}
    
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '| DNS Server Primary   :  '${DNS_primary} | tee -a -i ${outputfilefqfn}
    echo '| DNS Server Secondary :  '${DNS_secondary} | tee -a -i ${outputfilefqfn}
    echo '| DNS Server Tertiary  :  '${DNS_tertiary} | tee -a -i ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo tee -a -i ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2021-08-30

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#
#export DNS_primary=
#export DNS_secondary=
#export DNS_tertiary=
#
# Populate_DNS_Servers


# -------------------------------------------------------------------------------------------------
# Document_nslookup - Document nslookup of target URL with all DNS servers with log of response
# -------------------------------------------------------------------------------------------------

# MODIFIED 2021-08-30 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Document_nslookup () {
    #
    # Document_nslookup - Document nslookup of target URL with all DNS servers with log of response
    #
    
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '| nslookup address :  '${1}  | tee -a -i ${outputfilefqfn}
    
    if [ x"${DNS_primary}" != x"" ] ; then
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| nslookup command with DNS Server Primary :  '${DNS_primary} | tee -a -i ${outputfilefqfn}
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        
        nslookup ${1} ${DNS_primary} | tee -a -i ${outputfilefqfn}
    else
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| DNS Server Primary ['${DNS_primary}'] NOT DEFINED!' | tee -a -i ${outputfilefqfn}
    fi
    
    if [ x"${DNS_secondary}" != x"" ] ; then
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| nslookup command with DNS Server Secondary :  '${DNS_secondary} | tee -a -i ${outputfilefqfn}
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        
        nslookup ${1} ${DNS_secondary} | tee -a -i ${outputfilefqfn}
    else
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| DNS Server Secondary ['${DNS_secondary}'] NOT DEFINED!' | tee -a -i ${outputfilefqfn}
    fi
    
    if [ x"${DNS_tertiary}" != x"" ] ; then
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| nslookup command with DNS Server Tertiary :  '${DNS_tertiary} | tee -a -i ${outputfilefqfn}
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        
        nslookup ${1} ${DNS_tertiary} | tee -a -i ${outputfilefqfn}
    else
        echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo '| DNS Server Tertiary ['${DNS_tertiary}'] NOT DEFINED!' | tee -a -i ${outputfilefqfn}
    fi
    
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2021-08-30

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# Document_nslookup ${URL_to_check}


# -------------------------------------------------------------------------------------------------
# Document_curl - Document curl command with log of error response (the actual response)
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-01-19 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Document_curl () {
    #
    # Document_curl - Document curl command with log of error response (the actual response)
    #
    
    templogfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.curl_ops.log
    templogerrorfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.curl_ops.errout.log
    
    curl_cli "$@" 2> $templogerrorfile >> $templogfile
    curlerror=$?
    
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '| curl command | result = '$curlerror | tee -a -i ${outputfilefqfn}
    echo '| # curl_cli '$@ | tee -a -i ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    
    cat $templogfile >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    rm $templogfile >> ${outputfilefqfn}
    
    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' >> ${outputfilefqfn}
    
    cat $templogerrorfile >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    rm $templogerrorfile >> ${outputfilefqfn}
    
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-19

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# Document_curl


# -------------------------------------------------------------------------------------------------
# Document_wget - Document wget command with log of error response (the actual response)
# -------------------------------------------------------------------------------------------------

# MODIFIED 2023-02-17 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

Document_wget () {
    #
    # Document_wget - Document wget command with log of error response (the actual response)
    #
    
    templogfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.wget_ops.log
    templogerrorfile=${logfilepathbase}/${BASHScriptName}.${DATEDTGS}.wget_ops.errout.log
    
    rm index.html
    wget "$@" 2> ${templogerrorfile} >> ${templogfile}
    rm index.html
    wgeterror=$?
    
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo '| wget command | result = '${wgeterror} | tee -a -i ${outputfilefqfn}
    echo '| # wget '$@ | tee -a -i ${outputfilefqfn}
    echo '-----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    
    cat ${templogfile} >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    rm ${templogfile} >> ${outputfilefqfn}
    
    echo '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ' >> ${outputfilefqfn}
    
    cat ${templogerrorfile} >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    rm ${templogerrorfile} >> ${outputfilefqfn}
    
    echo '-----------------------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2023-02-17

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# Document_wget


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# END :  Operational Procedures
# -------------------------------------------------------------------------------------------------
#==================================================================================================


# =================================================================================================
# =================================================================================================
# START:  _template sub script
# =================================================================================================


#----------------------------------------------------------------------------------------
# bash - Gaia Version information 
#----------------------------------------------------------------------------------------

export command2folder=
export command2run=Gaia_version
export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
if [ -z ${command2folder} ] ; then
    export outputfilefqdn=${outputfilepath}
    export outputfilefqfn=${outputfilepath}${outputfile}
else
    export outputfilefqdn=${outputfilepath}${command2folder}/
    export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
fi

if [ ! -r ${outputfilefqdn} ] ; then
    mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
else
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
fi

# This was already collected earlier and saved in a dedicated file

cp ${gaiaversionoutputfile} ${outputfilefqfn} | tee -a -i ${logfilepath}
rm ${gaiaversionoutputfile} | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# clish and bash - Gather version information from all possible methods
#----------------------------------------------------------------------------------------

export command2folder=
export command2run=versions
export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
if [ -z ${command2folder} ] ; then
    export outputfilefqdn=${outputfilepath}
    export outputfilefqfn=${outputfilepath}${outputfile}
else
    export outputfilefqdn=${outputfilepath}${command2folder}/
    export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
fi

if [ ! -r ${outputfilefqdn} ] ; then
    mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
else
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
fi

echo | tee -a ${clishoutputfilefqfn}
echo 'Execute Command with output to Output Path : ' | tee -a -i ${clishoutputfilefqfn}
echo ' - Execute Command    : '${command2run} | tee -a -i ${clishoutputfilefqfn}
echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${clishoutputfilefqfn}
echo | tee -a ${clishoutputfilefqfn}

echo >> ${outputfilefqfn}
echo 'Execute Command with output to Output Path : ' >> ${outputfilefqfn}
echo ' - Execute Command    : '${command2run} >> ${outputfilefqfn}
echo ' - Output Path        : '${outputfilefqfn} >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

touch ${outputfilefqfn}
echo 'Versions:' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo 'uname for kernel version : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
uname -a >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'clish : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

CheckAndUnlockGaiaDB

clish -i -c "show version all" >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
clish -i -c "show version os build" >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'cpinfo -y all : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
cpinfo -y all >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'fwm ver : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
fwm ver >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'fw ver : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
fw ver >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
echo 'cpvinfo ${MDS_FWDIR}/cpm-server/dleserver.jar : ' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}
cpvinfo ${MDS_FWDIR}/cpm-server/dleserver.jar >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}

if ${IsR8XVersion}; then
    # installed_jumbo_take only exists in R7X
    echo >> ${outputfilefqfn}
else
    echo >> ${outputfilefqfn}
    echo 'installed_jumbo_take : ' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    installed_jumbo_take >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
fi

echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

cat ${outputfilefqfn} >> ${clishoutputfilefqfn}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather licensing information
#----------------------------------------------------------------------------------------

export command2folder=
export command2run=cplic_print

DoCommandAndDocument cplic print -x

#
#export command2run=cplic_db_print
#
#DoCommandAndDocument cplic db_print -all
#


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather container process information
#----------------------------------------------------------------------------------------

export command2folder=
export command2run=docker_ps

DoCommandAndDocument docker ps


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# files to collect sk160392 - List of Check Point Configuration Files on a Security Gateway that need to be re-configured after performing a clean installation on a Security Gateway 
# -------------------------------------------------------------------------------------------------

# Note: Some of these might not exist by default and may need to be created manually.
# 
# Note: Some of these might not be relevant, depending on whether these existed on the Security Gateway previously.
# 
# 
#     ${FWDIR}/boot/modules/fwkern.conf 
#     ${FWDIR}/boot/modules/vpnkern.conf 
#     simkern.conf 
#       Prior to R80.40
#           ${PPKDIR}/boot/modules/simkern.conf 
#       R80.40
#           ${PPKDIR}/conf/simkern.conf 
#     ${PPKDIR}/boot/modules/sim_aff.conf 
#     ${FWDIR}/conf/fwaffinity.conf 
#     ${FWDIR}/conf/fwauthd.conf 
#     ${FWDIR}/conf/local.arp 
#     ${FWDIR}/conf/discntd.if 
#     ${FWDIR}/conf/cpha_bond_ls_config.conf 
#     ${FWDIR}/conf/resctrl 
#     ${FWDIR}/conf/vsaffinity_exception.conf 
#     ${FWDIR}/database/qos_policy.C
# 


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Create directories to store the *.conf files
#----------------------------------------------------------------------------------------

#export conffilespathroot=${outputpathroot}/conf_files
#
# We actually want to have these configuration files
#
export command2folder=
if [ -z ${command2folder} ] ; then
    export conffilespathroot=${outputpathroot}/conf_files
else
    export conffilespathroot=${outputpathroot}/${command2folder}/conf_files
fi

if [ ! -r ${conffilespathroot} ] ; then
    mkdir -pv ${conffilespathroot} | tee -a -i ${logfilepath}
    chmod 775 ${conffilespathroot} | tee -a -i ${logfilepath}
else
    chmod 775 ${conffilespathroot} | tee -a -i ${logfilepath}
fi

export conffilespathFWDIRbootmodules=${conffilespathroot}/FWDIR_boot_modules
export conffilespathPPKDIRbootmodules=${conffilespathroot}/PPKDIR_boot_modules
export conffilespathPPKDIRconf=${conffilespathroot}/PPKDIR_conf
export conffilespathFWDIRconf=${conffilespathroot}/FWDIR_conf
export conffilespathFWDIRdatabase=${conffilespathroot}/FWDIR_database

echo '----------------------------------------------------------------------------' >> ${logfilepath}
echo '----------------------------------------------------------------------------' >> ${logfilepath}
echo 'conffilespathroot                      ='"${conffilespathroot}" | tee -a -i ${logfilepath}
echo 'conffilespathFWDIRbootmodules          ='"${conffilespathFWDIRbootmodules}" | tee -a -i ${logfilepath}
echo 'conffilespathPPKDIRbootmodules         ='"${conffilespathPPKDIRbootmodules}" | tee -a -i ${logfilepath}
echo 'conffilespathPPKDIRconf                ='"${conffilespathPPKDIRconf}" | tee -a -i ${logfilepath}
echo 'conffilespathFWDIRconf                 ='"${conffilespathFWDIRconf}" | tee -a -i ${logfilepath}
echo 'conffilespathFWDIRdatabase             ='"${conffilespathFWDIRdatabase}" | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------' >> ${logfilepath}

if [ ! -r ${conffilespathroot} ] ; then
    mkdir -pv ${conffilespathroot} >> ${logfilepath} 2>&1
    chmod 775 ${conffilespathroot} >> ${logfilepath} 2>&1
else
    #set permissions we need
    chmod 775 ${conffilespathroot} >> ${logfilepath} 2>&1
fi

if [ ! -r ${conffilespathFWDIRbootmodules} ] ; then
    mkdir -pv ${conffilespathFWDIRbootmodules} >> ${logfilepath} 2>&1
    chmod 775 ${conffilespathFWDIRbootmodules} >> ${logfilepath} 2>&1
else
    #set permissions we need
    chmod 775 ${conffilespathFWDIRbootmodules} >> ${logfilepath} 2>&1
fi

if [ ! -r ${conffilespathPPKDIRbootmodules} ] ; then
    mkdir -pv ${conffilespathPPKDIRbootmodules} >> ${logfilepath} 2>&1
    chmod 775 ${conffilespathPPKDIRbootmodules} >> ${logfilepath} 2>&1
else
    #set permissions we need
    chmod 775 ${conffilespathPPKDIRbootmodules} >> ${logfilepath} 2>&1
fi

if [ ! -r ${conffilespathPPKDIRconf} ] ; then
    mkdir -pv ${conffilespathPPKDIRconf} >> ${logfilepath} 2>&1
    chmod 775 ${conffilespathPPKDIRconf} >> ${logfilepath} 2>&1
else
    #set permissions we need
    chmod 775 ${conffilespathPPKDIRconf} >> ${logfilepath} 2>&1
fi

if [ ! -r ${conffilespathFWDIRconf} ] ; then
    mkdir -pv ${conffilespathFWDIRconf} >> ${logfilepath} 2>&1
    chmod 775 ${conffilespathFWDIRconf} >> ${logfilepath} 2>&1
else
    #set permissions we need
    chmod 775 ${conffilespathFWDIRconf} >> ${logfilepath} 2>&1
fi

if [ ! -r ${conffilespathFWDIRdatabase} ] ; then
    mkdir -pv ${conffilespathFWDIRdatabase} >> ${logfilepath} 2>&1
    chmod 775 ${conffilespathFWDIRdatabase} >> ${logfilepath} 2>&1
else
    #set permissions we need
    chmod 775 ${conffilespathFWDIRdatabase} >> ${logfilepath} 2>&1
fi

#if [ -r ${file2copypathfqfp} ] ; then
    #cp "${file2copypathfqfp}" ${conffilespathFWDIRbootmodules} &>> ${outputfilefqfn}
    #cp "${file2copypathfqfp}" ${conffilespathPPKDIRbootmodules} &>> ${outputfilefqfn}
    #cp "${file2copypathfqfp}" ${conffilespathPPKDIRconf} &>> ${outputfilefqfn}
    #cp "${file2copypathfqfp}" ${conffilespathFWDIRconf} &>> ${outputfilefqfn}
    #cp "${file2copypathfqfp}" ${conffilespathFWDIRdatabase} &>> ${outputfilefqfn}
#fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/boot/modules/fwkern.conf and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/boot/modules/fwkern.conf
export file2copy=fwkern.conf
export file2copypathfqfp="${FWDIR}/boot/modules/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRbootmodules} &>> ${outputfilefqfn}
fi

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" . &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/boot/modules/vpnkern.conf and backup if it exists  - SK101219 and sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/boot/modules/vpnkern.conf
export file2copy=vpnkern.conf
export file2copypathfqfp="${FWDIR}/boot/modules/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRbootmodules} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${PPKDIR}/boot/modules/simkern.conf and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

export file2copy=simkern.conf
# ${PPKDIR}/boot/modules/simkern.conf
#export file2copypathfqfp="${PPKDIR}/boot/modules/${file2copy}"

# At some version this moved and ${PPKDIR}/boot/modules/simkern.conf was deprecated
# ${PPKDIR}/conf/simkern.conf
#export file2copypathfqfp="${PPKDIR}/conf/${file2copy}"

# MODIFIED 2024-06-11 -

case "${gaiaversion}" in
    R77 | R77.10 | R77.20 | R77.30 )
        export file2copypathfqfp="${PPKDIR}/boot/modules/${file2copy}"
        export file2copytarget=${conffilespathPPKDIRbootmodules}
        ;;
    R80 | R80.10 | R80.20.M1 | R80.20.M2 | R80.20 | R80.30 ) 
        export file2copypathfqfp="${PPKDIR}/boot/modules/${file2copy}"
        export file2copytarget=${conffilespathPPKDIRbootmodules}
        ;;
    R80.40 ) 
        export file2copypathfqfp="${PPKDIR}/conf/${file2copy}"
        export file2copytarget=${conffilespathPPKDIRconf}
        ;;
    R81 | R81.10 | R81.20 ) 
        export file2copypathfqfp="${PPKDIR}/conf/${file2copy}"
        export file2copytarget=${conffilespathPPKDIRconf}
        ;;
    R82 | R82.10 | R82.20 ) 
        export file2copypathfqfp="${PPKDIR}/conf/${file2copy}"
        export file2copytarget=${conffilespathPPKDIRconf}
        ;;
    *)
        export file2copypathfqfp="${PPKDIR}/boot/modules/${file2copy}"
        export file2copytarget=${conffilespathPPKDIRbootmodules}
        ;;
esac

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${file2copytarget} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${PPKDIR}/boot/modules/simkern.conf and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${PPKDIR}/boot/modules/sim_aff.conf
export file2copy=sim_aff.conf
export file2copypathfqfp="${PPKDIR}/boot/modules/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathPPKDIRbootmodules} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/conf/fwaffinity.conf and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/conf/fwaffinity.conf
export file2copy=fwaffinity.conf
export file2copypathfqfp="${FWDIR}/conf/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRconf} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/conf/fwauthd.conf and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/conf/fwauthd.conf
export file2copy=fwauthd.conf
export file2copypathfqfp="${FWDIR}/conf/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRconf} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/conf/local.arp and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/conf/local.arp
export file2copy=local.arp
export file2copypathfqfp="${FWDIR}/conf/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRconf} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/conf/discntd.if and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/conf/discntd.if
export file2copy=discntd.if
export file2copypathfqfp="${FWDIR}/conf/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRconf} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/conf/cpha_bond_ls_config.conf  and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/conf/cpha_bond_ls_config.conf
export file2copy=cpha_bond_ls_config.conf
export file2copypathfqfp="${FWDIR}/conf/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRconf} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/conf/resctrl  and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/conf/resctrl
export file2copy=resctrl
export file2copypathfqfp="${FWDIR}/conf/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRconf} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/conf/vsaffinity_exception.conf  and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/conf/vsaffinity_exception.conf
export file2copy=vsaffinity_exception.conf
export file2copypathfqfp="${FWDIR}/conf/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRconf} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/database/qos_policy.C  and backup if it exists - sk160392
#----------------------------------------------------------------------------------------

# ${FWDIR}/database/qos_policy.C
export file2copy=qos_policy.C
export file2copypathfqfp="${FWDIR}/database/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

if [ -r ${file2copypathfqfp} ] ; then
    cp "${file2copypathfqfp}" ${conffilespathFWDIRdatabase} &>> ${outputfilefqfn}
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# files to collect sk160392 - List of Check Point Configuration Files on a Security Gateway that need to be re-configured after performing a clean installation on a Security Gateway 
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect ${FWDIR}/conf/malware_config and copy if it exists
#----------------------------------------------------------------------------------------

# ${FWDIR}/conf/malware_config
export file2copy=malware_config
export file2copypathfqfp="${FWDIR}/conf/${file2copy}"

export command2folder=def_conf_files
export outputfilenameaddon=

CopyFileAndDump2FQDNOutputfile

export file2find=malware_config

FindFilesAndCollectIntoArchiveAllVariants


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - process listing
#----------------------------------------------------------------------------------------

export command2folder=running_operation
export command2run=ps_process_status
export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
if [ -z ${command2folder} ] ; then
    export outputfilefqdn=${outputfilepath}
    export outputfilefqfn=${outputfilepath}${outputfile}
else
    export outputfilefqdn=${outputfilepath}${command2folder}/
    export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
fi

if [ ! -r ${outputfilefqdn} ] ; then
    mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
else
    chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
fi

echo
echo 'Execute '${command2run}' with output to : '${outputfilefqfn}

echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'ps -AFM -- process listing' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

ps -AFM >> ${outputfilefqfn}

echo >> ${outputfilefqfn}

echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - ?what next?
#----------------------------------------------------------------------------------------

#export command2folder=
#export command2run=command
#export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
#if [ -z ${command2folder} ] ; then
    #export outputfilefqfn=${outputfilepath}${outputfile}
#else
    #export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    
    #if [ ! -r ${outputfilepath}${command2folder} ] ; then
        #mkdir -pv ${outputfilepath}${command2folder} >> ${logfilepath} 2>&1
        #chmod 775 ${outputfilepath}${command2folder} >> ${logfilepath} 2>&1
    #else
        #chmod 775 ${outputfilepath}${command2folder} >> ${logfilepath} 2>&1
    #fi
#fi

#echo
#echo 'Execute '${command2run}' with output to : '${outputfilefqfn}
#${command2run} > ${outputfilefqfn}

#echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
#echo >> ${outputfilefqfn}
#echo 'fwacell stats -s' >> ${outputfilefqfn}
#echo >> ${outputfilefqfn}
#
#fwaccel stats -s >> ${outputfilefqfn}
#


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# =================================================================================================
# END:  _template sub script
# =================================================================================================
# =================================================================================================


if ${B4CPSCRIPTVERBOSE} ; then
    echo | tee -a -i ${logfilepath}
    echo 'Subscript Completed :  '${SubScriptName} | tee -a -i ${logfilepath}
else
    echo >> ${logfilepath}
    echo 'Subscript Completed :  '${SubScriptName} >> ${logfilepath}
fi


return 0


# =================================================================================================
# END subscript:  _template sub script
# =================================================================================================
# =================================================================================================


