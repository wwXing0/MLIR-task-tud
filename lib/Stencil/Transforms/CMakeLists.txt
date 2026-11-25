add_mlir_library(MLIRStencilTransforms
  StencilApplyToLinalg.cpp

  LINK_LIBS PUBLIC
  MLIRStencil
  MLIRArithDialect
  MLIRLinalgDialect
  MLIRMemRefDialect
  MLIRSCFDialect
  MLIRIR
  MLIRPass
)
