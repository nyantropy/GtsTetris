@echo off
setlocal
set "ROOT_DIR=%~dp0"
cd /d "%ROOT_DIR%"

echo Initializing submodules...
git submodule update --init --recursive
if errorlevel 1 goto :fail

if not exist build mkdir build
if errorlevel 1 goto :fail

cd build
if errorlevel 1 goto :fail

echo Configuring CMake...
cmake .. -G "MinGW Makefiles" ^
 -DCMAKE_BUILD_TYPE=Release ^
 -DCMAKE_EXE_LINKER_FLAGS="-static -static-libgcc -static-libstdc++"
if errorlevel 1 goto :fail

echo Building project...
mingw32-make
if errorlevel 1 goto :fail

cd /d "%ROOT_DIR%"
if errorlevel 1 goto :fail

echo.
echo Build complete!
echo Executable: build\Tetris.exe
pause
exit /b 0

:fail
echo.
echo Build failed. Make sure Git, CMake, MinGW, and mingw32-make are installed and available in PATH.
cd /d "%ROOT_DIR%"
pause
exit /b 1
