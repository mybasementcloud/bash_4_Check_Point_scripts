# bash_4_Check_Point_scripts

Collection of bash scripts for use on Check Point Gaia systems

## UPDATED 2022-02

## Overview

mybasementcloud operational implemented working Gaia and bash script examples

### NOTE:  !!!!! TO USE THESE SCRIPTS DO NOT PLACE IN /home/<user> FOLDER

### NOTE:  !! Provided AS-IS and mostly for reference on scripting approach.  No implied Support, SLA, or help, but might address issues identified if provided with enough details

Scripts should handle all installation types from R77.30 and higher, potential function on pre-R77.30 versions possible.  This set handles R8X varriants up to R81 and R81.10 EA.

These scripts are currently in deployment in the mybasementcloud environment and used to operate, document, and administer the mybasementcloud Check Point systems.

Specific examples and operation for:

- _api_subscripts - subscripts for Check Point mgmt_cli API scripts
- _fixes - script based changes and updates to address problems, bugs, issues, ideas, and format.  Can be used relative to the closest date template to fix scripts built with older templates.
- _hostsetupscripts - example scripts for configuring a newly installed Gaia host with bash 4 Check Point script base solution and operating environment
- _hostupdatescripts - example scripts for executing updates to bash 4 Check Point script base solution and operating environment
- _scripting_tools - folder for scripting tools and coding and change management templates, also scripts for touch and text correction when in bash
- _subscripts - sub-ordinate scripts called by the version vXX.YY.ZZ level template based scripts for common operations [formerly _sub-scripts folder]
- _template - templates for bash scripts, may include some canned plumbing
- _tools - tools folder with expected tools at the expected versions.  All sources subject to inlcuded limitations and rights
- alias_commands - folder for example files added to the $HOME folders to help with command shortcuts, predefined variables, and alias configurations
- Common - general use scripts
- Config - Configuration capture for Gaia (might work on SPLAT and Linux, not tested on those)
- GAIA - scripts to automatically update GAIA extensions from Check Point (e.g. GAIA REST API) using the tgz file provided and placed on a known tftp host, then downloading an comparing to last installed package.
- GW - Gateway systems
- Health_Check - System Health Check Script as provided in sk121447, including example of how to collect the generated files into a dump file location
- MDM - Multi-Domain Management Server systems
- MGMT - Common Security Management scripts
- Patch_HotFix - scripts that fix things
- Session_Cleanup - Example of how to execute a session clean-up script to remove dead, zerolock sessions that might accumulate in API enabled R8X management systems, with version 2018-11-21-1055CST using API script template so full access to CLI configuration of mgmt_cli authentication and access parameters run with --help to get CLI help; MDM specific scripts were removed, so use the -d <domain> parameter to identify the domain.
- SmartEvent - SmartEvent related scripts for common operations, e.g. backup SmartEvent index and database files
- SMS - Security Management Server systems
- SMS.migrate_backup - Security Management Server scripts specific to migrate and migrate server operations
- UserConfig - User configuration actions for bash CLI operations, like adding standard alias entries, etc.  Must be run by the specific user to execute configuration, which is available at next logon.

## FUNDAMENTAL CONCEPTS

This script set is established to live under /var/log/__customer main folder for working in Gaia bash, since that protects it under /var/log and does not pose the risk of loss during upgrades.

Scripts are installed to /var/log/__customer/upgrade_export/scripts folder in the provided folder structure that is scripts.

In the current incarnation, so version 4.26 and later, a change is made to address the way the scripts are provisioned for use.  Instead of using symlinks to create friendly names of the scripts and place those likes into the /var/log/__customer/upgrade_export folder if they are supposed to be visible, many of the scripts are now referenced in alias calls and the working scripts and plumbing copied to /var/log/__customer/_scripts/bash_4_Check_Point/scripts_repository and the symlinks are put in /var/log/__customer/_scripts/bash_4_Check_Point.  To find out what scripts are thus referenced from the new persistent _scripts folder, use the " alias" command to list what is configured.  Certain scripts are still symlinked into the /var/log/__customer/upgrade_export folder until solutions to calling issues are addressed--this is mostly the migrate scripts.

## NOTES

- Session_Cleanup
  Use the CLI parameters to configure operation.
  Examples:
  
    ```show_zerolocks_sessions.v??.??.??.sh -r --port 4434 -d "Global"```

    ```show_zerolocks_sessions.v??.??.??.sh -u admin --port 4434 -d "System Data"```

- Moved to new working folder /var/log/__customer/ from /var/ ; this is to hedge against los of files and information due to upgrade, like CPUSE operation for R80.20.M1, R80.20 GA T101, (and later)
- Updated to different approach on identifing final Gaia version to account for R80.20.M1 (R80.20.M2 later) and wether R80.10 and above are handling Endpoint Security, since R80.20.M1 effectively upgrades R77.30.03.  Now updated to utilize available python scripts on Gaia instead of using clish commands that might get impaired by users in Gaia webUI
- Updated to handle R81 EA elements
- Added sample updatescripts script to pull latest package of scripts (scripts.tgz) from a tftp server and expand them, after removing the existing script links and deleting the old folder
- Added --NOSTART CLI parameter to where cpstart or mdsstart was executed in scripts, to not execute the restart of Check Point services
- if $MYTFTPSERVER is set to IPv4 Address of a TFTP server, config_capture, healthdump, interface_info, and check_point_service_status_check will tftp their archived results to a folder defined in _root_script_config.sh.  If the value is not set, then only an archive is created at the root of the working folder.
- Updated Common/do_scripts_nohup.sh and scripts with CLI parameter handling to expand capabilities to document nohup progress, show diskspace usage.  Use ./do_scripts_nohup --help to see parameters and options.  Scripts with CLI parameter handling create their own cleanup script.

## REFERENCES

Reference Check Point Secure Knowledge (SK) articles:
sk121447 Health Check (<https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk121447>)
