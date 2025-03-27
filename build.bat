@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "BUILD_DIR=%SCRIPT_DIR%build"
set "RELEASE_DIR=%BUILD_DIR%\Release"
set "BIN_DIR=%SCRIPT_DIR%bin"
set "GNUCOBOL_PATH=C:\GnuCOBOL"

:: Initialize Visual Studio environment for x64
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

:: Set GnuCOBOL environment
set "PATH=%GNUCOBOL_PATH%\bin_x64;%PATH%"
set "COB_CFLAGS=-I%GNUCOBOL_PATH%\include"
set "COB_LDFLAGS=/LIBPATH:%GNUCOBOL_PATH%\lib_x64"
set "LIB=%GNUCOBOL_PATH%\lib_x64;%LIB%"

:: Create build directory if it doesn't exist
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

echo Compiling COBOL program...
cobc -v -m -o "%BUILD_DIR%\mediamatrix.dll" "%SCRIPT_DIR%\src\cobol\mediamatrix.cob"
if errorlevel 1 (
    echo Failed to compile COBOL program
    exit /b 1
)

:: Create DEF file for the DLL
echo LIBRARY mediamatrix > "%BUILD_DIR%\mediamatrix.def"
echo EXPORTS >> "%BUILD_DIR%\mediamatrix.def"
echo     list_items >> "%BUILD_DIR%\mediamatrix.def"
echo     add_item >> "%BUILD_DIR%\mediamatrix.def"
echo     edit_item >> "%BUILD_DIR%\mediamatrix.def"
echo     delete_item >> "%BUILD_DIR%\mediamatrix.def"

:: Generate import library with /NOEXP to prevent decorated names
lib /def:"%BUILD_DIR%\mediamatrix.def" /out:"%BUILD_DIR%\mediamatrix.lib" /machine:x64 /NOEXP
if errorlevel 1 (
    echo Failed to generate import library
    exit /b 1
)

:: Configure and build with CMake
cmake -S . -B "%BUILD_DIR%" -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 (
    echo Failed to configure CMake
    exit /b 1
)

cmake --build "%BUILD_DIR%" --config Release
if errorlevel 1 (
    echo Failed to build project
    exit /b 1
)

:: Copy DLLs and create necessary directories
if not exist "%RELEASE_DIR%\plugins" mkdir "%RELEASE_DIR%\plugins"
if not exist "%RELEASE_DIR%\data" mkdir "%RELEASE_DIR%\data"

:: Create qt.conf
echo [Paths] > "%RELEASE_DIR%\qt.conf"
echo Plugins = ./plugins >> "%RELEASE_DIR%\qt.conf"

copy "%BUILD_DIR%\mediamatrix.dll" "%RELEASE_DIR%"
copy "%BUILD_DIR%\mediamatrix.lib" "%RELEASE_DIR%"
copy "%GNUCOBOL_PATH%\lib_x64\libcob.lib" "%RELEASE_DIR%"

:: Copy GnuCOBOL and other required DLLs to output directory
copy "%GNUCOBOL_PATH%\bin_x64\libcob.dll" "%RELEASE_DIR%"
copy "%GNUCOBOL_PATH%\bin_x64\libdb48.dll" "%RELEASE_DIR%"
copy "%GNUCOBOL_PATH%\bin_x64\liblzma.dll" "%RELEASE_DIR%"
copy "%GNUCOBOL_PATH%\bin_x64\libxml2.dll" "%RELEASE_DIR%"
copy "%GNUCOBOL_PATH%\bin_x64\mpir.dll" "%RELEASE_DIR%"
copy "%GNUCOBOL_PATH%\bin_x64\pdcurses.dll" "%RELEASE_DIR%"
copy "%GNUCOBOL_PATH%\bin_x64\zlib1.dll" "%RELEASE_DIR%"
copy "%GNUCOBOL_PATH%\bin_x64\cjson.dll" "%RELEASE_DIR%"

echo Build completed successfully
echo.
echo To run the GUI application:
echo   %RELEASE_DIR%\mediamatrix_gui.exe
echo.
echo To run in console mode:
echo   %RELEASE_DIR%\mediamatrix_console.exe

endlocal