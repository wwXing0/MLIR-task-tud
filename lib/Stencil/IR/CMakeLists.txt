add_mlir_dialect_library(MLIRStencil
  StencilDialect.cpp
  StencilOps.cpp

  DEPENDS
  MLIRStencilDialectIncGen
  MLIRStencilOpsIncGen

  LINK_LIBS PUBLIC
  MLIRIR
)