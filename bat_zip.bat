@echo off & setlocal enabledelayedexpansion

set rar=C:\Program Files\WinRAR\WinRar.exe
for /f "delims=" %%a in ('dir /a-d/s/b *.rar,*.zip') do (
set out=%%a 
echo "%%a" !out:~-13,9!
"C:/Program Files/7-Zip/7z.exe" x "%%~a" -o"!out:~-14,9!"
)
pause