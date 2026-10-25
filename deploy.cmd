@echo off
echo ============================================
echo   LaoWuPE Deploy iPXE to ESP (Secure Boot)
echo ============================================
echo.

rem --- Step 1: check files exist in X:\ (or already renamed) ---
if not exist X:\ipxe-shim.efi if not exist X:\bootmgfw.efi goto missing
if not exist X:\ipxe-sb.efi if not exist X:\ipxe.efi goto missing
if not exist X:\autoexec.ipxe goto missing

rem --- Step 2: rename downloaded files ---
if exist X:\ipxe-shim.efi ren X:\ipxe-shim.efi bootmgfw.efi
if exist X:\ipxe-sb.efi ren X:\ipxe-sb.efi ipxe.efi

rem --- Step 3: mount ESP as S: ---
mountvol S: /S
if not exist S:\EFI\Microsoft\Boot\ goto noesp

rem --- Step 4: backup original bootmgfw.efi ---
if not exist S:\bootmgfw_orig.efi copy /y S:\EFI\Microsoft\Boot\bootmgfw.efi S:\bootmgfw_orig.efi

rem --- Step 5: copy iPXE files into ESP ---
copy /y X:\bootmgfw.efi S:\EFI\Microsoft\Boot\bootmgfw.efi
copy /y X:\ipxe.efi S:\EFI\Microsoft\Boot\ipxe.efi
copy /y X:\autoexec.ipxe S:\EFI\Microsoft\Boot\autoexec.ipxe

rem --- Step 6: verify ---
echo.
echo Files in ESP:
dir S:\EFI\Microsoft\Boot\bootmgfw.efi S:\EFI\Microsoft\Boot\ipxe.efi S:\EFI\Microsoft\Boot\autoexec.ipxe

echo.
echo ============================================
echo   Done. Check output above, then type:
echo       wpeutil reboot
echo ============================================
pause
exit /b

:missing
echo ERROR: files not found in X:\
echo Need: ipxe-shim.efi (or bootmgfw.efi), ipxe-sb.efi (or ipxe.efi), autoexec.ipxe
echo Please download them first via dl.html
pause
exit /b

:noesp
echo ERROR: ESP mount failed - S:\EFI\Microsoft\Boot not found
pause
exit /b
