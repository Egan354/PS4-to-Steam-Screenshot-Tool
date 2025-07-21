@echo off
setlocal enabledelayedexpansion

::-----------------------------------------------------------------------------
:: PS4-to-Steam Screenshot Tool
::
:: INSTRUCTIONS:
:: 1. Place 'exiftool.exe' in the SAME FOLDER as this .bat file.
:: 2. Ensure ImageMagick is installed.
::-----------------------------------------------------------------------------

::-----------------------------------------------------------------------------
:: USER-CONFIGURABLE VARIABLES
::-----------------------------------------------------------------------------
set "STEAM_PATH=C:\Program Files (x86)\Steam"

::-----------------------------------------------------------------------------
:: SCRIPT LOGIC - DO NOT EDIT BELOW THIS LINE
::-----------------------------------------------------------------------------

:: --- Define paths for external tools and config file ---
set "EXIFTOOL_PATH=%~dp0exiftool.exe"
set "CONFIG_FILE=%~dp0steam_user_id.txt"
set "LOG_FILE=%~dp0ps4_to_steam_tool_log.txt"
if exist "%LOG_FILE%" del "%LOG_FILE%"

echo.
echo  ====================================
echo    PS4-to-Steam Screenshot Tool
echo  ====================================
echo.

:: --- Prerequisite Checks ---
magick -version >nul 2>&1
if errorlevel 9009 (
    echo [ERROR] ImageMagick not found. It must be installed to continue.
    goto :end
)
if not exist "%EXIFTOOL_PATH%" (
    echo [ERROR] ExifTool not found!
    echo         Please place 'exiftool.exe' in the same folder as this script.
    echo         Expected at: %EXIFTOOL_PATH%
    goto :end
)

:: --- One-Time User ID Setup ---
if exist "%CONFIG_FILE%" (
    set /p USER_ID=<"%CONFIG_FILE%"
    echo [INFO] Using saved User ID: !USER_ID!
) else (
    echo [SETUP] This is a one-time setup.
    echo Please provide your Steam UserData ID. You can find this number in the
    echo C:\Program Files (x86)\Steam\userdata folder.
    echo.
    set /p "USER_ID=Enter your Steam UserData ID: "
    if not defined USER_ID (
        echo [ERROR] No User ID entered. Exiting.
        goto :end
    )
    echo !USER_ID! > "%CONFIG_FILE%"
    echo [SUCCESS] User ID saved for future use.
)
echo.

:: --- Get Game ID and Source Folder ---
set /p "GAME_ID=Enter the game's App ID: "
echo.

if not defined GAME_ID (
    echo [ERROR] You must enter a Game ID.
    goto :end
)
set "SOURCE_FOLDER=%~1"
if not defined SOURCE_FOLDER (
    echo [ERROR] Please drag and drop the folder containing screenshots onto this file.
    goto :end
)

set "SCREENSHOTS_DIR=%STEAM_PATH%\userdata\%USER_ID%\760\remote\%GAME_ID%\screenshots"
set "THUMBNAILS_DIR=%SCREENSHOTS_DIR%\thumbnails"
if not exist "%SCREENSHOTS_DIR%" mkdir "%SCREENSHOTS_DIR%"
if not exist "%THUMBNAILS_DIR%" mkdir "%THUMBNAILS_DIR%"

echo [INFO] Output Folder: %SCREENSHOTS_DIR%

echo [ACTION] Closing Steam...
taskkill /F /IM steam.exe >nul 2>&1

echo [ACTION] Processing and converting files...
set /a "file_counter=1"

for %%F in ("%SOURCE_FOLDER%\*.jpg" "%SOURCE_FOLDER%\*.png" "%SOURCE_FOLDER%\*.bmp") do (
    if exist "%%F" (
        set "original_filename=%%~nF"
        
        set "temp_name=!original_filename:_=\!"
        for %%a in ("!temp_name!") do set "datestring=%%~nxa"

        if defined datestring if not "!datestring:~7,1!"=="" (
            set "year=!datestring:~0,4!"
            set "month=!datestring:~4,2!"
            set "day=!datestring:~6,2!"
            set "file_date=!year!-!month!-!day!"
        ) else (
            echo [WARNING] Could not parse date from "%%~nxF". Using current date.
            for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
                set "file_date=%%c-%%a-%%b"
            )
        )

        set "padded_counter=0000!file_counter!"
        set "padded_counter=!padded_counter:~-5!"
        set "new_filename=!file_date!_!padded_counter!.jpg"

        echo   - Processing "%%~nxF"...
        
        set "FULL_SIZE_PATH=%SCREENSHOTS_DIR%\!new_filename!"
        set "THUMB_PATH=%THUMBNAILS_DIR%\!new_filename!"
        
        :: 1. Create the full-size screenshot
        magick "%%F" "!FULL_SIZE_PATH!" 1>>"%LOG_FILE%" 2>>&1
        
        if not errorlevel 1 (
            echo     - Full-size image created.
            
            :: 2. Create the thumbnail
            magick "!FULL_SIZE_PATH!" -resize 200x112 "!THUMB_PATH!" 1>>"%LOG_FILE%" 2>>&1
            
            if not errorlevel 1 (
                echo     - Thumbnail created.
                
                :: 3. Set file system timestamps
                set "new_date=!file_date! 12:00:00"
                powershell -ExecutionPolicy Bypass -Command "$file = Get-Item '!FULL_SIZE_PATH!'; $file.CreationTime = '!new_date!'; $file.LastWriteTime = '!new_date!'" >nul
                powershell -ExecutionPolicy Bypass -Command "$file = Get-Item '!THUMB_PATH!'; $file.CreationTime = '!new_date!'; $file.LastWriteTime = '!new_date!'" >nul
                echo     - File system dates set.

                :: 4. Set internal EXIF "Date Taken" timestamp
                set "exif_date_string=!year!:!month!:!day! 12:00:00"
                "%EXIFTOOL_PATH%" -overwrite_original -AllDates="!exif_date_string!" "!FULL_SIZE_PATH!" 1>>"%LOG_FILE%" 2>>&1
                "%EXIFTOOL_PATH%" -overwrite_original -AllDates="!exif_date_string!" "!THUMB_PATH!" 1>>"%LOG_FILE%" 2>>&1
                echo     - Internal EXIF date set.

            ) else (
                echo     [ERROR] Failed to create thumbnail. See log file.
            )
            set /a "file_counter+=1"
        ) else (
            echo   [ERROR] Failed to create full-size image. See log file.
        )
    )
)

echo [SUCCESS] All files have been processed.
echo [ACTION] Opening screenshot folder and relaunching Steam...
start "" "%SCREENSHOTS_DIR%"
start "" "%STEAM_PATH%\steam.exe"

echo.
echo  ====================================
echo    Process Complete!
echo  ====================================
echo.

:end
exit
