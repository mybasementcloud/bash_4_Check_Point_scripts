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
# SCRIPT Template for bash scripts subscripts or action scripts - Config Caputure Details Action Script - CP_Gateway_or_Cluster
#
#
SubScriptDate=2024-01-19
SubScriptVersion=05.36.00
SubScriptRevision=000
SubScriptSubRevision=000
TemplateVersion=05.36.00
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.36.00
SubScriptTemplateVersion=05.36.00
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


SubScriptFileNameRoot=config_details_capture.action_script.CP_Gateway_or_Cluster
SubScriptShortName="config_details_capture.CP_Gateway_or_Cluster.${SubScriptsLevel}"
SubScriptDescription="Template for bash scripts subscripts or action scripts - Config Caputure Details Action Script - CP_Gateway_or_Cluster"

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
# bash - GW - status of SecureXL
#----------------------------------------------------------------------------------------

export command2folder=SecureXL
if [ ${Check4GW} -eq 1 ]; then
    
    export command2run=fwaccel-statistics
    
    DoCommandAndDocument fwaccel stat
    
    DoCommandAndDocument fwaccel if
    
    #
    # [x@host:0]# fwaccel stats --help
    #
    # fwaccel: illegal option -- -
    # Usage: fwaccel stats <options>
    #
    # Options:
    #    -s                      - print only statistics summary
    #    -d                      - drop from device statistics
    #    -n                      - NAC statistics
    #    -p                      - print SXL violations (f2f packets) statistics
    #    -l                      - print statistics in legacy mode
    #    -r                      - reset statistics
    #    -m                      - print multicast traffic statistics
    #    -q                      - notifications sent to the FW
    #    -c                      - print cluster correction statistics
    #    -x                      - print PXL statistics
    #    -o                      - Reorder I/S
    #    -t                      - Traffic distribution
    #    -u                      - Callqueue
    #    -k                      - PPAK Network per cpu
    #    -b                      - BHM stats per cpu
    #    -h                      - this help message
    #
    # [x@host:0]#
    #
    DoCommandAndDocument fwaccel stats
    DoCommandAndDocument fwaccel stats -s
    DoCommandAndDocument fwaccel stats -p
    DoCommandAndDocument fwaccel stats -d
    DoCommandAndDocument fwaccel stats -n
    DoCommandAndDocument fwaccel stats -m
    DoCommandAndDocument fwaccel stats -q
    DoCommandAndDocument fwaccel stats -x
    DoCommandAndDocument fwaccel stats -o
    DoCommandAndDocument fwaccel stats -t
    DoCommandAndDocument fwaccel stats -u
    DoCommandAndDocument fwaccel stats -k
    DoCommandAndDocument fwaccel stats -b
    
    # [x@host:0]# fwaccel templates --help
    # 
    # fwaccel: illegal option -- -
    # Usage: fwaccel templates <options>
    # 
    # Options:
    #    -m <max entries>        - max number of entries to print
    #    -s                      - print only the number of offloaded templates
    #    -S                      - prints statistics
    #    -d                      - prints drop templates
    #    -h                      - this help message
    # 
    # Accept templates flags (one or more of the below flags):
    #    U                       - unidirectional
    #    N                       - NAT
    #    A                       - accounted
    #    S                       - pxl enabled
    #    Q                       - qxl enabled
    #    I                       - NAC enabled
    #    O                       - created for rule with/below dynamic object
    #    X                        - created for NAT rule with translated dynamic object
    #    E                        - created for NAT rule with IDA object
    #    M                       - created for rule with/below domain object
    #    T                       - created for rule with/below time object
    #    Z                       - created for rule with/below Sec Zone object
    #    B                       - created for rule with/below IDA support object
    #    R                       - created for rule with/below Traceroute object
    #    P                       - created for a connection that may match on a service with src port
    # Drop templates flags (one or more of the below flags):
    #    D                       - drop template
    #    L                       - log drop action
    # 
    # [x@host:0]#
    # 
    DoCommandAndDocument fwaccel templates -S
    DoCommandAndDocument fwaccel templates -s
    DoCommandAndDocument fwaccel templates
    DoCommandAndDocument fwaccel templates -d
    
    DoCommandAndDocument fwaccel ranges -l
    DoCommandAndDocument fwaccel ranges
    
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - GW - status of Identity Awareness
#----------------------------------------------------------------------------------------

export command2folder=Identity_Awareness
if [ ${Check4GW} -eq 1 ]; then
    
    echo 'Check Status of Identity Awareness'
    echo
    
    export command2run=identity_awareness_details
    
    DoCommandAndDocument pdp status show
    DoCommandAndDocument pep show pdp all
    DoCommandAndDocument pdp auth kerberos_encryption get
    
fi


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - Gateway User State Firewall (USFW) Information
#----------------------------------------------------------------------------------------

export command2folder=gateway
export command2run=gateway_USFW_Info

if [ "${sys_type_GW}" == "true" ]; then
    
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
    
    echo >> ${outputfilefqfn}
    echo 'Execute '${command2run}' with output to : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    #To check current mode:
    #cpprod_util FwIsUsermode 
    #cpprod_util FwIsUsfwMachine 
    #(0=kernel, 1=USFW)
    
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Execute Command with output to Output Path : ' | tee -a -i ${outputfilefqfn}
    echo ' - Execute Command    : '${command2run} | tee -a -i ${outputfilefqfn}
    echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    echo ' - Command with Parms # cpprod_util FwIsUsermode' | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    echo 'Check state of User Mode FireWall (USFW)' | tee -a -i ${outputfilefqfn}
    echo -en 'cpprod_util FwIsUsermode [1=true] : ' | tee -a -i ${outputfilefqfn}
    cpprod_util FwIsUsermode | tee -a -i ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo 'Execute Command with output to Output Path : ' | tee -a -i ${outputfilefqfn}
    echo ' - Execute Command    : '${command2run} | tee -a -i ${outputfilefqfn}
    echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    echo ' - Command with Parms # cpprod_util FwIsUsfwMachine' | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    echo 'Check state of User Mode FireWall (USFW)' | tee -a -i ${outputfilefqfn}
    echo -en 'cpprod_util FwIsUsermode [1=true] : ' | tee -a -i ${outputfilefqfn}
    cpprod_util FwIsUsfwMachine | tee -a -i ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
else
    echo 'Not a gateway, not checking USFW info' | tee -a -i ${logfilepath}
fi


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - Gateway Threat Prevention TEX Information
#----------------------------------------------------------------------------------------

export command2folder=gateway
export command2run=Gateway_TEX_Info

if [ "${sys_type_GW}" == "true" ]; then
    
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
    
    echo >> ${outputfilefqfn}
    echo 'Execute '${command2run}' with output to : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    echo 'Check TEX service DNS information:' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    nslookup -query=SRV te.checkpoint.com >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    DoCommandAndDocument cpstat threat-emulation -f default
    DoCommandAndDocument cat ${FWDIR}/teCurrentPack/te_ver.ini
    DoCommandAndDocument tecli advanced cloud geo status
    DoCommandAndDocument tecli show downloads all
    DoCommandAndDocument tecli advanced analyzer show
    DoCommandAndDocument tecli advanced engine version
    DoCommandAndDocument tecli advanced wem status
    DoCommandAndDocument tecli show downloads images all
    
    #DoCommandAndDocument 
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
else
    echo 'Not a gateway, not checking TEX info'
fi


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - Capture multi-core related details
#----------------------------------------------------------------------------------------

export command2folder=gateway
export command2run=multi_core_multi_queue

if [ "${sys_type_GW}" == "true" ]; then
    
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
    
    echo >> ${outputfilefqfn}
    echo 'Execute '${command2run}' with output to : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    DoCommandAndDocument fw ctl multik stat
    DoCommandAndDocument fw ctl affinity -a -l
    DoCommandAndDocument cplic print -x
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
fi


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - Document state of gateway utilization of X
#----------------------------------------------------------------------------------------

export command2folder=Gateway
export command2run=ips

if [ "${sys_type_GW}" == "true" ]; then
    
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
    
    export command2run=ips stat
    echo >> ${outputfilefqfn}
    echo 'Execute '${command2run}' with output to : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    DoCommandAndDocument ${command2run}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    export command2run=ips bypass stat
    echo >> ${outputfilefqfn}
    echo 'Execute '${command2run}' with output to : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    DoCommandAndDocument ${command2run}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
else
    echo 'Not a gateway, not checking X info' | tee -a -i ${logfilepath}
fi 


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - Gateway Mail Transfer Agent (MTA) Information
#----------------------------------------------------------------------------------------

export command2folder=MTA
export command2run=MTA_information
export outputfilenameaddon=

if [ "${sys_type_GW}" == "true" ]; then
    
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
    
    echo >> ${outputfilefqfn}
    echo 'Collect list of configuration files with output to : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    DoCommandAndDocument list /opt/postfix/etc/postfix/
    
    echo >> ${outputfilefqfn}
    echo 'Collect status of postfix spool folders with output to : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    DoCommandAndDocument ls -alh --color=auto --group-directories-first /opt/postfix/var/spool/postfix
    DoCommandAndDocument ls -alh --color=auto --group-directories-first /opt/postfix/var/spool/postfix/active
    DoCommandAndDocument ls -alh --color=auto --group-directories-first /opt/postfix/var/spool/postfix/bounce
    DoCommandAndDocument ls -alh --color=auto --group-directories-first /opt/postfix/var/spool/postfix/corrupt
    DoCommandAndDocument ls -alh --color=auto --group-directories-first /opt/postfix/var/spool/postfix/defer
    DoCommandAndDocument ls -alh --color=auto --group-directories-first /opt/postfix/var/spool/postfix/deferred
    DoCommandAndDocument ls -alh --color=auto --group-directories-first /opt/postfix/var/spool/postfix/hold
    DoCommandAndDocument ls -alh --color=auto --group-directories-first /opt/postfix/var/spool/postfix/incoming
    DoCommandAndDocument ls -alh --color=auto --group-directories-first /opt/postfix/var/spool/postfix/maildrop
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    # Collect Configuration Files to archive
    export file2find=main.cf
    
    FindFilesAndCollectIntoArchiveAllVariants
    
    # Collect Configuration Files to archive
    export file2find=bounce.cf
    
    FindFilesAndCollectIntoArchiveAllVariants
    
    # Collect Configuration Files to archive
    export file2find=master.cf
    
    FindFilesAndCollectIntoArchiveAllVariants
    
    # Collect log Files to archive
    export file2find=maillog
    
    FindFilesAndCollectIntoArchiveAllVariants
    
    # Collect log Files to archive
    export file2find=mtad.elg
    
    FindFilesAndCollectIntoArchiveAllVariants
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    export command2run=MTA_mail_security_config
    export outputfilenameaddon=
    # ADDED 2022-03-08 -
    
    # Collect mail_security_conf Configuration Files to archive - ${FWDIR}/conf/mail_security_config
    export file2copy=mail_security_config
    export file2copypathfqfp="${FWDIR}/conf//${file2copy}"
    
    CopyFileAndDump2FQDNOutputfile
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
else
    echo 'Not a gateway, not checking MTA info' | tee -a -i ${logfilepath}
fi


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# clish and bash - Gather ClusterXL information from all possible methods if it is a cluster
#----------------------------------------------------------------------------------------

export command2folder=gateway
export command2run=ClusterXL
export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}

echo | tee -a -i ${clishoutputfilefqfn}
echo 'ClusterXL information - if relevant' | tee -a -i ${clishoutputfilefqfn}
echo | tee -a -i ${clishoutputfilefqfn}

if [ "${sys_type_GW}" == "true" ]; then
    
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
    
    echo 'A Gateway so maybe ClusterXL' | tee -a -i ${clishoutputfilefqfn}
    
    export clustercheck=$(cpconfig <<< 10 | grep cluster)
    # #fix IDE bash parsing display so ignore this# cpconfig <<< 10 | grep cluster)
    export checkvalue=*"Disable"*
    
    if [[ ${clustercheck} == ${checkvalue} ]]; then
        # is a cluster
        echo 'A cluster member.' | tee -a -i ${clishoutputfilefqfn}
        echo | tee -a -i ${clishoutputfilefqfn}
        
        touch ${outputfilefqfn}
        
        DoCommandAndDocument cphaprob state
        DoCommandAndDocument cphaprob mmagic
        DoCommandAndDocument cphaprob -a if
        DoCommandAndDocument cphaprob -ia list
        DoCommandAndDocument cphaprob -l list
        DoCommandAndDocument cphaprob syncstat
        DoCommandAndDocument cpstat ha -f all
        
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'Execute Command with output to Output Path : ' | tee -a -i ${outputfilefqfn}
        echo ' - Execute Command    : '${command2run} | tee -a -i ${outputfilefqfn}
        echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'Sync Status : fw ctl pstat | grep -A50 Sync:' | tee -a -i ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        
        fw ctl pstat | grep -A50 Sync: >> ${outputfilefqfn}
        
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo | tee -a -i ${outputfilefqfn}
        
        echo | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'Execute Command with output to Output Path : ' | tee -a -i ${outputfilefqfn}
        echo ' - Execute Command    : '${command2run} | tee -a -i ${outputfilefqfn}
        echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo 'clish -c "show routed cluster-state detailed"' >> ${outputfilefqfn}
        echo >> ${outputfilefqfn}
        
        CheckAndUnlockGaiaDB
        
        clish -c "show routed cluster-state detailed" >> ${outputfilefqfn}
        
        echo >> ${outputfilefqfn}
        echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
        echo | tee -a -i ${outputfilefqfn}
        
        cat ${outputfilefqfn} >> ${clishoutputfilefqfn}
    else
        # is not a cluster
        echo 'Not a cluster member.' | tee -a -i ${clishoutputfilefqfn}
        echo | tee -a -i ${clishoutputfilefqfn}
    fi
else
    
    echo 'Not a Gateway so no ClusterXL' | tee -a -i ${clishoutputfilefqfn}
    
fi


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - Document state of gateway utilization of X
#----------------------------------------------------------------------------------------

#export command2folder=Gateway
#export command2run=X

#if [ "${sys_type_GW}" == "true" ]; then
    
    #export outputfile=${outputfileprefix}'_'${command2run}${outputfilesuffix}${outputfiletype}
    
    #if [ -z ${command2folder} ] ; then
        #export outputfilefqdn=${outputfilepath}
        #export outputfilefqfn=${outputfilepath}${outputfile}
    #else
        #export outputfilefqdn=${outputfilepath}${command2folder}/
        #export outputfilefqfn=${outputfilepath}${command2folder}/${outputfile}
    #fi
    
    #if [ ! -r ${outputfilefqdn} ] ; then
        #mkdir -pv ${outputfilefqdn} >> ${logfilepath} 2>&1
        #chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    #else
        #chmod 775 ${outputfilefqdn} >> ${logfilepath} 2>&1
    #fi
    
    #echo >> ${outputfilefqfn}
    #echo 'Execute '${command2run}' with output to : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
    
    #echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    
    #DoCommandAndDocument cpprod_util FwIsUsermode
    #DoCommandAndDocument cpprod_util FwIsUsfwMachine
    
    #echo >> ${outputfilefqfn}
    #echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
    #echo >> ${outputfilefqfn}
    
#else
    #echo 'Not a gateway, not checking X info' | tee -a -i ${logfilepath}
#fi 


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


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


