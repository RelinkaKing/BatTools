mkdir C:\VesalPPT >nul

if %run_mode% == need_install (
	if %Vesal_Install_Path%haha  == haha (
	rem ��� Vesal_Install_Path ���������ǿյģ���Ҫ��װ���Ų��
		echo ��װ���Ų��
		..\VesalPlayer\VesalPlayerSetup.exe
	) else (
		echo ���Ų���Ѿ���װ
	)
) else (
	echo n|comp C:\VesalPPT\Unity.zip ..\VesalPlayer\"Application Data"\Vesal\PPT\Unity.zip >nul 2>&1
	if errorlevel 1 (
		del C:\VesalPPT\*.exe
		rd /Q /S C:\VesalPPT\vesal_3D_ppt_unity_Data
		copy ..\VesalPlayer\"Application Data"\Vesal\PPT\Unity.zip C:\VesalPPT
		..\VesalPlayer\"Application Data"\Vesal\PPT\unzip.exe C:\VesalPPT\Unity.zip -d C:\VesalPPT
	) else (
		echo unity �������
	)
	copy ..\VesalPlayer\*.conf C:\VesalPPT
	copy ..\VesalPlayer\*.exe C:\VesalPPT
	copy ..\VesalPlayer\tmp.dat C:\VesalPPT
)

echo n|comp %bat_name%\%bat_name%.ppt C:\VesalPPT\%bat_name%.ppt >nul 2>&1
if errorlevel 1 (
    copy %bat_name%\%bat_name%.ppt C:\VesalPPT
)

echo n|comp %bat_name%\%bat_name%.pptx C:\VesalPPT\%bat_name%.pptx >nul 2>&1
if errorlevel 1 (
    copy %bat_name%\%bat_name%.pptx C:\VesalPPT
)

echo n|comp %bat_name%\vesal.dat C:\VesalPPT\vesal.dat >nul 2>&1
if errorlevel 1 (
    copy %bat_name%\vesal.dat C:\VesalPPT
)

echo n|comp %bat_name%\vesalvesal.dat C:\VesalPPT\vesalvesal.dat >nul 2>&1
if errorlevel 1 (
    copy %bat_name%\vesalvesal.dat C:\VesalPPT
)

rem ��������ģ����
mkdir C:\VesalPPT\com_mod

echo n|comp %bat_name%\common_vesal.dat C:\VesalPPT\com_mod\common_vesal.dat >nul 2>&1
if errorlevel 1 (
    copy %bat_name%\common_vesal.dat C:\VesalPPT\com_mod
)

echo n|comp %bat_name%\common_vesalvesal.dat C:\VesalPPT\com_mod\common_vesalvesal.dat >nul 2>&1
if errorlevel 1 (
    copy %bat_name%\common_vesalvesal.dat C:\VesalPPT\com_mod
)

echo n|comp %bat_name%\vesali.db C:\VesalPPT\com_mod\vesali.db >nul 2>&1
if errorlevel 1 (
    copy %bat_name%\vesali.db C:\VesalPPT\com_mod
)

if %run_mode% == no_install (
    start "" C:\VesalPPT\vesal_3D_ppt_unity.exe
)
rem ����ppt
C:\VesalPPT\%bat_name%.ppt
C:\VesalPPT\%bat_name%.pptx

if %run_mode% == no_install (
    taskkill /f /im vesal_3D_ppt_unity.exe
    C:\VesalPPT\renwulan.exe
)
