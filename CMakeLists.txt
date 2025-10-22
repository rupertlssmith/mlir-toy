cmake_minimum_required(VERSION 3.20)

# Name your project; set language to C++ only.
project(Hello LANGUAGES CXX)

# Create the executable from your source file
add_executable(hello src/hello.cpp)

# Ask for C++20 in an idiomatic, target-scoped way
target_compile_features(hello PRIVATE cxx_std_20)

# (Optional but nice) Stricter warnings per compiler, without breaking MSVC builds
if (MSVC)
  target_compile_options(hello PRIVATE /W4 /permissive-)
else()
  target_compile_options(hello PRIVATE -Wall -Wextra -Wpedantic)
endif()

