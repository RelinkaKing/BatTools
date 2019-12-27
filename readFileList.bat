@echo on & setlocal enabledelayedexpansion
set aa=0
for /f "eol=/delims=" %%b in (./file/1.txt) do (
    set /a "bds[!aa!] = %%b",aa=aa+1
    echo !aa!
) 
pause

REM for /l %%i in (1 1 10) do (
REM     set var=%%i
REM     echo !var! 
REM     echo %var% 
REM )
REM pause