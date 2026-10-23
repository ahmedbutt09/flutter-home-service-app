@echo off
setlocal
cd /d "%~dp0"
set "FLUTTER=D:\Flutter\flutter\bin\flutter.bat"
if not exist "%FLUTTER%" (
  echo Flutter was not found at D:\Flutter\flutter\bin\flutter.bat
  echo Update the FLUTTER path in this file if your SDK is elsewhere.
  pause
  exit /b 1
)

echo [1/3] Regenerating Android/Web platform files for the installed Flutter SDK...
call "%FLUTTER%" create --platforms=android,web .
if errorlevel 1 goto :error

echo [2/3] Getting packages...
call "%FLUTTER%" pub get
if errorlevel 1 goto :error

echo [3/3] Starting Home Services in Chrome...
call "%FLUTTER%" run -d chrome
if errorlevel 1 goto :error
exit /b 0

:error
echo.
echo The command above failed. Copy the red error output and send it to ChatGPT.
pause
exit /b 1
