//===-- TrsqSchedule.td - Trsq Scheduling Definitions ------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

def ALU     : FuncUnit;
//def IMULDIV : FuncUnit;

def IICAlu : InstrItinClass;
def IICLoad : InstrItinClass;
def IICStore : InstrItinClass;
def IICBranch : InstrItinClass;
def IICPseudo : InstrItinClass;

//===----------------------------------------------------------------------===//
// Trsq Generic instruction itineraries.
//===----------------------------------------------------------------------===//
def TrsqGenericItineraries : ProcessorItineraries<[ALU], [], [
  InstrItinData<IICAlu    , [InstrStage<1, [ALU]>]>,
  InstrItinData<IICLoad   , [InstrStage<1, [ALU]>]>,
  InstrItinData<IICStore  , [InstrStage<1, [ALU]>]>,
  InstrItinData<IICBranch , [InstrStage<1, [ALU]>]>,
  InstrItinData<IICPseudo , [InstrStage<1, [ALU]>]>
]>;

