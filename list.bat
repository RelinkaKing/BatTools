@echo off

SET Obj_Length=2
SET Obj_Index=0
SET Obj[0].Name=Test1
SET Obj[1].Name=Test2


  
:LoopStart
    echo %Obj_Index% .. %Obj_Length%
    IF %Obj_Index% EQU %Obj_Length% GOTO :EOF
    
    SET Obj_Current.Name=0
    
    FOR /F "usebackq delims==. tokens=1-3" %%I IN (`SET Obj[%Obj_Index%]`) DO (
        SET Obj_Current.%%J=%%K
    )
    
    ECHO Name = %Obj_Current.Name%
    
    SET /A Obj_Index=%Obj_Index% + 1
    pause
    
echo 5
GOTO LoopStart

REM Name = Test1
REM Value = Hello World
 
REM Name = Test2
REM Value = blahblah