add_toy_chapter(
  NAME toyc-ch1
  SOURCES
    src/toyc.cpp
    src/parser/AST.cpp
  LIBS
    # Optional: add extra MLIR/LLVM libs this chapter needs
    # e.g., MLIRParser, MLIRPass, MLIRTransforms
)
