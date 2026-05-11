@ECHO OFF

REM // This file has been gutted and replaced with the Lua make script.
REM // It has been kept around for ease-of-use for Windows users.
"tools/Lua/lua.exe" make.lua || pause REM // Pause on Lua parse failure so that the user can read the error message.
