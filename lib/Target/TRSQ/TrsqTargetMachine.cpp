//===-- TrsqTargetMachine.cpp - Define TargetMachine for Trsq ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Top-level implementation for the Trsq target.
//
//===----------------------------------------------------------------------===//

#include "TrsqTargetMachine.h"
#include "Trsq.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

extern "C" void LLVMInitializeTrsqTarget() {
  // Register the target.
  RegisterTargetMachine<TrsqTargetMachine> X(getTheTrsqTarget());
}

static Reloc::Model getEffectiveRelocModel(Optional<Reloc::Model> RM) {
  if (!RM.hasValue())
    return Reloc::Static;
  return *RM;
}

TrsqTargetMachine::TrsqTargetMachine(const Target &T, const Triple &TT,
                                         StringRef CPU, StringRef FS,
                                         const TargetOptions &Options,
                                         Optional<Reloc::Model> RM,
                                         CodeModel::Model CM,
                                         CodeGenOpt::Level OL)
    : LLVMTargetMachine(T, "e-m:e-p:16:16-i32:16:32-a:16-n8:16", TT, CPU, FS,
                        Options, getEffectiveRelocModel(RM), CM, OL),
      TLOF(make_unique<TargetLoweringObjectFileELF>()),
      // FIXME: Check DataLayout string.
      Subtarget(TT, CPU, FS, *this) {
  initAsmInfo();
}

TrsqTargetMachine::~TrsqTargetMachine() {}

namespace {
/// Trsq Code Generator Pass Configuration Options.
class TrsqPassConfig : public TargetPassConfig {
public:
  TrsqPassConfig(TrsqTargetMachine *TM, PassManagerBase &PM)
    : TargetPassConfig(TM, PM) {}

  TrsqTargetMachine &getTrsqTargetMachine() const {
    return getTM<TrsqTargetMachine>();
  }

  bool addInstSelector() override;
  void addPreEmitPass() override;
};
} // namespace

TargetPassConfig *TrsqTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new TrsqPassConfig(this, PM);
}

bool TrsqPassConfig::addInstSelector() {
  // Install an instruction selector.
  addPass(createTrsqISelDag(getTrsqTargetMachine(), getOptLevel()));
  return false;
}

void TrsqPassConfig::addPreEmitPass() {
  // Must run branch selection immediately preceding the asm printer.
  addPass(createTrsqBranchSelectionPass(), false);
}
