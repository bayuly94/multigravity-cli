@echo off
setlocal
set "SCRIPT_DIR=%~dp0"

:: Fast-path for quota commands to bypass PowerShell startup overhead
if /i "%~1"=="quotas" goto :quota_fastpath
if /i "%~1"=="quota"  goto :quota_fastpath
if /i "%~1"=="quotes" goto :quota_fastpath
if /i "%~1"=="quote"  goto :quota_fastpath

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%mgy.ps1" %*
exit /b %ERRORLEVEL%

:quota_fastpath
set "QUOTA_ARGS="
for /f "tokens=1* delims= " %%a in ("%*") do set "QUOTA_ARGS=%%b"
if exist "%SCRIPT_DIR%mgy-quota.py" (
    python "%SCRIPT_DIR%mgy-quota.py" %QUOTA_ARGS%
    exit /b %ERRORLEVEL%
)
if exist "%SCRIPT_DIR%mgy-quota" (
    python "%SCRIPT_DIR%mgy-quota" %QUOTA_ARGS%
    exit /b %ERRORLEVEL%
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%mgy.ps1" %*
exit /b %ERRORLEVEL%
