#! /bin/bash

## WARNIG SudOku  dont run this you dont have it set up 

project_name="carcinisation"

godot --export-release "Web" ./exports/web/index.html
zip -r ./exports/web.zip ./exports/web
butler push ./exports/web.zip  horryportier/$project_name:html5



godot --export-release "Linux" ./exports/linux/$project_name.x86_64
zip -r ./exports/linux.zip ./exports/linux/
butler push ./exports/linux.zip  horryportier/$project_name:linux

godot --export-release "Windows Desktop" ./exports/windows/$project_name.exe
zip -r ./exports/windows.zip ./exports/windows/
butler push ./exports/windows.zip  horryportier/$project_name:win
