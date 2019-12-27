@echo off
set vi_path=%vesal_install_path%
if %vi_path:~-1%hehe NEQ \hehe (
    set vi_path=%vi_path%\
)

set v_path=%vesal_path%
if %v_path:~-1%hehe NEQ \hehe (
    set v_path=%v_path%\
)

rem 升级插件
copy /y VesalDigital\PPT\* %vi_path%
xcopy "Application Data"\Vesal\PPT\* %v_path% /s /y
cd %v_path%
rd /Q /S vesal_3D_ppt_unity_Data
unzip.exe -o Unity.zip

echo =======
echo () ()
echo (' ')
echo (   )
echo "" ""
echo 升级完毕
echo =======

