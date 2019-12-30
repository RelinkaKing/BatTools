@echo start...

rem svn up
rem svn up
rem cd ..\Model_3d\Release
rem svn up
rem cd ..\..\PPTPlugin
rem 更新install
rem git -C C:\install\ pull

rem clean player
rd /Q /S VesalPlayerPlugin2010\VesalPlayerPlugin2010\bin
rd /Q /S VesalPlayerPlugin2010\VesalPlayerPlugin2010\obj

rd /Q /S VesalPlayerPlugin2010\VesalPlayerSetup\VesalPlayerSetup

del C:\install\Unity\*.zip
del C:\install\VesalPlayer\*.zip

rem upgrader
rd /Q /S vesal_upgrade\vesal_upgrade\bin
rd /Q /S vesal_upgrade\vesal_upgrade\obj

rem plugin
rd /Q /S VesalPPTPlugin2010\VesalPPTPlugin2010\bin
rd /Q /S VesalPPTPlugin2010\VesalPPTPlugin2010\obj

rd /Q /S VesalPPTPlugin2010\Vesallib\bin
rd /Q /S VesalPPTPlugin2010\Vesallib\obj

rd /Q /S VesalPPTPlugin2010\VesalPPTPluginSetup\VesalPPTPluginSetup

rem 删除总setup程序
rd /Q /S VesalSetup\Debug\Debug

call "D:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\Tools\VsDevCmd.bat"

rem 编译总升级工具
cd VesalSetup
msbuild
move Debug\VesalSetup.exe C:\install
cd.. 

rem 编译升级工具
cd vesal_upgrade
msbuild
move vesal_upgrade\bin\Debug\vesal_upgrade.exe ..\..\Model_3d\Release
cd ..

rem 拷贝unity
cd ..\Model_3d\Release
del unity.zip
del renwulan.exe
copy C:\install\Unity\renwulan.exe .\
zip -r -q unity.zip *
move unity.zip C:\install\Unity
cd ..\..\PPTPlugin

rem 拷贝 3d 播放器
cd ..\Model_3d\new_ppt_player
del *.zip
zip -r -q VesalPlayer.zip *
move VesalPlayer.zip C:\install\VesalPlayer
cd ..\..\PPTPlugin


rem 完成最终版本
cd VesalPPTPlugin2010
msbuild
cd VesalPPTPluginSetup\VesalPPTPluginSetup\Express\DVD-5\DiskImages\DISK1
cd..
del *.exe
copy C:\install\VesalSetup.exe .
zip -r -q vesal_install.zip *

rem 只生成一个安装包，就是最新的
move vesal_install.zip C:\install\

rem cd D:\code\vesal_gongwang\pc_model\PPTPlugin
rem type Common\common_value.cs | findstr version_info > c:\install\pack_ver.txt


pause


