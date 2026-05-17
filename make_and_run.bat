@echo off

REM // Convenience batch script to build the ROM and open it in the default emulator if compilation succeeds.
REM // Requires ".bin" files to be associated with an emulator.

call make.bat
if exist s1built.bin (
    start "" s1built.bin
)