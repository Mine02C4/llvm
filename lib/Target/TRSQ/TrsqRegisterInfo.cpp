//===-- TrsqRegisterInfo.cpp - Trsq Register Information --------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the Trsq implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "TrsqRegisterInfo.h"
#include "Trsq.h"
#include "TrsqMachineFunctionInfo.h"
#include "TrsqTargetMachine.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"

using namespace llvm;

#define DEBUG_TYPE "trsq-reg-info"

#define GET_REGINFO_TARGET_DESC
#include "TrsqGenRegisterInfo.inc"

// FIXME: Provide proper call frame setup / destroy opcodes.
TrsqRegisterInfo::TrsqRegisterInfo()
  : TrsqGenRegisterInfo(Trsq::PC) {}

const MCPhysReg*
TrsqRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  const TrsqFrameLowering *TFI = getFrameLowering(*MF);
  const Function* F = MF->getFunction();
  static const MCPhysReg CalleeSavedRegs[] = {
    Trsq::FP, Trsq::R5, Trsq::R6, Trsq::R7,
    Trsq::R8, Trsq::R9, Trsq::R10, Trsq::R11,
    0
  };
  static const MCPhysReg CalleeSavedRegsFP[] = {
    Trsq::R5, Trsq::R6, Trsq::R7,
    Trsq::R8, Trsq::R9, Trsq::R10, Trsq::R11,
    0
  };
  static const MCPhysReg CalleeSavedRegsIntr[] = {
    Trsq::FP,  Trsq::R5,  Trsq::R6,  Trsq::R7,
    Trsq::R8,  Trsq::R9,  Trsq::R10, Trsq::R11,
    Trsq::R12, Trsq::R13, Trsq::R14, Trsq::R15,
    0
  };
  static const MCPhysReg CalleeSavedRegsIntrFP[] = {
    Trsq::R5,  Trsq::R6,  Trsq::R7,
    Trsq::R8,  Trsq::R9,  Trsq::R10, Trsq::R11,
    Trsq::R12, Trsq::R13, Trsq::R14, Trsq::R15,
    0
  };

  if (TFI->hasFP(*MF))
    return (F->getCallingConv() == CallingConv::Trsq_INTR ?
            CalleeSavedRegsIntrFP : CalleeSavedRegsFP);
  else
    return (F->getCallingConv() == CallingConv::Trsq_INTR ?
            CalleeSavedRegsIntr : CalleeSavedRegs);

}

BitVector TrsqRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());
  const TrsqFrameLowering *TFI = getFrameLowering(MF);

  // Mark 4 special registers with subregisters as reserved.
  Reserved.set(Trsq::PCB);
  Reserved.set(Trsq::SPB);
  Reserved.set(Trsq::SRB);
  Reserved.set(Trsq::CGB);
  Reserved.set(Trsq::PC);
  Reserved.set(Trsq::SP);
  Reserved.set(Trsq::SR);
  Reserved.set(Trsq::CG);

  // Mark frame pointer as reserved if needed.
  if (TFI->hasFP(MF)) {
    Reserved.set(Trsq::FPB);
    Reserved.set(Trsq::FP);
  }

  return Reserved;
}

const TargetRegisterClass *
TrsqRegisterInfo::getPointerRegClass(const MachineFunction &MF, unsigned Kind)
                                                                         const {
  return &Trsq::GR16RegClass;
}

void
TrsqRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                        int SPAdj, unsigned FIOperandNum,
                                        RegScavenger *RS) const {
  assert(SPAdj == 0 && "Unexpected");

  MachineInstr &MI = *II;
  MachineBasicBlock &MBB = *MI.getParent();
  MachineFunction &MF = *MBB.getParent();
  const TrsqFrameLowering *TFI = getFrameLowering(MF);
  DebugLoc dl = MI.getDebugLoc();
  int FrameIndex = MI.getOperand(FIOperandNum).getIndex();

  unsigned BasePtr = (TFI->hasFP(MF) ? Trsq::FP : Trsq::SP);
  int Offset = MF.getFrameInfo().getObjectOffset(FrameIndex);

  // Skip the saved PC
  Offset += 2;

  if (!TFI->hasFP(MF))
    Offset += MF.getFrameInfo().getStackSize();
  else
    Offset += 2; // Skip the saved FP

  // Fold imm into offset
  Offset += MI.getOperand(FIOperandNum + 1).getImm();

  if (MI.getOpcode() == Trsq::ADD16ri) {
    // This is actually "load effective address" of the stack slot
    // instruction. We have only two-address instructions, thus we need to
    // expand it into mov + add
    const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();

    MI.setDesc(TII.get(Trsq::MOV16rr));
    MI.getOperand(FIOperandNum).ChangeToRegister(BasePtr, false);

    if (Offset == 0)
      return;

    // We need to materialize the offset via add instruction.
    unsigned DstReg = MI.getOperand(0).getReg();
    if (Offset < 0)
      BuildMI(MBB, std::next(II), dl, TII.get(Trsq::SUB16ri), DstReg)
        .addReg(DstReg).addImm(-Offset);
    else
      BuildMI(MBB, std::next(II), dl, TII.get(Trsq::ADD16ri), DstReg)
        .addReg(DstReg).addImm(Offset);

    return;
  }

  MI.getOperand(FIOperandNum).ChangeToRegister(BasePtr, false);
  MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset);
}

unsigned TrsqRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  const TrsqFrameLowering *TFI = getFrameLowering(MF);
  return TFI->hasFP(MF) ? Trsq::FP : Trsq::SP;
}
