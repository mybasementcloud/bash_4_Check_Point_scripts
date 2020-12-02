@ECHO OFF
REM
REM Script     :  Touch bash scripts in scripts folder
REM
REM # (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
REM #
REM # ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
REM # DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
REM # RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
REM # TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
REM # OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
REM # APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
REM # AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
REM #
REM #

SET _LOCALSCRIPTNAME=zzTouch.bash.scripts
SET _LOCALSCRIPTDATE=2020-10-21
SET _LOCALSCRIPTTIME=1300CDT
SET _LOCALSCRIPTVERSION=04.37.00
SET _LOCALSCRIPTREVISION=000


@ECHO.
@ECHO =====================================================================================
@ECHO =====================================================================================
@ECHO Script Name:  %_LOCALSCRIPTNAME%
@ECHO DATE:  %_LOCALSCRIPTDATE%  TIME:  %_LOCALSCRIPTTIME%
@ECHO VERSION:  %_LOCALSCRIPTVERSION%  REVISION:  %_LOCALSCRIPTREVISION%
@ECHO =====================================================================================
@ECHO.
@ECHO.


GOTO :STARTSCRIPT

REM =====================================================================================
REM -------------------------------------------------------------------------------------
REM START SUBROUTINE:  sub_FindTouchUtility  :  
REM -------------------------------------------------------------------------------------

:sub_FindTouchUtility

REM ----------------------------------------------------------------
REM Find Touch Utility
REM ----------------------------------------------------------------

SET PATHTOUCH=

if exist "C:\APPS\Touch\touch.exe" GOTO :SETAPPSTOUCH_C
if exist "D:\APPS\Touch\touch.exe" GOTO :SETAPPSTOUCH_D
if exist "C:\APPS\_Utilities\touch.exe" GOTO :SETAPPSUTILS_C
if exist "D:\APPS\_Utilities\touch.exe" GOTO :SETAPPSUTILS_D

EXIT /B 1

:SETAPPSTOUCH_C
SET PATHTOUCH=C:\APPS\Touch\touch.exe
GOTO :LASTCHKAPPS

:SETAPPSTOUCH_D
SET PATHTOUCH=D:\APPS\Touch\touch.exe
GOTO :LASTCHKAPPS

:SETAPPSUTILS_C
SET PATHTOUCH=C:\APPS\_Utilities\touch.exe
GOTO :LASTCHKAPPS

:SETAPPSUTILS_D
SET PATHTOUCH=D:\APPS\_Utilities\touch.exe
GOTO :LASTCHKAPPS

:LASTCHKAPPS
REM if "%PATHTOUCH%"=="" goto :ERRNOTOUCH
if "%PATHTOUCH%"=="" EXIT /B 1

REM * -------------------------------------------------------------------------
REM * 
REM * -------------------------------------------------------------------------


EXIT /B 0

REM -------------------------------------------------------------------------------------
REM SUBROUTINE IMPLEMENTATION ELEMENTS : sub_FindTouchUtility
REM -------------------------------------------------------------------------------------

REM CALL :sub_FindTouchUtility
REM if "%PATHTOUCH%"=="" goto :ERRNOTOUCH

REM -------------------------------------------------------------------------------------
REM END SUBROUTINE: sub_FindTouchUtility
REM -------------------------------------------------------------------------------------
REM =====================================================================================


REM =====================================================================================
REM -------------------------------------------------------------------------------------
REM START SUBROUTINE:  sub_TouchDirectory  :  
REM -------------------------------------------------------------------------------------

:sub_TouchDirectory

REM * -------------------------------------------------------------------------
REM * 
REM * -------------------------------------------------------------------------

SET "xPARMNOQUOTES="

IF "%~1"=="" (
	ECHO Missing parameter 1
	EXIT /B 255
)

SET xPARMNOQUOTES=%~1


REM ----------------------------------------------------------------
REM Touch Directory
REM ----------------------------------------------------------------
:TOUCHDIR

ECHO Check if "%xPARMNOQUOTES%" exists...
IF NOT EXIST "%xPARMNOQUOTES%" EXIT /B 0
ECHO Touch "%xPARMNOQUOTES%"

REM CD /D "%xPARMNOQUOTES%"
PUSHD "%xPARMNOQUOTES%"

REM FOR %%I IN (*.CMD) DO "%PATHTOUCH%" "%%I" >> "%TEMP%\TouchDir.log"
REM FOR %%I IN (v*.) DO "%PATHTOUCH%" "%%I" >> "%TEMP%\TouchDir.log"
FOR %%I IN (*.sh) DO "%PATHTOUCH%" "%%I" >> "%TEMP%\TouchDir.log"
FOR %%I IN (*.help) DO "%PATHTOUCH%" "%%I" >> "%TEMP%\TouchDir.log"
FOR %%I IN (*.version) DO "%PATHTOUCH%" "%%I" >> "%TEMP%\TouchDir.log"

IF EXIST "%xPARMNOQUOTES%\help.v%VERSIONNAME%" FOR %%I IN (help.v%VERSIONNAME%\*.help) DO "%PATHTOUCH%" "%%I" >> "%TEMP%\TouchDir.log"

REM CD /D "%CURDIR%"
POPD

REM ----------------------------------------------------------------
REM ----------------------------------------------------------------

SET "xPARMNOQUOTES="


EXIT /B 0

REM -------------------------------------------------------------------------------------
REM SUBROUTINE IMPLEMENTATION ELEMENTS : sub_TouchDirectory
REM -------------------------------------------------------------------------------------

REM CALL :sub_TouchDirectory <Path-to-Touch>

REM -------------------------------------------------------------------------------------
REM END SUBROUTINE: sub_TouchDirectory
REM -------------------------------------------------------------------------------------
REM =====================================================================================

:STARTSCRIPT

REM ----------------------------------------------------------------
REM Initial variables
REM ----------------------------------------------------------------

SET CURDIR=%CD%

SET VERSIONNAME=
IF "%1"=="" (
	ECHO Missing parameter 1
	ECHO Not handling HELP folders!
) ELSE (
	ECHO Handling HELP folders, as ../help.v%1
)

IF NOT "%1"=="" SET VERSIONNAME=%1

REM ----------------------------------------------------------------
REM Handle finding the Touch utility, which is not native to Windows
REM ----------------------------------------------------------------

CALL :sub_FindTouchUtility
if "%PATHTOUCH%"=="" goto :ERRNOTOUCH

REM ----------------------------------------------------------------
REM Execute the touch operations against the script folders
REM ----------------------------------------------------------------

CALL :sub_TouchDirectory "%CURDIR%"
REM CALL :sub_TouchDirectory "%CURDIR%\_api_subscripts"
CALL :sub_TouchDirectory "%CURDIR%\_fixes"
CALL :sub_TouchDirectory "%CURDIR%\_hostsetupscripts"
CALL :sub_TouchDirectory "%CURDIR%\_hostupdatescripts"
CALL :sub_TouchDirectory "%CURDIR%\_scripting_tools"
CALL :sub_TouchDirectory "%CURDIR%\_subscripts"
CALL :sub_TouchDirectory "%CURDIR%\_subscripts\Code_Snipets"
CALL :sub_TouchDirectory "%CURDIR%\_template"
CALL :sub_TouchDirectory "%CURDIR%\_template\Code_Snipets"
CALL :sub_TouchDirectory "%CURDIR%\alias_commands"
CALL :sub_TouchDirectory "%CURDIR%\alias_commands.CORE_G2.NPM"
CALL :sub_TouchDirectory "%CURDIR%\alias_commands.SAMPLE"
CALL :sub_TouchDirectory "%CURDIR%\Code_Snipets"
CALL :sub_TouchDirectory "%CURDIR%\Common"
CALL :sub_TouchDirectory "%CURDIR%\Config"
CALL :sub_TouchDirectory "%CURDIR%\GAIA"
CALL :sub_TouchDirectory "%CURDIR%\GAIA.SAMPLE"
CALL :sub_TouchDirectory "%CURDIR%\GW"
CALL :sub_TouchDirectory "%CURDIR%\GW.CORE"
CALL :sub_TouchDirectory "%CURDIR%\GW.CORE\SK106251"
CALL :sub_TouchDirectory "%CURDIR%\GW.CORE\SMCIAS01"
CALL :sub_TouchDirectory "%CURDIR%\GW.CORE\SMCIAS02"
IF EXIST "%CURDIR%\Health_Check\check_status_checkpoint_services.sh" "%PATHTOUCH%" "%CURDIR%\Health_Check\check_status_checkpoint_services.sh"
IF EXIST "%CURDIR%\Health_Check\check_status_checkpoint_services.%VERSIONNAME%.sh" "%PATHTOUCH%" "%CURDIR%\Health_Check\check_status_checkpoint_services.%VERSIONNAME%.sh"
IF EXIST "%CURDIR%\Health_Check\run_healthcheck_to_dump_dtg.sh" "%PATHTOUCH%" "%CURDIR%\Health_Check\run_healthcheck_to_dump_dtg.sh"
IF EXIST "%CURDIR%\Health_Check\run_healthcheck_to_dump_dtg.%VERSIONNAME%.sh" "%PATHTOUCH%" "%CURDIR%\Health_Check\run_healthcheck_to_dump_dtg.%VERSIONNAME%.sh"
CALL :sub_TouchDirectory "%CURDIR%\MDM"
CALL :sub_TouchDirectory "%CURDIR%\MGMT"
CALL :sub_TouchDirectory "%CURDIR%\Patch_HotFix"
REM CALL :sub_TouchDirectory "%CURDIR%\Session_Cleanup"
CALL :sub_TouchDirectory "%CURDIR%\SmartEvent"
CALL :sub_TouchDirectory "%CURDIR%\SMS"
CALL :sub_TouchDirectory "%CURDIR%\SMS.CORE"
CALL :sub_TouchDirectory "%CURDIR%\SMS.migrate_backup"
CALL :sub_TouchDirectory "%CURDIR%\UserConfig"
CALL :sub_TouchDirectory "%CURDIR%\UserConfig.CORE_G2.NPM"


REM ----------------------------------------------------------------

PAUSE

goto :DONE

REM *****************************************************************
REM *****************************************************************
:DONE

SET PATHTOUCH=
SET CURDIR=
SET TARGETDIR=
SET NEXTOP=

@ECHO ON

REM *****************************************************************
exit /b

REM *****************************************************************
REM *****************************************************************
REM Error Handling
REM *****************************************************************

REM ----------------------------------------------------------------
:ERRNOTOUCH
ECHO.
ECHO No TOUCH.EXE Found
ECHO.

goto :DONE

REM *****************************************************************
REM *****************************************************************
