set(LLVM_TARGET_DEFINITIONS StencilDialect.td)
mlir_tablegen(StencilDialect.h.inc -gen-dialect-decls -dialect=stencil)
mlir_tablegen(StencilDialect.cpp.inc -gen-dialect-defs -dialect=stencil)
add_public_tablegen_target(MLIRStencilDialectIncGen)

set(LLVM_TARGET_DEFINITIONS StencilOps.td)
mlir_tablegen(StencilOps.h.inc -gen-op-decls)
mlir_tablegen(StencilOps.cpp.inc -gen-op-defs)
add_public_tablegen_target(MLIRStencilOpsIncGen)
