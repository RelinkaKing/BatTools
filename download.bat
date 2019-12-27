@echo off & setlocal enabledelayedexpansion

title demo

call:download
goto:eof

echo download medical_zip
REM set Save=C:\Users\Raytine\Desktop\zipfile\img
set Save=C:\Users\Raytine\Desktop\zipfile\medical
REM set Url=http://fileprod.vesal.site/upload/unity3D/pc/zip/medical/v240/v2/RA0800001.zip

:callPythonOpearaJson
    echo get_file_urls..
    cmd "/c activate python3.6.4 && cd D:/MyFile/PythonWorkSpaces && python jsonOpera.py"

:CreateDownLoad_vbs
    echo CreateDownLoad_vbs........
    (echo Download Wscript.Arguments^(0^),Wscript.Arguments^(1^)
    echo Sub Download^(url,target^)
    echo   Const adTypeBinary = 1
    echo   Const adSaveCreateOverWrite = 2
    echo   Dim http,ado
    echo   Set http = CreateObject^("Msxml2.ServerXMLHTTP"^)
    echo   http.open "GET",url,False
    echo   http.send
    echo   Set ado = createobject^("Adodb.Stream"^)
    echo   ado.Type = adTypeBinary
    echo   ado.Open
    echo   ado.Write http.responseBody
    echo   ado.SaveToFile target
    echo   ado.Close
    echo End Sub)>DownloadFile.vbs
    REM pause
    goto download

:download
    echo ------download-------
    for /f "eol=/delims=" %%b in (./file/medical.txt) do (
        for %%a in ("%%b") do (
            set "FileName=%%~nxa"
            if not defined Save set "Save=%cd%"
            echo %FileName%
            echo download .. "%%b" "%Save%\!FileName!"
            DownloadFile.vbs "%%b" "%Save%\!FileName!"
        )
    )
    start %Save% 
    pause


:unzip_files
    :: 描述参数 %~1 - %~9
    REM dir C:\Users\Raytine\Desktop\zipfile\*.zip /s
    REM pause
    call zip.bat "C:/Users/Raytine/Desktop/zipfile/RA0801001.zip" "C:/Users/Raytine/Desktop/zipfile/RA0801001" 3
    REM for %%i in (C:\Users\Raytine\Desktop\zipfile\*.zip) do (
    REM     set var=%%i
    REM     echo %%i !var! !var:~0,-4!
    REM     call zip.bat "%%i" "!var:~0,-4!"
    REM )
    REM pause

:replace_zip
    echo unzip find .assetbundle get replace_file , excute replace_file,and zip file
    goto:eof

:replace_file
    echo.
    goto:eof

:download_simple
    echo -------download_simple--------
    DownloadFile.vbs "http://fileprod.vesal.site/upload/unity3D/android/zip/medical/v240/v2/RA0801001.zip" "C:\Users\Raytine\Desktop\zipfile\RA0801001.zip"
    goto:eof