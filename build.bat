echo gradlew assembleRelease
cd android
CALL ./gradlew assembleRelease  --stacktrace --console plain
pause
rem ������Ŀ
rem start app\build\outputs\apk
rem cd app\build\outputs\apk
rem start ./app-release.apk