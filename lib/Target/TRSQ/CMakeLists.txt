set(LLVM_TARGET_DEFINITIONS Trsq.td)

tablegen(LLVM TrsqGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM TrsqGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM TrsqGenDisassemblerTables.inc -gen-disassembler)
tablegen(LLVM TrsqGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM TrsqGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM TrsqGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM TrsqGenFastISel.inc -gen-fast-isel)
tablegen(LLVM TrsqGenCallingConv.inc -gen-callingconv)
tablegen(LLVM TrsqGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM TrsqGenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM TrsqGenMCPseudoLowering.inc -gen-pseudo-lowering)
add_public_tablegen_target(TrsqCommonTableGen)

add_llvm_target(TrsqCodeGen
  Trsq16FrameLowering.cpp
  Trsq16HardFloat.cpp
  Trsq16HardFloatInfo.cpp
  Trsq16InstrInfo.cpp
  Trsq16ISelDAGToDAG.cpp
  Trsq16ISelLowering.cpp
  Trsq16RegisterInfo.cpp
  TrsqAnalyzeImmediate.cpp
  TrsqAsmPrinter.cpp
  TrsqCCState.cpp
  TrsqConstantIslandPass.cpp
  TrsqDelaySlotFiller.cpp
  TrsqFastISel.cpp
  TrsqHazardSchedule.cpp
  TrsqInstrInfo.cpp
  TrsqISelDAGToDAG.cpp
  TrsqISelLowering.cpp
  TrsqFrameLowering.cpp
  TrsqLongBranch.cpp
  TrsqMCInstLower.cpp
  TrsqMachineFunction.cpp
  TrsqModuleISelDAGToDAG.cpp
  TrsqOptimizePICCall.cpp
  TrsqOs16.cpp
  TrsqRegisterInfo.cpp
  TrsqSEFrameLowering.cpp
  TrsqSEInstrInfo.cpp
  TrsqSEISelDAGToDAG.cpp
  TrsqSEISelLowering.cpp
  TrsqSERegisterInfo.cpp
  TrsqSubtarget.cpp
  TrsqTargetMachine.cpp
  TrsqTargetObjectFile.cpp
  )

add_subdirectory(InstPrinter)
add_subdirectory(Disassembler)
add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)
add_subdirectory(AsmParser)

