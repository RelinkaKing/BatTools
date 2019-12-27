@echo off & setlocal enabledelayedexpansion
REM set unZipName="C:/Users/Raytine/Desktop/zipfile/RA0801001.zip"
REM set zipName="C:/Users/Raytine/Desktop/zipfile/RA0801001"

set unZipName=%1%
set zipName=%2%
set mode=%3%

if mode==0 (
    call zip_simple
) ELSE (
    if mode==1(
        call zip_with_file
    ) else (
        call unzip
    )
)

REM goto zip_with_file
REM call :file_path

:zip_with_file
    rem 压缩当前文件包含文件夹
    echo zip_with_file "C:/Program Files/7-Zip/7z.exe a -tzip %unZipName% %zipName%"
    "C:/Program Files/7-Zip/7z.exe" a -tzip %unZipName% %zipName% -r -mmt=on
    goto :EOF

:zip_simple
    echo zip_simple "C:/Program Files/7-Zip/7z.exe a -tzip %unZipName% %zipName%"
    echo "%zipName:"=%/*"
    "C:/Program Files/7-Zip/7z.exe" a -tzip %unZipName% "%zipName:"=%/*" -r -mmt=on
    goto :EOF
    

:unzip
    echo un_zip "C:/Program Files/7-Zip/7z.exe x %unZipName% -o%zipName%"
    "C:/Program Files/7-Zip/7z.exe" x %unZipName% -o%zipName%
    goto :EOF

:file_path
    echo 当前盘符：%~d0
    echo 当前盘符和路径：%~dp0
    echo 当前批处理全路径：%~f0
    echo 当前盘符和路径的短文件名格式：%~sdp0
    echo 当前CMD默认目录：%cd%
    echo 目录中有空格也可以加入""避免找不到路径
    echo 当前盘符："%~d0"
    echo 当前盘符和路径："%~dp0"
    echo 当前批处理全路径："%~f0"
    echo 当前盘符和路径的短文件名格式："%~sdp0"
    echo 当前CMD默认目录："%cd%"
    goto :EOF