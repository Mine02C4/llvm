//===-- TrsqInstrFormats.td - Trsq Instruction Formats -----*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

class Format<bits<3> val> {
  bits<3> Value = val;
}

def Pseudo    : Format<0>;
def FormFile  : Format<1>;
def FormBit   : Format<2>;
def FormCtrl  : Format<3>;
def FormOther : Format<4>; // Instruction w/ a custom format

class TrsqInst<dag outs, dag ins, string asmstr, list<dag> pattern, InstrItinClass itin, Format f>
  : Instruction
{
  field bits<16> Inst;
  Format Form = f;
  let Namespace = "Trsq";
  let Size = 1;
  let OutOperandList = outs;
  let InOperandList = ins;
  let AsmString = asmstr;
  let Pattern = pattern;
  let Itinerary = itin;

  bits<3> FormBits = Form.Value;
  let DecoderNamespace = "Trsq";

  field bits<8> SoftFail = 0;
}

class TrsqInstFormFile<bits<8> op, dag outs, dag ins, string asmstr, list<dag> pattern, InstrItinClass itin>
  : TrsqInst<outs, ins, asmstr, pattern, itin, FormFile>
{
  bits<8> file;
  let Inst{15-8} = op;
  let Inst{7-0} = file;
}

class TrsqInstFormBit<bits<5> op, dag outs, dag ins, string asmstr, list<dag> pattern, InstrItinClass itin>
  : TrsqInst<outs, ins, asmstr, pattern, itin, FormBit>
{
  bits<8> file;
  bits<3> bit;
  let Inst{15-11} = op;
  let Inst{10-8} = bit;
  let Inst{7-0} = file;
}

class TrsqInstFormCtrl<dag outs, dag ins, string asmstr, list<dag> pattern, InstrItinClass itin>
  : TrsqInst<outs, ins, asmstr, pattern, itin, FormCtrl>
{
}


// Trsq Pseudo Instructions Format
class TrsqPseudo<dag outs, dag ins, list<dag> pattern> :
  TrsqInst<outs, ins, "", pattern, IICPseudo, Pseudo> {
  let isCodeGenOnly = 1;
  let isPseudo = 1;
}

class ArithLogicInst<bits<8> op, string asmstr, SDNode OpNode, InstrItinClass itin, RegisterClass RC>
  : TrsqInstFormFile<op, (outs RC:$wr), (ins RC:$ra, RC:$wr), !strconcat(asmstr, " $ra"),
    [(set RC:$wr, (OpNode RC:$ra, RC:$wr))], itin>
{
}
def ADD : ArithLogicInst<0x20, "ADD", add, IICAlu, CPURegs>;
def SUB : ArithLogicInst<0x21, "SUB", sub, IICAlu, CPURegs>;

