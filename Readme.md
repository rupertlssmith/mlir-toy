# Try out working with mlir

## To work directly on a Debian host

Install the following packages on Debian or other apt based Linux:

    sudo apt install clang lld ninja-build cmake ccache

A CMake preset configuration to build with ninja, clang and lld exists in 
`CMakePresets.json`. To set up the build and run it:

    cmake --preset ninja-clang-lld-linux
    cmake --build --preset build

## To use the interactive Docker container

This step will take some time top build the docker image, as it checks out the 
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

Top run an interactive session as your user inside the docker container:

    docker run -it --rm -v "$PWD":/work mlir-dev:bookworm bash

Your build artifacts will be owned by you on the host, not root.

Build it with:

    cmake --preset ninja-clang-lld-linux
    cmake --build --preset build

## Examples

### Chapter 3

Build it:

    cmake --build --preset build --target toyc-ch3
 
Try hand coded rule for eliminating double transpose:

    ./build/chapter3/toyc-ch3 -emit=mlir < chapter3/example1.toy
    ./build/chapter3/toyc-ch3 -emit=mlir -opt < chapter3/example1.toy
 
Try table-gen rewrite rule for eliminating unnecessary reshapes:

    ./build/chapter3/toyc-ch3 -emit=mlir < chapter3/example2.toy
    ./build/chapter3/toyc-ch3 -emit=mlir -opt < chapter3/example2.toy

### Chapter 4

Build it:

    cmake --build --preset build --target toyc-ch4

Try function inlining and shape inference passes:

    ./build/chapter4/toyc-ch4 -emit=mlir < chapter4/example1.toy
    ./build/chapter4/toyc-ch4 -emit=mlir -opt < chapter4/example1.toy
