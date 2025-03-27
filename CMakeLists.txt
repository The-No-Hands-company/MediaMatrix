cmake_minimum_required(VERSION 3.31.6)
project(mediamatrix)

# Find required packages
find_package(Qt6 COMPONENTS Core Gui Widgets REQUIRED)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable Qt features
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Set GnuCOBOL paths
set(GNUCOBOL_DIR "C:/GnuCOBOL")
set(GNUCOBOL_INCLUDE_DIR "${GNUCOBOL_DIR}/include")
set(GNUCOBOL_LIB_DIR "${GNUCOBOL_DIR}/lib_x64")

# Add include directories
include_directories(
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/include/mediamatrix
    ${CMAKE_SOURCE_DIR}/include/mediamatrix/core
    ${GNUCOBOL_INCLUDE_DIR}
)

# C wrapper library
add_library(mm_wrapper SHARED
    src/core/mm_wrapper.c
)

target_include_directories(mm_wrapper PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/include/mediamatrix
    ${CMAKE_SOURCE_DIR}/include/mediamatrix/core
    ${GNUCOBOL_INCLUDE_DIR}
)

# Link against the COBOL library
target_link_libraries(mm_wrapper PRIVATE
    ${CMAKE_BINARY_DIR}/mediamatrix.lib
    ${GNUCOBOL_LIB_DIR}/libcob.lib
)

# GUI executable
set(GUI_SOURCES
    src/gui/main.cpp
    src/gui/mm_main_window.cpp
    src/gui/mm_item_dialog.cpp
)

set(GUI_HEADERS
    include/mediamatrix/gui/mm_main_window.h
    include/mediamatrix/gui/mm_item_dialog.h
)

add_executable(mediamatrix_gui ${GUI_SOURCES} ${GUI_HEADERS})

target_include_directories(mediamatrix_gui PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/include/mediamatrix
    ${CMAKE_SOURCE_DIR}/include/mediamatrix/core
    "D:/Qt/6.8.1/msvc2022_64/include"
    "D:/Qt/6.8.1/msvc2022_64/include/QtCore"
    "D:/Qt/6.8.1/msvc2022_64/include/QtGui"
    "D:/Qt/6.8.1/msvc2022_64/include/QtWidgets"
)

target_link_libraries(mediamatrix_gui PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    mm_wrapper
)

# Console application
add_library(mediamatrix_console SHARED
    src/core/mm_wrapper.c
)

target_include_directories(mediamatrix_console PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/include/mediamatrix
    ${CMAKE_SOURCE_DIR}/include/mediamatrix/core
    ${GNUCOBOL_INCLUDE_DIR}
)

target_link_libraries(mediamatrix_console PRIVATE
    mm_wrapper
    ${CMAKE_BINARY_DIR}/mediamatrix.lib
    ${GNUCOBOL_LIB_DIR}/libcob.lib
)

# Copy DLLs and plugins to output directory
add_custom_command(TARGET mediamatrix_gui POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:Qt6::Core>
        $<TARGET_FILE:Qt6::Gui>
        $<TARGET_FILE:Qt6::Widgets>
        ${CMAKE_BINARY_DIR}/mediamatrix.dll
        $<TARGET_FILE_DIR:mediamatrix_gui>
    COMMAND ${CMAKE_COMMAND} -E make_directory
        $<TARGET_FILE_DIR:mediamatrix_gui>/plugins/platforms
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${Qt6_DIR}/../../../plugins/platforms
        $<TARGET_FILE_DIR:mediamatrix_gui>/plugins/platforms
)

# Create qt.conf file
file(WRITE ${CMAKE_BINARY_DIR}/qt.conf "[Paths]\nPlugins = ./plugins")
add_custom_command(TARGET mediamatrix_gui POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_BINARY_DIR}/qt.conf
        $<TARGET_FILE_DIR:mediamatrix_gui>/qt.conf
)

# Create data directory
add_custom_command(TARGET mediamatrix_gui POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory
        $<TARGET_FILE_DIR:mediamatrix_gui>/data
)

# Copy GnuCOBOL DLLs to output directory
add_custom_command(TARGET mediamatrix_gui POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${GNUCOBOL_DIR}/bin_x64/libcob.dll"
        "${GNUCOBOL_DIR}/bin_x64/libdb48.dll"
        "${GNUCOBOL_DIR}/bin_x64/liblzma.dll"
        "${GNUCOBOL_DIR}/bin_x64/libxml2.dll"
        "${GNUCOBOL_DIR}/bin_x64/mpir.dll"
        "${GNUCOBOL_DIR}/bin_x64/pdcurses.dll"
        "${GNUCOBOL_DIR}/bin_x64/zlib1.dll"
        $<TARGET_FILE_DIR:mediamatrix_gui>
)

# Copy Qt plugins to output directory
add_custom_command(TARGET mediamatrix_gui POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_FILE_DIR:mediamatrix_gui>/plugins"
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_FILE_DIR:mediamatrix_gui>/plugins/platforms"
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_FILE_DIR:mediamatrix_gui>/plugins/styles"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${Qt6_DIR}/../../../plugins/platforms/qwindows.dll"
        "$<TARGET_FILE_DIR:mediamatrix_gui>/plugins/platforms/"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${Qt6_DIR}/../../../plugins/styles/qmodernwindowsstyle.dll"
        "$<TARGET_FILE_DIR:mediamatrix_gui>/plugins/styles/"
) 