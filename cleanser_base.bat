@echo off
:: Run this bat with a shortcut set to run as admin...
cd /d "%~dp0"

echo ===================================================
echo System Preparation Utility: DEBUG MODE
echo ===================================================
echo.

:: Add EXEs here. Find them by right clicking them in taskmanager and go to details.
set PROCESS_NAMES="Discord.exe" "steam.exe" "NVIDIA Broadcast.exe" "PowerToys.exe" "firefox.exe" "soji.exe" "wallpaper32.exe" "wallpaper64.exe" "XboxPcAppFt.exe" "msedge.exe" "voicemeeterpro.exe" "MusicPresence.exe"

echo [1] Terminating background applications...
for %%p in (%PROCESS_NAMES%) do (
    echo.
    echo ---------------------------------------------------
    echo [DEBUG] Attempting to kill: %%p
    taskkill /F /IM %%p /T
)

echo.
echo ---------------------------------------------------
echo [2] Shutting down Windows Subsystem for Linux (WSL)...
wsl --shutdown
echo [DEBUG] WSL shutdown command executed.

echo.
echo ---------------------------------------------------
echo [3] Clearing Windows Standby List...
if exist "EmptyStandbyList.exe" (
    echo [DEBUG] EmptyStandbyList.exe found. Running...
    EmptyStandbyList.exe standbylist
    echo [DEBUG] Standby list cleared successfully.
) else (
    echo [FAILED] EmptyStandbyList.exe not found in current directory: "%CD%"
)

echo.
echo ===================================================
echo Preparation Complete.
echo ===================================================
pause