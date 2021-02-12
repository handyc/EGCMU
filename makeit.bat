@echo off

if not exist rsrc.rc goto over1
C:\masm32\BIN\Rc.exe /v rsrc.rc
C:\masm32\BIN\Cvtres.exe /machine:ix86 rsrc.res
:over1

if exist %1.obj del egcmu.obj
if exist %1.exe del egcmu.exe

C:\masm32\BIN\Ml.exe /c /coff egcmu.asm
if errorlevel 1 goto errasm

if not exist rsrc.obj goto nores

C:\masm32\BIN\Link.exe /SUBSYSTEM:WINDOWS egcmu.obj rsrc.obj
if errorlevel 1 goto errlink

pause

dir egcmu
goto TheEnd

:nores
C:\masm32\BIN\Link.exe /SUBSYSTEM:WINDOWS egcmu.obj
if errorlevel 1 goto errlink
dir %1
goto TheEnd

:errlink
echo _
echo Link error
goto TheEnd

:errasm
echo _
echo Assembly Error
goto TheEnd

:TheEnd

pause

