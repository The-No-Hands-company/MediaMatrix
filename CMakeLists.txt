cmake_minimum_required(VERSION 3.10)
project(collector)

# Find required Qt packages
find_package(Qt6 COMPONENTS Core Widgets REQUIRED)

# Set Qt paths
set(QT_DIR "D:/Qt/6.8.1/msvc2022_64")
set(QT_BIN_DIR "${QT_DIR}/bin")
set(QT_PLUGINS_DIR "${QT_DIR}/plugins")

# Set COBOL paths
set(COBOL_INCLUDE_DIR "C:/GnuCOBOL/include")
set(COBOL_LIB_DIR "C:/GnuCOBOL/lib_x64")

# Add include directories
include_directories(${COBOL_INCLUDE_DIR} include)

# Create data files if they don't exist
foreach(DATA_FILE movies.dat tvseries.dat anime.dat games.dat manga.dat comics.dat books.dat magazines.dat)
    if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data/${DATA_FILE}")
        file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/data/${DATA_FILE}" "")
    endif()
endforeach()

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Set output directories for all configurations
foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
endforeach()

# Create shared library for collector_wrapper
add_library(collector_wrapper_lib SHARED
    src/c/collector_wrapper.c
)

target_link_libraries(collector_wrapper_lib
    "${COBOL_LIB_DIR}/libcob.lib"
)

# Create GUI executable
add_executable(collector_gui
    src/cpp/collector_gui.cpp
    include/item_dialog.h
)

# Enable Qt features for collector_gui
set_target_properties(collector_gui PROPERTIES
    AUTOMOC ON
    AUTORCC ON
    AUTOUIC ON
    WIN32_EXECUTABLE ON
    OUTPUT_NAME "collector_gui"
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

target_link_libraries(collector_gui
    collector_wrapper_lib
    Qt6::Core
    Qt6::Widgets
)

# Create console executable
add_executable(collector_wrapper
    src/c/collector_wrapper.c
)

set_target_properties(collector_wrapper PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

target_link_libraries(collector_wrapper
    "${COBOL_LIB_DIR}/libcob.lib"
)

# Add custom commands to copy Qt DLLs and plugins post-build
add_custom_command(TARGET collector_gui POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_FILE_DIR:collector_gui>/platforms"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${QT_BIN_DIR}/Qt6Core.dll"
        "${QT_BIN_DIR}/Qt6Gui.dll"
        "${QT_BIN_DIR}/Qt6Widgets.dll"
        "$<TARGET_FILE_DIR:collector_gui>"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${QT_PLUGINS_DIR}/platforms/qwindows.dll"
        "$<TARGET_FILE_DIR:collector_gui>/platforms"
) 