#!/bin/bash
#
# (C) 2016-2022 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
# Sample
#
# SCRIPT Update _tools package with latest package from tftp server
#
#
ScriptDate=2022-02-24
ScriptVersion=05.28.01
ScriptRevision=000
TemplateVersion=05.28.01
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

export BASHScriptFileNameRoot=update_tools
export BASHScriptShortName=Update_tools
export BASHScriptnohupName=${BASHScriptShortName}
export BASHScriptDescription="Update _tools package with latest package from tftp server"

#export BASHScriptName=${BASHScriptFileNameRoot}.${TemplateLevel}.v${ScriptVersion}
export BASHScriptName=${BASHScriptFileNameRoot}

export BASHScriptHelpFilePath=help.v${ScriptVersion}
export BASHScriptHelpFileName=${BASHScriptFileNameRoot}.help
export BASHScriptHelpFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileName}
export BASHScriptHelpFileExamplesName=${BASHScriptFileNameRoot}.examples.help
export BASHScriptHelpExamplesFile=${BASHScriptHelpFilePath}/${BASHScriptHelpFileExamplesName}

# _api_subscripts|_hostsetupscripts|_hostupdatescripts|_scripting_tools|_subscripts|_template|Common|Config|GAIA|GW|[GW.CORE]|HCP|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=_hostupdatescripts

export BASHScripttftptargetfolder="_template"


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Basic Configuration
# -------------------------------------------------------------------------------------------------


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
# logfile naming control variables
# -------------------------------------------------------------------------------------------------


# MODIFIED 2020-11-12 -
# if we are date-time stamping the output location as a subfolder of the 
# output folder set this to true,  otherwise it needs to be false
#
# OutputEnableLogFile             : true|false : log output to log file
#
# OutputYearSubfolder             : true|false : Add a folder level with just the year (YYYY)
# OutputYMSubfolder               : true|false : Add a folder level with the year-month (YYYY-MM)
# OutputDTGSSubfolder             : true|false : Add a folder level with Date Time Group with Seconds (YYYY-MM-DD-HHmmSS)
# Append script name to output subfolder, only one of these should be true, ignored if both are false
# OutputSubfolderScriptName       : true|false : Add full script name to folder name of output folder
#                                 :: setting this value true will override OutputSubfolderScriptShortName
# OutputSubfolderScriptShortName  : true|false : Add short script name to folder name of output folder
#
# OutputDTGTZinUTC                : true|false : Instead of using the local timezone in logs use UTC timezone
#

export OutputEnableLogFile=true

export OutputYearSubfolder=true
export OutputYMSubfolder=true
export OutputDTGSSubfolder=true
export OutputSubfolderScriptName=false
export OutputSubfolderScriptShortName=true

export OutputDTGTZinUTC=false


# -------------------------------------------------------------------------------------------------
# Local logfile variables
# -------------------------------------------------------------------------------------------------


export logfilefolderroot=/var/log/__customer/upgrade_export
export logfilefoldername=dump


# -------------------------------------------------------------------------------------------------
# logfile configuration
# -------------------------------------------------------------------------------------------------


# ADDED 2020-12-22
# we need the quick version of the gaiaversion
cpreleasefile=/etc/cp-release
export getgaiaquickversion=$(cat ${cpreleasefile} | cut -d " " -f 4)
export gaiaquickversion=${getgaiaquickversion}

# setup initial log file for output logging
DATEYear=`date +%Y`
DATEYM=`date +%Y-%m`
export logfilefolder=${logfilefolderroot}/${logfilefoldername}
if $OutputYearSubfolder ; then
    export logfilefolder=${logfilefolder}/${DATEYear}
fi
if $OutputYMSubfolder ; then
    export logfilefolder=${logfilefolder}/${DATEYM}
fi
if ${OutputDTGSSubfolder} ; then
    if $OutputDTGTZinUTC ; then
        export logfilefolder=${logfilefolder}/${DATEUTCDTGS}
    else
        export logfilefolder=${logfilefolder}/${DATEDTGS}
    fi
fi
if ${OutputSubfolderScriptName} ; then
    export logfilefolder=${logfilefolder}.${BASHScriptName}
elif  ${OutputSubfolderScriptShortName} ; then
    export logfilefolder=${logfilefolder}.${BASHScriptShortName}
fi
# UPDATED 2020-12-22
if $OutputDTGTZinUTC ; then
    export logfilepath=${logfilefolder}/${BASHScriptName}.${HOSTNAME}.${gaiaquickversion}.${DATEUTCDTGS}.log
    #export logfilepath=${logfilefolder}/${BASHScriptName}.${DATEUTCDTGS}.log
else
    export logfilepath=${logfilefolder}/${BASHScriptName}.${HOSTNAME}.${gaiaquickversion}.${DATEDTGS}.log
    #export logfilepath=${logfilefolder}/${BASHScriptName}.${DATEDTGS}.log
fi

if ${OutputEnableLogFile} ; then
    # We are logging, so create the initial working folder and log file
    if [ ! -w ${logfilefolder} ]; then
        mkdir -pv ${logfilefolder} > /dev/null
    fi
    
    touch ${logfilepath}
    
    echo
else
    # We are NOT logging, so don't create the initial working folder and log file
    # set the logfilepath to device null /dev/null to squelch the output
    
    export logfilepath=/dev/null
    echo
fi


# -------------------------------------------------------------------------------------------------
# END:  Basic Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# JQ and json related
# -------------------------------------------------------------------------------------------------

# MODIFIED 2020-01-03 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

# points to where jq is installed
if [ -r ${CPDIR}/jq/jq ] ; then
    export JQ=${CPDIR}/jq/jq
elif [ -r ${CPDIR_PATH}/jq/jq ] ; then
    export JQ=${CPDIR_PATH}/jq/jq
elif [ -r ${MDS_CPDIR}/jq/jq ] ; then
    export JQ=${MDS_CPDIR}/jq/jq
else
    export JQ=
fi

# points to where jq 1.6 is installed, which is not generally part of Gaia, even R80.40EA (2020-01-20)
export JQ16PATH=${MYWORKFOLDER}/_tools/JQ
export JQ16FILE=jq-linux64
export JQ16FQFN=${JQ16PATH}/${JQ16FILE}
if [ -r ${JQ16FQFN} ] ; then
    # OK we have the easy-button alternative
    export JQ16=${JQ16FQFN}
elif [ -r "./_tools/JQ/${JQ16FILE}" ] ; then
    # OK we have the local folder alternative
    export JQ16=./_tools/JQ/${JQ16FILE}
elif [ -r "../_tools/JQ/${JQ16FILE}" ] ; then
    # OK we have the parent folder alternative
    export JQ16=../_tools/JQ/${JQ16FILE}
else
    export JQ16=
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-01-03


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# Start of Script Operations
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# local scripts variables configuration
# -------------------------------------------------------------------------------------------------


export rootworkfolder=/var/log
export customerrootfolder=${rootworkfolder}/__customer
export targetfolder=${customerrootfolder}
export targetfolderforscript=${targetfolder}/upgrade_export
export targetresultsfolder=_tools
export targetresultspath=${targetfolder}/$targetresultsfolder

export remoterootfolder=/__gaia
export remotefilefolder=_tools
export remotefilename=_tools.tgz
export remotescriptname=update_tools.sh

export fqfpremotefile=$remoterootfolder/$remotefilefolder/$remotefilename
export fqfpremotescript=$remoterootfolder/$remotescriptname

export checkfilefolder=_tools/JQ
export checkfilename=jq-linux64
export fqfpcheckfile=${targetfolder}/$checkfilefolder/$checkfilename

export rootworkpath=${targetfolder}/download
export workfolder=_tools.updates
export workfoldernew=new
export workfoldercurrent=current
export workfolderhistory=.history

export workfilename=$remotefilename
export workscriptname=$remotescriptname

export fqpnworkfolder=$rootworkpath/$workfolder
export fqpnnewfolder=$fqpnworkfolder/$workfoldernew
export fqpncurrentfolder=$fqpnworkfolder/$workfoldercurrent
export fqpnhistoryfolder=$fqpnworkfolder/$workfolderhistory

export fqfpworkfile=$fqpnworkfolder/$workfilename
export fqfpnewfile=$fqpnnewfolder/$workfilename
export fqfpcurrentfile=$fqpncurrentfolder/$workfilename
export fqfphistoryfile=$fqpnhistoryfolder/$workfilename

export fqfpworkscript=$fqpnworkfolder/$workscriptname
export fqfpnewscript=$fqpnnewfolder/$workscriptname
export fqfpcurrentscript=$fqpncurrentfolder/$workscriptname
export fqfphistoryscript=$fqpnhistoryfolder/$workscriptname


# -------------------------------------------------------------------------------------------------
# tfpt server variable configuration
# -------------------------------------------------------------------------------------------------


if [ ! -z ${MYTFTPSERVER1} ] && [ ${MYTFTPSERVER1} != ${MYTFTPSERVER} ]; then
    export targettftpserver=${MYTFTPSERVER1}
elif [ ! -z ${MYTFTPSERVER2} ] && [ ${MYTFTPSERVER2} != ${MYTFTPSERVER} ]; then
    export targettftpserver=${MYTFTPSERVER2}
elif [ ! -z ${MYTFTPSERVER3} ] && [ ${MYTFTPSERVER3} != ${MYTFTPSERVER} ]; then
    export targettftpserver=${MYTFTPSERVER3}
elif [ ! -z ${MYTFTPSERVER} ]; then
    export targettftpserver=${MYTFTPSERVER}
else
    export targettftpserver=192.168.1.1
fi


# -------------------------------------------------------------------------------------------------
# Script intro
# -------------------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo ${BASHScriptName}', script version '${ScriptVersion}', revision '${ScriptRevision}' from '${ScriptDate} | tee -a -i ${logfilepath}
echo ${BASHScriptDescription} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Date Time Group   :  '${DATEDTGS} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
# Document working variables at start
#----------------------------------------------------------------------------------------

echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo 'Document working variables at start'  | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'targettftpserver                 = '${targettftpserver} | tee -a -i ${logfilepath}

echo 'logfilefolderroot                = '${logfilefolderroot} | tee -a -i ${logfilepath}
echo 'logfilefoldername                = '${logfilefoldername} | tee -a -i ${logfilepath}
echo 'logfilefolder                    = '${logfilefolder} | tee -a -i ${logfilepath}
echo 'logfilepath                      = '${logfilepath} | tee -a -i ${logfilepath}

echo 'rootworkfolder                   = '${rootworkfolder} | tee -a -i ${logfilepath}
echo 'customerrootfolder               = '${customerrootfolder} | tee -a -i ${logfilepath}
echo 'targetfolder                     = '${targetfolder} | tee -a -i ${logfilepath}
echo 'targetfolderforscript            = '$targetfolderforscript | tee -a -i ${logfilepath}
echo 'targetresultsfolder              = '$targetresultsfolder | tee -a -i ${logfilepath}
echo 'targetresultspath                = '$targetresultspath | tee -a -i ${logfilepath}

echo 'remoterootfolder                 = '$remoterootfolder | tee -a -i ${logfilepath}
echo 'remotefilefolder                 = '$remotefilefolder | tee -a -i ${logfilepath}
echo 'remotefilename                   = '$remotefilename | tee -a -i ${logfilepath}
echo 'remotescriptname                 = '$remotescriptname | tee -a -i ${logfilepath}

echo 'fqfpremotefile                   = '$fqfpremotefile | tee -a -i ${logfilepath}
echo 'fqfpremotescript                 = '$fqfpremotescript | tee -a -i ${logfilepath}

echo 'checkfilefolder                  = '$checkfilefolder | tee -a -i ${logfilepath}
echo 'checkfilename                    = '$checkfilename | tee -a -i ${logfilepath}
echo 'fqfpcheckfile                    = '$fqfpcheckfile | tee -a -i ${logfilepath}

echo 'rootworkpath                     = '$rootworkpath | tee -a -i ${logfilepath}
echo 'workfolder                       = '$workfolder | tee -a -i ${logfilepath}
echo 'workfoldernew                    = '$workfoldernew | tee -a -i ${logfilepath}
echo 'workfoldercurrent                = '$workfoldercurrent | tee -a -i ${logfilepath}
echo 'workfolderhistory                = '$workfolderhistory | tee -a -i ${logfilepath}

echo 'workfilename                     = '$workfilename | tee -a -i ${logfilepath}
echo 'workscriptname                   = '$workscriptname | tee -a -i ${logfilepath}

echo 'fqpnworkfolder                   = '$fqpnworkfolder | tee -a -i ${logfilepath}
echo 'fqpnnewfolder                    = '$fqpnnewfolder | tee -a -i ${logfilepath}
echo 'fqpncurrentfolder                = '$fqpncurrentfolder | tee -a -i ${logfilepath}
echo 'fqpnhistoryfolder                = '$fqpnhistoryfolder | tee -a -i ${logfilepath}

echo 'fqfpworkfile                     = '$fqfpworkfile | tee -a -i ${logfilepath}
echo 'fqfpnewfile                      = '$fqfpnewfile | tee -a -i ${logfilepath}
echo 'fqfpcurrentfile                  = '$fqfpcurrentfile | tee -a -i ${logfilepath}
echo 'fqfphistoryfile                  = '$fqfphistoryfile | tee -a -i ${logfilepath}

echo 'fqfpworkscript                   = '$fqfpworkscript | tee -a -i ${logfilepath}
echo 'fqfpnewscript                    = '$fqfpnewscript | tee -a -i ${logfilepath}
echo 'fqfpcurrentscript                = '$fqfpcurrentscript | tee -a -i ${logfilepath}
echo 'fqfphistoryscript                = '$fqfphistoryscript | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '-------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey; echo


#----------------------------------------------------------------------------------------
# Check for working folders
#----------------------------------------------------------------------------------------

echo >> ${logfilepath}
echo '----------------------------------------------------------------------------------------' >> ${logfilepath}
echo ' Folder path check and creation! ' >> ${logfilepath}
echo '----------------------------------------------------------------------------------------' >> ${logfilepath}
echo >> ${logfilepath}

echo 'Check if folder exists and if not create it: '${targetfolder} | tee -a -i ${logfilepath}
if [ ! -r ${targetfolder} ] ; then
    mkdir -pv ${targetfolder} >> ${logfilepath}
    chmod 775 ${targetfolder}
else
    chmod 775 ${targetfolder}
fi

echo 'Check if folder exists and if not create it: '$targetfolderforscript | tee -a -i ${logfilepath}
if [ ! -r $targetfolderforscript ] ; then
    mkdir -pv $targetfolderforscript >> ${logfilepath}
    chmod 775 $targetfolderforscript
else
    chmod 775 $targetfolderforscript
fi

echo 'Check if folder exists and if not create it: '$rootworkpath | tee -a -i ${logfilepath}
if [ ! -r $rootworkpath ] ; then
    mkdir -pv $rootworkpath >> ${logfilepath}
    chmod 775 $rootworkpath
else
    chmod 775 $rootworkpath
fi

echo 'Check if folder exists and if not create it: '$fqpnworkfolder | tee -a -i ${logfilepath}
if [ ! -r $fqpnworkfolder ] ; then
    mkdir -pv $fqpnworkfolder
    chmod 775 $fqpnworkfolder
else
    chmod 775 $fqpnworkfolder
fi

echo 'Check if folder exists and if not create it: '$fqpncurrentfolder | tee -a -i ${logfilepath}
if [ ! -r $fqpncurrentfolder ] ; then
    mkdir -pv $fqpncurrentfolder
    chmod 775 $fqpncurrentfolder
else
    chmod 775 $fqpncurrentfolder
fi

echo 'Check if folder exists and if not create it: '$fqpnhistoryfolder | tee -a -i ${logfilepath}
if [ ! -r $fqpnhistoryfolder ] ; then
    mkdir -pv $fqpnhistoryfolder
    chmod 775 $fqpnhistoryfolder
else
    chmod 775 $fqpnhistoryfolder
fi

echo 'Check if folder exists and if not create it: '$fqpnnewfolder | tee -a -i ${logfilepath}
if [ ! -r $fqpnnewfolder ] ; then
    mkdir -pv $fqpnnewfolder
    chmod 775 $fqpnnewfolder
else
    chmod 775 $fqpnnewfolder
fi

echo >> ${logfilepath}
echo '----------------------------------------------------------------------------------------' >> ${logfilepath}
echo >> ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Drop into folder and make sure we can write! ' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Wait until the target folder is available : '$fqpnworkfolder; echo
echo -n '!'
until [ -r $fqpnworkfolder ]; do echo -n '.'; done; echo

echo | tee -a -i ${logfilepath}
echo 'pushd to '$fqpnworkfolder | tee -a -i ${logfilepath}

pushd "$fqpnworkfolder"

echo | tee -a -i ${logfilepath}
echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo 'Current content of working folder : '$fqpnworkfolder | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

ls -alh $fqpnworkfolder | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo 'Clear root content of working folder : '$fqpnworkfolder | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

rm -fv $fqpnworkfolder/* | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo 'Post clean-up content of working folder : '$fqpnworkfolder | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
ls -alh $fqpnworkfolder | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey; echo


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Get remote files! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo "Fetch latest $fqfpremotefile from tftp repository on ${targettftpserver}..." | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

tftp -v -m binary ${targettftpserver} -c get $fqfpremotefile | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo "Fetch latest $fqfpremotescript from tftp repository on ${targettftpserver}..." | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

tftp -v -m binary ${targettftpserver} -c get $fqfpremotescript | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Check File transfer OK! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo "Check that we the Work File : $workfilename" | tee -a -i ${logfilepath}
if [ ! -r $workfilename ]; then
    # Oh, oh, we didn't get the $workfilename file
    echo | tee -a -i ${logfilepath}
    echo 'Critical Error!!! Did not obtain '$workfilename' file from tftp!!!' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'returning to script starting folder' | tee -a -i ${logfilepath}
    
    popd
    
    echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'Exiting...' | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'Output location for all results is here : '$fqpnworkfolder | tee -a -i ${logfilepath}
    echo 'Log results documented in this log file : '${logfilepath} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 255
else
    # we have the $workfilename file and can work with it
    echo 'Work File found' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    ls -alh $workfilename | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    # copy the new file to the new folder
    cp $workfilename $fqpnnewfolder >> ${logfilepath}
fi

echo "Check that we the Work Script : $workscriptname" | tee -a -i ${logfilepath}
if [ ! -r $workscriptname ]; then
    # Oh, oh, we didn't get the $workscriptname file
    echo | tee -a -i ${logfilepath}
    echo 'Critical Error!!! Did not obtain '$workscriptname' file from tftp!!!' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'returning to script starting folder' | tee -a -i ${logfilepath}
    
    popd
    
    echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'Exiting...' | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'Output location for all results is here : '$fqpnworkfolder | tee -a -i ${logfilepath}
    echo 'Log results documented in this log file : '${logfilepath} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 255
else
    # we have the $workscriptname file and can work with it
    echo 'Work Script found' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    ls -alh $workscriptname | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    # copy the new script to the new folder
    cp $workscriptname $fqpnnewfolder >> ${logfilepath}
    cp $workscriptname $targetfolderforscript >> ${logfilepath}
fi

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Check if this is the first run or if we need to verify downloaded file is newer! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

if [ ! -x $fqfpcheckfile ]; then
    # Expected check file $fqfpcheckfile is not currently installed
    echo "Expected check file $fqfpcheckfile IS NOT currently installed!" | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    # overwrite the current file with the work file
    echo "Overwrite the current file : $fqfpcurrentfile with $workfilename" | tee -a -i ${logfilepath}
    echo "We'll assume this is first install and copy the new to current for later." | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    # copy the new file to the current folder
    #cp $workfilename $fqpncurrentfolder >> ${logfilepath}
    #cp $workscriptname $fqpncurrentfolder >> ${logfilepath}
else
    # Expected check file $fqfpcheckfile is currently installed
    echo "Expected check file $fqfpcheckfile IS currently installed!" | tee -a -i ${logfilepath}
    if [ -r $fqfpcurrentfile ]; then
        # we have a current file to check
        echo "We have an existing current file : $fqfpcurrentfile" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        # md5sum current/Check_Point_gaia_dynamic_cli.tgz
        export md5current=$(md5sum $fqfpcurrentfile | cut -d " " -f 1)
        echo 'md5 of current : '$md5current | tee -a -i ${logfilepath}
        
        # md5sum Check_Point_gaia_dynamic_cli.tgz
        export md5new=$(md5sum $fqfpnewfile | cut -d " " -f 1)
        echo 'md5 of     new : '$md5new | tee -a -i ${logfilepath}
        
        if [ $md5new == $md5current ]; then 
            echo "Files are the same" | tee -a -i ${logfilepath}
            echo 'No reason to update the existing installation!' | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'returning to script starting folder' | tee -a -i ${logfilepath}
            
            popd
            
            echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            echo 'Exiting...' | tee -a -i ${logfilepath}
            
            echo | tee -a -i ${logfilepath}
            echo 'Output location for all results is here : '$fqpnworkfolder | tee -a -i ${logfilepath}
            echo 'Log results documented in this log file : '${logfilepath} | tee -a -i ${logfilepath}
            echo | tee -a -i ${logfilepath}
            
            exit 255
        else 
            echo "Files are different, moving right along..." | tee -a -i ${logfilepath}
        fi
        
        # overwrite the current file with the work file
        echo "Overwrite the current file : $fqfpcurrentfile with $workfilename" | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        # copy the new file to the current folder
        #cp $workfilename $fqpncurrentfolder >> ${logfilepath}
        #cp $workscriptname $fqpncurrentfolder >> ${logfilepath}
        
    else
        # no current file, so copy new file to current
        echo "There is no current file : $fqfpcurrentfile" | tee -a -i ${logfilepath}
        echo "We'll assume this is first install and copy the new to current for later." | tee -a -i ${logfilepath}
        echo | tee -a -i ${logfilepath}
        
        # copy the new file to the current folder
        #cp $workfilename $fqpncurrentfolder >> ${logfilepath}
        #cp $workscriptname $fqpncurrentfolder >> ${logfilepath}
    fi
fi

# copy the new file to the current folder
echo 'Copy file : '$workfilename' to folder : '$fqpncurrentfolder' !' | tee -a -i ${logfilepath}
cp $workfilename $fqpncurrentfolder >> ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Copy file : '$workscriptname' to folder : '$fqpncurrentfolder' !' | tee -a -i ${logfilepath}
cp $workscriptname $fqpncurrentfolder >> ${logfilepath}
echo | tee -a -i ${logfilepath}

# copy the new file to the history folder with DTGS tag
# configure local temporary variables
_tempworkfile=${DATEDTGS}.$workfilename
_tempfqpnhistoryfile=$fqpnhistoryfolder/$_tempworkfile
_tempworkscript=${DATEDTGS}.$workscriptname
_tempfqpnhistoryscript=$fqpnhistoryfolder/$_tempworkscript

echo 'Copy file : '$workfilename' to file : '$_tempfqpnhistoryfile' !' | tee -a -i ${logfilepath}
cp $workfilename $_tempfqpnhistoryfile >> ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Copy file : '$workscriptname' to file : '$_tempfqpnhistoryscript' !' | tee -a -i ${logfilepath}
cp $workscriptname $_tempfqpnhistoryscript >> ${logfilepath}
echo | tee -a -i ${logfilepath}

# clear local temporary variables
_tempworkfile=
_tempfqpnhistoryfile=
_tempworkscript=
_tempfqpnhistoryscript=


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Drop into folder '${targetfolder}' and make sure we can write! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo 'Wait until the target folder is available : '${targetfolder}; echo
echo -n '!'; until [ -r ${targetfolder} ]; do echo -n '.'; done; echo

echo | tee -a -i ${logfilepath}
echo 'pushd to '${targetfolder} | tee -a -i ${logfilepath}

pushd "${targetfolder}"

echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo 'Current content of working folder : '$fqpnworkfolder | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
ls -alh $fqpnworkfolder | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

# Not removing the existing folder!
#
#rm -fv $fqpnworkfolder/* | tee -a -i ${logfilepath}
#echo | tee -a -i ${logfilepath}
#echo 'Post clean-up content of working folder : '$fqpnworkfolder | tee -a -i ${logfilepath}
#echo | tee -a -i ${logfilepath}
#ls -alh $fqpnworkfolder | tee -a -i ${logfilepath}
#echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

# copy in the workfile
cp -fv $fqfpworkfile . | tee -a -i ${logfilepath}
ls -alh $workfilename | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Untar the '$workfilename' and execute the installer! ' | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

if [ -r $workfilename ]; then
    # OK now that we are clear on doing the work, let's extract this file and make it happen
    
    echo -n 'Current Folder : pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    # now unzip existing scripts folder
    echo "Extract $workfilename file..." | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    tar -zxvf $workfilename | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'Remove '$workfilename' file...' | tee -a -i ${logfilepath}
    rm -fv $workfilename | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'Current folder listing...' | tee -a -i ${logfilepath}
    ls -alh | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'returning to script working folder' | tee -a -i ${logfilepath}
    
    popd
    
    echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
else
    # Heh????
    # What happened to the file?!?!?!
    
    echo 'Critical error, can not access the work file : '$workfilename | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'Files and folders:' | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    ls -alhR | tee -a -i ${logfilepath}
    echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'returning to script working folder' | tee -a -i ${logfilepath}
    
    popd
    
    echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    echo 'returning to script starting folder' | tee -a -i ${logfilepath}
    
    popd
    
    echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    echo 'Exiting...' | tee -a -i ${logfilepath}
    
    echo | tee -a -i ${logfilepath}
    echo 'Output location for all results is here : '$fqpnworkfolder | tee -a -i ${logfilepath}
    echo 'Log results documented in this log file : '${logfilepath} | tee -a -i ${logfilepath}
    echo | tee -a -i ${logfilepath}
    
    exit 255
fi


echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Return to script starting folder... ' | tee -a -i ${logfilepath}

popd

echo -n 'pwd = ' | tee -a -i ${logfilepath}; pwd | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


read -t ${WAITTIME} -n 1 -p "Any key to continue.  Automatic continue after ${WAITTIME} seconds : " anykey; echo

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Target Working folder details for '$fqpnworkfolder | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Files and folders:' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

ls -alhR "$fqpnworkfolder" | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo ' Target results folder details for '$targetresultspath | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}
echo 'Files and folders:' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}

ls -alhR "$targetresultspath" | tee -a -i ${logfilepath}

echo | tee -a -i ${logfilepath}
echo '----------------------------------------------------------------------------------------' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


echo 'Done processing!' | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


#==================================================================================================
#==================================================================================================
#
# END :  Download and if necessary, upgrade GAIA REST API
#
#==================================================================================================
#==================================================================================================


# -------------------------------------------------------------------------------------------------
# Closing operations and log file information
# -------------------------------------------------------------------------------------------------


if [ -r nul ] ; then
    rm nul >> ${logfilepath}
fi

if [ -r None ] ; then
    rm None >> ${logfilepath}
fi

echo | tee -a -i ${logfilepath}
echo 'Log File : '${logfilepath} | tee -a -i ${logfilepath}
echo | tee -a -i ${logfilepath}


# -------------------------------------------------------------------------------------------------
# End of script Operations
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

echo 'Done!'
echo
