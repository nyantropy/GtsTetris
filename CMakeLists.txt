cmake_minimum_required(VERSION 3.20)
project(Tetris LANGUAGES CXX)

if(POLICY CMP0205)
    cmake_policy(SET CMP0205 NEW)
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

function(gts_ensure_path_link link_path target_path)
    if(NOT EXISTS "${link_path}")
        file(CREATE_LINK "${target_path}" "${link_path}" SYMBOLIC COPY_ON_ERROR)
    endif()
endfunction()

# The engine's CMake uses CMAKE_SOURCE_DIR internally. These links preserve the
# expected top-level layout without changing anything inside /engine.
gts_ensure_path_link(
    "${CMAKE_CURRENT_SOURCE_DIR}/shaders"
    "${CMAKE_CURRENT_SOURCE_DIR}/engine/shaders"
)
gts_ensure_path_link(
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/fonts"
    "${CMAKE_CURRENT_SOURCE_DIR}/engine/resources/fonts"
)
gts_ensure_path_link(
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/models"
    "${CMAKE_CURRENT_SOURCE_DIR}/engine/resources/models"
)
gts_ensure_path_link(
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/textures"
    "${CMAKE_CURRENT_SOURCE_DIR}/engine/resources/textures"
)

file(GLOB_RECURSE ENGINE_HEADERS CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/engine/engine/*.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/engine/engine/*.h"
)

set(ENGINE_COMPAT_INCLUDE_DIRS
    "${CMAKE_CURRENT_SOURCE_DIR}/engine/external/stb"
    "${CMAKE_CURRENT_SOURCE_DIR}/engine/external/glm/glm"
)

foreach(header_path IN LISTS ENGINE_HEADERS)
    get_filename_component(header_dir "${header_path}" DIRECTORY)
    list(APPEND ENGINE_COMPAT_INCLUDE_DIRS "${header_dir}")
endforeach()

list(REMOVE_DUPLICATES ENGINE_COMPAT_INCLUDE_DIRS)
include_directories(${ENGINE_COMPAT_INCLUDE_DIRS})

add_subdirectory(engine EXCLUDE_FROM_ALL)

set(GTS_ENGINE_TARGET "")
foreach(candidate IN ITEMS GtsEngine GravitasEngine gravitas_engine)
    if(TARGET "${candidate}")
        set(GTS_ENGINE_TARGET "${candidate}")
        break()
    endif()
endforeach()

if(NOT GTS_ENGINE_TARGET)
    message(FATAL_ERROR "Could not find an exported engine target after add_subdirectory(engine).")
endif()

message(STATUS "Linking Tetris against engine target: ${GTS_ENGINE_TARGET}")

file(GLOB_RECURSE GAME_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h"
)

add_executable(Tetris ${GAME_SOURCES})

target_include_directories(Tetris PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/engine"
)

target_link_libraries(Tetris PRIVATE "${GTS_ENGINE_TARGET}")

add_custom_command(TARGET Tetris POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    "${CMAKE_CURRENT_SOURCE_DIR}/resources"
    "$<TARGET_FILE_DIR:Tetris>/resources"
)

set_target_properties(Tetris PROPERTIES
    VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)

if (WIN32)
    set_target_properties(Tetris PROPERTIES OUTPUT_NAME "Tetris.exe")
endif()
