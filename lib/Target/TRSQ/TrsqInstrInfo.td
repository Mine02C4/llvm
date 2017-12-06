//===- TrsqInstrInfo.td - Target Description for Trsq Target -*- tablegen -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the Trsq implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//


//===----------------------------------------------------------------------===//
// Trsq profiles and nodes
//===----------------------------------------------------------------------===//

// Call
def SDT_TrsqCall : SDTypeProfile<0, 1, [SDTCisVT<0, iPTR>]>;
//def TrsqJmpLink : SDNode<"TrsqISD::JmpLink",SDT_TrsqCall,
//                         [SDNPHasChain, SDNPOutGlue, SDNPOptInGlue,
//                          SDNPVariadic]>;
def TrsqCall : SDNode<"TrsqISD::Call" , SDT_TrsqCall,
  [SDNPHasChain, SDNPOutGlue, SDNPOptInGlue, SDNPVariadic]>;

// Tail call
def TrsqTailCall : SDNode<"TrsqISD::TailCall", SDT_TrsqJmpLink,
                          [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

def : Pat<(TrsqCall (i16 tglobaladdr:$dst)), (CALL tglobaladdr:$dst)>;
def : Pat<(TrsqCall (i16 texternalsym:$dst)), (CALL texternalsym:$dst)>;

def calltarget : Operand<iPTR> {
  let EncoderMethod = "getCallTargetOpValue";
}

class Call<bits<2> op, string asmstr> :
  TrsqInstFormCtrl<(outs), (ins calltarget:$other, variable_ops),
  !strconcat(asmstr, "\t$other"), [(TrsqCall imm:$other)],
  IICBranch>
{
  let isCall = 1;
  let DecoderMethod = "DecodeCallTarget";
}

def CALL : Call<0x3, "call">;

def mem : Operand<i8>
{
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops CPURegs, i16imm);
  let EncoderMethod = "getMemEncoding";
}

def addr : ComplexPattern(iPTR, 2, "SelectAddr", [], []>;

class FMem<bits<8> op, dag outs, dag ins, string asmstr, list<dag> pattern, InstrItinClass itin>
  : TrsqInstFormFile<op, outs, ins, asmstr, pattern, itin>
{
  bits<8> addr;
  let Inst{7-0} = addr;
  let DecoderMethod = "DecodeMem";
}

// Load
let canFoldAsLoad = 1 in
class LoadM<bits<8> op, string asmstr, RegisterClass RC>
  : FMem<op, (outs RC:$wr), (ins mem:$addr), !strconcat(asmstr, " $addr"),
  [(set RC:$wr, (load addr:$addr))], IICLoad>;
def LOAD : LoadM<0x2d, "LD", CPURegs>;

// Store
class StoreM<bits<8> op, string asmstr, RegisterClass RC>
  : FMmem<op, (outs RC:$wr, mem:$addr)], !strconcat(asmstr, " $addr"),
  [(store RC:$wr, addr:$addr)], IICStore>;
def STORE : StoreM<0x2c, "ST", CPURegs>;

