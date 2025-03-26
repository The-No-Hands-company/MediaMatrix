@echo off
echo Building Collector Application...

REM Clean up previous build
if exist build rmdir /s /q build
if exist collector.dll del collector.dll
if exist collector.lib del collector.lib
if exist collector.exp del collector.exp
if exist collector.def del collector.def

REM Initialize Visual Studio environment
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

REM Add GnuCOBOL to PATH and set include directory
set PATH=C:\GnuCOBOL\bin_x64;%PATH%
set INCLUDE=C:\GnuCOBOL\include;%INCLUDE%

REM Create build and bin directories
mkdir build
cd build
mkdir bin

REM Compile COBOL program
echo Compiling COBOL program...
cobc -v -b -free -fimplicit-init -I C:\GnuCOBOL\include -o collector.dll -L C:\GnuCOBOL\lib_x64 ..\src\cobol\collector.cob

REM Create DEF file
echo Creating DEF file...
echo EXPORTS > collector.def
echo init_collector >> collector.def
echo cleanup_collector >> collector.def
echo add_movie >> collector.def
echo add_tvseries >> collector.def
echo add_anime >> collector.def
echo add_game >> collector.def
echo add_manga >> collector.def
echo add_comic >> collector.def
echo add_book >> collector.def
echo add_magazine >> collector.def
echo list_movies >> collector.def
echo list_tvseries >> collector.def
echo list_anime >> collector.def
echo list_games >> collector.def
echo list_manga >> collector.def
echo list_comics >> collector.def
echo list_books >> collector.def
echo list_magazines >> collector.def

REM Generate import library
echo Generating import library...
lib /def:collector.def /out:collector.lib /machine:x64

REM Configure with CMake
echo Configuring with CMake...
cmake .. -G "Visual Studio 17 2022" -A x64

REM Build the project
echo Building the project...
cmake --build . --config Release

REM Copy COBOL DLL and its dependencies
echo Copying DLLs...
copy collector.dll bin\
copy collector.lib bin\

REM Copy GnuCOBOL dependencies
echo Searching for DLLs in: C:\GnuCOBOL\bin_x64;C:\mingw64\bin;C:\msys64\mingw64\bin
for %%p in (C:\GnuCOBOL\bin_x64;C:\mingw64\bin;C:\msys64\mingw64\bin) do (
    if exist "%%p\libcob.dll" copy "%%p\libcob.dll" bin\
    if exist "%%p\libgcc_s_seh-1.dll" copy "%%p\libgcc_s_seh-1.dll" bin\
    if exist "%%p\mpir.dll" copy "%%p\mpir.dll" bin\
    if exist "%%p\libdb48.dll" copy "%%p\libdb48.dll" bin\
    if exist "%%p\pdcurses.dll" copy "%%p\pdcurses.dll" bin\
    if exist "%%p\iconv-2.dll" copy "%%p\iconv-2.dll" bin\
    if exist "%%p\libxml2.dll" copy "%%p\libxml2.dll" bin\
    if exist "%%p\liblzma.dll" copy "%%p\liblzma.dll" bin\
    if exist "%%p\zlib1.dll" copy "%%p\zlib1.dll" bin\
)

REM Copy Qt dependencies
echo Deploying Qt dependencies...
mkdir bin\platforms
copy "D:\Qt\6.8.1\msvc2022_64\bin\Qt6Core.dll" bin\
copy "D:\Qt\6.8.1\msvc2022_64\bin\Qt6Gui.dll" bin\
copy "D:\Qt\6.8.1\msvc2022_64\bin\Qt6Widgets.dll" bin\
copy "D:\Qt\6.8.1\msvc2022_64\plugins\platforms\qwindows.dll" bin\platforms\

cd ..

echo.
echo Building complete! You can now run:
echo bin\collector_gui.exe    - For GUI mode
echo bin\collector_wrapper.exe --console    - For console mode
echo.
pause 