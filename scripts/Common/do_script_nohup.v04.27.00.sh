#!/bin/bash
#
# SCRIPT Execute named script in CLI parameter with NOHUP and rest of CLI parameters
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
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
ScriptDate=2020-06-05
ScriptVersion=04.27.00
ScriptRevision=000
TemplateVersion=04.27.00
TemplateLevel=006
SubScriptsLevel=NA
SubScriptsVersion=NA
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}
export BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

export BASHSubScriptsVersion=v${SubScriptsVersion//./x}
export BASHSubScriptTemplateVersion=v${TemplateVersion//./x}
export BASHExpectedSubScriptsVersion=$SubScriptsLevel.v${SubScriptsVersion//./x}

export BASHScriptFileNameRoot=do_script_nohup
export BASHScriptShortName="do_script_nohup"
export BASHScriptnohupName=$BASHScriptShortName
export BASHScriptDescription=="Execute named script in CLI parameter with NOHUP and rest of CLI parameters"

#export BASHScriptName=$BASHScriptFileNameRoot.$TemplateLevel.v$ScriptVersion
export BASHScriptName=$BASHScriptFileNameRoot.v$ScriptVersion

export BASHScriptHelpFileName="$BASHScriptFileNameRoot.help"
export BASHScriptHelpFilePath="help.v$ScriptVersion"
export BASHScriptHelpFile="$BASHScriptHelpFilePath/$BASHScriptHelpFileName"

# _sub-scripts|_template|Common|Config|GAIA|GW|[GW.CORE]|Health_Check|MDM|MGMT|Patch_Hotfix|Session_Cleanup|SmartEvent|SMS|[SMS.CORE]|SMS.migrate_backup|UserConfig|[UserConfig.CORE_G2.NPM]
export BASHScriptsFolder=Common

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

echo 'Date Time Group   :  '$DATE $DATEDTG $DATEDTGS
echo 'Date (YYYY-MM-DD) :  '$DATEYMD
echo
    

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
export JQ16PATH=$MYWORKFOLDER/_tools/JQ
export JQ16FILE=jq-linux64
export JQ16FQFN=$JQ16PATH/$JQ16FILE
if [ -r $JQ16FQFN ] ; then
    # OK we have the easy-button alternative
    export JQ16=$JQ16FQFN
elif [ -r "./_tools/JQ/$JQ16FILE" ] ; then
    # OK we have the local folder alternative
    export JQ16=./_tools/JQ/$JQ16FILE
elif [ -r "../_tools/JQ/$JQ16FILE" ] ; then
    # OK we have the parent folder alternative
    export JQ16=../_tools/JQ/$JQ16FILE
else
    export JQ16=
fi

#
# /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ MODIFIED 2020-01-03


# -------------------------------------------------------------------------------------------------
# END:  Basic Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Other variable configuration
# -------------------------------------------------------------------------------------------------


WAITTIME=20


# -------------------------------------------------------------------------------------------------
# CheckAndUnlockGaiaDB - Check and Unlock Gaia database
# -------------------------------------------------------------------------------------------------

# MODIFIED 2019-01-31 -\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#

CheckAndUnlockGaiaDB () {
    #
    # CheckAndUnlockGaiaDB - Check and Unlock Gaia database
    #
    
    echo -n 'Unlock gaia database : '

    export gaiadbunlocked=false

    until $gaiadbunlocked ; do

        export checkgaiadblocked=`clish -i -c "lock database override" | grep -i "owned"`
        export isclishowned=`test -z $checkgaiadblocked; echo $?`

        if [ $isclishowned -eq 1 ]; then 
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
# \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/-  MODIFIED 2019-01-31

#CheckAndUnlockGaiaDB

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# Start of Script Operations
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# local scripts variables configuration
# -------------------------------------------------------------------------------------------------


targetfolder=/var/log/__customer/upgrade_export


# -------------------------------------------------------------------------------------------------
# logfile configuration
# -------------------------------------------------------------------------------------------------


# setup initial log file for output logging
export logfilefolder=$targetfolder/dump/$DATEDTGS.$BASHScriptShortName
export logfilepath=$logfilefolder/$BASHScriptName.$DATEDTGS.log

if [ ! -w $logfilefolder ]; then
    #mkdir -pv $logfilefolder
    mkdir -p $logfilefolder
fi

touch $logfilepath


# -------------------------------------------------------------------------------------------------
# Script intro
# -------------------------------------------------------------------------------------------------


echo | tee -a -i $logfilepath
echo $BASHScriptDescription', script version '$ScriptVersion', revision '$ScriptRevision' from '$ScriptDate | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

echo 'Date Time Group   :  '$DATEDTGS | tee -a -i $logfilepath
echo | tee -a -i $logfilepath


# -------------------------------------------------------------------------------------------------
# script plumbing 1
# -------------------------------------------------------------------------------------------------

doshowhelp=false

if [ x"$1" = x"--help" ] || [ x"$1" = x"-?" ] ; then
    # first parameter is for help
    
    doshowhelp=true
    
    echo 'Generating Help for '$0 | tee -a -i $logfilepath
    
elif [ x"$1" = x"--diskspace" ]  && [ -x "$2" ] ; then
    # first parameter is for diskspace statistics collection and second parm actually works
    
    doshowhelp=false
    
    echo 'Diskspace statistics collection requested for script : "'$2'" which exists and is executable!' | tee -a -i $logfilepath
    
elif [ x"$1" = x"--diskspace" ]  && [ ! -x "$2" ] ; then
    # first parameter is for disk space monitoring and second parm doesn't work
    
    doshowhelp=true
    
    echo 'Diskspace statistics collection requested for script : "'$2'" either does not exist or is not executable!' | tee -a -i $logfilepath
    
elif [ ! -x "$1" ] ; then
    # missing the critical first parameter for what to run
    
    doshowhelp=true
    
    echo 'Script file : "'$1'" either does not exist or is not executable!' | tee -a -i $logfilepath
    
else
    # things look OK
    
    doshowhelp=false
    
    echo 'Script file : "'$@'" ' | tee -a -i $logfilepath
    
fi

if $doshowhelp; then
    # Show some help
    echo | tee -a -i $logfilepath
    echo 'do_script_nohup [--help|OPTION] script_to_execute [parameter(s)]' | tee -a -i $logfilepath
    echo  | tee -a -i $logfilepath
    echo '  --help             Show this help dialogue' | tee -a -i $logfilepath
    echo '  OPTION             Script options' | tee -a -i $logfilepath
    echo '         --diskspace       Add collection of diskspace statistics to operation' | tee -a -i $logfilepath
    echo '  script_to_execute  Script to execute in nohup mode' | tee -a -i $logfilepath
    echo '  [parameter(s)]     Parameter(s) for script to execute in nohup mode' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo Log file : $logfilepath | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo
    
    exit
fi

if [ x"$1" = x"--diskspace" ]; then
    echo 'Diskspace statistics collection requested...' | tee -a -i $logfilepath
    export nohupAddDiskspace=true
    shift
else
    export nohupAddDiskspace=false
fi

if [ ! -x $1 ]; then
    # missing the critical first parameter for what to run
    
    echo 'Script file : "'$1'" either does not exist or is not executable!' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo 'Exiting !!!....' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo Log file : $logfilepath | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo
    
    exit
fi

export script2nohup=$1
export script2nohuppath=$(dirname "$script2nohup")
export script2nohupfile=$(basename -- "$script2nohup")
#export script2nohupfile="${script2nohup##*/}"
export script2nohupfilename="${script2nohupfile##*.}"
export script2nohupfileext="${script2nohupfile%.*}"

#export script2nohupstdoutlog=.nohup.$DATEDTGS.$script2nohupfile.stdout.txt
#export script2nohupstderrlog=.nohup.$DATEDTGS.$script2nohupfile.stderr.txt
#export script2watchnohupwork=.nohup.$DATEDTGS.$script2nohupfile.watchme.sh
#export script2watchdiskspace=.nohup.$DATEDTGS.$script2nohupfile.diskspace.sh
#export script2cleannohupwork=.nohup.$DATEDTGS.$script2nohupfile.cleanup.sh
#export script2logdisklv_log=.nohup.$DATEDTGS.$script2nohupfile.diskspace.vg_splat-lv_log.sh
#export script2logdisklvcrnt=.nohup.$DATEDTGS.$script2nohupfile.diskspace.vg_splat-lv_current.sh

export script2nohupstdoutlog=.nohup.$DATEDTG.$script2nohupfile.stdout.txt
export script2nohupstderrlog=.nohup.$DATEDTG.$script2nohupfile.stderr.txt
export script2watchnohupwork=.nohup.$DATEDTG.$script2nohupfile.watchme.sh
export script2watchdiskspace=.nohup.$DATEDTG.$script2nohupfile.diskspace.sh
export script2cleannohupwork=.nohup.$DATEDTG.$script2nohupfile.cleanup.sh
export script2logdisklv_log=.nohup.$DATEDTG.$script2nohupfile.diskspace.vg_splat-lv_log.sh
export script2logdisklvcrnt=.nohup.$DATEDTG.$script2nohupfile.diskspace.vg_splat-lv_current.sh

echo 'NOHUP Clean-up related files and values : ' | tee -a -i $logfilepath
echo ' $script2nohup          : '"$script2nohup" | tee -a -i $logfilepath
echo ' $script2nohuppath      : '"$script2nohuppath" | tee -a -i $logfilepath
echo ' $script2nohupfile      : '"$script2nohupfile" | tee -a -i $logfilepath
echo ' $script2nohupfilename  : '"$script2nohupfilename" | tee -a -i $logfilepath
echo ' $script2nohupfileext   : '"$script2nohupfileext" | tee -a -i $logfilepath
echo ' $script2nohupstdoutlog : '"$script2nohupstdoutlog" | tee -a -i $logfilepath
echo ' $script2nohupstderrlog : '"$script2nohupstderrlog" | tee -a -i $logfilepath
echo ' $script2watchnohupwork : '"$script2watchnohupwork" | tee -a -i $logfilepath
echo ' $script2cleannohupwork : '"$script2cleannohupwork" | tee -a -i $logfilepath
echo ' $script2watchdiskspace : '"$script2watchdiskspace" | tee -a -i $logfilepath
echo ' $script2watchdiskspace : '"$script2watchdiskspace" | tee -a -i $logfilepath
echo ' $script2logdisklv_log  : '"$script2logdisklv_log" | tee -a -i $logfilepath
echo ' $script2logdisklvcrnt  : '"$script2logdisklvcrnt" | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

touch $script2nohupstdoutlog
touch $script2nohupstderrlog

echo >> $script2nohupstdoutlog
echo $BASHScriptDescription', script version '$ScriptVersion' from '$ScriptDate >> $script2nohupstdoutlog
echo >> $script2nohupstdoutlog

echo 'Execute script : '$script2nohup' with NOHUP, all paramters' | tee -a -i $script2nohupstdoutlog
echo '  and dump stdout to log file : '$script2nohupstdoutlog | tee -a -i $script2nohupstdoutlog
echo '  and dump stderr to log file : '$script2nohupstderrlog | tee -a -i $script2nohupstdoutlog
echo '  and watch command script    : '$script2watchnohupwork | tee -a -i $script2nohupstdoutlog
echo | tee -a -i $script2nohupstdoutlog

cat $script2nohupstdoutlog >> $script2nohupstderrlog
cat $script2nohupstdoutlog >> $logfilepath

echo 'watch command string - copy to execute'
echo

watchtail1="tail -n 10 $script2nohupstdoutlog"
watchtail2="tail -n 10 $script2nohupstderrlog"
watchdiskspace=./$script2watchdiskspace

if $nohupAddDiskspace ; then
    echo 'watch -d -n 2 "'$watchtail1';echo;echo;'$watchtail2';echo;echo;'$watchdiskspace';echo"'
    
    echo '#!/bin/bash' > $script2watchdiskspace
    echo '#' >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo 'currentDTG=`date +%Y-%m-%d-%H%M%Z`' >> $script2watchdiskspace
    echo 'currentDTGS=`date +%Y-%m-%d-%H%M%S%Z`' >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo 'echo $currentDTGS' >> $script2watchdiskspace
    echo 'echo' >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    #echo 'echo' >> $script2watchdiskspace
    echo 'df -hk' >> $script2watchdiskspace
    echo 'echo' >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo 'echo -n $currentDTGS" " >> '$script2logdisklv_log >> $script2watchdiskspace
    echo 'df -hk | grep "vg_splat-lv_log" >> '$script2logdisklv_log >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo 'echo -n $currentDTGS" " >> '$script2logdisklvcrnt >> $script2watchdiskspace
    echo 'df -hk | grep "vg_splat-lv_current" >> '$script2logdisklvcrnt >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo 'echo' >> $script2watchdiskspace
    echo 'echo -n $currentDTG"   "; df -hk | grep "Filesystem"' >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo 'echo' >> $script2watchdiskspace
    echo 'tail -n 5 '$script2logdisklv_log >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo 'echo' >> $script2watchdiskspace
    echo 'tail -n 5 '$script2logdisklvcrnt >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    echo 'echo' >> $script2watchdiskspace
    echo 'echo '....'' >> $script2watchdiskspace
    echo >> $script2watchdiskspace
    
    chmod 775 $script2watchdiskspace | tee -a -i $logfilepath
    
    echo 'Copy file : '$script2watchdiskspace' to folder : '$logfilefolder | tee -a -i $logfilepath
    cp $script2watchdiskspace $logfilefolder | tee -a -i $logfilepath
    
else
    echo 'watch -d -n 2 "'$watchtail1';echo;echo;'$watchtail2';echo"'
fi

echo

echo '#!/bin/bash' > $script2watchnohupwork
echo '#' >> $script2watchnohupwork
echo  >> $script2watchnohupwork

if $nohupAddDiskspace ; then
    
    echo >> $script2watchnohupwork
    echo 'currentDTGS=`date +%Y-%m-%d-%H%M%S%Z`' >> $script2watchnohupwork
    echo >> $script2watchnohupwork
    echo 'echo -n > '$script2logdisklv_log >> $script2watchnohupwork
    echo 'echo -n $currentDTGS" " >> '$script2logdisklv_log >> $script2watchnohupwork
    echo 'df -hk | grep "Filesystem" >> '$script2logdisklv_log >> $script2watchnohupwork
    echo >> $script2watchnohupwork
    echo 'echo -n > '$script2logdisklvcrnt >> $script2watchnohupwork
    echo 'echo -n $currentDTGS" " >> '$script2logdisklvcrnt >> $script2watchnohupwork
    echo 'df -hk | grep "Filesystem" >> '$script2logdisklvcrnt >> $script2watchnohupwork
    echo >> $script2watchnohupwork
    
    echo 'watch -d -n 2 "'$watchtail1';echo;echo;'$watchtail2';echo;echo;'$watchdiskspace';echo"' >> $script2watchnohupwork
else
    echo 'watch -d -n 2 "'$watchtail1';echo;echo;'$watchtail2';echo"' >> $script2watchnohupwork
fi

echo 'echo' >> $script2watchnohupwork
echo 'echo "Remember to remove $script2watchnohupwork"' >> $script2watchnohupwork
echo 'echo' >> $script2watchnohupwork
echo  >> $script2watchnohupwork

chmod 775 $script2watchnohupwork

echo 'Copy file : '$script2watchdiskspace' to folder : '$logfilefolder | tee -a -i $logfilepath
cp $script2watchnohupwork $logfilefolder | tee -a -i $logfilepath

echo | tee -a -i $logfilepath
echo 'Setup of operation do_script_nohup completed.' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath
echo 'nohup "'$@'" --NOWAIT --NOHUP --NOHUP-Script="'$script2nohupfile'" 2>> '$script2nohupstderrlog' >> '$script2nohupstdoutlog' &' | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

#nohup $script2nohup >> $script2nohupstdoutlog 2>> $script2nohupstderrlog
nohup "$@" --NOWAIT --NOHUP --NOHUP-Script="$script2nohupfile" 2>> $script2nohupstderrlog >> $script2nohupstdoutlog &

echo | tee -a -i $logfilepath
echo Log file : $logfilepath | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

sleep 10

# That should be enough time for the called script to get things going

if [ -r nul ] ; then
    rm nul >> $logfilepath
fi

if [ -r None ] ; then
    rm None >> $logfilepath
fi

#ls -alh .nohup.$DATEDTGS.$script2nohupfile.* | tee -a -i $logfilepath
ls -alh .nohup.$DATEDTG.$script2nohupfile.* | tee -a -i $logfilepath
echo | tee -a -i $logfilepath

