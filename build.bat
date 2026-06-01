@echo off

if exist "C:\Windows\System32\chcp.com" chcp 65001 >nul

REM --- CONFIGURACIÓN DE RUTAS ---
SET ISO_DIR="ISO"
SET KERNEL_NAME="pavilionix86.bin"

echo 1. Compilando código fuente...
nasm -f elf32 boot.asm -o boot.o >nul 2>&1
gcc -m32 -ffreestanding -fno-pic -fno-stack-protector -c kernel.c -o kernel.o >nul 2>&1

echo 2. Enlazando kernel con linker.ld...
ld -m elf_i386 -T linker.ld boot.o kernel.o -o %KERNEL_NAME% >nul 2>&1

echo 3. Actualizando imagen en $ISO_DIR...
REM Movemos el kernel recién compilado a la carpeta ISO
move %KERNEL_NAME% %ISO_DIR%/ >nul 2>&1

echo "4. Generando 1024OS.iso..."
REM Por si acaso. No ejecutar: mkisofs -as mkisofs -o 1024OS.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table %ISO_DIR% >nul 2>&1
mkisofs -o 1024OS.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table ISO >nul 2>&1

echo "5. Limpiando archivos temporales..."
del "*.o" >nul 2>&1

if "%errorlevel%"=="0" (
    echo ¡Listo! 1024OS.iso ha sido generado exitosamente.
) else (
    echo Se ha producido un error.
)
pause >nul