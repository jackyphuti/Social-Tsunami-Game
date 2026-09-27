@echo off
setlocal enabledelayedexpansion
title Social Tsunami - One-Click Installer

echo ==========================================================
echo               SOCIAL TSUNAMI - INSTALLER
echo        Master the art of the wave (Vaporwave Edition)
echo ==========================================================
echo.

set "TARGET_DIR=%LOCALAPPDATA%\Programs\Social Tsunami"
set "DESKTOP_DIR=%USERPROFILE%\Desktop"
set "START_MENU_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Social Tsunami"

echo [*] Target Directory: %TARGET_DIR%
echo.

if not exist "%TARGET_DIR%" (
    echo [*] Creating application directory...
    mkdir "%TARGET_DIR%" >nul 2>&1
)

if not exist "%START_MENU_DIR%" (
    mkdir "%START_MENU_DIR%" >nul 2>&1
)

echo [*] Installing game files...
if exist "dist\SocialTsunami.exe" (
    copy /Y "dist\SocialTsunami.exe" "%TARGET_DIR%\SocialTsunami.exe" >nul
) else (
    echo [ERROR] dist\SocialTsunami.exe not found!
    pause
    exit /b 1
)

if exist "dist\SocialTsunami.pck" (
    copy /Y "dist\SocialTsunami.pck" "%TARGET_DIR%\SocialTsunami.pck" >nul
) else (
    echo [ERROR] dist\SocialTsunami.pck not found!
    pause
    exit /b 1
)

echo [*] Creating Desktop and Start Menu shortcuts...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ws = New-Object -ComObject WScript.Shell; " ^
    "$desk = $ws.CreateShortcut('%DESKTOP_DIR%\Social Tsunami.lnk'); " ^
    "$desk.TargetPath = '%TARGET_DIR%\SocialTsunami.exe'; " ^
    "$desk.WorkingDirectory = '%TARGET_DIR%'; " ^
    "$desk.Description = 'Social Tsunami - Master the Art of the Wave'; " ^
    "$desk.Save(); " ^
    "$sm = $ws.CreateShortcut('%START_MENU_DIR%\Social Tsunami.lnk'); " ^
    "$sm.TargetPath = '%TARGET_DIR%\SocialTsunami.exe'; " ^
    "$sm.WorkingDirectory = '%TARGET_DIR%'; " ^
    "$sm.Description = 'Social Tsunami - Master the Art of the Wave'; " ^
    "$sm.Save()"

echo [*] Creating Uninstaller...
(
    echo @echo off
    echo echo Uninstalling Social Tsunami...
    echo del "%DESKTOP_DIR%\Social Tsunami.lnk" ^>nul 2^>^&1
    echo rmdir /S /Q "%START_MENU_DIR%" ^>nul 2^>^&1
    echo rmdir /S /Q "%TARGET_DIR%" ^>nul 2^>^&1
    echo echo Social Tsunami was successfully uninstalled.
    echo pause
) > "%TARGET_DIR%\Uninstall.bat"

echo.
echo ==========================================================
echo [SUCCESS] Social Tsunami installed successfully!
echo.
echo  - Desktop shortcut created: "Social Tsunami"
echo  - Start Menu entry created: "Social Tsunami"
echo ==========================================================
echo.
set /p LAUNCH="Would you like to play now? (Y/N): "
if /i "%LAUNCH%"=="Y" (
    start "" "%TARGET_DIR%\SocialTsunami.exe"
)
exit /b 0
