@echo off
for /f "delims=" %%i in ('dir /b/a-d/s ') do @echo %%i
pause