@echo off
IF EXIST sound\z80.bin move /Y sound\z80.bin sound\z80.prev.bin >NUL
tool\windows\sjasmplus --lst=sound\z80.lst sound\z80.asm --raw=sound\z80.bin
IF EXIST s1built.bin move /Y s1built.bin s1built.prev.bin >NUL
tool\windows\asm68k /p /o ae-,l. main.asm, s1built.bin, , main.lst > main.log