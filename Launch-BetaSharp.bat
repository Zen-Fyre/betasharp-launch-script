@echo off
setlocal enabledelayedexpansion
call :Get_DateTime

:: Booleans are either "true" or %anything you wish%
SET "HideTerminal=true"
SET "SaveBackupsEnabled=true"


::Working Paths

SET BackupName="saves-%datetime%.zip"
SET SavesPath="%appdata%\.BetaSharp\saves"
SET SavesBackupPath="%appdata%\.BetaSharp\savesBackup"
SET LauncherPath="BetaSharp.Launcher"


if %SaveBackupsEnabled%==true (call :DoBackup)

::LAUNCH GAME
cd %LauncherPath%
if %HideTerminal%==true (call :LaunchNoTerminal) else (call :LaunchWithTerminal)

exit /b









:LaunchNoTerminal
powershell -Command "Start-Process dotnet -ArgumentList 'run --configuration Release' -WindowStyle Hidden"
exit /b

:LaunchWithTerminal
start dotnet run --configuration Release
exit /b

:CheckBackupPath
if not exist %SavesBackupPath% (mkdir %SavesBackupPath%)
exit /b


:DoBackup
call :CheckBackupPath
powershell Compress-Archive -Path '%SavesPath%' -DestinationPath "%SavesBackupPath%/%BackupName%"
exit /b


:Get_DateTime
for /f "delims=" %%i in ('powershell -Command "Get-Date -Format 'dd-MM-yyyy_HH-mm-ss'" 2^>nul') do (
	set datetime=%%i
)
set datetime=!datetime!
exit /b
