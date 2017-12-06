//===-- TrsqTargetInfo.cpp - Trsq Target Implementation ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Trsq.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

Target &llvm::getTheTrsqTarget() {
  static Target TheTrsqTarget;
  return TheTrsqTarget;
}

extern "C" void LLVMInitializeTrsqTargetInfo() {
  RegisterTarget<Triple::Trsq> X(getTheTrsqTarget(), "Trsq",
                                   "Trsq [experimental]");
}
