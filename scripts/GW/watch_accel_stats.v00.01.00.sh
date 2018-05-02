#!/bin/bash
#
# Watch Firewall Acceleration Status (-s)
#
ScriptVersion=00.01.00
ScriptDate=2018-03-29
#

export BASHScriptVersion=v00x01x00


watch -d -n 1 "fwaccel stats -s"

