cmake_minimum_required(VERSION 3.20)
project(Toy LANGUAGES CXX)

include_directories(include/)

# Your executable
add_executable(toyc src/toyc.cpp
        src/parser/AST.cpp)

# Ask for C++20 at the target level
target_compile_features(toyc PRIVATE cxx_std_20)

# Find an installed MLIR (and transitively LLVM) via its exported CMake config
# You will pass -DMLIR_DIR=... when configuring (see step 3)
find_package(MLIR REQUIRED CONFIG)  # This also pulls in LLVMConfig.cmake

# Some MLIR exports still expect you to add include dirs explicitly
# (mirroring the upstream examples)
include_directories(${LLVM_INCLUDE_DIRS} ${MLIR_INCLUDE_DIRS})

# Link the minimal set of MLIR libs needed for IR + basic types/ops.
# This mirrors MLIR's own "minimal" examples.
target_link_libraries(toyc PRIVATE MLIRIR MLIRSupport)

# (Optional) Stricter warnings
if (MSVC)
    target_compile_options(toyc PRIVATE /w)
else ()
    target_compile_options(toyc PRIVATE -w)
endif ()
