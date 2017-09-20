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
  def STATUS : TrsqReg< 0, "STATUS">, DwarfRegNum<[0]>;
  def PCRL   : TrsqReg< 1, "PCRL">,   DwarfRegNum<[1]>;
  def PCRH   : TrsqReg< 2, "PCRH">,   DwarfRegNum<[2]>;
  def IRQR   : TrsqReg< 3, "IRQR">,   DwarfRegNum<[3]>;
  def G4   : TrsqReg< 4, "4">,    DwarfRegNum<[4]>;
  def G5   : TrsqReg< 5, "5">,    DwarfRegNum<[5]>;
  def G6   : TrsqReg< 6, "6">,    DwarfRegNum<[6]>;
  def G7   : TrsqReg< 7, "7">,    DwarfRegNum<[7]>;
  def G8   : TrsqReg< 8, "8">,    DwarfRegNum<[8]>;
  def G9   : TrsqReg< 9, "9">,    DwarfRegNum<[9]>;
  def G10  : TrsqReg< 10, "10">,  DwarfRegNum<[10]>;
  def G11  : TrsqReg< 11, "11">,  DwarfRegNum<[11]>;
  def G12  : TrsqReg< 12, "12">,  DwarfRegNum<[12]>;
  def G13  : TrsqReg< 13, "13">,  DwarfRegNum<[13]>;
  def G14  : TrsqReg< 14, "14">,  DwarfRegNum<[14]>;
  def G15  : TrsqReg< 15, "15">,  DwarfRegNum<[15]>;
  def G16  : TrsqReg< 16, "16">,  DwarfRegNum<[16]>;
  def G17  : TrsqReg< 17, "17">,  DwarfRegNum<[17]>;
  def G18  : TrsqReg< 18, "18">,  DwarfRegNum<[18]>;
  def G19  : TrsqReg< 19, "19">,  DwarfRegNum<[19]>;
  def G20  : TrsqReg< 20, "20">,  DwarfRegNum<[20]>;
  def G21  : TrsqReg< 21, "21">,  DwarfRegNum<[21]>;
  def G22  : TrsqReg< 22, "22">,  DwarfRegNum<[22]>;
  def G23  : TrsqReg< 23, "23">,  DwarfRegNum<[23]>;
  def G24  : TrsqReg< 24, "24">,  DwarfRegNum<[24]>;
  def G25  : TrsqReg< 25, "25">,  DwarfRegNum<[25]>;
  def G26  : TrsqReg< 26, "26">,  DwarfRegNum<[26]>;
  def G27  : TrsqReg< 27, "27">,  DwarfRegNum<[27]>;
  def G28  : TrsqReg< 28, "gp">,  DwarfRegNum<[28]>;
  def G29  : TrsqReg< 29, "sp">,  DwarfRegNum<[29]>;
  def G30  : TrsqReg< 30, "fp">,  DwarfRegNum<[30]>;
  def G31  : TrsqReg< 31, "ra">,  DwarfRegNum<[31]>;
}

//===----------------------------------------------------------------------===//
// Register Classes
//===----------------------------------------------------------------------===//

class TrsqRegs : RegisterClass<"Trsq", [i8], 8, (add
    // Special Function Register
    STATUS, PCRL, PCRH, IRQR,
    // User Data Register
    G4, G5, G6, G7, G8, G9, G10, G11, G12, G13,
    G14, G15, G16, G17, G18, G19, G20, G21, G22, G23,
    G24, G25, G26, G27, G28, G29, G30, G31
)>

