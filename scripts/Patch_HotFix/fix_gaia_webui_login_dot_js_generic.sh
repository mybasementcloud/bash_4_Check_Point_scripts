#!/bin/bash
#
# SCRIPT execute operation to fix Gaia webUI logon problem for Chrome and FireFox
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
RootScriptTemplateLevel=006
RootScriptVersion=03.00.00 Generic
RootScriptDate=2018-12-18
#

RootScriptVersion=v03x00x00

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTSG=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

echo 'Date Time Group   :  '$DATEDTGS
echo 'Date (YYYY-MM-DD) :  '$DATEYMD
echo

# WAITTIME in seconds for read -t commands
export WAITTIME=60

export outputpathroot=/var/tmp/Change_Log
export outputpathbase=$outputpathroot/$DATEDTGS

if [ ! -r $outputpathroot ] 
then
    mkdir $outputpathroot
fi
if [ ! -r $outputpathbase ] 
then
    mkdir $outputpathbase
fi

sed -i.bak '/form.isValid/s/$/\nform.el.dom.action=formAction;\n/' /web/htdocs2/login/login.js
cp /web/htdocs2/login/login.js* $outputpathbase


echo 'Created folder :  '$outputpathbase
echo
ls -al $outputpathbase
echo

