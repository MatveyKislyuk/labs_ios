@echo off
set "start_directory=%~dp0"
set "output_file=file_list.txt"
set "bat_file=%~nx0"
set "file_count=0"
if exist "%output_file%" del "%output_file%"

for /r "%start_directory%" %%F in (*) do (
    if exist "%%F" (
        if /I not "%%~nxF"=="%bat_file%" (
      echo %%F
            echo %%F >> "%output_file%"
            type "%%F" >> "%output_file%"
            echo. >> "%output_file%"
      set /a file_count+=1

        )
    )
)
echo total: %file_count%
echo saved in: %output_file%.
pause
