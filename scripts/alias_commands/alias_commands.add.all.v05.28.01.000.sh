# !! SAMPLE !!
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
# SCRIPT  Alias commands and variables configuration for bash shell launch
#
#
ScriptDate=2022-02-24
ScriptVersion=05.28.01
ScriptRevision=000
TemplateVersion=05.28.01
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.28.01
AliasCommandsLevel=075
#

#========================================================================================
#========================================================================================
# start of alias.commands.<action>.<scope>.sh
#========================================================================================
#========================================================================================


#========================================================================================
# Setup standard environment export variables
#========================================================================================


tCLEAR=`tput clear`

tNORM=`tput sgr0`
tBOLD=`tput bold`
tDIM=`tput dim`
tREVERSE=`tput rev`

tULINEs=`tput smul`
tULINEe=`tput rmul`

tSTANDOb=`tput smso`
tSTANDOe=`tput rmso`

WinCols=`tput cols`
WinLines=`tput lines`


#tput setab color  Set ANSI Background color
#tput setaf color  Set ANSI Foreground color
tBLACK=`tput setaf 0`
tRED=`tput setaf 1`
tGREEN=`tput setaf 2`
tYELLOW=`tput setaf 3`
tBLUE=`tput setaf 4`
tMAGENTA=`tput setaf 5`
tCYAN=`tput setaf 6`
tWHITE=`tput setaf 7`
tDEFAULT=`tput setaf 9`

bkBLACK=`tput setab 0`
bkRED=`tput setab 1`
bkGREEN=`tput setab 2`
bkYELLOW=`tput setab 3`
bkBLUE=`tput setab 4`
bkMAGENTA=`tput setab 5`
bkCYAN=`tput setab 6`
bkWHITE=`tput setab 7`
bkDEFAULT=`tput setab 9`


#========================================================================================
#========================================================================================


echo ${tRED}'==============================================================================='${tDEFAULT}
echo ${tCYAN}'==============================================================================='${tDEFAULT}
echo ${tCYAN}' MyBasementCloud bash 4 Check Point Environmen'${tDEFAULT}
echo ${tCYAN}' Scripts :  Version '${ScriptVersion}', Revision '${ScriptRevision}', Level '${AliasCommandsLevel}' from Date '${ScriptDate}${tDEFAULT}
echo ${tCYAN}'==============================================================================='${tDEFAULT}
echo
echo ${tCYAN}'Configuring User Environment...'${tDEFAULT}
echo


#========================================================================================
#========================================================================================


# 2021-08-26
export ENVIRONMENTHELPFILE=${HOME}/environment_help_file.txt

if [ -f ${ENVIRONMENTHELPFILE} ]; then
    rm ${ENVIRONMENTHELPFILE}
fi
touch ${ENVIRONMENTHELPFILE}

# 2021-08-26
export ENVIRONMENTVARSFILE=${HOME}/environment_variables_file.txt

if [ -f ${ENVIRONMENTVARSFILE} ]; then
    rm ${ENVIRONMENTVARSFILE}
fi
touch ${ENVIRONMENTVARSFILE}

echo >> ${ENVIRONMENTHELPFILE}
echo '===============================================================================' >> ${ENVIRONMENTHELPFILE}
echo '===============================================================================' >> ${ENVIRONMENTHELPFILE}
echo 'MyBasementCloud bash 4 Check Point Environment' >> ${ENVIRONMENTHELPFILE}
echo 'Scripts :  Version '${ScriptVersion}', Revision '${ScriptRevision}', Level '${AliasCommandsLevel}' from Date '${ScriptDate} >> ${ENVIRONMENTHELPFILE}
echo '===============================================================================' >> ${ENVIRONMENTHELPFILE}
echo >> ${ENVIRONMENTHELPFILE}

echo '===============================================================================' >> ${ENVIRONMENTHELPFILE}
echo 'User Environment Configuration Variables and Alias Commands' >> ${ENVIRONMENTHELPFILE}
echo '===============================================================================' >> ${ENVIRONMENTHELPFILE}
echo >> ${ENVIRONMENTHELPFILE}

# 2021-06-01

echo >> ${ENVIRONMENTVARSFILE}
echo '===============================================================================' >> ${ENVIRONMENTVARSFILE}
echo '===============================================================================' >> ${ENVIRONMENTVARSFILE}
echo 'MyBasementCloud bash 4 Check Point Environment' >> ${ENVIRONMENTVARSFILE}
echo 'Scripts :  Version '${ScriptVersion}', Revision '${ScriptRevision}', Level '${AliasCommandsLevel}' from Date '${ScriptDate} >> ${ENVIRONMENTVARSFILE}
echo '===============================================================================' >> ${ENVIRONMENTVARSFILE}
echo >> ${ENVIRONMENTVARSFILE}

echo '===============================================================================' >> ${ENVIRONMENTVARSFILE}
echo 'User Environment Configuration Variables' >> ${ENVIRONMENTVARSFILE}
echo '===============================================================================' >> ${ENVIRONMENTVARSFILE}
echo >> ${ENVIRONMENTVARSFILE}

tempENVHELPFILEvars=/var/tmp/environment_help_file.temp.variables.txt
tempENVHELPFILEalias=/var/tmp/environment_help_file.temp.alias.txt

echo '===============================================================================' > ${tempENVHELPFILEvars}
echo 'List Custom User variables set by alias_commands.add.all' >> ${tempENVHELPFILEvars}
echo '===============================================================================' >> ${tempENVHELPFILEvars}
echo >> ${tempENVHELPFILEvars}


echo '===============================================================================' > ${tempENVHELPFILEalias}
echo 'List Custom User alias commands set by alias_commands.add.all' >> ${tempENVHELPFILEalias}
echo '===============================================================================' >> ${tempENVHELPFILEalias}
echo >> ${tempENVHELPFILEalias}


# Single Line entries
#printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "x" ${x} >> ${tempENVHELPFILEvars}
#printf "${tCYAN}%-35s${tNORM} : %s\n" "x" 'x' >> ${tempENVHELPFILEalias}
# Two Line entries
#printf "${tCYAN}%s${tNORM}\n" "x" >> ${tempENVHELPFILEalias}
#printf "${tCYAN}%-35s${tNORM} :: %s\n" " " 'x' >> ${tempENVHELPFILEalias}


#========================================================================================
# 2020-11-18

if [ -z ${SCRIPTVERBOSE} ] ; then 
    export SCRIPTVERBOSE=false
fi
if [ -z ${NOWAIT} ] ; then 
    export NOWAIT=false
fi
if [ -z ${NOSTART} ] ; then 
    export NOSTART=false
fi

printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "SCRIPTVERBOSE" ${SCRIPTVERBOSE} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "NOWAIT" ${NOWAIT} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "NOSTART" ${NOSTART} >> ${tempENVHELPFILEvars}
echo >> ${tempENVHELPFILEvars}

#========================================================================================
# 2019-09-28, 2020-05-30, 2020-09-30, 2020-11-18

export MYWORKFOLDER=/var/log/__customer

export MYWORKFOLDERSCRIPTS=${MYWORKFOLDER}/_scripts
export MYWORKFOLDERSCRIPTSB4CP=${MYWORKFOLDER}/_scripts/bash_4_Check_Point
export MYWORKFOLDERTOOLS=${MYWORKFOLDER}/_tools
export MYWORKFOLDERDOWNLOADS=${MYWORKFOLDER}/download
export MYWORKFOLDERUGEX=${MYWORKFOLDER}/upgrade_export
export MYWORKFOLDERUGEXSCRIPTS=${MYWORKFOLDER}/upgrade_export/scripts
export MYWORKFOLDERCHANGE=${MYWORKFOLDERUGEX}/Change_Log
export MYWORKFOLDERDUMP=${MYWORKFOLDERUGEX}/dump
export MYWORKFOLDERREFERENCE=${MYWORKFOLDERUGEX}/Reference

printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDER" ${MYWORKFOLDER} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERSCRIPTS" ${MYWORKFOLDERSCRIPTS} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERSCRIPTSB4CP" ${MYWORKFOLDERSCRIPTSB4CP} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERTOOLS" ${MYWORKFOLDERTOOLS} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERDOWNLOADS" ${MYWORKFOLDERDOWNLOADS} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERUGEX" ${MYWORKFOLDERUGEX} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERUGEXSCRIPTS" ${MYWORKFOLDERUGEXSCRIPTS} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERCHANGE" ${MYWORKFOLDERCHANGE} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERDUMP" ${MYWORKFOLDERDUMP} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERREFERENCE" ${MYWORKFOLDERREFERENCE} >> ${tempENVHELPFILEvars}
echo >> ${tempENVHELPFILEvars}

#========================================================================================
# 2020-01-0

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
export JQ16FQFN=$JQ16PATH/${JQ16FILE}
if [ -r ${JQ16FQFN} ] ; then
    # OK we have the easy-button alternative
    export JQ16=${JQ16FQFN}
else
    export JQ16=
fi

printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "JQ" ${JQ} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "JQ16PATH" ${JQ16PATH} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "JQ16FILE" ${JQ16FILE} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "JQ16FQFN" ${JQ16FQFN} >> ${tempENVHELPFILEvars}
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "JQ16" ${JQ16} >> ${tempENVHELPFILEvars}
echo >> ${tempENVHELPFILEvars}


#========================================================================================
# Setup main environment help alias
#========================================================================================
# 2021-06-23


alias show_environment_help='echo;more ${ENVIRONMENTHELPFILE};echo'

printf "${tCYAN}%-35s${tNORM} : %s\n" "show_environment_help" 'Display help for user environment variables and alias values set' >> ${tempENVHELPFILEalias}

alias show_user_variables='echo;more ${ENVIRONMENTVARSFILE};echo'

printf "${tCYAN}%-35s${tNORM} : %s\n" "show_user_variables" 'Display help for user environment variables' >> ${tempENVHELPFILEalias}


#========================================================================================
# Setup Private Configuration Variables and operations
#========================================================================================


if [ -f private_config.add.sh ] ; then
    . private_config.add.sh "$@"
fi


#========================================================================================
# Setup alias and other complex operations
#========================================================================================


#========================================================================================
# Updated 2020-11-26
#alias list='ls -alh'
alias list='ls -alh --color=auto --group-directories-first'
printf "${tCYAN}%-35s${tNORM} : %s\n" "list" 'display folder content with -alh --color=auto --group-directories-first' >> ${tempENVHELPFILEalias}


#========================================================================================
# 2021-06-23

alias DAYDATE='date +%Y-%m-%d'
alias DTGDATE='date +%Y-%m-%d-%H%M%Z'
alias DTGSDATE='date +%Y-%m-%d-%H%M%S%Z'

alias DTGUTCDATE='date -u +%Y-%m-%d-%H%M%Z'
alias DTGUTCSDATE='date -u +%Y-%m-%d-%H%M%S%Z'

printf "${tCYAN}%-35s${tNORM} : %s\n" "DAYDATE" 'Generate Date Group with Year-Month-Day YYYY-mm-dd' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "DTGDATE" 'Generate Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "DTGSDATE" 'Generate Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "DTGUTCDATE" 'Generate UTC based Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "DTGUTCSDATE" 'Generate UTC based Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}

alias timecheck='echo -e "Current Date-Time-Group : `DTGSDATE` \n"'

printf "${tCYAN}%-35s${tNORM} : %s\n" "timecheck" 'Show Current DTGS Date Time Group (YYYY-mm-dd-HHMMSSTZ3)' >> ${tempENVHELPFILEalias}


#========================================================================================
# 2021-06-23

alias DAYDATE='date +%Y-%m-%d'
alias DTGDATE='date +%Y-%m-%d-%H%M%Z'
alias DTGSDATE='date +%Y-%m-%d-%H%M%S%Z'

alias DTGUTCDATE='date -u +%Y-%m-%d-%H%M%Z'
alias DTGUTCSDATE='date -u +%Y-%m-%d-%H%M%S%Z'

printf "${tCYAN}%-35s${tNORM} : %s\n" "DAYDATE" 'Generate Date Group with Year-Month-Day YYYY-mm-dd' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "DTGDATE" 'Generate Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "DTGSDATE" 'Generate Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "DTGUTCDATE" 'Generate UTC based Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "DTGUTCSDATE" 'Generate UTC based Date Time Group with Year-Month-Day-Time-TimeZone YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}

alias timecheck='echo -e "Current Date-Time-Group : `DTGSDATE` \n"'

printf "${tCYAN}%-35s${tNORM} : %s\n" "timecheck" 'Show Current DTGS Date Time Group (YYYY-mm-dd-HHMMSSTZ3)' >> ${tempENVHELPFILEalias}


#========================================================================================
# 2021-08-30


alias HOSTNAMEDTG='echo ${HOSTNAME}.`DTGDATE`'
alias HOSTNAMEDTGS='echo ${HOSTNAME}.`DTGSDATE`'
alias HOSTNAMENOW='echo ${HOSTNAME}.`DTGSDATE`'

printf "${tCYAN}%-35s${tNORM} : %s\n" "HOSTNAMEDTG" 'Generate hostname . (dot) Date Time Group :  ${HOSTNAME}.YYYY-mm-dd-HHMMTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "HOSTNAMEDTGS" 'Generate hostname . (dot) Date Time Group with Seconds :  ${HOSTNAME}.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "HOSTNAMENOW" 'Generate hostname . (dot) Date Time Group with Seconds :  ${HOSTNAME}.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}


alias namenow='echo ${HOSTNAME}.`DTGSDATE`'
alias nametoday='echo ${HOSTNAME}.`DAYDATE`'
printf "${tCYAN}%-35s${tNORM} : %s\n" "namenow" 'Name Now - Generate hostname . (dot) Date Time Group with Seconds :  ${HOSTNAME}.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "nametoday" 'Name Today - Generate hostname . (dot) Date Group :  ${HOSTNAME}.YYYY-mm-dd' >> ${tempENVHELPFILEalias}


#========================================================================================
# 2021-08-30


alias hostnow='echo ${HOSTNAME}.`DTGSDATE`'
alias hosttoday='echo ${HOSTNAME}.`DAYDATE`'

printf "${tCYAN}%-35s${tNORM} : %s\n" "hostnow" 'Name Now - Generate hostname . (dot) Date Time Group with Seconds :  ${HOSTNAME}.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "hosttoday" 'Name Today - Generate hostname . (dot) Date Group :  ${HOSTNAME}.YYYY-mm-dd' >> ${tempENVHELPFILEalias}


alias usernow='echo ${USER}.`DTGSDATE`'
alias usertoday='echo ${USER}.`DAYDATE`'

printf "${tCYAN}%-35s${tNORM} : %s\n" "usernow" 'Name Now - Generate username . (dot) Date Time Group with Seconds :  ${USER}YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "usertoday" 'Name Today - Generate username . (dot) Date Group :  ${USER}.YYYY-mm-dd' >> ${tempENVHELPFILEalias}


alias hostusernow='echo ${HOSTNAME}.${USER}.`DTGSDATE`'
alias hostusertoday='echo ${HOSTNAME}.${USER}.`DAYDATE`'

printf "${tCYAN}%-35s${tNORM} : %s\n" "hostusernow" 'Name Now - Generate hostname . (dot) username . (dot) Date Time Group with Seconds :  ${HOSTNAME}.${USER}.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "hostusertoday" 'Name Today - Generate hostname . (dot) username . (dot) Date Group :  ${HOSTNAME}.${USER}.YYYY-mm-dd' >> ${tempENVHELPFILEalias}


alias userhostnow='echo ${USER}.${HOSTNAME}.`DTGSDATE`'
alias userhosttoday='echo ${USER}.${HOSTNAME}.`DAYDATE`'

printf "${tCYAN}%-35s${tNORM} : %s\n" "userhostnow" 'Name Now - Generate username . (dot) hostname . (dot) Date Time Group with Seconds :  ${USER}.${HOSTNAME}.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "userhosttoday" 'Name Today - Generate username . (dot) hostname . (dot) Date Group :  ${USER}.${HOSTNAME}.YYYY-mm-dd' >> ${tempENVHELPFILEalias}


#========================================================================================
# UPDATED 2021-06-23 -

#Generate Check Point release version
CPRELEASEVERSION ()
{
    # we need the quick version of the gaiaversion
    cpreleasefile=/etc/cp-release
    getgaiaquickversion=$(cat ${cpreleasefile} | cut -d " " -f 4)
    gaiaquickversion=${getgaiaquickversion}
    echo ${gaiaquickversion}
}

printf "${tCYAN}%-35s${tNORM} : %s\n" "CPRELEASEVERSION" 'Generate Check Point release version' >> ${tempENVHELPFILEalias}

alias CPVERSIONNOW='echo `CPRELEASEVERSION`.${HOSTNAME}.`DTGSDATE`'
alias CPVERSIONHOSTNOW='echo `CPRELEASEVERSION`.${HOSTNAME}.`DTGSDATE`'
alias HOSTCPVERSIONNOW='echo ${HOSTNAME}.`CPRELEASEVERSION`.`DTGSDATE`'
alias vnamenow='echo `CPRELEASEVERSION`.${HOSTNAME}.`DTGSDATE`'
alias vnametoday='echo `CPRELEASEVERSION`.${HOSTNAME}.`DAYDATE`'
alias namevnow='echo ${HOSTNAME}.`CPRELEASEVERSION`.`DTGSDATE`'
alias namevtoday='echo ${HOSTNAME}.`CPRELEASEVERSION`.`DAYDATE`'

printf "${tCYAN}%-35s${tNORM} : %s\n" "CPVERSIONNOW" 'Generate Check Point release version . (dot) Date Time Group :  release_version.YYYY-mm-dd-HHMMTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "CPVERSIONHOSTNOW" 'Generate Check Point release version . (dot) hostname . (dot) Date Time Group with Seconds :  release_version.${HOSTNAME}.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "HOSTCPVERSIONNOW" 'Generate hostname . (dot) Check Point release version . (dot) Date Time Group with Seconds :  ${HOSTNAME}.release_version.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "vnamenow" 'Version Name Now - Generate Check Point release version . (dot) hostname . (dot) Date Time Group with Seconds :  release_version.${HOSTNAME}.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "vnametoday" 'Version Name Today - Generate Check Point release version . (dot) hostname . (dot) Date Group :  release_version.${HOSTNAME}.YYYY-mm-dd' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "namevnow" 'Name Version Now - Generate hostname . (dot) Check Point release version . (dot) Date Time Group with Seconds :  ${HOSTNAME}.release_version.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "namevtoday" 'Name Version Today - Generate Check Point release version . (dot) hostname . (dot) Date Group :  ${HOSTNAME}.release_version.YYYY-mm-dd' >> ${tempENVHELPFILEalias}


#========================================================================================
# UPDATED 2021-06-23 -

#Generate testing folders
alias testingnow='testfolder="./__testing.${HOSTNAME}.`CPRELEASEVERSION`.`DTGSDATE`" ; echo "Making test folder now:  ${testfolder}" ; echo ; mkdir ${testfolder} ; ls -alh --color=auto --group-directories-first ${testfolder} ; echo'
alias testingtoday='testfolder="./__testing.${HOSTNAME}.`CPRELEASEVERSION`.`DAYDATE`" ; echo "Making test folder now:  ${testfolder}" ; echo ; mkdir ${testfolder} ; ls -alh --color=auto --group-directories-first ${testfolder} ; echo'

printf "${tCYAN}%-35s${tNORM} : %s\n" "testingnow" 'Generate Test Folder Now in this folder :  ${HOSTNAME}.release_version.YYYY-mm-dd-HHMMSSTZ3' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "testingtoday" 'Generate Test Folder Today in this folder :  ${HOSTNAME}.release_version.YYYY-mm-dd' >> ${tempENVHELPFILEalias}


#========================================================================================
# 2020-09-17
alias gocustomer='cd ${MYWORKFOLDER};echo Current path = `pwd`;echo'
alias gougex='cd ${MYWORKFOLDERUGEX};echo Current path = `pwd`;echo'
alias gochangelog='cd "${MYWORKFOLDERCHANGE}";echo Current path = `pwd`;echo'
alias godump='cd "${MYWORKFOLDERDUMP}";echo Current path = `pwd`;echo'
alias godownload='cd "${MYWORKFOLDERDOWNLOADS}";echo Current path = `pwd`;echo'
alias goscripts='cd "${MYWORKFOLDERSCRIPTS}";echo Current path = `pwd`;echo'
alias gob4cp='cd "${MYWORKFOLDERSCRIPTSB4CP}";echo Current path = `pwd`;echo'
alias gob4CP='gob4cp'

printf "${tCYAN}%-35s${tNORM} : %s\n" "gocustomer" 'Go to customer work folder '${MYWORKFOLDER} >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "gougex" 'Go to upgrade export folder '${MYWORKFOLDER}/upgrade_export >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "gochangelog" 'Go to Change Log folder '${MYWORKFOLDERCHANGE} >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "godump" 'Go to dump folder '${MYWORKFOLDERDUMP} >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "godownload" 'Go to download folder '${MYWORKFOLDERDOWNLOADS} >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "goscripts" 'Go to scripts folder '${MYWORKFOLDERSCRIPTS} >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "gob4cp|gob4CP" 'Go to bash 4 Check Point folder '${MYWORKFOLDERSCRIPTSB4CP} >> ${tempENVHELPFILEalias}
#printf "${tCYAN}%-35s${tNORM} : %s\n" "gob4CP" 'Go to bash 4 Check Point folder '${MYWORKFOLDERSCRIPTSB4CP} >> ${tempENVHELPFILEalias}

#========================================================================================
# 2020-09-17
if [ -r ${MYWORKFOLDER}/cli_api_ops ] ; then
    alias goapi='cd ${MYWORKFOLDER}/cli_api_ops;echo Current path = `pwd`;echo'
    alias goapiexport='cd ${MYWORKFOLDER}/cli_api_ops/export_import;echo Current path = `pwd`;echo'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "goapi" 'Go to api work folder '${MYWORKFOLDER}/cli_api_ops >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "goapiexport" 'Go to api export folder '${MYWORKFOLDER}/cli_api_ops/export_import >> ${tempENVHELPFILEalias}
fi
if [ -r ${MYWORKFOLDER}/cli_api_ops.wip ] ; then
    alias goapiwip='cd ${MYWORKFOLDER}/cli_api_ops.wip;echo Current path = `pwd`;echo'
    alias goapiwipexport='cd ${MYWORKFOLDER}/cli_api_ops.wip/export_import.wip;echo Current path = `pwd`;echo'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "goapiwip" 'Go to api development work folder '${MYWORKFOLDER}/cli_api_ops.wip >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "goapiwipexport" 'Go to api development export folder '${MYWORKFOLDER}/cli_api_ops.wip/export_import.wip >> ${tempENVHELPFILEalias}
fi

#========================================================================================
# 2020-11-08
if [ -r ${MYWORKFOLDER}/devops ] ; then
    alias godevops='cd ${MYWORKFOLDER}/devops;echo Current path = `pwd`;echo'
    if [ -r ${MYWORKFOLDER}/devops/objects ] ; then
        alias godevopsexport='cd ${MYWORKFOLDER}/devops/objects/export_import;echo Current path = `pwd`;echo'
    else
        alias godevopsexport='cd ${MYWORKFOLDER}/devops/export_import;echo Current path = `pwd`;echo'
    fi
    printf "${tCYAN}%-35s${tNORM} : %s\n" "godevops" 'Go to api devops folder '${MYWORKFOLDER}/devops >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "godevopsexport" 'Go to api devops export folder '${MYWORKFOLDER}/devops/export_import >> ${tempENVHELPFILEalias}
fi
if [ -r ${MYWORKFOLDER}/devops.dev ] ; then
    alias godevopsdev='cd ${MYWORKFOLDER}/devops.dev;echo Current path = `pwd`;echo'
    if [ -r ${MYWORKFOLDER}/devops.dev/objects.wip ] ; then
        alias godevopsdevexport='cd ${MYWORKFOLDER}/devops.dev/objects.wip/export_import.wip;echo Current path = `pwd`;echo'
    else
        alias godevopsdevexport='cd ${MYWORKFOLDER}/devops.dev/export_import.wip;echo Current path = `pwd`;echo'
    fi
    printf "${tCYAN}%-35s${tNORM} : %s\n" "godevopsdev" 'Go to api devops development folder '${MYWORKFOLDER}/devops.dev >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "godevopsdevexport" 'Go to api devops development objects export folder '${MYWORKFOLDER}/devops.dev/objects.wip/export_import.wip >> ${tempENVHELPFILEalias}
fi
if [ -r ${MYWORKFOLDER}/devops.dev.test ] ; then
    alias godevopsdevtest='cd ${MYWORKFOLDER}/devops.dev.test;echo Current path = `pwd`;echo'
    if [ -r ${MYWORKFOLDER}/devops.dev.test/objects.wip ] ; then
        alias godevopsdevtestexport='cd ${MYWORKFOLDER}/devops.dev.test/objects.wip/export_import.wip;echo Current path = `pwd`;echo'
    else
        alias godevopsdevtestexport='cd ${MYWORKFOLDER}/devops.dev.test/export_import.wip;echo Current path = `pwd`;echo'
    fi
    printf "${tCYAN}%-35s${tNORM} : %s\n" "godevopsdevtest" 'Go to api devops development test folder '${MYWORKFOLDER}/devops.dev.test >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "godevopsdevtestexport" 'Go to api devops development test objects export folder '${MYWORKFOLDER}/devops.dev.test/objects.wip/export_import.wip >> ${tempENVHELPFILEalias}
fi

#========================================================================================
# 2021-08-30

alias godumpnow='DTGSNOW=`DTGSDATE`;mkdir -pv "${MYWORKFOLDERDUMP}/${DTGSNOW}";list "${MYWORKFOLDERDUMP}/";echo;cd "${MYWORKFOLDERDUMP}/${DTGSNOW}";echo;echo Current path = `pwd`;echo'
alias godumpdtg='DTGNOW=`DTGDATE`;mkdir -pv "${MYWORKFOLDERDUMP}/${DTGNOW}";list "${MYWORKFOLDERDUMP}/";echo;cd "${MYWORKFOLDERDUMP}/${DTGNOW}";echo;echo Current path = `pwd`;echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "godumpnow" 'Create a dump folder with current Date Time Group (DTGS) and change to that folder' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "godumpdtg" 'Create a dump folder with current Date Time Group (DTG) and change to that folder' >> ${tempENVHELPFILEalias}

alias gochangelognow='DTGSNOW=`DTGSDATE`;mkdir -pv "${MYWORKFOLDERCHANGE}/${DTGSNOW}";list "${MYWORKFOLDERCHANGE}/";echo;cd "${MYWORKFOLDERCHANGE}/${DTGSNOW}";echo;echo Current path = `pwd`;echo'
alias gochangelogdtg='DTGNOW=`DTGDATE`;mkdir -pv "${MYWORKFOLDERCHANGE}/${DTGNOW}";list "${MYWORKFOLDERCHANGE}/";echo;cd "${MYWORKFOLDERCHANGE}/${DTGNOW}";echo;echo Current path = `pwd`;echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "gochangelognow" 'Create a Change Log folder with current Date Time Group (DTGS) and change to that folder' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "gochangelogdtg" 'Create a Change Log folder with current Date Time Group (DTG) and change to that folder' >> ${tempENVHELPFILEalias}

alias makedumpnow='DTGSNOW=`DTGSDATE`;mkdir -pv "${MYWORKFOLDERDUMP}/${DTGSNOW}";list "${MYWORKFOLDERDUMP}/";echo;echo "New dump folder = ${MYWORKFOLDERDUMP}/${DTGSNOW}";echo Current path = `pwd`;echo'
alias makedumpdtg='DTGNOW=`DTGDATE`;mkdir -pv "${MYWORKFOLDERDUMP}/${DTGNOW}";list "${MYWORKFOLDERDUMP}/";echo;echo "New dump folder = ${MYWORKFOLDERDUMP}/${DTGNOW}";echo Current path = `pwd`;echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "makedumpnow" 'Create a dump folder with current Date Time Group (DTGS) and show that folder' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "makedumpdtg" 'Create a dump folder with current Date Time Group (DTG) and show that folder' >> ${tempENVHELPFILEalias}

alias makechangelognow='DTGSNOW=`DTGSDATE`;mkdir -pv "${MYWORKFOLDERCHANGE}/${DTGSNOW}";list "${MYWORKFOLDERCHANGE}/";echo;echo Current path = `pwd`;echo'
alias makechangelogdtg='DTGNOW=`DTGDATE`;mkdir -pv "${MYWORKFOLDERCHANGE}/${DTGNOW}";list "${MYWORKFOLDERCHANGE}/";echo;echo Current path = `pwd`;echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "makechangelognow" 'Create a Change Log folder with current Date Time Group (DTGS) and show that folder' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "makechangelogdtg" 'Create a Change Log folder with current Date Time Group (DTG) and show that folder' >> ${tempENVHELPFILEalias}

#========================================================================================
# 2021-06-01

makeSRnow ()
{
    if [ x"$1" == x"" ] ; then
        echo 'Missing parameter 1 for the SR number!  Exiting!'
        exit /b
    else
        echo 'Create SR Folder with SR number '$1
        echo
    fi
    
    SRFOLDERROOT=${MYWORKFOLDERUGEX}'/SR_'$1
    
    if [ ! -r ${SRFOLDERROOT} ] ; then
        mkdir -pv ${SRFOLDERROOT} | tee -a -i ${logfilepath}
        chmod 775 ${SRFOLDERROOT} | tee -a -i ${logfilepath}
    else
        chmod 775 ${SRFOLDERROOT} | tee -a -i ${logfilepath}
    fi
    list "${MYWORKFOLDERUGEX}/"
    
    DTGSNOW=`DTGSDATE`
    
    SRFOLDERNOW=${SRFOLDERROOT}/${DTGSNOW}
    
    if [ ! -r ${SRFOLDERROOT} ] ; then
        mkdir -pv ${SRFOLDERROOT} | tee -a -i ${logfilepath}
        chmod 775 ${SRFOLDERROOT} | tee -a -i ${logfilepath}
    else
        chmod 775 ${SRFOLDERROOT} | tee -a -i ${logfilepath}
    fi
    
    list "${SRFOLDERROOT}/"
    echo
    echo Current path = `pwd`
    echo
}

goSRnow ()
{
    if [ x"$1" == x"" ] ; then
        echo 'Missing parameter 1 for the SR number!  Exiting!'
        exit /b
    else
        echo 'Create SR Folder with SR number '$1' and go there.'
        echo
    fi
    
    SRFOLDERROOT=${MYWORKFOLDERUGEX}'/SR_'$1
    
    if [ ! -r ${SRFOLDERROOT} ] ; then
        mkdir -pv ${SRFOLDERROOT} | tee -a -i ${logfilepath}
        chmod 775 ${SRFOLDERROOT} | tee -a -i ${logfilepath}
    else
        chmod 775 ${SRFOLDERROOT} | tee -a -i ${logfilepath}
    fi
    list "${MYWORKFOLDERUGEX}/"
    
    DTGSNOW=`DTGSDATE`
    
    SRFOLDERNOW=${SRFOLDERROOT}/${DTGSNOW}
    
    if [ ! -r ${SRFOLDERROOT} ] ; then
        mkdir -pv ${SRFOLDERROOT} | tee -a -i ${logfilepath}
        chmod 775 ${SRFOLDERROOT} | tee -a -i ${logfilepath}
    else
        chmod 775 ${SRFOLDERROOT} | tee -a -i ${logfilepath}
    fi
    
    list "${SRFOLDERROOT}/"
    echo
    cd "${SRFOLDERNOW}"
    echo
    echo Current path = `pwd`
    echo
}

printf "${tCYAN}%-35s${tNORM} : %s\n" "makeSRnow" 'Create a SR folder with supplied SR numbrer and current Date Time Group (DTGS) and show that folder' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "goSRnow" 'Create a SR folder with supplied SR numbrer and current Date Time Group (DTGS) and change to that folder' >> ${tempENVHELPFILEalias}

#========================================================================================
# 2021-08-30

alias show_logs_messages='echo; echo "list /var/log/messages*"; echo; list /var/log/messages* ; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_logs_messages" 'Show list of current messages log files' >> ${tempENVHELPFILEalias}

alias show_logs_elg='echo; echo "list $MDS_FWDIR/log/*.elg*"; echo; list $MDS_FWDIR/log/*.elg* ; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_logs_cpm_elg" 'Show list of current *.elg* log files' >> ${tempENVHELPFILEalias}

alias show_logs_cpm_elg='echo; echo "list $MDS_FWDIR/log/cpm.elg*"; echo; list $MDS_FWDIR/log/cpm.elg* ; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_logs_cpm_elg" 'Show list of current cpm.elg* log files' >> ${tempENVHELPFILEalias}

alias show_logs_api='echo; echo "list $MDS_FWDIR/log/api*.elg*"; echo; list $MDS_FWDIR/log/api*.elg* ; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_logs_api" 'Show list of current api log files' >> ${tempENVHELPFILEalias}

alias show_logs_gaia_api_server='echo; echo "list /var/log/gaia_api_server*"; echo; list /var/log/gaia_api_server* ; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_logs_gaia_api_server" 'Show list of current gaia_api_server log files' >> ${tempENVHELPFILEalias}

alias show_domain_logs_elg='echo; echo "list $FWDIR/log/*.elg*"; echo; list $FWDIR/log/*.elg* ; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_logs_cpm_elg" 'Show list of current *.elg* log files for current MDSM domain' >> ${tempENVHELPFILEalias}

alias show_domain_logs_cpm_elg='echo; echo "list $FWDIR/log/cpm.elg*"; echo; list $FWDIR/log/cpm.elg* ; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_domain_logs_cpm_elg" 'Show list of current cpm.elg* log files for current MDSM domain' >> ${tempENVHELPFILEalias}

#========================================================================================
# 2020-09-17

alias versionsdump='echo;echo;uname -a;echo;echo;clish -c "show version all";echo;echo;clish -c "show installer status";echo;echo;cpinfo -y all;echo;echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "versionsdump" 'Dump current version information for linux, clish, and cpinfo ' >> ${tempENVHELPFILEalias}

#alias configdump='echo;gougex;pwd;echo;echo;./config_capture;echo;echo;./healthdump;echo;echo'
alias configdump='echo;config_capture;echo;healthdump;echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "configdump" 'Execute configuration dump (config_capture) and health status check (healthdump)' >> ${tempENVHELPFILEalias}

#alias braindump='echo;gougex;pwd;echo;echo;./config_capture;echo;echo;./healthdump;echo;echo;./interface_info;echo;echo;./check_point_service_status_check;echo;echo'
alias braindump='echo;config_capture;echo;healthdump;echo;interface_info;echo;check_point_service_status_check;echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "braindump" 'Execute complete configuration and status dump (config_capture, healthdump, interface_info, check_point_service_status_check) ' >> ${tempENVHELPFILEalias}

alias checkFTW='echo; echo "Check if FTW completed!  TRUE if .wizard_accepted found"; echo; ls -alh /etc/.wizard_accepted; echo; tail -n 10 /var/log/ftw_install.log; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "checkFTW" 'Display status of First Time Wizard (FTW) completion or operation' >> ${tempENVHELPFILEalias}

alias show_core_dumps='echo; echo "Core dumps:"; echo; ls -alh --color=auto /var/log/dump/usermode/; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_core_dumps" 'Display current Core Dumps in /var/log/dump/usermode/' >> ${tempENVHELPFILEalias}

# 2022-02-22
alias collect_core_dumps_now='WORKNOWFOLDER="${MYWORKFOLDERDUMP}/`date +%Y`/`DTGSDATE`";mkdir -pv "${WORKNOWFOLDER}";list "${MYWORKFOLDERDUMP}/";echo;cd "${WORKNOWFOLDER}";echo;echo Current path = `pwd`;echo;echo "Core dumps:";echo;ls -alh --color=auto /var/log/dump/usermode/;echo;echo "Copy core dump *.gz files to this folder";echo;cp /var/log/dump/usermode/*.gz .;echo;ls -alh --color=auto .;echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "collect_core_dumps_now" 'Collect current Core Dumps from /var/log/dump/usermode/ to Dump folder now with DTGSDATE' >> ${tempENVHELPFILEalias}

#========================================================================================
# 2020-09-17, 2020-11-11, 2022-02-22

if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/watch_accel_stats ] ; then
    # GW related aliases
    
    alias dumpzdebugnow='filesuffix=`HOSTCPVERSIONNOW`; targefolder="${MYWORKFOLDERDUMP}/`date +%Y`/`DTGSDATE`" ; mkdir -pv "${targefolder}";list "${targefolder}/";echo;cd "${targefolder}";echo;echo Current path = `pwd`;echo;fw ctl zdebug drop | tee -a zdebug_drop.${filesuffix}.txt'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "dumpzdebugnow" 'Gateway : generate zdebug drop dump to new dump folder with current Date Time Group (DTGS)' >> ${tempENVHELPFILEalias}
fi


#========================================================================================
# 2020-09-17

export MYWORKFOLDERCCC=${MYWORKFOLDER}/_scripts/ccc
printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYWORKFOLDERCCC" ${MYWORKFOLDERCCC} >> ${tempENVHELPFILEvars}

alias installccc="mkdir ${MYWORKFOLDERCCC}; curl_cli -k https://dannyjung.de/ccc | zcat > ${MYWORKFOLDERCCC}/ccc && chmod +x ${MYWORKFOLDERCCC}/ccc; alias ccc='${MYWORKFOLDERCCC}/ccc'"
printf "${tCYAN}%-35s${tNORM} : %s\n" "installccc" 'Install ccc utility by Danny Jung and put in folder '"${MYWORKFOLDERCCC}" >> ${tempENVHELPFILEalias}

if [ -r ${MYWORKFOLDERCCC}/ccc ] ; then
    # ccc related aliases
    
    alias ccc='${MYWORKFOLDERCCC}/ccc'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "ccc" 'Execute ccc utility by Danny Jung from folder '"${MYWORKFOLDERCCC}" >> ${tempENVHELPFILEalias}
    
fi

#========================================================================================
#========================================================================================
# 2020-11-26 Updated

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

# MYTFTPSERVERx and MYTFTPFOLDER values are now set in private_config.add.sh file
#

if [ -n ${MYTFTPSERVER} ] ; then
    # MYTFTPSERVERx values are set
    
    printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYTFTPSERVER1" ${MYTFTPSERVER1} >> ${tempENVHELPFILEvars}
    printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYTFTPSERVER2" ${MYTFTPSERVER2} >> ${tempENVHELPFILEvars}
    printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYTFTPSERVER3" ${MYTFTPSERVER3x} >> ${tempENVHELPFILEvars}
    printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYTFTPSERVER" ${MYTFTPSERVERx} >> ${tempENVHELPFILEvars}
    printf "variable :  ${tCYAN}%-25s${tNORM} = %s\n" "MYTFTPFOLDER" ${MYTFTPFOLDER} >> ${tempENVHELPFILEvars}
    echo >> ${tempENVHELPFILEvars}
    
    alias show_mytftpservers='echo -e "MYTFTPSERVERs: \n MYTFTPSERVER  = ${MYTFTPSERVER} \n MYTFTPSERVER1 = ${MYTFTPSERVER1} \n MYTFTPSERVER2 = ${MYTFTPSERVER2} \n MYTFTPSERVER3 = ${MYTFTPSERVER3}" ;echo'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "show_mytftpservers" 'Show current settings for the TFTP servers defined by MYTFTPSERVERx ' >> ${tempENVHELPFILEalias}
    
    alias getupdatescripts='gougex;pwd;tftp -v -m binary ${MYTFTPSERVER} -c get ${MYTFTPFOLDER}/updatescripts.sh;echo;chmod 775 updatescripts.sh;echo;ls -alh updatescripts.sh'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "getupdatescripts" 'Get the current update script from the primary TFTP server' >> ${tempENVHELPFILEalias}
    
    alias updatelatestscripts='getupdatescripts ; . ./updatescripts.sh ; . ./alias_commands_update_all_users'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "updatelatestscripts" 'Update to the latest scripts on the TFTP server' >> ${tempENVHELPFILEalias}
    
    alias getsetuphostscript='cd /var/log;pwd;tftp -v -m binary ${MYTFTPSERVER} -c get ${MYTFTPFOLDER}/setuphost.sh;echo;chmod 775 setuphost.sh;echo;ls -alh setuphost.sh'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "getsetuphostscript" 'Get the current host setup script from the primary TFTP server' >> ${tempENVHELPFILEalias}
    
    alias gettoolsupdatescript='gougex;pwd;tftp -v -m binary ${MYTFTPSERVER} -c get ${MYTFTPFOLDER}/update_tools.sh;echo;chmod 775 update_tools.sh;echo;ls -alh update_tools.sh'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "gettoolsupdatescript" 'Get the current tools setup script from the primary TFTP server' >> ${tempENVHELPFILEalias}
    
else
    # MYTFTPSERVERx values are not set
    
    echo
    echo 'Values for MYTFTPSERVERx not set, so not establishing the configuration and alias'
    echo
    
fi


#========================================================================================
#========================================================================================
# 2020-12-01 Updated

alias generate_script_links='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/generate_script_links.v05.28.01.sh'
alias remove_script_links='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/remove_script_links.v05.28.01.sh'
alias reset_script_links='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/remove_script_links.v05.28.01.sh;echo;${MYWORKFOLDERUGEXSCRIPTS}/generate_script_links.v05.28.01.sh;echo;list'
alias rebuild_customer_scripts='cd ${MYWORKFOLDERUGEX};remove_script_links;echo;rm -f -r -d -v ${MYWORKFOLDERSCRIPTSB4CP};echo;generate_script_links;echo;list'
printf "${tCYAN}%-35s${tNORM} : %s\n" "generate_script_links" 'Generate links and references to current scripts' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "remove_script_links" 'Remove links and references to current scripts' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "reset_script_links" 'Remove and Regenerate links and references to current scripts' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "rebuild_customer_scripts" 'Rebuild the _scripts folder at the root of the customer folder' >> ${tempENVHELPFILEalias}

alias gaia_version_type='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERSCRIPTSB4CP}/gaia_version_type'
printf "${tCYAN}%-35s${tNORM} : %s\n" "gaia_version_type" 'Display and document current Gaia version and installation type' >> ${tempENVHELPFILEalias}

alias do_script_nohup='${MYWORKFOLDERSCRIPTSB4CP}/do_script_nohup'
printf "${tCYAN}%-35s${tNORM} : %s\n" "do_script_nohup" 'Execute script in passed parameters via nohup' >> ${tempENVHELPFILEalias}

alias make_local_snapshot_and_backup='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/Common/make_local_snapshot_and_backup.v05.28.01.sh'
printf "${tCYAN}%-35s${tNORM} : %s\n" "make_local_snapshot_and_backup" 'Make local Gaia Snapshot and Backup' >> ${tempENVHELPFILEalias}
alias make_snapshot_and_backup_to_ftp='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/Common/make_snapshot_and_backup_to_ftp_target.v05.28.01.sh'
printf "${tCYAN}%-35s${tNORM} : %s\n" "make_snapshot_and_backup_to_ftp" 'Make Gaia Snapshot and Backup and export to FTP target' >> ${tempENVHELPFILEalias}

watch_snapshots () 
{
    echo 'Monitor Gaia Snapshots...' ; echo
#    ccommand="clish -c 'show snapshots'"
    ccommand="echo 'Snapshots:' ; clish -c 'show snapshots'; echo; echo; echo 'Backup Status:' ; clish -c 'show backup status'"
    watch -d -n 1 "${ccommand}"
}

alias show_snapshots='clish -c "show snapshots"'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_snapshots" 'Show current list of Gaia Snapshots' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "watch_snapshots" 'Watch current list of Gaia Snapshots' >> ${tempENVHELPFILEalias}

alias show_backup_status='clish -c "show backup status"'
printf "${tCYAN}%-35s${tNORM} : %s\n" "show_backup_status" 'Show current status of Gaia backups' >> ${tempENVHELPFILEalias}

alias config_capture='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERSCRIPTSB4CP}/config_capture'
alias interface_info='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERSCRIPTSB4CP}/interface_info'
printf "${tCYAN}%-35s${tNORM} : %s\n" "config_capture" 'Execute capture and documentation of key configuration elements' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "interface_info" 'Execute capture and documentation of interface information' >> ${tempENVHELPFILEalias}

if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/EPM_config_check ] ; then
    alias EPM_config_check='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERSCRIPTSB4CP}/EPM_config_check'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "EPM_config_check" 'Execute Configuration Capture for Endpoint Management Server' >> ${tempENVHELPFILEalias}
fi

if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/update_gaia_rest_api ] ; then
    alias update_gaia_rest_api='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERSCRIPTSB4CP}/update_gaia_rest_api'
    alias update_gaia_dynamic_cli='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERSCRIPTSB4CP}/update_gaia_dynamic_cli'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "update_gaia_rest_api" 'Execute update script for Gaia REST API' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "update_gaia_dynamic_cli" 'Execute update script for Gaia (clish) Dynamic CLI' >> ${tempENVHELPFILEalias}
fi

if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/watch_accel_stats ] ; then
    # GW scripts set
    alias enable_rad_admin_stats_and_cpview='${MYWORKFOLDERSCRIPTSB4CP}/enable_rad_admin_stats_and_cpview'
    alias vpn_client_operational_info='${MYWORKFOLDERSCRIPTSB4CP}/vpn_client_operational_info'
    alias show_USFW_status='echo;echo "Check state of User Mode FireWall (USFW)";echo -en "cpprod_util FwIsUsermode [1=true] : ";cpprod_util FwIsUsermode;echo -en "cpprod_util FwIsUsfwMachine [1=true] : ";cpprod_util FwIsUsfwMachine;echo'
    alias watch_accel_stats='${MYWORKFOLDERSCRIPTSB4CP}/watch_accel_stats'
    alias fix_gw_missing_updatable_objects='${MYWORKFOLDERSCRIPTSB4CP}/fix_gw_missing_updatable_objects'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "enable_rad_admin_stats_and_cpview" 'Launch cpview with rad_admin stats enabled' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "vpn_client_operational_info" 'Display status of VPN Clients connected to the gateway' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "show_USFW_status" 'Display status of User State FireWall enabling' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "watch_accel_stats" 'Display (watch) status of firewall SecureXL Accelleration' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "fix_gw_missing_updatable_objects" 'Fix issues with missing updatable objects on gateway' >> ${tempENVHELPFILEalias}
    if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/watch_cluster_status ] ; then
        alias watch_cluster_status='${MYWORKFOLDERSCRIPTSB4CP}/watch_cluster_status'
        alias show_cluster_info='${MYWORKFOLDERSCRIPTSB4CP}/show_cluster_info'
        printf "${tCYAN}%-35s${tNORM} : %s\n" "watch_cluster_status" 'Display (watch) current ClusterXL information' >> ${tempENVHELPFILEalias}
        printf "${tCYAN}%-35s${tNORM} : %s\n" "show_cluster_info" 'Display and document current ClusterXL information' >> ${tempENVHELPFILEalias}
    fi
fi

alias healthcheck='${MYWORKFOLDERSCRIPTSB4CP}/healthcheck'
alias healthdump='${MYWORKFOLDERSCRIPTSB4CP}/healthdump'
alias check_point_service_status_check='${MYWORKFOLDERSCRIPTSB4CP}/check_point_service_status_check'
printf "${tCYAN}%-35s${tNORM} : %s\n" "healthcheck" 'Execute Check Point Healthcheck script' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "healthdump" 'Execute Check Point Healthcheck script and place results in healtchecks folder' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "check_point_service_status_check" 'Check and document status of access to Check Point Internet resource locations' >> ${tempENVHELPFILEalias}

alias runHCP='${MYWORKFOLDERSCRIPTSB4CP}/run_hcp_and_copy_files'
printf "${tCYAN}%-35s${tNORM} : %s\n" "runHCP" 'Execute Check Point HCP script for health check, report and place results in healtchecks folder' >> ${tempENVHELPFILEalias}
#alias installHCP='${MYWORKFOLDERSCRIPTSB4CP}/install_hcp_offline'
#printf "${tCYAN}%-35s${tNORM} : %s\n" "installHCP" 'Install or Update Check Point HCP script' >> ${tempENVHELPFILEalias}

if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/report_mdsstat ] ; then
    alias report_mdsstat='${MYWORKFOLDERSCRIPTSB4CP}/report_mdsstat'
    alias watch_mdsstat='${MYWORKFOLDERSCRIPTSB4CP}/watch_mdsstat'
    alias show_all_domains_in_array='${MYWORKFOLDERSCRIPTSB4CP}/show_all_domains_in_array'
    alias show_sessions_all_domains='${MYWORKFOLDERSCRIPTSB4CP}/show_sessions_all_domains'
    alias mdsm_mds_reassign_global_assignments='${MYWORKFOLDERSCRIPTSB4CP}/mdsm_mds_reassign_global_assignments'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "report_mdsstat" 'Display and document status of MDSM server and domains' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "watch_mdsstat" 'Display (watch) status of MDSM server and domains' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "show_all_domains_in_array" 'Display list of currently defined MDSM Domains on this MDS' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "show_sessions_all_domains" 'Display sessions for all currently defined MDSM Domains on this MDS' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "mdsm_mds_reassign_global_assignments" 'MDSM MDS - Re-assign global-assignments on MDS' >> ${tempENVHELPFILEalias}
fi

alias check_status_of_scheduled_ips_updates_on_management='${MYWORKFOLDERSCRIPTSB4CP}/check_status_of_scheduled_ips_updates_on_management'
alias identify_self_referencing_symbolic_link_files='${MYWORKFOLDERSCRIPTSB4CP}/identify_self_referencing_symbolic_link_files'
#alias Lite_identify_self_referencing_symbolic_link_files='${MYWORKFOLDERSCRIPTSB4CP}/Lite.identify_self_referencing_symbolic_link_files'
printf "${tCYAN}%s${tNORM}\n" "check_status_of_scheduled_ips_updates_on_management" >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} :: %s\n" " " 'Check and document the status of IPS updates process' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%s${tNORM}\n" "identify_self_referencing_symbolic_link_files" >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} :: %s\n" " " 'Identify and if set, remove self referencing symbolic link files in target folder' >> ${tempENVHELPFILEalias}
#printf "${tCYAN}%s${tNORM}\n" "Lite_identify_self_referencing_symbolic_link_files" >> ${tempENVHELPFILEalias}
#printf "${tCYAN}%-35s${tNORM} :: %s\n" " " 'Identify and if set, remove self referencing symbolic link files in target folder' >> ${tempENVHELPFILEalias}

if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/remove_zerolocks_sessions ] ; then
    alias show_zerolocks_sessions='${MYWORKFOLDERSCRIPTSB4CP}/show_zerolocks_sessions'
    alias remove_zerolocks_sessions='${MYWORKFOLDERSCRIPTSB4CP}/remove_zerolocks_sessions'
    alias show_zerolocks_web_api_sessions='${MYWORKFOLDERSCRIPTSB4CP}/show_zerolocks_web_api_sessions'
    alias remove_zerolocks_web_api_sessions='${MYWORKFOLDERSCRIPTSB4CP}/remove_zerolocks_web_api_sessions'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "remove_zerolocks_sessions" 'Remove management sessions with Zero locks' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "show_zerolocks_sessions" 'Show management sessions with Zero locks' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "remove_zerolocks_web_api_sessions" 'Remove management sessions with Zero locks for the web_api user' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "show_zerolocks_web_api_sessions" 'Show management sessions with Zero locks for the web_api user' >> ${tempENVHELPFILEalias}
fi

if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/remove_zerolocks_sessions ] ; then
    # Means we have api potential
    alias apiversions='apiwebport=`clish -c "show web ssl-port" | cut -d " " -f 2`;echo "API web port = $apiwebport";echo;echo "API Versions:";mgmt_cli -r true --port $apiwebport show-api-versions -f json'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "apiversions" 'Display current management API version' >> ${tempENVHELPFILEalias}
fi

alias show_gaia_api_version='export get_gaia_api_version=`gaia_api status | grep "Version" | cut -c 17-` ; export gaia_api_version=${get_gaia_api_version}; echo "Gaia API Version : ${gaia_api_version}"'

printf "${tCYAN}%-35s${tNORM} : %s\n" "show_gaia_api_version" 'Show version of Gaia API installed.  Blank indicates not installed' >> ${tempENVHELPFILEalias}

if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/SmartEvent_backup ] ; then
    alias SmartEvent_backup='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/SmartEvent_backup'
    #alias SmartEvent_restore='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/SmartEvent_restore'
    alias Reset_SmartLog_Indexing='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/Reset_SmartLog_Indexing'
    #alias SmartEvent_NUKE_Index_and_Logs='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/SmartEvent_NUKE_Index_and_Logs'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "SmartEvent_backup" 'Backup SmartEvent Indexing and Log files' >> ${tempENVHELPFILEalias}
    #printf "${tCYAN}%-35s${tNORM} : %s\n" "SmartEvent_restore" 'Backup SmartEvent Indexing and Log files' >> ${tempENVHELPFILEalias}
    printf "${tCYAN}%-35s${tNORM} : %s\n" "Reset_SmartLog_Indexing" 'Reset SmartLog Indexing back the number of days provided in parameter' >> ${tempENVHELPFILEalias}
    #printf "${tCYAN}%s${tNORM}\n" "SmartEvent_NUKE_Index_and_Logs" >> ${tempENVHELPFILEalias}
    #printf "${tCYAN}%-35s${tNORM} :: %s\n" " " 'Annihilate SmartEvent Indexes and Logs' >> ${tempENVHELPFILEalias}
fi

if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/LogExporter_Backup_R8X ] ; then
    alias LogExporter_Backup_R8X='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERSCRIPTSB4CP}/LogExporter_Backup_R8X'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "LogExporter_Backup_R8X" 'Backup Log Exporter configuration for R8X based systems (SMS, MDSM)' >> ${tempENVHELPFILEalias}
fi

alias report_cpwd_admin_list='${MYWORKFOLDERSCRIPTSB4CP}/report_cpwd_admin_list'
alias report_admin_status='${MYWORKFOLDERSCRIPTSB4CP}/report_cpwd_admin_list'
alias watch_cpwd_admin_list='${MYWORKFOLDERSCRIPTSB4CP}/watch_cpwd_admin_list'
alias admin_status='${MYWORKFOLDERSCRIPTSB4CP}/watch_cpwd_admin_list'
printf "${tCYAN}%-35s${tNORM} : %s\n" "report_cpwd_admin_list" 'Report management services status' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "report_admin_status" 'Report management services status' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "watch_cpwd_admin_list" 'Display watch of management services status' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "admin_status" 'Display watch of management services status' >> ${tempENVHELPFILEalias}
if [ -r ${MYWORKFOLDERSCRIPTSB4CP}/restart_mgmt ] ; then
    alias restart_mgmt='${MYWORKFOLDERSCRIPTSB4CP}/restart_mgmt'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "restart_mgmt" 'Execute and document a restart of management services' >> ${tempENVHELPFILEalias}
    alias fix_mgmt_missing_updatable_objects='${MYWORKFOLDERSCRIPTSB4CP}/fix_mgmt_missing_updatable_objects'
    printf "${tCYAN}%-35s${tNORM} : %s\n" "fix_mgmt_missing_updatable_objects" 'Fix issues with missing updatable objects on management' >> ${tempENVHELPFILEalias}
fi


#========================================================================================
#========================================================================================
# 2021-08-30
#

alias alias_commands_add_user='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/UserConfig/alias_commands_add_user.v05.28.01.sh'
alias alias_commands_add_all_users='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/UserConfig/alias_commands_add_all_users.v05.28.01.sh'
printf "${tCYAN}%-35s${tNORM} : %s\n" "alias_commands_add_user" 'Add alias commands to current user' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "alias_commands_add_all_users" 'Add alias commands to all user' >> ${tempENVHELPFILEalias}

alias alias_commands_update_user='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/UserConfig/alias_commands_update_user.v05.28.01.sh'
alias alias_commands_update_all_users='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/UserConfig/alias_commands_update_all_users.v05.28.01.sh'
printf "${tCYAN}%-35s${tNORM} : %s\n" "alias_commands_update_user" 'Update alias commands to current user' >> ${tempENVHELPFILEalias}
printf "${tCYAN}%-35s${tNORM} : %s\n" "alias_commands_update_all_users" 'Update alias commands to current user' >> ${tempENVHELPFILEalias}

alias reset_users_home_profile_files='cd ${HOME}; echo; list; cp -fv /etc/skel/.bash_logout ~/.bash_logout; cp -fv /etc/skel/.bash_profile ~/.bash_profile; cp -fv /etc/skel/.bashrc ~/.bashrc; echo; list; cd ${MYWORKFOLDERUGEX}; echo'
printf "${tCYAN}%-35s${tNORM} : %s\n" "reset_users_home_profile_files" 'Reset current users home profile files in /home folder' >> ${tempENVHELPFILEalias}
alias reset_all_users_home_profile_files='cd ${MYWORKFOLDERUGEX};${MYWORKFOLDERUGEXSCRIPTS}/UserConfig/reset_all_users_home_profile_files.v05.28.01.sh'
printf "${tCYAN}%-35s${tNORM} : %s\n" "reset_all_users_home_profile_files" 'Reset all users home profile files in /home folders' >> ${tempENVHELPFILEalias}


#========================================================================================
#========================================================================================
# 2020-09-30, 2020-11-11
#

# Add function to save the help output from a command to a file in the Upgrade Export Reference Folder
#

printf "${tCYAN}%-35s${tNORM} : %s\n" 'help2reference <command>' 'Document help for <command> to Reference folder' >> ${tempENVHELPFILEalias}

help2reference () 
{ 
    referencefile="${MYWORKFOLDERREFERENCE}/help.$1.`HOSTCPVERSIONNOW`.txt"
    echo > ${referencefile}
    echo 'referencefile = '${referencefile} | tee -a -i ${referencefile}
    echo 'Command = '"$@" --help | tee -a -i ${referencefile}
    echo | tee -a -i ${referencefile}
    "$@" --help >> ${referencefile} 2>> ${referencefile}
    echo | tee -a -i ${referencefile}
    list ${referencefile}
    echo
}


#========================================================================================
#========================================================================================
# 2020-09-30, 2020-11-11, 2020-11-18, 2022-02-22
#

# Add function to save the help output from a command to a file in the Upgrade Export Reference Folder
#

printf "${tCYAN}%-35s${tNORM} : %s\n" "docset2reference" 'Document set output to Reference folder' >> ${tempENVHELPFILEalias}

docset2reference () 
{ 
    referencefile="${MYWORKFOLDERREFERENCE}/help.set.`HOSTCPVERSIONNOW`.txt"
    echo 'Document set output to Reference folder file:  '${referencefile}
    echo
    set > ${referencefile}
    echo
    list ${referencefile}
    echo
}


# 2020-11-18
# Add function to save the help output from a command to a file in a NOW Upgrade Export dump Folder
#

printf "${tCYAN}%-35s${tNORM} : %s\n" "docset2dumpnow" 'Document set output to dump folder with DTG NOW' >> ${tempENVHELPFILEalias}

docset2dumpnow () 
{ 
    dumpnowfolder=${MYWORKFOLDERDUMP}/`date +%Y`/`date +%Y-%m`/`DTGSDATE`'_set'
    mkdir -pv "${dumpnowfolder}"
    referencefile="${dumpnowfolder}/current.set.`HOSTCPVERSIONNOW`.txt"
    echo 'Document set output to dump folder with DTG NOW :  '${referencefile}
    echo
    set > ${referencefile}
    echo
    list "${dumpnowfolder}/"
    echo
}


#========================================================================================
# 2021-08-26, 2022-02-22
# Add functions to save the  output from history to a file in a NOW linux dev dump Folder
#

printf "${tCYAN}%-35s${tNORM} : %s\n" "historydumpnow" 'Document current history output to dump folder for today with DTG NOW' >> ${tempENVHELPFILEalias}

historydumpnow () 
{ 
    dumpnowfolder=${MYWORKFOLDERDUMP}/`date +%Y`/`date +%Y-%m`/`DTGSDATE`'_history_dump'
    mkdir -pv "${dumpnowfolder}"
    historyfile="${dumpnowfolder}/current.history.`userhostnow`.txt"
    echo 'Document current history output to dump folder for today with DTG NOW :  '${referencefile}
    echo
    history > ${historyfile}
    echo
    list "${dumpnowfolder}/"
    echo
    echo 'History dump file FQPN:'
    echo ${historyfile}
    echo
}


# Add functions to save the  output from history to a file in a NOW linux dev dump Folder and clear history
#

printf "${tCYAN}%-35s${tNORM} : %s\n" "historyclearnow" 'Document current history output to dump folder for today with DTG NOW and clear history' >> ${tempENVHELPFILEalias}

historyclearnow () 
{ 
    dumpnowfolder=${MYWORKFOLDERDUMP}/`date +%Y`/`date +%Y-%m`/`DTGSDATE`'_history_clear'
    mkdir -pv "${dumpnowfolder}"
    historyfile="${dumpnowfolder}/current.history.`userhostnow`.txt"
    echo 'Document current history output to dump folder for today with DTG NOW and clear history :  '${referencefile}
    echo
    history > ${historyfile}
    echo
    list "${dumpnowfolder}/"
    echo
    history -c
    echo
    echo 'History dump file FQPN:'
    echo ${historyfile}
    echo
}


#========================================================================================
#========================================================================================
# 2021-01-21
#

# Add function to show status of CPUSE and upgrade tools
#

printf "${tCYAN}%-35s${tNORM} : %s\n" "CPUSE_status [release]" 'Show status of CPUSE and upgrade tools' >> ${tempENVHELPFILEalias}

CPUSE_status () 
{ 
    echo
    echo 'Show status of CPUSE and upgrade tools'
    echo
    
    echo 'Document clish Installer status and packages: '
    clish -i -c "show installer status all"
    echo
    clish -i -c "show installer packages all"
    echo
    
    # properly handle current product version
    echo 'Try to get Upgrade Tools version: '
    cpprod_util CPPROD_GetValue CPupgrade-tools-`CPRELEASEVERSION` BuildNumber 1
    echo
    
    # properly handle requested product version in 
    if [ x"$1" != x"" ] ; then
        echo 'Try to get Upgrade Tools version for '$1': '
        cpprod_util CPPROD_GetValue CPupgrade-tools-$1 BuildNumber 1
    fi
    echo
    
    echo 'Last 10 of /opt/CPInstLog/DA_Actions.xml : '
    tail -n 10 /opt/CPInstLog/DA_Actions.xml
    
    echo 'Last 5 of /opt/CPInstLog/DA_Actions_Messages.json : '
    tail -n 5 /opt/CPInstLog/DA_Actions_Messages.json
}


# Add function to show status of CPUSE and upgrade tools
#

printf "${tCYAN}%-35s${tNORM} : %s\n" "da_cli_status" 'Show status of da_cli' >> ${tempENVHELPFILEalias}

da_cli_status () 
{ 
    echo
    echo 'Document da_cli installer status and packages: '
    da_cli da_status
    echo
    da_cli get_version
    echo
    da_cli edit_configuration operation=show_config
    echo
    da_cli upgrade_tools_update_status
    echo
    da_cli packages_info status=all
    echo
}


# Add function to show status of CPUSE and upgrade tools
#

printf "${tCYAN}%-35s${tNORM} : %s\n" "upgrade_tools_status [release]" 'Show status of upgrade tools' >> ${tempENVHELPFILEalias}

upgrade_tools_status () 
{ 
    echo
    
    # properly handle current product version
    echo 'Try to get Upgrade Tools version: '
    cpprod_util CPPROD_GetValue CPupgrade-tools-`CPRELEASEVERSION` BuildNumber 1
    echo
    
    # properly handle requested product version in 
    if [ x"$1" != x"" ] ; then
        echo 'Try to get Upgrade Tools version for '$1': '
        cpprod_util CPPROD_GetValue CPupgrade-tools-$1 BuildNumber 1
    fi
    echo
    
    echo 'Last 10 of /opt/CPInstLog/DA_Actions.xml : '
    tail -n 10 /opt/CPInstLog/DA_Actions.xml
    
    echo 'Last 5 of /opt/CPInstLog/DA_Actions_Messages.json : '
    tail -n 5 /opt/CPInstLog/DA_Actions_Messages.json
}


#========================================================================================
#========================================================================================
# Build environment help file
#========================================================================================

cat ${tempENVHELPFILEvars} >> ${ENVIRONMENTHELPFILE}
cat ${tempENVHELPFILEvars} >> ${ENVIRONMENTVARSFILE}
rm -f ${tempENVHELPFILEvars}
tempENVHELPFILEvars=

cat ${tempENVHELPFILEalias} >> ${ENVIRONMENTHELPFILE}
rm -f ${tempENVHELPFILEalias}
tempENVHELPFILEalias=

echo >> ${ENVIRONMENTHELPFILE}
echo '===============================================================================' >> ${ENVIRONMENTHELPFILE}
echo 'MyBasementCloud bash 4 Check Point Environment' >> ${ENVIRONMENTHELPFILE}
echo 'Scripts :  Version '${ScriptVersion}', Revision '${ScriptRevision}', Level '${AliasCommandsLevel}' from Date '${ScriptDate} >> ${ENVIRONMENTHELPFILE}
echo '===============================================================================' >> ${ENVIRONMENTHELPFILE}
echo '===============================================================================' >> ${ENVIRONMENTHELPFILE}
echo >> ${ENVIRONMENTHELPFILE}

echo >> ${ENVIRONMENTVARSFILE}
echo '===============================================================================' >> ${ENVIRONMENTVARSFILE}
echo 'MyBasementCloud bash 4 Check Point Environment' >> ${ENVIRONMENTVARSFILE}
echo 'Scripts :  Version '${ScriptVersion}', Revision '${ScriptRevision}', Level '${AliasCommandsLevel}' from Date '${ScriptDate} >> ${ENVIRONMENTVARSFILE}
echo '===============================================================================' >> ${ENVIRONMENTVARSFILE}
echo '===============================================================================' >> ${ENVIRONMENTVARSFILE}
echo >> ${ENVIRONMENTVARSFILE}

list ${ENVIRONMENTHELPFILE}
list ${ENVIRONMENTVARSFILE}

echo
echo 'Configuration of User Environment completed!'
echo 'Display help regarding configured variables and aliases with command :  show_environment_help'
echo

timecheck
echo
gougex

echo
echo ${tRED}'==============================================================================='${tDEFAULT}
echo

#========================================================================================
#========================================================================================
# End of alias.commands.<action>.<scope>.sh
#========================================================================================
#========================================================================================


