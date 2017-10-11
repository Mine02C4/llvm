//===-- Trsq.td - Describe the Trsq Target Machine ---------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// This is the top level entry point for the Trsq target.
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Target-independent interfaces
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

// The overall idea of the PredicateControl class is to chop the Predicates list
// into subsets that are usually overridden independently. This allows
// subclasses to partially override the predicates of their superclasses without
// having to re-add all the existing predicates.
class PredicateControl {
  // Predicates for the encoding scheme in use such as HasStdEnc
  list<Predicate> EncodingPredicates = [];
  // Predicates for the GPR size such as IsGP64bit
  list<Predicate> GPRPredicates = [];
  // Predicates for the PTR size such as IsPTR64bit
  list<Predicate> PTRPredicates = [];
  // Predicates for the FGR size and layout such as IsFP64bit
  list<Predicate> FGRPredicates = [];
  // Predicates for the instruction group membership such as ISA's and ASE's
  list<Predicate> InsnPredicates = [];
  // Predicate for marking the instruction as usable in hard-float mode only.
  list<Predicate> HardFloatPredicate = [];
  // Predicates for anything else
  list<Predicate> AdditionalPredicates = [];
  list<Predicate> Predicates = !listconcat(EncodingPredicates,
                                           GPRPredicates,
                                           PTRPredicates,
                                           FGRPredicates,
                                           InsnPredicates,
                                           HardFloatPredicate,
                                           AdditionalPredicates);
}

// Like Requires<> but for the AdditionalPredicates list
class AdditionalRequires<list<Predicate> preds> {
  list<Predicate> AdditionalPredicates = preds;
}

//===----------------------------------------------------------------------===//
// Register File, Calling Conv, Instruction Descriptions
//===----------------------------------------------------------------------===//

include "TrsqRegisterInfo.td"
include "TrsqSchedule.td"
include "TrsqInstrInfo.td"
include "TrsqCallingConv.td"

def TrsqInstrInfo : InstrInfo;

//===----------------------------------------------------------------------===//
// Trsq Subtarget features                                                    //
//===----------------------------------------------------------------------===//


//===----------------------------------------------------------------------===//
// Trsq processors supported.
//===----------------------------------------------------------------------===//

def ImplP5600 : SubtargetFeature<"p5600", "ProcImpl",
                                 "TrsqSubtarget::CPU::P5600",
                                 "The P5600 Processor", [FeatureTrsq32r5]>;

class Proc<string Name, list<SubtargetFeature> Features>
 : ProcessorModel<Name, TrsqGenericModel, Features>;

def : Proc<"mips1", [FeatureTrsq1]>;
def : Proc<"mips2", [FeatureTrsq2]>;
def : Proc<"mips32", [FeatureTrsq32]>;
def : Proc<"mips32r2", [FeatureTrsq32r2]>;
def : Proc<"mips32r3", [FeatureTrsq32r3]>;
def : Proc<"mips32r5", [FeatureTrsq32r5]>;
def : Proc<"mips32r6", [FeatureTrsq32r6]>;

def : Proc<"mips3", [FeatureTrsq3]>;
def : Proc<"mips4", [FeatureTrsq4]>;
def : Proc<"mips5", [FeatureTrsq5]>;
def : Proc<"mips64", [FeatureTrsq64]>;
def : Proc<"mips64r2", [FeatureTrsq64r2]>;
def : Proc<"mips64r3", [FeatureTrsq64r3]>;
def : Proc<"mips64r5", [FeatureTrsq64r5]>;
def : Proc<"mips64r6", [FeatureTrsq64r6]>;
def : Proc<"octeon", [FeatureTrsq64r2, FeatureCnTrsq]>;
def : ProcessorModel<"p5600", TrsqP5600Model, [ImplP5600]>;

def TrsqAsmParser : AsmParser {
  let ShouldEmitMatchRegisterName = 0;
}

def TrsqAsmParserVariant : AsmParserVariant {
  int Variant = 0;

  // Recognize hard coded registers.
  string RegisterPrefix = "$";
}

def Trsq : Target {
  let InstructionSet = TrsqInstrInfo;
  let AssemblyParsers = [TrsqAsmParser];
  let AssemblyParserVariants = [TrsqAsmParserVariant];
}
