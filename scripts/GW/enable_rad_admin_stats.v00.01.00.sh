#!/bin/bash
#
# SCRIPT Setup rad_admin stats for needed blades to monitor
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
#
# Version :  00.01.00
# Date    :  2020-03-11
#

rad_admin stats on urlf
rad_admin stats on appi
rad_admin stats on av
rad_admin stats on malware

cpview

