# Try out working with mlir

Install the following packages on Debian or other apt based Linux:

    sudo apt install clang lld ninja-build cmake ccache

A CMake preset configuration to build with ninja, clang and lld exists in 
`CMakePresets.json`. To set up the build and run it:

    cmake --preset ninja-clang-lld-linux
    cmake --build --preset build