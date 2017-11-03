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
  def R0 : TrsqReg< 1, "R0">, DwarfRegNum<[1]>;
  def R1 : TrsqReg< 2, "R1">, DwarfRegNum<[2]>;
  def R2 : TrsqReg< 3, "R2">, DwarfRegNum<[3]>;
  def R3 : TrsqReg< 4, "R3">, DwarfRegNum<[4]>;
  def R4 : TrsqReg< 5, "R4">, DwarfRegNum<[5]>;
  def R5 : TrsqReg< 6, "R5">, DwarfRegNum<[6]>;
  def R6 : TrsqReg< 7, "R6">, DwarfRegNum<[7]>;
  def R7 : TrsqReg< 8, "R7">, DwarfRegNum<[8]>;
}

//===----------------------------------------------------------------------===//
// Register Classes
//===----------------------------------------------------------------------===//

class TrsqRegs : RegisterClass<"Trsq", [i8], 8, (add
    // Working Register
    W0,
    // SRAM Register
    R0, R1, R2, R3, R4, R5, R6, R7
)>

