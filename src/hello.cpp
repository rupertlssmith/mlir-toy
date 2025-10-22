#include <iostream>

// --- MLIR headers (C++ API)
#include <mlir/IR/MLIRContext.h>
#include <mlir/IR/BuiltinOps.h>

int main() {
    std::cout << "Hello, world!\n";

    mlir::MLIRContext ctx;
    auto module = mlir::ModuleOp::create(mlir::UnknownLoc::get(&ctx));
    std::cout << "MLIR ready; module has "
              << std::distance(module.begin(), module.end())
              << " ops\n";
}
