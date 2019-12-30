@echo off
@set unity="D:\Program Files\unity2017.2.0.f3\Editor\Unity.exe"
@set unityProjectPath="D:\UnityWorkSpace\UnityPC\VesalUnityCombine_user"
@set unityBranch=dev
@set reactProjectPath="D:\Vesal\Vesal_PC_user\wpf_new"
@set reactBranch=vesal_user

@set mainAssetsPath=".\Vesal_PC\bin\x86\ReleaseBundle"
@set exportWindowsExePath=".\Vesal_PC\bin\x86\ReleaseBundle\win"
@set reactAssetsPath=".\Vesal_PC\bin\x86\ReleaseBundle\ReactAssets"

rem 切换分支 %unityBranch% branch
git -C %unityProjectPath% checkout %unityBranch%
git -C %unityProjectPath% pull origin %unityBranch%
rem 切换分支 %reactBranch% branch
git -C %reactProjectPath% checkout %reactBranch%
git -C %reactProjectPath% pull origin %reactBranch%

rem 删除版本文件 delete ReleaseBundle
rd /Q /S %mainAssetsPath%

rem 1. 创建window原生应用程序 re-build-x86-releasebundle bin file
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\VsDevCmd.bat"
msbuild /p:Configuration=ReleaseBundle;Platform=x86 /target:Clean;Rebuild

rem 2. 导出react bundle文件 export react-native bundle! copy ReactAssets to releasebundle 
react-native bundle --platform windows --entry-file index.js --dev false --bundle-output wpf/Vesal_PC/ReactAssets\/index.wpf.bundle  --assets-dest wpf/Vesal_PC/ReactAssets/
echo D | xcopy .\Vesal_PC\ReactAssets  %reactAssetsPath% /s /y

rem 3. 添加下载库文件 add extral file(wget.exe etc)
echo D | xcopy .\build_extral .\Vesal_PC\bin\x86\ReleaseBundle /s /y

rem 4. 导出unity到指定目录 exporting windows application exe file...（see code in Commandbuild.cs）
call %unity%  -batchmode -quit -nographics -executeMethod Commandbuild.BuildAndroid  -logFile ./UnityEditor.log -projectPath  %exportWindowsExePath%

rem 构建完成 build complete
cd %mainAssetsPath%
start ..\
