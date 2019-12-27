@echo off
set Url=http://fileprod.vesal.site/upload/unity3D/pc/zip/medical/v240/v2/RA0800001.zip
for %%a in ("%Url%") do set "FileName=%%~nxa" echo %FileName%
pause