cmake_minimum_required(VERSION 3.20)
project(Toy LANGUAGES CXX)

# ============================================================
# 1) Find MLIR / LLVM (once globally)
# ============================================================
find_package(MLIR REQUIRED CONFIG)

# ============================================================
# 2) Shared configuration target (inherits common settings)
# ============================================================
add_library(toy_common INTERFACE)

# Require C++20
target_compile_features(toy_common INTERFACE cxx_std_20)

# Disable warnings (only show errors)
if (MSVC)
    target_compile_options(toy_common INTERFACE /w)
else()
    target_compile_options(toy_common INTERFACE -w)
endif()

# Prefer lld when using Clang
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_link_options(toy_common INTERFACE -fuse-ld=lld)
endif()

# Link minimal MLIR pieces every chapter needs
target_link_libraries(toy_common INTERFACE
        MLIRIR
        MLIRSupport
)

# Include MLIR/LLVM directories (INTERFACE = inherited by dependents)
target_include_directories(toy_common INTERFACE
        ${MLIR_INCLUDE_DIRS}
        ${LLVM_INCLUDE_DIRS}
)

# ============================================================
# 3) Helper function: add_toy_chapter(NAME <name> SOURCES ... [LIBS ...])
# ============================================================
# 3) Helper function: add_toy_chapter(NAME <name> SOURCES ... [LIBS ...])
function(add_toy_chapter)
    set(options)
    set(oneValueArgs NAME)
    set(multiValueArgs SOURCES LIBS)
    cmake_parse_arguments(TOY "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT TOY_NAME)
        message(FATAL_ERROR "add_toy_chapter: missing required argument NAME")
    endif()
    if (NOT TOY_SOURCES)
        message(FATAL_ERROR "add_toy_chapter: missing required SOURCES list")
    endif()

    add_executable(${TOY_NAME} ${TOY_SOURCES})

    # ✅ Use the chapter's own include/ dir (this file is called from chapterN/)
    if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/include")
        target_include_directories(${TOY_NAME} PRIVATE
                "${CMAKE_CURRENT_SOURCE_DIR}/include"
        )
    endif()

    target_link_libraries(${TOY_NAME} PRIVATE toy_common)

    if (TOY_LIBS)
        target_link_libraries(${TOY_NAME} PRIVATE ${TOY_LIBS})
    endif()

    message(STATUS "Added Toy chapter target: ${TOY_NAME} (includes: ${CMAKE_CURRENT_SOURCE_DIR}/include)")
endfunction()

# ============================================================
# 4) Add all chapters
# ============================================================
add_subdirectory(chapter1)
add_subdirectory(chapter2)
#add_subdirectory(chapter3)
#add_subdirectory(chapter4)
#add_subdirectory(chapter5)
#add_subdirectory(chapter6)
#add_subdirectory(chapter7)
