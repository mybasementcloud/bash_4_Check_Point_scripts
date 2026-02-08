# SD_WAN scripts

Collection of bash scripts for use on Check Point Gaia systems to handle SD-WAN specific issues or information

## UPDATED 2026-02-08

## Overview

Check Point Gaia systems scripts to handle SD-WAN specific issues or information

### NOTE:  !! Provided AS-IS and mostly for reference on scripting approach.  No implied Support, SLA, or help, but might address issues identified if provided with enough details

X

Specific examples and operation for:

- X

## FUNDAMENTAL CONCEPTS

Y
## NOTES

- {scripts_folder}/SD-WAN/fix_DHCP_DNS_Override_for_SDWAN.{version}.sh - This script addresses the issue where enabling DHCP on an interface will overwrite a fixed setting of the DNS server values in Gaia.  This script will handle the change to stop the changes for interfaces either defined in a append_to_dhclient-enter-hooks.bash file (see the append_to_dhclient-enter-hooks.EXAMPLE.bash for an example of how to set the values, script looks for the file in the same folder it is in).  If no append_to_dhclient-enter-hooks.bash file is found, then the script will append a fixed value that disables all DHCP changes to the DNS settings by modifying the bash variable PEERDNS to "no" (export PEERDNS="no"), which should stop the changes.  The script also backs up the original /etc/dhcp/dhclient-enter-hooks file and creates a copy of the modifed version into the same folder.  Logging documents the changes to the standard /var/log/__customer/upgrade_export/dump/{year}/{year-month(MM)} folder for reference with a copy of the original and changed files.  This script should run without dependency to any other script elements, except for the assumed append_to_dhclient-enter-hooks.bash for specific interface configuration of the disabling changes to DNS by DHCP.

## THANKS

Thank you to those who have assisted with feedback and utilization reports and issues.

## QUICK START

To quickly start working with the scripts, do the following.

- Download the release tgz file (b4CP.scripts.v05.38.00.000.tgz) and deploy to a work folder on the target management host, like /var/log/__customer [recommended location], the folder should be under the /var/log folder to ensure survival during upgrades and patches (Jumbo Hotfix accumulator installation)
- Expand the TGZ file, e.g.

    Example:  `tar -xf b4CP.scripts.{version}.tgz`
    `tar -xf b4CP.scripts.v05.38.00.000.tgz`

- Goto the scripts folder

   `cd ./scripts`

- Execute desired script with help parameter to show command options, e.g.

   Example:  `./generate_script_links.{version}.sh --help`
   `./generate_script_links.v05.38.00.sh --help`

## REFERENCES

Reference Check Point Secure Knowledge (SK) articles: 

- There are currently NO public SK articles for the DHCP modification of the desired fixed DNS settings in Gaia.  Contact your respective Check Point engineering representative for assitance if you have questions on this issue.