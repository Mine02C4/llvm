//===-- TrsqSubtarget.cpp - Trsq Subtarget Information ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the Trsq specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "TrsqSubtarget.h"
#include "Trsq.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "trsq-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "TrsqGenSubtargetInfo.inc"

void TrsqSubtarget::anchor() { }

TrsqSubtarget &
TrsqSubtarget::initializeSubtargetDependencies(StringRef CPU, StringRef FS) {
  ParseSubtargetFeatures("generic", FS);
  return *this;
}

TrsqSubtarget::TrsqSubtarget(const Triple &TT, const std::string &CPU,
                                 const std::string &FS, const TargetMachine &TM)
    : TrsqGenSubtargetInfo(TT, CPU, FS), FrameLowering(),
      InstrInfo(initializeSubtargetDependencies(CPU, FS)), TLInfo(TM, *this) {}
