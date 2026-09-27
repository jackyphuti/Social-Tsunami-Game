@echo off
setlocal
title Build Social Tsunami Distribution & Installer

echo ==========================================================
echo        BUILDING SOCIAL TSUNAMI STANDALONE & INSTALLER
echo ==========================================================
echo.

set "GODOT_EXE="
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\WinGet\Packages\" -Recurse -Filter \"Godot_v4.7.2-stable_win64.exe\").FullName"') do set "GODOT_EXE=%%i"
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\WinGet\Packages\" -Recurse -Filter \"*console.exe\").FullName"') do set "GODOT_CONSOLE=%%i"

if "%GODOT_EXE%"=="" (
    echo [ERROR] Godot 4.7.2 executable not found in WinGet packages!
    pause
    exit /b 1
)

if not exist "dist" mkdir "dist"

echo [1/3] Exporting project package (dist\SocialTsunami.pck)...
"%GODOT_CONSOLE%" --headless --export-pack "Windows Desktop" "dist\SocialTsunami.pck"
if errorlevel 1 (
    echo [ERROR] Failed to export PCK!
    pause
    exit /b 1
)

echo [2/3] Bundling engine binary (dist\SocialTsunami.exe)...
copy /Y "%GODOT_EXE%" "dist\SocialTsunami.exe" >nul

echo [3/3] Compiling Inno Setup Installer (installer_output\Social_Tsunami_Setup.exe)...
set "ISCC=%LOCALAPPDATA%\Programs\Inno Setup 7\ISCC.exe"
if exist "%ISCC%" (
    "%ISCC%" setup.iss
    echo [SUCCESS] Windows Setup wizard created in installer_output\Social_Tsunami_Setup.exe
) else (
    echo [NOTE] Inno Setup compiler not found; standalone files in dist\ are ready.
)

echo.
echo ==========================================================
echo BUILD COMPLETE!
echo Standalone folder: dist\
echo One-click installer: Install_Social_Tsunami.bat
echo Setup Wizard: installer_output\Social_Tsunami_Setup.exe
echo ==========================================================
pause
