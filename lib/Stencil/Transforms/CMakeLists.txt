add_mlir_library(MLIRStencilTransforms
  StencilApplyToLinalg.cpp
  StencilSweepToScf.cpp
  Passes.cpp

  LINK_LIBS PUBLIC
  MLIRStencil
  MLIRArithDialect
  MLIRLinalgDialect
  MLIRMemRefDialect
  MLIRSCFDialect
  MLIRIR
  MLIRPass
)
