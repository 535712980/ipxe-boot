@echo off
setlocal
echo ============================================
echo   LaoWuPE Deploy iPXE to MBR disk
echo ============================================
echo.
rem --- Step 1: check files in X:\ ---
if not exist X:\grldr     goto missing
if not exist X:\menu.lst  goto missing
if not exist X:\ipxe.lkrn goto missing
if not exist X:\grldr.mbr goto missing

rem --- Step 2: copy to C:\ (unchanged) ---
echo Copy files to C:\
copy /y X:\grldr     C:\grldr     || goto copyfail
copy /y X:\menu.lst  C:\menu.lst  || goto copyfail
copy /y X:\ipxe.lkrn C:\ipxe.lkrn || goto copyfail
copy /y X:\grldr.mbr C:\grldr.mbr || goto copyfail
echo.
echo Files on C:\
dir C:\grldr C:\menu.lst C:\ipxe.lkrn C:\grldr.mbr

rem --- Step 3: register GRUB4DOS in target system BCD ---
rem  (was: PowerShell writing MBR sector; MBR is NOT touched now)
echo.
echo Register GRUB4DOS entry in C:\Boot\BCD ...
if not exist C:\Boot\BCD goto nobcd
set GUID=
for /f "tokens=2 delims={}" %%A in ('bcdedit /store C:\Boot\BCD /create /d "LaoWuPE iPXE" /application bootsector') do set GUID={%%A}
if "%GUID%"=="" goto bcdfail
bcdedit /store C:\Boot\BCD /set %GUID% device partition=C:  || goto bcdfail
bcdedit /store C:\Boot\BCD /set %GUID% path \grldr.mbr      || goto bcdfail
bcdedit /store C:\Boot\BCD /displayorder %GUID% /addlast    || goto bcdfail
bcdedit /store C:\Boot\BCD /default %GUID%                  || goto bcdfail
bcdedit /store C:\Boot\BCD /timeout 3                       || goto bcdfail

echo.
echo Entry GUID: %GUID%
echo.
echo ============================================
echo   Done. Check output above, then type:
echo       wpeutil reboot
echo ============================================
echo.
echo Undo:  bcdedit /store C:\Boot\BCD /delete %GUID%
pause
exit /b

:missing
echo ERROR: files not found in X:\
echo Need: grldr, menu.lst, ipxe.lkrn, grldr.mbr
echo Download them first via dl-mbr.html
pause
exit /b

:copyfail
echo ERROR: copy to C:\ failed
pause
exit /b

:nobcd
echo ERROR: C:\Boot\BCD not found - not a BIOS/MBR Windows layout
pause
exit /b

:bcdfail
echo ERROR: bcdedit failed - entry not registered
pause
exit /b
