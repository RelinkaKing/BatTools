@echo off
@set unity="D:\Program Files\unity2017.2.0.f3\Editor\Unity.exe"
@set projectPath="D:\UnityWorkSpace\UnityPC\VesalUnityCombine_user"
@set exportGooGleProjectPath="D:\git\unityAndPorjectOutput\Vesal3DAnatomy\assets\"
@set targetUnityPath="D:\git\unityAndPorjectOutput\Vesal3DAnatomy\assets\"


rem switch to dev branch
git -C %projectPath% checkout dev
git -C %projectPath% pull origin dev

rem exporting Goggle project...（see code in Commandbuild.cs）
CALL %unity%  -batchmode -quit -nographics -executeMethod Commandbuild.BuildAndroid  -logFile ./UnityEditor.log -projectPath  %projectPath%

rem replace files!
rd /s /q .\android\app\src\main\assets\bin
move %exportGooGleProjectPath% %targetUnityPath%



rem export react-native bundle!

rem re-build 