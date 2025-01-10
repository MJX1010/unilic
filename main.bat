@echo off

chcp 65001

setlocal enabledelayedexpansion

set /p unityExePath=请将Unity.exe的路径拖放到此BAT窗口中，然后按回车键：
if not defined unityExePath (
    echo 未输入Unity.exe的路径,请重新输入。
    set /p unityExePath=请将Unity.exe的路径拖放到此BAT窗口中，然后按回车键：
)

REM 注释1
goto remove1
= set "unityExePath=%~1"
= if not defined unityExePath (
=    echo 请将Unity.exe的路径拖放到此BAT窗口中。
=    pause
=    exit /b 1
=)
:remove1

REM 注释2
goto remove2
= set /p input=请确认Unity.exe路径是否正确（%unityExePath%），如果正确请按回车键继续，否则请输入新的路径：
= if not "%input%"=="" set "unityExePath=%input%"
:remove2

set "dllPath=%unityExePath%\..\Data\Resources\Licensing\Client\Unity.Licensing.EntitlementResolver.dll"
set "patchExePath=%~dp0patch-windows-amd64.exe"
set "signExePath=%~dp0sign-windows-amd64.exe"

set "patchResult=1"
set "signResult=1"

if exist "%unityExePath%" (
    echo "%dllPath%"
    if exist "%dllPath%" (
        echo "%patchExePath%"
        if exist "%patchExePath%" (

            echo 即将执行patch操作，按任意键继续...
            pause

            "%patchExePath%" "%dllPath%"
            if %errorlevel% equ 0 (
                set "patchResult=0"
                echo Patch operation successful.
            ) else (
                echo Patch operation failed.
            )
        ) else (
            echo patch-windows-amd64.exe not found in the bat file directory.
        )

        echo !patchResult!
        if !patchResult! == 0 (
            set "signResult=1"
            set /p input=是否继续执行sign操作（y/n）：
            if /i "!input!"=="y" (
                echo "%signExePath%"
                if exist "%signExePath%" (
                    "%signExePath%" "%dllPath%"
                    if %errorlevel% equ 0 (
                        set "signResult=0"
                        echo Sign operation successful.
                    ) else (
                        echo Sign operation failed.
                    )
                ) else (
                    echo sign-windows-amd64.exe not found in the bat file directory.
                )
            ) else (
                echo 已取消sign操作
            )
        ) else (
            echo patch流程出错
        )
    ) else (
        echo The specified DLL file does not exist.
    )
) else (
    echo The specified Unity.exe file does not exist.
)

if !patchResult! == 0 if !signResult! == 0 (
    echo 破解成功
) else (
    echo 破解失败
)


endlocal

pause