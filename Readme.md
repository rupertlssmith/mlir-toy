# MLIR Toy Language Tutorial

There is a Toy language tutorial included with MLIR. This project extracts that
code as a standalone repository, with some example programs and full
instructions on how to build an run it. https://mlir.llvm.org/docs/Tutorials/Toy/

## To use the interactive Docker container (recommended)

This step will take some time to build the docker image, as it checks out the 
LLVM git and builds it. This is set up to support interactive development inside
the container, and will detect and run as your current user.

Follow the advice here on installing Docker, 
[install docker](https://docs.docker.com/engine/install/debian/) 
as well as setting up non-root users to be able to use it, 
[non-root users](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).

To confirm it is working correctly run these commands (`newgrp docker` only 
needs to be run if you are not logging out and back in again):

    newgrp docker
    docker run hello-world

To build the docker image:

    docker build -t mlir-dev:bookworm .

To run an interactive session as your user inside the docker container:

    docker run -it --rm -v "$PWD":/work mlir-dev:bookworm bash

Your build artifacts will be owned by you on the host, not root.

Set up the build with:

    cmake --preset ninja-clang-lld-linux

## To work directly on a Debian or other apt-based Linux host

Install the following packages:

    sudo apt install clang lld ninja-build cmake ccache

Next you need to checkout the LLVM project and build and install it on
your system:

    LLVM_VERSION=21.1.4
    git clone --branch "llvmorg-${LLVM_VERSION}" https://github.com/llvm/llvm-project.git

    cd llvm-project
    cmake -S llvm -B build -G Ninja \
    -DLLVM_ENABLE_PROJECTS="mlir" \
    -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DMLIR_ENABLE_CMAKE_PACKAGE=ON \
    -DLLVM_ENABLE_ZLIB=OFF \
    -DLLVM_ENABLE_LIBXML2=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_USE_LINKER=lld \
    -DCMAKE_INSTALL_PREFIX=/opt/llvm-mlir

    cmake --build build
    sudo cmake --install build

A CMake preset configuration to build with ninja, clang and lld exists in
`CMakePresets.json`. Set up the build in this project with:

    cmake --preset ninja-clang-lld-linux

## Examples

There are some example Toy programs included that are used in the tutorial to
demonstrate various compiler capabilities. These are:

* first.toy - the first example program from chapter 1 of the tutorial.
* reshape.toy - eliminating unnecessary reshape operations.
* transpose.toy - eliminating unnecessary transpose operations. 
* struct.toy - adding a struct datatype to the language.

### Chapter 1

Build it:

    cmake --build --preset build --target toyc-ch1

Try parsing a program and printing the AST:

    ./build/chapter1/toyc-ch1 -emit=ast < examples/first.toy

### Chapter 2

Build it:

    cmake --build --preset build --target toyc-ch2

Try turning a program into high-level MLIR:

    ./build/chapter2/toyc-ch2 -emit=mlir < examples/first.toy 

### Chapter 3

Build it:

    cmake --build --preset build --target toyc-ch3
 
Try hand coded rule for eliminating double transpose:

    ./build/chapter3/toyc-ch3 -emit=mlir < examples/transpose.toy
    ./build/chapter3/toyc-ch3 -emit=mlir -opt < examples/transpose.toy
 
Try table-gen rewrite rule for eliminating unnecessary reshapes:

    ./build/chapter3/toyc-ch3 -emit=mlir < examples/reshape.toy
    ./build/chapter3/toyc-ch3 -emit=mlir -opt < examples/reshape.toy

### Chapter 4

Build it:

    cmake --build --preset build --target toyc-ch4

Try function inlining and shape inference passes:

    ./build/chapter4/toyc-ch4 -emit=mlir < examples/transpose.toy
    ./build/chapter4/toyc-ch4 -emit=mlir -opt < examples/transpose.toy

### Chapter 5

Build it:

    cmake --build --preset build --target toyc-ch5

Try partial lowering to affine and memref (note: -emit=mlir-affine also does -opt):

    ./build/chapter5/toyc-ch5 -emit=mlir < examples/transpose.toy
    ./build/chapter5/toyc-ch5 -emit=mlir-affine < examples/transpose.toy

### Chapter 6

Build it:

    cmake --build --preset build --target toyc-ch6

Try full lowering to llvm:

    ./build/chapter6/toyc-ch6 -emit=mlir-llvm < examples/transpose.toy

Try running the example in the JIT

    ./build/chapter6/toyc-ch6 -emit=jit < examples/transpose.toy

### Chapter 7

Build it:

    cmake --build --preset build --target toyc-ch7

Try running the example in the JIT

    ./build/chapter7/toyc-ch7 -emit=jit < examples/struct.toy

