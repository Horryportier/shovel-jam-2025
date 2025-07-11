#! /bin/bash

## WARNIG SudOku  dont run this you dont have it set up 

project_name=""

godot --export-release "Web" ./exports/web/index.html
zip -r ./exports/web.zip ./exports/web
butler push ./exports/web.zip  horryportier/{$project_name}:html5

if [[ $1 == "web" ]]; then
	exit 0
fi

godot --export-release "Linux" ./exports/linux/{$project_name}.x86_64
zip -r ./exports/{$project_name}_linux.zip ./exports/linux/
butler push ./exports/{$project_name}_linux.zip  horryportier/{$project_name}:linux

godot --export-release "Windows Desktop" ./exports/windows/{$project_name}.exe
zip -r ./exports/{$project_name}_windows.zip ./exports/windows/
butler push ./exports/{$project_name}_windows.zip  horryportier/{$project_name}:win
