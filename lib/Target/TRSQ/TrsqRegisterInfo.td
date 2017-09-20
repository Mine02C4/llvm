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
  def A0   : TrsqReg< 4, "4">,    DwarfRegNum<[4]>;
  def A1   : TrsqReg< 5, "5">,    DwarfRegNum<[5]>;
  def A2   : TrsqReg< 6, "6">,    DwarfRegNum<[6]>;
  def A3   : TrsqReg< 7, "7">,    DwarfRegNum<[7]>;
  def T0   : TrsqReg< 8, "8">,    DwarfRegNum<[8]>;
  def T1   : TrsqReg< 9, "9">,    DwarfRegNum<[9]>;
  def T2   : TrsqReg< 10, "10">,  DwarfRegNum<[10]>;
  def T3   : TrsqReg< 11, "11">,  DwarfRegNum<[11]>;
  def T4   : TrsqReg< 12, "12">,  DwarfRegNum<[12]>;
  def T5   : TrsqReg< 13, "13">,  DwarfRegNum<[13]>;
  def T6   : TrsqReg< 14, "14">,  DwarfRegNum<[14]>;
  def T7   : TrsqReg< 15, "15">,  DwarfRegNum<[15]>;
  def S0   : TrsqReg< 16, "16">,  DwarfRegNum<[16]>;
  def S1   : TrsqReg< 17, "17">,  DwarfRegNum<[17]>;
  def S2   : TrsqReg< 18, "18">,  DwarfRegNum<[18]>;
  def S3   : TrsqReg< 19, "19">,  DwarfRegNum<[19]>;
  def S4   : TrsqReg< 20, "20">,  DwarfRegNum<[20]>;
  def S5   : TrsqReg< 21, "21">,  DwarfRegNum<[21]>;
  def S6   : TrsqReg< 22, "22">,  DwarfRegNum<[22]>;
  def S7   : TrsqReg< 23, "23">,  DwarfRegNum<[23]>;
  def T8   : TrsqReg< 24, "24">,  DwarfRegNum<[24]>;
  def T9   : TrsqReg< 25, "25">,  DwarfRegNum<[25]>;
  def K0   : TrsqReg< 26, "26">,  DwarfRegNum<[26]>;
  def K1   : TrsqReg< 27, "27">,  DwarfRegNum<[27]>;
  def GP   : TrsqReg< 28, "gp">,  DwarfRegNum<[28]>;
  def SP   : TrsqReg< 29, "sp">,  DwarfRegNum<[29]>;
  def FP   : TrsqReg< 30, "fp">,  DwarfRegNum<[30]>;
  def RA   : TrsqReg< 31, "ra">,  DwarfRegNum<[31]>;
}

//===----------------------------------------------------------------------===//
// Register Classes
//===----------------------------------------------------------------------===//

class GPR32Class<list<ValueType> regTypes> :
  RegisterClass<"Trsq", regTypes, 32, (add
  // Reserved
  ZERO, AT,
  // Return Values and Arguments
  V0, V1, A0, A1, A2, A3,
  // Not preserved across procedure calls
  T0, T1, T2, T3, T4, T5, T6, T7,
  // Callee save
  S0, S1, S2, S3, S4, S5, S6, S7,
  // Not preserved across procedure calls
  T8, T9,
  // Reserved
  K0, K1, GP, SP, FP, RA)>;

def GPR32 : GPR32Class<[i32]>;
def DSPR  : GPR32Class<[v4i8, v2i16]>;

def GPRMM16 : RegisterClass<"Trsq", [i32], 32, (add
  // Callee save
  S0, S1,
  // Return Values and Arguments
  V0, V1, A0, A1, A2, A3)>;

def GPRMM16Zero : RegisterClass<"Trsq", [i32], 32, (add
  // Reserved
  ZERO,
  // Callee save
  S1,
  // Return Values and Arguments
  V0, V1, A0, A1, A2, A3)>;

def GPRMM16MoveP : RegisterClass<"Trsq", [i32], 32, (add
  // Reserved
  ZERO,
  // Callee save
  S1,
  // Return Values and Arguments
  V0, V1,
  // Callee save
  S0, S2, S3, S4)>;

def GPR64 : RegisterClass<"Trsq", [i64], 64, (add
// Reserved
  ZERO_64, AT_64,
  // Return Values and Arguments
  V0_64, V1_64, A0_64, A1_64, A2_64, A3_64,
  // Not preserved across procedure calls
  T0_64, T1_64, T2_64, T3_64, T4_64, T5_64, T6_64, T7_64,
  // Callee save
  S0_64, S1_64, S2_64, S3_64, S4_64, S5_64, S6_64, S7_64,
  // Not preserved across procedure calls
  T8_64, T9_64,
  // Reserved
  K0_64, K1_64, GP_64, SP_64, FP_64, RA_64)>;

def GPRMM16_64 : RegisterClass<"Trsq", [i64], 64, (add
  // Callee save
  S0_64, S1_64,
  // Return Values and Arguments
  V0_64, V1_64, A0_64, A1_64, A2_64, A3_64)>;

def CPU16Regs : RegisterClass<"Trsq", [i32], 32, (add
  // Return Values and Arguments
  V0, V1, A0, A1, A2, A3,
  // Callee save
  S0, S1)>;

def CPU16RegsPlusSP : RegisterClass<"Trsq", [i32], 32, (add
  // Return Values and Arguments
  V0, V1, A0, A1, A2, A3,
  // Callee save
  S0, S1,
  SP)>;

def CPURAReg : RegisterClass<"Trsq", [i32], 32, (add RA)>, Unallocatable;

def CPUSPReg : RegisterClass<"Trsq", [i32], 32, (add SP)>, Unallocatable;

// 64bit fp:
// * FGR64  - 32 64-bit registers
// * AFGR64 - 16 32-bit even registers (32-bit FP Mode)
//
// 32bit fp:
// * FGR32 - 16 32-bit even registers
// * FGR32 - 32 32-bit registers (single float only mode)
def FGR32 : RegisterClass<"Trsq", [f32], 32, (sequence "F%u", 0, 31)>;

def FGRH32 : RegisterClass<"Trsq", [f32], 32, (sequence "F_HI%u", 0, 31)>,
             Unallocatable;

def AFGR64 : RegisterClass<"Trsq", [f64], 64, (add
  // Return Values and Arguments
  D0, D1,
  // Not preserved across procedure calls
  D2, D3, D4, D5,
  // Return Values and Arguments
  D6, D7,
  // Not preserved across procedure calls
  D8, D9,
  // Callee save
  D10, D11, D12, D13, D14, D15)>;

def FGR64 : RegisterClass<"Trsq", [f64], 64, (sequence "D%u_64", 0, 31)>;

// Used to reserve odd registers when given -mattr=+nooddspreg
// FIXME: Remove double precision registers from this set.
def OddSP : RegisterClass<"Trsq", [f32], 32,
                          (add (decimate (sequence "F%u", 1, 31), 2),
                               (decimate (sequence "F_HI%u", 1, 31), 2),
                               (decimate (sequence "D%u", 1, 15), 2),
                               (decimate (sequence "D%u_64", 1, 31), 2))>,
            Unallocatable;

// FP control registers.
def CCR : RegisterClass<"Trsq", [i32], 32, (sequence "FCR%u", 0, 31)>,
          Unallocatable;

// FP condition code registers.
def FCC : RegisterClass<"Trsq", [i32], 32, (sequence "FCC%u", 0, 7)>,
          Unallocatable;

// MIPS32r6/MIPS64r6 store FPU condition codes in normal FGR registers.
// This class allows us to represent this in codegen patterns.
def FGRCC : RegisterClass<"Trsq", [i32], 32, (sequence "F%u", 0, 31)>;

def MSA128F16 : RegisterClass<"Trsq", [f16], 128, (sequence "W%u", 0, 31)>;

def MSA128B: RegisterClass<"Trsq", [v16i8], 128,
                           (sequence "W%u", 0, 31)>;
def MSA128H: RegisterClass<"Trsq", [v8i16, v8f16], 128,
                           (sequence "W%u", 0, 31)>;
def MSA128W: RegisterClass<"Trsq", [v4i32, v4f32], 128,
                           (sequence "W%u", 0, 31)>;
def MSA128D: RegisterClass<"Trsq", [v2i64, v2f64], 128,
                           (sequence "W%u", 0, 31)>;
def MSA128WEvens: RegisterClass<"Trsq", [v4i32, v4f32], 128,
                                (decimate (sequence "W%u", 0, 31), 2)>;

def MSACtrl: RegisterClass<"Trsq", [i32], 32, (add
  MSAIR, MSACSR, MSAAccess, MSASave, MSAModify, MSARequest, MSAMap, MSAUnmap)>;

// Hi/Lo Registers
def LO32 : RegisterClass<"Trsq", [i32], 32, (add LO0)>;
def HI32 : RegisterClass<"Trsq", [i32], 32, (add HI0)>;
def LO32DSP : RegisterClass<"Trsq", [i32], 32, (sequence "LO%u", 0, 3)>;
def HI32DSP : RegisterClass<"Trsq", [i32], 32, (sequence "HI%u", 0, 3)>;
def LO64 : RegisterClass<"Trsq", [i64], 64, (add LO0_64)>;
def HI64 : RegisterClass<"Trsq", [i64], 64, (add HI0_64)>;

// Hardware registers
def HWRegs : RegisterClass<"Trsq", [i32], 32, (sequence "HWR%u", 0, 31)>,
             Unallocatable;

// Accumulator Registers
def ACC64 : RegisterClass<"Trsq", [untyped], 64, (add AC0)> {
  let Size = 64;
}

def ACC128 : RegisterClass<"Trsq", [untyped], 128, (add AC0_64)> {
  let Size = 128;
}

def ACC64DSP : RegisterClass<"Trsq", [untyped], 64, (sequence "AC%u", 0, 3)> {
  let Size = 64;
}

def DSPCC : RegisterClass<"Trsq", [v4i8, v2i16], 32, (add DSPCCond)>;

// Coprocessor 0 registers.
def COP0 : RegisterClass<"Trsq", [i32], 32, (sequence "COP0%u", 0, 31)>,
           Unallocatable;

// Coprocessor 2 registers.
def COP2 : RegisterClass<"Trsq", [i32], 32, (sequence "COP2%u", 0, 31)>,
           Unallocatable;

// Coprocessor 3 registers.
def COP3 : RegisterClass<"Trsq", [i32], 32, (sequence "COP3%u", 0, 31)>,
           Unallocatable;

// Stack pointer and global pointer classes for instructions that are limited
// to a single register such as lwgp/lwsp in microMIPS.
def SP32 : RegisterClass<"Trsq", [i32], 32, (add SP)>, Unallocatable;
def SP64 : RegisterClass<"Trsq", [i64], 64, (add SP_64)>, Unallocatable;
def GP32 : RegisterClass<"Trsq", [i32], 32, (add GP)>, Unallocatable;
def GP64 : RegisterClass<"Trsq", [i64], 64, (add GP_64)>, Unallocatable;

// Octeon multiplier and product registers
def OCTEON_MPL : RegisterClass<"Trsq", [i64], 64, (add MPL0, MPL1, MPL2)>,
                 Unallocatable;
def OCTEON_P : RegisterClass<"Trsq", [i64], 64, (add P0, P1, P2)>,
               Unallocatable;

// Register Operands.

class TrsqAsmRegOperand : AsmOperandClass {
  let ParserMethod = "parseAnyRegister";
}

def GPR64AsmOperand : TrsqAsmRegOperand {
  let Name = "GPR64AsmReg";
  let PredicateMethod = "isGPRAsmReg";
}

def GPR32AsmOperand : TrsqAsmRegOperand {
  let Name = "GPR32AsmReg";
  let PredicateMethod = "isGPRAsmReg";
}

def GPRMM16AsmOperand : TrsqAsmRegOperand {
  let Name = "GPRMM16AsmReg";
  let PredicateMethod = "isMM16AsmReg";
}

def GPRMM16AsmOperandZero : TrsqAsmRegOperand {
  let Name = "GPRMM16AsmRegZero";
  let PredicateMethod = "isMM16AsmRegZero";
}

def GPRMM16AsmOperandMoveP : TrsqAsmRegOperand {
  let Name = "GPRMM16AsmRegMoveP";
  let PredicateMethod = "isMM16AsmRegMoveP";
}

def ACC64DSPAsmOperand : TrsqAsmRegOperand {
  let Name = "ACC64DSPAsmReg";
  let PredicateMethod = "isACCAsmReg";
}

def HI32DSPAsmOperand : TrsqAsmRegOperand {
  let Name = "HI32DSPAsmReg";
  let PredicateMethod = "isACCAsmReg";
}

def LO32DSPAsmOperand : TrsqAsmRegOperand {
  let Name = "LO32DSPAsmReg";
  let PredicateMethod = "isACCAsmReg";
}

def CCRAsmOperand : TrsqAsmRegOperand {
  let Name = "CCRAsmReg";
}

def AFGR64AsmOperand : TrsqAsmRegOperand {
  let Name = "AFGR64AsmReg";
  let PredicateMethod = "isFGRAsmReg";
}

def FGR64AsmOperand : TrsqAsmRegOperand {
  let Name = "FGR64AsmReg";
  let PredicateMethod = "isFGRAsmReg";
}

def FGR32AsmOperand : TrsqAsmRegOperand {
  let Name = "FGR32AsmReg";
  let PredicateMethod = "isFGRAsmReg";
}

def FGRH32AsmOperand : TrsqAsmRegOperand {
  let Name = "FGRH32AsmReg";
  let PredicateMethod = "isFGRAsmReg";
}

def FCCRegsAsmOperand : TrsqAsmRegOperand {
  let Name = "FCCAsmReg";
}

def MSA128AsmOperand : TrsqAsmRegOperand {
  let Name = "MSA128AsmReg";
}

def MSACtrlAsmOperand : TrsqAsmRegOperand {
  let Name = "MSACtrlAsmReg";
}

def GPR32Opnd : RegisterOperand<GPR32> {
  let ParserMatchClass = GPR32AsmOperand;
}

def GPRMM16Opnd : RegisterOperand<GPRMM16> {
  let ParserMatchClass = GPRMM16AsmOperand;
}

def GPRMM16OpndZero : RegisterOperand<GPRMM16Zero> {
  let ParserMatchClass = GPRMM16AsmOperandZero;
}

def GPRMM16OpndMoveP : RegisterOperand<GPRMM16MoveP> {
  let ParserMatchClass = GPRMM16AsmOperandMoveP;
}

def GPR64Opnd : RegisterOperand<GPR64> {
  let ParserMatchClass = GPR64AsmOperand;
}

def DSPROpnd : RegisterOperand<DSPR> {
  let ParserMatchClass = GPR32AsmOperand;
}

def CCROpnd : RegisterOperand<CCR> {
  let ParserMatchClass = CCRAsmOperand;
}

def HWRegsAsmOperand : TrsqAsmRegOperand {
  let Name = "HWRegsAsmReg";
}

def COP0AsmOperand : TrsqAsmRegOperand {
  let Name = "COP0AsmReg";
}

def COP2AsmOperand : TrsqAsmRegOperand {
  let Name = "COP2AsmReg";
}

def COP3AsmOperand : TrsqAsmRegOperand {
  let Name = "COP3AsmReg";
}

def HWRegsOpnd : RegisterOperand<HWRegs> {
  let ParserMatchClass = HWRegsAsmOperand;
}

def AFGR64Opnd : RegisterOperand<AFGR64> {
  let ParserMatchClass = AFGR64AsmOperand;
}

def FGR64Opnd : RegisterOperand<FGR64> {
  let ParserMatchClass = FGR64AsmOperand;
}

def FGR32Opnd : RegisterOperand<FGR32> {
  let ParserMatchClass = FGR32AsmOperand;
}

def FGRCCOpnd : RegisterOperand<FGRCC> {
  // The assembler doesn't use register classes so we can re-use
  // FGR32AsmOperand.
  let ParserMatchClass = FGR32AsmOperand;
}

def FGRH32Opnd : RegisterOperand<FGRH32> {
  let ParserMatchClass = FGRH32AsmOperand;
}

def FCCRegsOpnd : RegisterOperand<FCC> {
  let ParserMatchClass = FCCRegsAsmOperand;
}

def LO32DSPOpnd : RegisterOperand<LO32DSP> {
  let ParserMatchClass = LO32DSPAsmOperand;
}

def HI32DSPOpnd : RegisterOperand<HI32DSP> {
  let ParserMatchClass = HI32DSPAsmOperand;
}

def ACC64DSPOpnd : RegisterOperand<ACC64DSP> {
  let ParserMatchClass = ACC64DSPAsmOperand;
}

def COP0Opnd : RegisterOperand<COP0> {
  let ParserMatchClass = COP0AsmOperand;
}

def COP2Opnd : RegisterOperand<COP2> {
  let ParserMatchClass = COP2AsmOperand;
}

def COP3Opnd : RegisterOperand<COP3> {
  let ParserMatchClass = COP3AsmOperand;
}

def MSA128F16Opnd : RegisterOperand<MSA128F16> {
  let ParserMatchClass = MSA128AsmOperand;
}

def MSA128BOpnd : RegisterOperand<MSA128B> {
  let ParserMatchClass = MSA128AsmOperand;
}

def MSA128HOpnd : RegisterOperand<MSA128H> {
  let ParserMatchClass = MSA128AsmOperand;
}

def MSA128WOpnd : RegisterOperand<MSA128W> {
  let ParserMatchClass = MSA128AsmOperand;
}

def MSA128DOpnd : RegisterOperand<MSA128D> {
  let ParserMatchClass = MSA128AsmOperand;
}

def MSA128CROpnd : RegisterOperand<MSACtrl> {
  let ParserMatchClass = MSACtrlAsmOperand;
}
