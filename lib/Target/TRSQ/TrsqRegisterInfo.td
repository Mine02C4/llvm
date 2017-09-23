//===-- TrsqRegisterInfo.td - Trsq Register defs -----------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the TRSQ register file
//===----------------------------------------------------------------------===//
let Namespace = "Trsq" in {
def sub_32     : SubRegIndex<32>;
def sub_64     : SubRegIndex<64>;
def sub_lo     : SubRegIndex<32>;
def sub_hi     : SubRegIndex<32, 32>;
def sub_dsp16_19 : SubRegIndex<4, 16>;
def sub_dsp20    : SubRegIndex<1, 20>;
def sub_dsp21    : SubRegIndex<1, 21>;
def sub_dsp22    : SubRegIndex<1, 22>;
def sub_dsp23    : SubRegIndex<1, 23>;
}

class Unallocatable {
  bit isAllocatable = 0;
}

class TrsqReg<bits<8> Enc, string n> : Register<n> {
  let HWEncoding = Enc;
  let Namespace = "Trsq";
}
// Trsq CPU Registers
class TrsqGPRReg<bits<16> Enc, string n> : TrsqReg<Enc, n>;

//===----------------------------------------------------------------------===//
//  Registers
//===----------------------------------------------------------------------===//

let Namespace = "Trsq" in {
  // General Purpose Registers
  def W0 : TrsqReg< 0, "W0">, DwarfRegNum<[0]>;
}

//===----------------------------------------------------------------------===//
// Register Classes
//===----------------------------------------------------------------------===//

class TrsqRegs : RegisterClass<"Trsq", [i8], 8, (add
    // Working Register
    W0
)>

