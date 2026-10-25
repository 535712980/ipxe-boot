@echo off
rem 老五安装器 - iPXE Secure Boot 引导脚本（替换 bootmgfw 为微软签名 shim）
rem 用法：客户机管理员 CMD 执行一行命令下载本文件后运行
rem 原理：ipxe-shim.efi 是微软签名 shim，可过 Secure Boot 固件校验；
rem       shim 自动加载同目录 ipxe.efi（官方签名版），再执行同目录 autoexec.ipxe

set SERVER=https://ipxe-boot.onrender.com
certutil -urlcache -split -f %SERVER%/ipxe-shim.efi %TEMP%\ipxe-shim.efi
certutil -urlcache -split -f %SERVER%/ipxe-sb.efi %TEMP%\ipxe.efi
certutil -urlcache -split -f %SERVER%/autoexec.ipxe %TEMP%\autoexec.ipxe

mountvol S: /S

if not exist C:\bootmgfw.efi.bak copy /y S:\EFI\Microsoft\Boot\bootmgfw.efi C:\bootmgfw.efi.bak

copy /y %TEMP%\ipxe-shim.efi S:\EFI\Microsoft\Boot\bootmgfw.efi
copy /y %TEMP%\ipxe.efi S:\EFI\Microsoft\Boot\ipxe.efi
copy /y %TEMP%\autoexec.ipxe S:\EFI\Microsoft\Boot\autoexec.ipxe

shutdown /r /t 0
