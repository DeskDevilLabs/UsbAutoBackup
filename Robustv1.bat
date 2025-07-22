@echo off
title USB File Copier
color 0A
setlocal enabledelayedexpansion

:: Configuration
set "USB_DRIVE=F:"
set "TARGET_FOLDER=C:\USB_Files"
set "LOG_FILE=%TARGET_FOLDER%\log.txt"
set "EXTENSIONS=.ppt .pptx .pdf .docx"

:: Create target folder if it doesn't exist
if not exist "%TARGET_FOLDER%" (
    mkdir "%TARGET_FOLDER%"
    echo [%date% %time%] Created target folder: %TARGET_FOLDER% >> "%LOG_FILE%"
)

:MAIN_LOOP
echo.
echo [%date% %time%] Scanning USB drive %USB_DRIVE% for files...
echo [%date% %time%] Scanning USB drive %USB_DRIVE% for files... >> "%LOG_FILE%"

:: Check if USB drive is available
vol %USB_DRIVE% >nul 2>&1
if errorlevel 1 (
    echo [%date% %time%] ERROR: USB drive %USB_DRIVE% not found or not ready.
    echo [%date% %time%] ERROR: USB drive %USB_DRIVE% not found or not ready. >> "%LOG_FILE%"
    timeout /t 5 >nul
    goto MAIN_LOOP
)

:: Process each extension
set "FILES_FOUND=0"
for %%E in (%EXTENSIONS%) do (
    echo Checking for *%%E files...
    
    :: Process files in root and subfolders
    for /f "delims=" %%F in ('dir /b /s "%USB_DRIVE%\*%%E" 2^>nul') do (
        set "RELATIVE_PATH=%%~pF"
        set "RELATIVE_PATH=!RELATIVE_PATH:%USB_DRIVE%\=!"
        
        :: Create subfolder structure in target
        if not "!RELATIVE_PATH!"=="" (
            if not exist "%TARGET_FOLDER%\!RELATIVE_PATH!" (
                mkdir "%TARGET_FOLDER%\!RELATIVE_PATH!"
                echo [%date% %time%] Created folder: %TARGET_FOLDER%\!RELATIVE_PATH! >> "%LOG_FILE%"
            )
        )
        
        :: Copy the file
        set "DESTINATION=%TARGET_FOLDER%\!RELATIVE_PATH!%%~nxF"
        if not exist "!DESTINATION!" (
            echo [%date% %time%] Found: %%F
            echo [%date% %time%] Found: %%F >> "%LOG_FILE%"
            
            copy "%%F" "!DESTINATION!" >nul
            if errorlevel 1 (
                echo [%date% %time%] ERROR: Failed to copy %%F
                echo [%date% %time%] ERROR: Failed to copy %%F >> "%LOG_FILE%"
            ) else (
                echo [%date% %time%] SUCCESS: Copied to !DESTINATION!
                echo [%date% %time%] SUCCESS: Copied to !DESTINATION! >> "%LOG_FILE%"
                set /a FILES_FOUND+=1
            )
        ) else (
            echo [%date% %time%] File already exists: !DESTINATION!
            echo [%date% %time%] File already exists: !DESTINATION! >> "%LOG_FILE%"
        )
    )
)

if %FILES_FOUND% equ 0 (
    echo [%date% %time%] No new files found with specified extensions.
    echo [%date% %time%] No new files found with specified extensions. >> "%LOG_FILE%"
) else (
    echo [%date% %time%] Copied %FILES_FOUND% file(s) successfully.
    echo [%date% %time%] Copied %FILES_FOUND% file(s) successfully. >> "%LOG_FILE%"
)

:: Wait before next scan
timeout /t 10 >nul
goto MAIN_LOOP