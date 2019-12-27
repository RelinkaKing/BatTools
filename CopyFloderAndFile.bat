@echo off&setlocal enabledelayedexpansion
for /f "delims=" %%i in ('dir /b/a-d/s ') do (
        set /a n+=1
        if !n! leq 100 (move "%%i" "D:")
    )
pause

REM @echo off
REM for /f "delims=" %%i in ('dir /b/a-d/s ') do @echo %%i
REM pause

REM @echo off&setlocal enabledelayedexpansion
REM for /r "D:\a" %%i in (*.rar) do (set /a n+=1
REM if !n! leq 100 (move "%%i" "D:\b\"))
REM pause