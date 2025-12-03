@echo off
if exist sound\z80.bin move /y sound\z80.bin sound\z80.prev.bin >NUL
tool\windows\sjasmplus --lst=sound\z80.lst sound\z80.asm --raw=sound\z80.bin
if exist s1built.bin move /y s1built.bin s1built.prev.bin >NUL
tool\windows\asm68k /p /o ae-,l. main.asm, s1built.bin, , main.lst >main.log