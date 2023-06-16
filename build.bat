@echo off

REM input parameters
SET PLATFORM=windows

REM paths (make sure to replace these with actual paths in your system)
SET ROOT_DIR=.
SET DEST_DIR=lib\bin

mkdir "%DEST_DIR%"

REM copy binary file
SET SRC_DIR=%ROOT_DIR%\bin\windows
SET BINARY_FILE1=gpcl6dll64.dll
SET BINARY_FILE2=gpcl6win64.exe
copy "%SRC_DIR%\%BINARY_FILE1%" "%DEST_DIR%\%BINARY_FILE1%"
copy "%SRC_DIR%\%BINARY_FILE2%" "%DEST_DIR%\%BINARY_FILE2%"

REM build
flutter build %PLATFORM%

REM cleanup
del "%DEST_DIR%\%BINARY_FILE1%"
del "%DEST_DIR%\%BINARY_FILE2%"

REM cleanup
rd /s /q "%DEST_DIR%"