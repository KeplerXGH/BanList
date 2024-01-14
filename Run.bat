@echo off
setlocal enabledelayedexpansion

set "outputCSV=Ban.txt"
set "tempFile=temp.txt"

pushd "%~dp0"

rem Find the first CSV file in the folder
for %%i in (*.csv) do (
    set "csvFile=%%i"
    goto :foundCSV
)

echo No CSV file found in the folder.
goto :end

:foundCSV
if exist "%outputCSV%" del "%outputCSV%"

for /f "usebackq delims=, tokens=*" %%a in ("%csvFile%") do (
    set "name=%%a"
    set "name=!name: =!" REM Remove spaces
    echo !name! >> "%tempFile%"
)

rem Remove duplicates and save to Ban.txt
if exist "%tempFile%" (
    for /f "delims=" %%a in ('type "%tempFile%" ^| sort') do (
        set "name=%%a"
        if "x!names!" neq "x!name!" (
            echo !name! >> "%outputCSV%"
            set "names=!name!"
        )
    )
    del "%tempFile%"
    echo Spaces removed and saved to %outputCSV%
) else (
    echo No data found in CSV file.
)

:end
popd

exit /b
