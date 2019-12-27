@echo off
@set unity="C:\Program Files\Unity5.6.3\Editor\Unity.exe"
@set projectPath="D:\Vesal\vesal_pc_unity"
@set exportGooGleProjectPath="D:\git\unityAndPorjectOutput\Vesal3DAnatomy\assets\"

@set startTime=%time%

echo switch to dev branch
git -C %projectPath% checkout dev
rem git -C %projectPath% pull origin vesal_mobile_branch
git -C %projectPath% pull origin dev
echo exporting Goggle project...（see code in Commandbuild.cs）
CALL %unity%  -batchmode -quit -nographics -executeMethod Commandbuild.BuildAndroid  -logFile ./UnityEditor.log -projectPath  %projectPath%
echo export down!
rd /s /q .\android\app\src\main\assets\bin
rd /s /q .\android\app\build\intermediates
xcopy %exportGooGleProjectPath%*  .\android\app\src\main\assets\ /s /y

rem 更新react
git pull
rem 生成react bundle
rem react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res
rem 构建安卓apK(自动更新bundle)
echo gradlew assembleRelease
cd android
CALL ./gradlew assembleRelease --stacktrace --console plain
rem 开启项目
start app\build\outputs\apk
cd app\build\outputs\apk
start ./app-release.apk

@set endTime=%time%
echo starttime:%startTime%
echo endTime:%endTime%
rem echo total use time :%time3% s
rem echo start MainActivity
rem adb shell am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n com.vesal.sport/com.vesal.sport.MainActivity
pause
