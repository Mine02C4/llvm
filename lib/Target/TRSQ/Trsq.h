//==-- Trsq.h - Top-level interface for Trsq representation --*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the entry points for global functions defined in
// the LLVM Trsq backend.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_TRSQ_TRSQ_H
#define LLVM_LIB_TARGET_TRSQ_TRSQ_H

#include "MCTargetDesc/TrsqMCTargetDesc.h"
#include "llvm/Target/TargetMachine.h"

namespace TrsqCC {
  enum CondCodes {
    COND_E  = 0,  // aka COND_Z
    COND_NE = 1,  // aka COND_NZ
    COND_HS = 2,  // aka COND_C
    COND_LO = 3,  // aka COND_NC
    COND_GE = 4,
    COND_L  = 5,

    COND_INVALID = -1
  };
}

namespace llvm {
  class TrsqTargetMachine;
  class FunctionPass;
  class formatted_raw_ostream;

  FunctionPass *createTrsqISelDag(TrsqTargetMachine &TM,
                                    CodeGenOpt::Level OptLevel);

  FunctionPass *createTrsqBranchSelectionPass();

} // end namespace llvm;

#endif
