@echo off
@set unity="D:\Program Files\unity2017.2.0.f3\Editor\Unity.exe"
@set projectPath="D:\UnityWorkSpace\UnityPC\VesalUnityCombine_user"
@set exportWindowsExePath="D:\git\unityAndPorjectOutput\Vesal3DAnatomy\assets\"
@set targetUnityPath="D:\vesal\pc_export"

rem switch to dev branch
git -C %projectPath% checkout dev
git -C %projectPath% pull origin dev

rem exporting Goggle project...（see code in Commandbuild.cs）
CALL %unity%  -batchmode -quit -nographics -executeMethod Commandbuild.BuildAndroid  -logFile ./UnityEditor.log -projectPath  %projectPath%

rem replace files!
rd /s /q .\android\app\src\main\assets\bin
move %exportGooGleProjectPath% %targetUnityPath%


rem export react-native bundle!

rem re-build-x86-release bin file

rem add extral file(wget.exe etc)

rem move resource file to target path
