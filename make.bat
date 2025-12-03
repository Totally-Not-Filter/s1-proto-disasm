@echo off
if exist s1built.bin move /y s1built.bin s1built.prev.bin >NUL
tool\windows\asw -xx -q -A -L -U -E -i . main.asm
tool\windows\p2bin -p=FF -z=0,uncompressed,Size_of_DAC_driver_guess,after main.p s1built.bin
del main.p