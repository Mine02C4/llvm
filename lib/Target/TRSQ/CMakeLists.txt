set(LLVM_TARGET_DEFINITIONS Trsq.td)

tablegen(LLVM TrsqGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM TrsqGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM TrsqGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM TrsqGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM TrsqGenCallingConv.inc -gen-callingconv)
tablegen(LLVM TrsqGenSubtargetInfo.inc -gen-subtarget)
add_public_tablegen_target(TrsqCommonTableGen)

add_llvm_target(TrsqCodeGen
  TrsqISelDAGToDAG.cpp
  TrsqISelLowering.cpp
  TrsqInstrInfo.cpp
  TrsqFrameLowering.cpp
  TrsqMachineFunctionInfo.cpp
  TrsqRegisterInfo.cpp
  TrsqSubtarget.cpp
  TrsqTargetMachine.cpp
  )

add_subdirectory(InstPrinter)
add_subdirectory(TargetInfo)
#add_subdirectory(MCTargetDesc)

