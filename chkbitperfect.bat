@echo off
call tool/md5 s1built.bin md5
if "%md5%" equ "b06578c3412de1c5be765a59dec5ff1f" (
	echo MD5 identical!
) else (
	echo MD5 does not match.
)
pause