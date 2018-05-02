#!/bin/bash
#
# SCRIPT add content of alias_commands.add.000.sh to .bashrc file
#
# (C) 2017-2018 Eric James Beasley
#
ScriptVersion=00.03.00
ScriptDate=2018-03-29
#

export BASHScriptVersion=v00x03x00

export alliasAddFile=/var/upgrade_export/scripts/UserConfig/alias_commands.add.000.sh

if [ ! -r $alliasAddFile ] ; then
    echo 'Missing '"$alliasAddFile"' file !!!'
    echo 'Exiting!'
    exit 255
else
    echo 'Found '"$alliasAddFile"' file :  '$alliasAddFile
    echo
    cat $alliasAddFile
    echo
fi

dos2unix $alliasAddFile

echo
echo "Adding alias commands from $alliasAddFile to user's $HOME/.bashrc file"
echo
echo "Original $HOME/.bashrc file"
echo
cat $HOME/.bashrc
echo
cat $alliasAddFile >> $HOME/.bashrc
echo
echo
echo "Updated $HOME/.bashrc file"
echo
cat $HOME/.bashrc

