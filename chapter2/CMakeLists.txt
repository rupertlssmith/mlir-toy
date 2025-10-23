add_subdirectory(include/toy)

add_toy_chapter(toyc-ch2
  SOURCES
    src/toyc.cpp
    src/mlir/Dialect.cpp
    src/mlir/MLIRGen.cpp
    src/parser/AST.cpp
  LIBS
    # Optional: add extra MLIR/LLVM libs this chapter needs
    # e.g., MLIRParser, MLIRPass, MLIRTransforms
  DEPENDS
    ToyCh2OpsIncGen
)

include_directories(include/)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/include/)

target_link_libraries(toyc-ch2
        PRIVATE
        MLIRAnalysis
        MLIRFunctionInterfaces
        MLIRIR
        MLIRParser
        MLIRSideEffectInterfaces
        MLIRTransforms)
