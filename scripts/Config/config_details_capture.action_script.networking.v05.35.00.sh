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
# SCRIPT Template for bash scripts subscripts or action scripts - Config Caputure Details Action Script - networking
#
#
SubScriptDate=2024-01-12
SubScriptVersion=05.35.00
SubScriptRevision=000
SubScriptSubRevision=000
TemplateVersion=05.35.00
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.35.00
SubScriptTemplateVersion=05.35.00
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


SubScriptFileNameRoot=config_details_capture.action_script.networking
SubScriptShortName="config_details_capture.networking.${SubScriptsLevel}"
SubScriptDescription="Template for bash scripts subscripts or action scripts - Config Caputure Details Action Script - networking"

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
# bash - gather arp details
#----------------------------------------------------------------------------------------

export command2folder=network
export command2run=arp

DoCommandAndDocument arp -vn
DoCommandAndDocument arp -av


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather route details
#----------------------------------------------------------------------------------------

export command2folder=network
export command2run=route

DoCommandAndDocument route -vn


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect /etc/routed*.conf and copy if it exists
#----------------------------------------------------------------------------------------

export command2folder=network
# /etc/routed*.conf
export file2copy=routed.conf
export file2copypathfqfp="/etc/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2copy=routed0.conf
export file2copypathfqfp="/etc/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2find=routed*.conf

FindFilesAndCollectIntoArchiveAllVariants


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather interface details
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=ifconfig

DoCommandAndDocument ifconfig


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather interfaces via ls
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=ls_sys_class_net

DoCommandAndDocument ls -1 /sys/class/net


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather interface statistics via netstat -s
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=netstat_dash_s

DoCommandAndDocument netstat -s


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather interface statistics via netstat -i
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=netstat_dash_i

DoCommandAndDocument netstat -i


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# InterfacesDoCommandAndDocument - For Interfaces execute command and document results to dedicated file
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-11-11 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#
export command2folder=network_interfaces

InterfacesDoCommandAndDocument () {
    #
    # For Interfaces execute command and document results to dedicated file
    #
    
    echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
    echo 'Execute : '"$@" >> ${interfaceoutputfilefqfn}
    echo >> ${interfaceoutputfilefqfn}
    
    "$@" >> ${interfaceoutputfilefqfn}
    
    echo >> ${interfaceoutputfilefqfn}
    echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
    
    return 0
}

#
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

#InterfacesDoCommandAndDocument


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - Collect Interface Information per interface
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=interfaces_details
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

if [ ! -r ${dmesgfilefqfn} ] ; then
    echo | tee -a -i ${outputfilefqfn}
    echo 'No dmesg file at :  '${dmesgfilefqfn} | tee -a -i ${outputfilefqfn}
    echo 'Generating dmesg file!' | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
    dmesg > ${dmesgfilefqfn}
else
    echo | tee -a -i ${outputfilefqfn}
    echo 'found dmesg file at :  '${dmesgfilefqfn} | tee -a -i ${outputfilefqfn}
    echo | tee -a -i ${outputfilefqfn}
fi
echo | tee -a -i ${outputfilefqfn}

echo > ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}
echo 'Execute Commands with output to Output Path : ' | tee -a -i ${outputfilefqfn}
echo ' - Execute Commands   : '${command2run} | tee -a -i ${outputfilefqfn}
echo ' - Output Path        : '${outputfilefqfn} | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'clish -i -c "show interfaces"' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

CheckAndUnlockGaiaDB

clish -i -c "show interfaces" | tee -a -i ${outputfilefqfn}

echo >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

IFARRAY=()

GETINTERFACES="`clish -i -c "show interfaces"`"

echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'Build array of interfaces : ' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

case "${gaiaversion}" in
    R81 | R81.10 | R81.20 ) 
        export HasR8XDockerVersion=true
        ;;
    *)
        export HasR8XDockerVersion=false
        ;;
esac

arraylength=0

if ${HasR8XDockerVersion} ; then
    
    if [ ${arraylength} -eq 0 ]; then
        echo -n 'Interfaces :  ' | tee -a -i ${outputfilefqfn}
    else
        echo -n ', ' | tee -a -i ${outputfilefqfn}
    fi
    
    IFARRAY+=("docker0")
    
    arraylength=${#IFARRAY[@]}
    arrayelement=$((arraylength-1))
fi

while read -r line; do
    
    if [ ${arraylength} -eq 0 ]; then
        echo -n 'Interfaces :  ' | tee -a -i ${outputfilefqfn}
    else
        echo -n ', ' | tee -a -i ${outputfilefqfn}
    fi
    
    #IFARRAY+=("${line}")
    if [ "${line}" == 'lo' ]; then
        echo -n 'Not adding '${line} | tee -a -i ${outputfilefqfn}
    else 
        IFARRAY+=("${line}")
        echo -n ${line} | tee -a -i ${outputfilefqfn}
    fi
    
    arraylength=${#IFARRAY[@]}
    arrayelement=$((arraylength-1))
    
done <<< "${GETINTERFACES}"

echo | tee -a -i ${outputfilefqfn}

echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

echo 'Identified Interfaces in array for detail data collection :' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

for j in "${IFARRAY[@]}"
do
    #echo "${j}, ${j//\'/}"  | tee -a -i ${outputfilefqfn}
    echo ${j} | tee -a -i ${outputfilefqfn}
done
echo | tee -a -i ${outputfilefqfn}

echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}

export ifshortoutputfile=${outputfileprefix}'_'${command2run}'_short'${outputfilesuffix}${outputfiletype}
#export ifshortoutputfilefqfn=${outputfilepath}${ifshortoutputfile}
if [ -z ${command2folder} ] ; then
    export ifshortoutputfilefqfn=${outputfilepath}${ifshortoutputfile}
else
    export ifshortoutputfilefqfn=${outputfilepath}${command2folder}/${ifshortoutputfile}
fi

touch ${ifshortoutputfilefqfn}
echo | tee -a -i ${ifshortoutputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${ifshortoutputfilefqfn}

for i in "${IFARRAY[@]}"
do
    
    export currentinterface=${i}
    
    export chkinterface4=`expr substr ${i} 1 4`
    
    #Check if the interface is a bond interface
    
    export bondckeck=`[[ 'bond' = ${chkinterface4} ]]; echo $?`
    if [ ${bondckeck} -eq 0 ] ; then
        export interfaceisbond=true
    else
        export interfaceisbond=false
    fi
    
    #------------------------------------------------------------------------------------------------------------------
    # Short Information
    #------------------------------------------------------------------------------------------------------------------
    
    echo 'Interface : '${i} | tee -a -i ${ifshortoutputfilefqfn}
    ifconfig ${i} | grep -i HWaddr | tee -a -i ${ifshortoutputfilefqfn}
    if ${interfaceisbond} ; then
        echo 'bond interface' | tee -a -i ${ifshortoutputfilefqfn}
    else
        ethtool -i ${i} | grep -i bus | tee -a -i ${ifshortoutputfilefqfn}
    fi
    echo '----------------------------------------------------------------------------------------' | tee -a -i ${ifshortoutputfilefqfn}
    
    #------------------------------------------------------------------------------------------------------------------
    # Detailed Information
    #------------------------------------------------------------------------------------------------------------------
    
    export interfaceoutputfile=${outputfileprefix}'_'${command2run}'_'$i${outputfilesuffix}${outputfiletype}
    #export interfaceoutputfilefqfn=${outputfilepath}${interfaceoutputfile}
    if [ -z ${command2folder} ] ; then
        export interfaceoutputfilefqfn=${outputfilepath}${interfaceoutputfile}
    else
        export interfaceoutputfilefqfn=${outputfilepath}${command2folder}/${interfaceoutputfile}
    fi
    
    echo 'Executing commands for interface : '${currentinterface}' with output to file : '${interfaceoutputfilefqfn} | tee -a -i ${outputfilefqfn}
    #echo | tee -a -i ${outputfilefqfn}
    
    if ${HasR8XDockerVersion} ; then
        # Currently R81+ with docker installation does not have clish visibility for docker0
        
        InterfacesDoCommandAndDocument ifconfig ${i}
        
    else
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Execute clish -i -c "show interface '${i}'"' >> ${interfaceoutputfilefqfn}
        echo >> ${interfaceoutputfilefqfn}
        
        clish -i -c "show interface ${i}" >> ${interfaceoutputfilefqfn}
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        
        InterfacesDoCommandAndDocument ifconfig ${i}
        
    fi
    
    #------------------------------------------------------------------------------------------------------------------
    # Detailed Information not available for bond interfaces
    #------------------------------------------------------------------------------------------------------------------
    
    if ${interfaceisbond} ; then
        # bond interface, skip details not relevant for bond interfaces
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Interface '${i}' is bond interface so no further details relevant or available!' >> ${interfaceoutputfilefqfn}
        echo 'Interface '${i}' is bond interface so no further details relevant or available!' | tee -a -i ${ifshortoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo >> ${interfaceoutputfilefqfn}
        
    else
        # not a bond interface, so drill down available details for the interface
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Interface '${i}' is not a bond, so drill into further details!' >> ${interfaceoutputfilefqfn}
        echo 'Interface '${i}' is not a bond, so drill into further details!' | tee -a -i ${ifshortoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        
        if ! ${HasR8XDockerVersion} ; then
            # Currently R81+ with docker installation does not have clish visibility for docker0
            
            echo >> ${interfaceoutputfilefqfn}
            echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
            echo 'Execute clish -i -c "show interface '${i}' rx-ringsize"' >> ${interfaceoutputfilefqfn}
            echo >> ${interfaceoutputfilefqfn}
            
            clish -i -c "show interface ${i} rx-ringsize" >> ${interfaceoutputfilefqfn}
            
            echo >> ${interfaceoutputfilefqfn}
            echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
            echo 'Execute clish -i -c "show interface '${i}' tx-ringsize"' >> ${interfaceoutputfilefqfn}
            echo >> ${interfaceoutputfilefqfn}
            
            clish -i -c "show interface ${i} tx-ringsize" >> ${interfaceoutputfilefqfn}
            
            echo >> ${interfaceoutputfilefqfn}
            echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
            echo 'Execute clish -i -c show interface '${i}' multi-queue verbose"' >> ${interfaceoutputfilefqfn}
            echo >> ${interfaceoutputfilefqfn}
            
            clish -i -c "show interface ${i} multi-queue verbose" >> ${interfaceoutputfilefqfn}
            
            echo >> ${interfaceoutputfilefqfn}
            echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
            
        fi
        
        InterfacesDoCommandAndDocument ethtool ${i}
        InterfacesDoCommandAndDocument ethtool -a ${i}
        InterfacesDoCommandAndDocument ethtool -i ${i}
        InterfacesDoCommandAndDocument ethtool -m ${i}
        InterfacesDoCommandAndDocument ethtool -m raw on ${i}
        InterfacesDoCommandAndDocument ethtool -P ${i}
        InterfacesDoCommandAndDocument ethtool -g ${i}
        InterfacesDoCommandAndDocument ethtool -k ${i}
        InterfacesDoCommandAndDocument ethtool -S ${i}
        InterfacesDoCommandAndDocument ethtool --phy-statistics ${i}
        InterfacesDoCommandAndDocument ethtool -d ${i}
        InterfacesDoCommandAndDocument ethtool -e ${i}
        InterfacesDoCommandAndDocument netstat --interfaces=${i}
        
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Execute grep of driver for '${i} >> ${interfaceoutputfilefqfn}
        echo >> ${interfaceoutputfilefqfn}
        
        export interfacedriver=`ethtool -i ${i} | grep -i "driver:" | cut -d " " -f 2`
        InterfacesDoCommandAndDocument modinfo $interfacedriver
        
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        echo 'Execute grep of dmesg for '${i} >> ${interfaceoutputfilefqfn}
        echo >> ${interfaceoutputfilefqfn}
        
        cat ${dmesgfilefqfn} | grep -i ${i} >> ${interfaceoutputfilefqfn}
        
        echo >> ${interfaceoutputfilefqfn}
        echo '----------------------------------------------------------------------------------------' >> ${interfaceoutputfilefqfn}
        
    fi
    
    #------------------------------------------------------------------------------------------------------------------
    # Dump Detailed interface Information into consolidated interface file
    #------------------------------------------------------------------------------------------------------------------
    
    cat ${interfaceoutputfilefqfn} >> ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
    echo >> ${outputfilefqfn}
    echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
    echo >> ${outputfilefqfn}
    
done

echo | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - collect /etc/sysconfig/network and backup if it exists
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
# /etc/sysconfig/network
export file2copy=network
export file2copypathfqfp="/etc/sysconfig/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2find=modprobe.conf


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather interface details from /etc/sysconfig/networking
#----------------------------------------------------------------------------------------

# /etc/sysconfig/networking

export command2folder=network_interfaces
export command2run=etc_sysconfig_networking
export sourcepath=/etc/sysconfig/networking

CopyFiles2CaptureFolder


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather interface details from /etc/sysconfig/network-scripts
#----------------------------------------------------------------------------------------

# /etc/sysconfig/network-scripts

export command2folder=network_interfaces
export command2run=etc_sysconfig_networking_scripts
export sourcepath=/etc/sysconfig/network-scripts

CopyFiles2CaptureFolder


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - gather interface name rules
#----------------------------------------------------------------------------------------

export command2folder=network_interfaces
export command2run=interfaces_naming_rules
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

export file2copy=00-OS-XX.rules
export file2copypathfqfp="/etc/udev/rules.d/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2find=${file2copy}

FindFilesAndCollectIntoArchiveAllVariants


export file2copy=00-ANACONDA.rules
export file2copypathfqfp="/etc/sysconfig/${file2copy}"

export outputfilenameaddon=
CopyFileAndDump2FQDNOutputfile

export file2find=${file2copy}

FindFilesAndCollectIntoArchiveAllVariants


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - Port utilization and potential overlaps
#----------------------------------------------------------------------------------------

export command2folder=network
export command2run=netstat
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
echo 'netstat -nap -- Ports used' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

netstat -nap >> ${outputfilefqfn}

echo >> ${outputfilefqfn}

echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo | tee -a -i ${outputfilefqfn}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# bash - Port utilization and potential overlaps - Endpoint Management (EPM)
#----------------------------------------------------------------------------------------

export command2folder=network
export command2run=netstat_for_EPM
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
echo 'netstat -nap | grep 8080 -- Endpoint Port use of 8080' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

netstat -nap | grep 8080 >> ${outputfilefqfn}

echo >> ${outputfilefqfn}

echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'netstat -nap | grep 8009 -- Endpoint Port use of 8009' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

netstat -nap | grep 8009 >> ${outputfilefqfn}

echo >> ${outputfilefqfn}

echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'netstat -nap | grep 8005 -- Endpoint Port use of 8005' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

netstat -nap | grep 8005 >> ${outputfilefqfn}

echo >> ${outputfilefqfn}

echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'netstat -nap | grep 80 -- Endpoint Port use of 80' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

netstat -nap | grep 80 >> ${outputfilefqfn}

echo >> ${outputfilefqfn}

echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'netstat -nap | grep 443 -- Endpoint Port use of 443' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

netstat -nap | grep 443 >> ${outputfilefqfn}

echo >> ${outputfilefqfn}

echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo '----------------------------------------------------------------------------' | tee -a -i ${outputfilefqfn}
echo 'netstat -nap | grep 4434 -- Endpoint Port use of 4434' | tee -a -i ${outputfilefqfn}
echo '----------------------------------------------------------------------------' >> ${outputfilefqfn}
echo >> ${outputfilefqfn}

netstat -nap | grep 4434 >> ${outputfilefqfn}

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


