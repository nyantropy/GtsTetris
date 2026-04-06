cmake_minimum_required(VERSION 3.20)
project(Tetris LANGUAGES CXX)

if(POLICY CMP0205)
    cmake_policy(SET CMP0205 NEW)
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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
