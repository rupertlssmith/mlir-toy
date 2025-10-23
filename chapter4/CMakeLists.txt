add_subdirectory(include/toy)

set(LLVM_LINK_COMPONENTS
  Support
)

set(_TBLGEN_INC_DIRS
        "${CMAKE_CURRENT_SOURCE_DIR}/include"  # the folder with Ops.td
        ${MLIR_INCLUDE_DIRS}
        ${LLVM_INCLUDE_DIRS}
)
set(_TBLGEN_I_ARGS)
foreach(dir IN LISTS _TBLGEN_INC_DIRS)
    list(APPEND _TBLGEN_I_ARGS -I "${dir}")
endforeach()

set(LLVM_TARGET_DEFINITIONS src/mlir/ToyCombine.td)
mlir_tablegen(ToyCombine.inc -gen-rewriters ${_TBLGEN_I_ARGS})
add_public_tablegen_target(ToyCh4CombineIncGen)

add_toy_chapter(toyc-ch4
  SOURCES
    src/toyc.cpp
    src/mlir/Dialect.cpp
    src/mlir/MLIRGen.cpp
    src/mlir/ToyCombine.cpp
    src/mlir/ShapeInferencePass.cpp
    src/parser/AST.cpp
  LIBS
    # Optional: add extra MLIR/LLVM libs this chapter needs
    # e.g., MLIRParser, MLIRPass, MLIRTransforms
  DEPENDS
    ToyCh4OpsIncGen
    ToyCh4CombineIncGen
    ToyCh4ShapeInferenceInterfaceIncGen
)

include_directories(include/)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/include/)

target_link_libraries(toyc-ch4
        PRIVATE
        MLIRAnalysis
        MLIRCastInterfaces
        MLIRCallInterfaces
        MLIRFunctionInterfaces
        MLIRIR
        MLIRParser
        MLIRPass
        MLIRSideEffectInterfaces
        MLIRTransforms)
