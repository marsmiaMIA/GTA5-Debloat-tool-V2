@echo off
setlocal EnableExtensions EnableDelayedExpansion
color 3
cd /d "%~dp0"
set "dlcpath=update\x64\dlcpacks"
title GTA V Debloat Tool
echo.
echo ========================================
echo            GTA V DEBLOAT TOOL
echo ========================================
echo.
echo This tool will:
echo - Remove GTA Online DLC packs
echo - Remove BattlEye anti-cheat files
echo - Keep Story Mode completely intact
echo.
echo ========================================
echo.
:: Check install path
if not exist "%dlcpath%\" (
    echo [ERROR] Could not find dlcpacks folder.
    echo Make sure this is run from your GTA V root directory.
    echo.
    pause
    exit
)
:: Required folders to KEEP
set required[0]=mpairraces
set required[1]=mpbiker
set required[2]=mpchristmas2
set required[3]=mpheist
set required[4]=mplowrider
set required[5]=mpluxe
set required[6]=mpluxe2
set required[7]=mppatchesng
set required[8]=mpspecialraces
set required[9]=mpstunt

:: -----------------------------
:: ALREADY-COMPLETE CHECK
:: -----------------------------
set alreadyDone=1

:: If any non-required mp* folder still exists, not done
for /D %%F in ("%dlcpath%\mp*") do (
    set "name=%%~nxF"
    set "isRequired=0"
    for /L %%i in (0,1,9) do (
        if /I "!name!"=="!required[%%i]!" set "isRequired=1"
    )
    if "!isRequired!"=="0" set "alreadyDone=0"
)

:: If BattlEye still exists, not done
if exist "BattlEye\" set "alreadyDone=0"
if exist "GTA5_BE.exe" set "alreadyDone=0"

:: If all required folders are missing entirely, something is wrong - don't claim done
for /L %%i in (0,1,9) do (
    if not exist "%dlcpath%\!required[%%i]!" set "alreadyDone=0"
)

if "!alreadyDone!"=="1" (
    echo [INFO] This tool has already been run.
    echo.
    echo All Online DLC packs are removed.
    echo BattlEye is not present.
    echo Required Story Mode files are intact.
    echo.
    echo Nothing left to do. Your install is already debloated.
    echo.
    echo ========================================
    echo STATUS: ALREADY COMPLETE [DONE]
    echo ========================================
    echo.
    pause
    exit
)

echo.
echo WARNING: Online content will be removed.
echo This action is safe for Story Mode.
echo.
set /p c=Do you want to continue? (Y/N): 
if /I "%c%" NEQ "Y" goto quit
echo.
echo ========================================
echo STARTING DEBLOAT
echo ========================================
echo.
:: -----------------------------
:: VERIFY REQUIRED FILES FIRST
:: -----------------------------
set missing=
for /L %%i in (0,1,9) do (
    if not exist "%dlcpath%\!required[%%i]!" (
        set "missing=!missing! !required[%%i]!"
    )
)
if defined missing (
    echo [ERROR] Critical DLC folders missing:
    echo !missing!
    echo.
    echo Your game may already be modified or incomplete.
    echo Recommend:
    echo - Verify game files via launcher
    echo - Or reinstall GTA V
    echo.
    pause
    exit
)
echo [OK] Required files verified.
echo.
:: -----------------------------
:: REMOVE BATTLEYE
:: -----------------------------
echo Removing BattlEye...
del /Q "GTA5_BE.exe" 2>nul
rmdir /S /Q "BattlEye" 2>nul
echo [OK] BattlEye removed.
echo.
:: -----------------------------
:: CLEAN DLC PACKS
:: -----------------------------
echo Cleaning Online DLC packs...
set removed=0
for /D %%F in ("%dlcpath%\mp*") do (
    set "name=%%~nxF"
    set keep=0
    for /L %%i in (0,1,9) do (
        if /I "!name!"=="!required[%%i]!" set keep=1
    )
    if "!keep!"=="0" (
        rmdir /S /Q "%%F" 2>nul
        set removed=1
    )
)
echo [OK] DLC cleanup complete.
echo.
:: -----------------------------
:: FINAL VERIFICATION
:: -----------------------------
echo ========================================
echo FINAL VERIFICATION CHECK
echo ========================================
echo.
set issues=0
:: Check for unexpected leftover mp* folders
for /D %%F in ("%dlcpath%\mp*") do (
    set "name=%%~nxF"
    set "isRequired=0"
    for /L %%i in (0,1,9) do (
        if /I "!name!"=="!required[%%i]!" set "isRequired=1"
    )
    if "!isRequired!"=="0" (
        echo [ISSUE] Unexpected folder still present: %%~nxF
        set issues=1
    )
)
:: Check required folders survived
for /L %%i in (0,1,9) do (
    if not exist "%dlcpath%\!required[%%i]!" (
        echo [ISSUE] Required folder missing: !required[%%i]!
        set issues=1
    )
)
:: Check BattlEye is gone
if exist "BattlEye\" (
    echo [ISSUE] BattlEye folder still exists
    set issues=1
)
if exist "GTA5_BE.exe" (
    echo [ISSUE] BattlEye exe still exists
    set issues=1
)
echo.
echo ========================================
echo RESULT
echo ========================================
echo.
if "!issues!"=="0" (
    echo STATUS: CLEAN [DONE]
    echo Debloat completed successfully.
    echo No issues detected.
) else (
    echo STATUS: ISSUES FOUND [!]
    echo Some items were not removed correctly.
    echo Please re-run or verify game files.
)
echo ========================================
echo.
pause
exit
:quit
echo.
echo Cancelled by user.
echo.
pause
exit
