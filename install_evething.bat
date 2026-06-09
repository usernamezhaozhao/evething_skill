@echo off
setlocal enabledelayedexpansion

echo User: %USERNAME%
echo Target: %USERPROFILE%\Evething

set "DST=%USERPROFILE%\Evething"

if not exist "%DST%\Everything.exe" (
    :: Detect arch
    set "ARCH=%PROCESSOR_ARCHITECTURE%"
    if "!ARCH!"=="AMD64" set "ARCH=x64"
    echo Arch: !ARCH!

    set "SRC=%~dp0source"

    if not exist "!SRC!\Everything-1.4.1.1032.!ARCH!.zip" ( echo Missing Everything zip & pause & exit /b 1 )
    if not exist "!SRC!\ES-1.1.0.30.!ARCH!.zip"           ( echo Missing ES zip        & pause & exit /b 1 )
    if not exist "!SRC!\Everything.lng.zip"                ( echo Missing lang pack    & pause & exit /b 1 )

    mkdir "%DST%" 2>nul

    echo Extracting...
    tar -xf "!SRC!\Everything-1.4.1.1032.!ARCH!.zip" -C "%DST%"
    tar -xf "!SRC!\ES-1.1.0.30.!ARCH!.zip"           -C "%DST%"
    tar -xf "!SRC!\Everything.lng.zip"                -C "%DST%"

    echo Install done!
    mkdir "%DST%\result" 2>nul
    dir "%DST%"
) else (
    echo Evething already exists, skip install.
)

:: Start Everything if not running
tasklist /fi "imagename eq Everything.exe" 2>nul | find /i "Everything.exe" >nul
if errorlevel 1 (
    echo Starting Everything...
    start "" "%DST%\Everything.exe"
) else (
    echo Everything is already running.
)
pause
