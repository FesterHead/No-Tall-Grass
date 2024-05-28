@echo off
setlocal enabledelayedexpansion

set "propertiesFile=versioning.properties"
set "minecraft_version="
set "version="
set "short="
set "tall="
set "combined="

rem #############################################################

for /f "tokens=1,2 delims==" %%A in (%propertiesFile%) do (
    set "key=%%A"
    set "value=%%B"
    if "!key!"=="minecraft-version" set "minecraft_version=!value!"
    if "!key!"=="version" set "version=!value!"
    if "!key!"=="short" set "short=!value!"
    if "!key!"=="tall" set "tall=!value!"
    if "!key!"=="combined" set "combined=!value!"
)

rem #############################################################

if "%minecraft_version%"=="" (
    echo Error: minecraft-version value is not set in %propertiesFile%
    exit /b 1
)
if "%version%"=="" (
    echo Error: version value is not set in %propertiesFile%
    exit /b 1
)
if "%short%"=="" (
    echo Error: short value is not set in %propertiesFile%
    exit /b 1
)
if "%tall%"=="" (
    echo Error: tall value is not set in %propertiesFile%
    exit /b 1
)
if "%combined%"=="" (
    echo Error: combined value is not set in %propertiesFile%
    exit /b 1
)

set "outputDir=releases"
if not exist "%outputDir%" mkdir "%outputDir%"

rem #############################################################

rem build short grass release
set "filename=%short%-%minecraft_version%-%version%.zip"
set "outputPath=%outputDir%\%filename%"
if exist "%outputPath%" del "%outputPath%"
cd "%tall%"
"C:\Program Files\WinRAR\WinRAR.exe" a -r "%~dp0%outputPath%" *
cd ..

if errorlevel 1 (
    echo Error: Failed to create the ZIP file
    exit /b 1
)

rem #############################################################

rem build tall grass release
set "filename=%tall%-%minecraft_version%-%version%.zip"
set "outputPath=%outputDir%\%filename%"
if exist "%outputPath%" del "%outputPath%"
cd "%tall%"
"C:\Program Files\WinRAR\WinRAR.exe" a -r "%~dp0%outputPath%" *
cd ..

if errorlevel 1 (
    echo Error: Failed to create the ZIP file
    exit /b 1
)

rem #############################################################

rem build short and tall grass release
set "filename=%combined%-%minecraft_version%-%version%.zip"
set "outputPath=%outputDir%\%filename%"
if exist "%outputPath%" del "%outputPath%"
cd "%short%"
"C:\Program Files\WinRAR\WinRAR.exe" a -r "%~dp0%outputPath%" *
cd ..
cd "%tall%"
"C:\Program Files\WinRAR\WinRAR.exe" a -r "%~dp0%outputPath%" *
cd ..
cd "%combined%"
"C:\Program Files\WinRAR\WinRAR.exe" a -r "%~dp0%outputPath%" *
cd ..

if errorlevel 1 (
    echo Error: Failed to create the ZIP file
    exit /b 1
)

rem #############################################################

endlocal
pause
