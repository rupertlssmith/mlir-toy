#ifndef TOY_OPS
#define TOY_OPS

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/FunctionInterfaces.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def Toy_Dialect : Dialect {
  let name = "toy";
  let summary = "A high-level dialect for analyzing and optimizing the "
                "Toy language";
  let description = [{
    The Toy language is a tensor-based language that allows you to define
    functions, perform some math computation, and print results. This dialect
    provides a representation of the language that is amenable to analysis and
    optimization.
  }];
  let cppNamespace = "toy";
}

class Toy_Op<string mnemonic, list<Trait> traits = []> :
    Op<Toy_Dialect, mnemonic, traits>;

def ConstantOp : Toy_Op<"constant"> {
    let summary = "constant operation";
    let description = [{
      Constant operation turns a literal into an SSA value. The data is attached
      to the operation as an attribute. For example:

        %0 = "toy.constant"()
           { value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf64> }
          : () -> tensor<2x3xf64>
    }];
    let arguments = (ins F64ElementsAttr:$value);
    let results = (outs F64Tensor);
    let hasVerifier = 1;
    let builders = [
        OpBuilder<(ins "DenseElementsAttr":$value), [{
          build(builder, result, value.getType(), value);
        }]>,
        OpBuilder<(ins "double":$value)>
      ];
}

#endif // TOY_OPS