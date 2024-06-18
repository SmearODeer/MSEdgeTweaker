@echo off
@setlocal EnableDelayedExpansion

:: Metadata
set "ProgramName=MSEdge Tweaker"
set "GitHubLink=https://github.com/TheBobPony/MSEdgeTweaker/tree/948b70704c320486fa23abeeedbdac211749202b"
set "Author=TheBobPony"
set "OriginalCreationDate=2024-06-17"
set "version=v24-06-18"

:: Define log retention period (days)
set LogRetentionDays=7

:: Determine the drive letter Windows is installed on
for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%i:\Windows (
        set SystemDrive=%%i:
        goto :FoundDrive
    )
)
:FoundDrive

:: Create timestamp variable
for /f "tokens=2 delims==" %%i in ('"wmic os get localdatetime /value"') do set timestamp=%%i
set timestamp=%timestamp:~0,4%%timestamp:~4,2%%timestamp:~6,2%_%timestamp:~8,2%%timestamp:~10,2%%timestamp:~12,2%

:: Define log and backup paths
set LogPath=%SystemDrive%\ProgramData\MSEdgeTweaker\Logs_%timestamp%
set BackupPath=%SystemDrive%\ProgramData\MSEdgeTweaker\Backups_%timestamp%

:: Create log and backup directories
mkdir "%LogPath%"
mkdir "%BackupPath%"

:: Log file
set LogFile=%LogPath%\MSEdgeTweaker_%timestamp%.log

:: Track executed options
set "ExecutedOptions="

:: Logging function
:Log
echo %date% %time% %* >> "%LogFile%"
exit /b

:: Remove old logs
forfiles /p "%SystemDrive%\ProgramData\MSEdgeTweaker" /m *.log /d -%LogRetentionDays% /c "cmd /c del @path"

:: Check for administrator rights
echo Please wait, checking your system...
Reg.exe query "HKU\S-1-5-19\Environment"
If Not %ERRORLEVEL% EQU 0 (
    cls
    echo You must have administrator rights to run this script...
    echo To do this, right-click on this script file then select 'Run as administrator'.
    pause
    exit
)

:: Log start of script
call :Log "Script started. Version: %version%"

:: Main Menu
:MainMenu
cls
echo.
echo Welcome to %ProgramName% %version%!
echo.
echo Here's the list of available options:
echo.
echo. [1] Disable the first run experience and splash screen
echo. [2] Disable importing from other web browsers on launch
echo. [3] Disable browser sign in and sync services
echo. [4] Disable setting as the default browser
echo. [5] Disable edge sidebar
echo. [6] Disable shopping assistant
echo. [7] Disable sponsored links in the new tab page
echo.
echo. [8] Extras menu
echo.
echo. [9] Visit this project on GitHub
echo. [0] Exit
echo.
echo Enter a menu option [1-9, 0]:
choice /C:1234567890 /N
set _erl=%errorlevel%

:: Check if the option was already executed
if "!ExecutedOptions:%_erl%=!" neq "%ExecutedOptions%" (
    call :Log "Option %_erl% already executed."
    echo Option %_erl% already executed.
    pause
    goto :MainMenu
)

:: Track executed option
set ExecutedOptions=%ExecutedOptions%%_erl%,

if %_erl%==10 exit /b
if %_erl%==9 start https://github.com/TheBobPony/MSEdgeTweaker & goto :MainMenu
if %_erl%==8 goto :ExtrasMenu
if %_erl%==7 goto :sponsorednewtab
if %_erl%==6 goto :shoppingassist
if %_erl%==5 goto :sidebar
if %_erl%==4 goto :defaultbrowser
if %_erl%==3 goto :nosignin
if %_erl%==2 goto :browserimport
if %_erl%==1 goto :firstrunoobe

goto :MainMenu

:ExtrasMenu
cls
echo.
echo Extras menu for %ProgramName%
echo.
echo Here's the list of available options:
echo.
echo. [1] Disable insider banner in about page
echo. [2] Disable user feedback option
echo. [3] Disable search bar and on startup
echo. [4] Disable browser guest mode
echo. [5] Disable collections feature
echo. [6] Disable startup boost
echo.
echo. [7] Uninstall Microsoft Edge web browser (coming soon)
echo. [8] Uninstall Microsoft Edge WebView (coming soon)
echo.
echo. [9] Return to Main Menu
echo. [0] Exit
echo.
echo Enter a menu option [1-9, 0]:
choice /C:1234567890 /N
set _erl=%errorlevel%

:: Check if the option was already executed
if "!ExecutedOptions:%_erl%=!" neq "%ExecutedOptions%" (
    call :Log "Option %_erl% already executed."
    echo Option %_erl% already executed.
    pause
    goto :ExtrasMenu
)

:: Track executed option
set ExecutedOptions=%ExecutedOptions%%_erl%,

if %_erl%==10 exit /b
if %_erl%==9 goto :MainMenu
if %_erl%==8 goto :uninstalledgewebview
if %_erl%==7 goto :uninstalledge
if %_erl%==6 goto :startup
if %_erl%==5 goto :collections
if %_erl%==4 goto :guestmode
if %_erl%==3 goto :searchbar
if %_erl%==2 goto :userfeedback
if %_erl%==1 goto :insiderbanner

goto :MainMenu

:: Function definitions

:firstrunoobe
call :Log "Disabling the first run experience and splash screen..."
echo Disabling the first run experience and splash screen...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "HideFirstRunExperience" /t REG_DWORD /d "1" /f
timeout 5
goto :MainMenu

:browserimport
call :Log "Disabling importing from other web browsers on launch..."
echo Disabling importing from other web browsers on launch...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "ImportOnEachLaunch" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:defaultbrowser
call :Log "Disabling setting as default browser..."
echo Disabling setting as default browser...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "DefaultBrowserSettingEnabled" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:sidebar
call :Log "Disabling edge sidebar..."
echo Disabling edge sidebar...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "HubsSidebarEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "StandaloneHubsSidebarEnabled" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:shoppingassist
call :Log "Disabling shopping assistant..."
echo Disabling shopping assistant...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:sponsorednewtab
call :Log "Disabling Sponsored links in new tab page..."
echo Disabling Sponsored links in new tab page...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "NewTabPageHideDefaultTopSites" /t REG_DWORD /d "1" /f
timeout 5
goto :MainMenu

:nosignin
call :Log "Disabling browser sign in and sync services..."
echo Disabling browser sign in and sync services...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "BrowserSignin" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "ImplicitSignInEnabled" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "SyncDisabled" /t REG_DWORD /d "1" /f
timeout 5
goto :MainMenu

:insiderbanner
call :Log "Disabling insider banner in the about page..."
echo Disabling insider banner in the about page...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "MicrosoftEdgeInsiderPromotionEnabled" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:userfeedback
call :Log "Disabling user feedback option..."
echo Disabling user feedback option...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:searchbar
call :Log "Disabling search bar..."
echo Disabling search bar...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "SearchbarAllowed" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "SearchbarIsEnabledOnStartup" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:guestmode
call :Log "Disabling use of guest mode..."
echo Disabling use of guest mode...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "BrowserGuestModeEnabled" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:collections
call :Log "Disabling collections feature..."
echo Disabling collections feature...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "EdgeCollectionsEnabled" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:startup
call :Log "Disabling startup boost..."
echo Disabling startup boost...
Reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d "0" /f
timeout 5
goto :MainMenu

:uninstalledge
call :Log "Uninstalling Microsoft Edge web browser is coming soon..."
echo Uninstalling Microsoft Edge web browser is coming soon...
timeout 5
goto :MainMenu

:uninstalledgewebview
call :Log "Uninstalling Microsoft Edge WebView2 is coming soon, check back later!"
echo Uninstalling Microsoft Edge WebView2 is coming soon, check back later!
timeout 5
goto :MainMenu
