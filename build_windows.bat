@echo off
setlocal
set "ROOT_DIR=%~dp0"
cd /d "%ROOT_DIR%"

where cmake >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo CMake not found. Please install CMake and add it to PATH.
    goto :fail
)

where ninja >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Ninja not found. Please install Ninja and add it to PATH.
    goto :fail
)

echo Initializing submodules...
git submodule update --init --recursive
if errorlevel 1 goto :fail

if not exist build mkdir build
if errorlevel 1 goto :fail

cd build
if errorlevel 1 goto :fail

echo Configuring CMake...
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 goto :fail

echo Building project...
cmake --build .
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
echo Build failed. Make sure Git, CMake, Ninja, and a supported C++ compiler are installed and available in PATH.
cd /d "%ROOT_DIR%"
pause
exit /b 1
