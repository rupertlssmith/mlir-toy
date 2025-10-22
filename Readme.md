# Try out working with mlir

Install the following packages on Debian or other apt based Linux:

    sudo apt install clang lld ninja-build cmake ccache

A CMake preset configuration to build with ninja, clang and lld exists in 
`CMakePresets.json`. To set up the build and run it:

    cmake --preset ninja-clang-lld-linux
    cmake --build --preset build

## To use the Docker image

Follow the advice here on installing Docker, [install docker](https://docs.docker.com/engine/install/debian/) 
as well as setting up non-root users to be able to use it, 
[non-root users](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).

To confirm it is working correctly run these commands (`newgrp docker` only needs to be run if you are not 
logging out and back in again):

    newgrp docker
    docker run hello-world

This step may take some time as it checks out the LLVM git and builds it. To
build the docker image:

    docker build -t mlir-dev:bookworm .

Top run an interactive session in a docker container:

    docker run -it --rm -v "$PWD":/work mlir-dev:bookworm bash
