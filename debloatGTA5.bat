@echo off
setlocal EnableDelayedExpansion
color 2

:choice
set /P c=Are you sure you want to debloat GTA V? (BattlEye and GTA Online will be removed.) [Y/N] 
if /I "%c%"=="Y" goto :execute
if /I "%c%"=="N" goto :quit
goto :choice

:execute

echo Removing BattlEye...
del /Q "GTA5_BE.exe" 2>nul
rmdir /Q /S "BattlEye" 2>nul

echo.
echo Scanning MP DLC folders...

set "dlcpath=update\x64\dlcpacks"

for /D %%F in ("%dlcpath%\mp*") do (
    set "folder=%%~nxF"
    set "keepFolder=0"

    if /I "!folder!"=="mpairraces" set "keepFolder=1"
    if /I "!folder!"=="mpbiker" set "keepFolder=1"
    if /I "!folder!"=="mpchristmas2" set "keepFolder=1"
    if /I "!folder!"=="mpheist" set "keepFolder=1"
    if /I "!folder!"=="mplowrider" set "keepFolder=1"
    if /I "!folder!"=="mpluxe" set "keepFolder=1"
    if /I "!folder!"=="mpluxe2" set "keepFolder=1"
    if /I "!folder!"=="mppatchesng" set "keepFolder=1"
    if /I "!folder!"=="mpspecialraces" set "keepFolder=1"
    if /I "!folder!"=="mpstunt" set "keepFolder=1"

    if "!keepFolder!"=="0" (
        echo Removing !folder!...
        rmdir /Q /S "%%F" 2>nul
    ) else (
        echo Keeping !folder!
    )
)

echo.
echo GTA V has been successfully debloated.
pause
exit

:quit
exit
