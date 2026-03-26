@echo off
title Crimson Desert Performance Tweaks
setlocal enabledelayedexpansion

set CONFIG_DIR=%LOCALAPPDATA%\CrimsonDesert\Saved\Config\WindowsClient
set ENGINE_INI=%CONFIG_DIR%\Engine.ini
set BACKUP_DIR=%CONFIG_DIR%\backup
set SOURCE_INI=%~dp0config\Engine.ini

:menu
cls
echo ==============================================
echo   Crimson Desert Performance Tweaks - Menu
echo ==============================================
echo 1. Apply performance tweaks
echo 2. Restore original settings
echo 3. Exit
echo ==============================================
set /p choice="Choose an option (1-3): "

if "%choice%"=="1" goto apply
if "%choice%"=="2" goto restore
if "%choice%"=="3" exit
goto menu

:apply
echo Creating backup...
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
if exist "%ENGINE_INI%" (
    copy "%ENGINE_INI%" "%BACKUP_DIR%\Engine_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ini" >nul
    echo Backup saved.
) else (
    echo No existing Engine.ini found, skipping backup.
)

echo Copying optimized Engine.ini...
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
copy "%SOURCE_INI%" "%ENGINE_INI%" >nul
if errorlevel 1 (
    echo [ERROR] Failed to copy file. Make sure you run as administrator.
    pause
    goto menu
)
echo [SUCCESS] Tweaks applied!
pause
goto menu

:restore
if not exist "%BACKUP_DIR%" (
    echo No backup folder found. Cannot restore.
    pause
    goto menu
)
echo Available backups:
dir /b "%BACKUP_DIR%\Engine_*.ini"
echo.
set /p restore_file="Enter the full filename to restore (or press Enter to cancel): "
if "%restore_file%"=="" goto menu
if exist "%BACKUP_DIR%\%restore_file%" (
    copy "%BACKUP_DIR%\%restore_file%" "%ENGINE_INI%" >nul
    echo Restore complete.
) else (
    echo File not found.
)
pause
goto menu