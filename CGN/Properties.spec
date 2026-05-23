spec unit Properties

use
Comments. Comment

functions

GetBlockType(block : Block): String
GetName(block : Block): String
HasComment(block : Block, comment : String): Bool

GetTitle(network : Network): (String)

GetNetwPrefix(network: Network): String

// Get all declared variables
GetReferences(fb: FunctionBody): List(Reference)

GetName(ref: Reference): String
GetName(fld: Field): String

// Remove quotes if present
GetRawName(ref: Reference): String

GetComments(me : Instruction): List(Comment)
GetComments(me : Field): List(Comment)
GetFullComments(me : List(Field)): List(String)

// Returns the jump label attached to an instruction, if any, or else an
// empty string.
GetLabel(inst: Instruction): String

GetGlobalVar(arg: InstrExpression): GlobalVariable|NIL

IsDatabaseAction(expr: InstrExpression): Bool

IsLoadingAR1(instr : InstructionName): Bool
IsSymbolicReference(instr : Instruction): Bool
IsUsingAR1(instr : InstrExpression|NIL): Bool

IsAccessingAR2(locals : List(String), instr : Instruction): Bool
IsModifyingAR2(instr : InstructionName): Bool
IsRestoringAR2(instr : Instruction): Bool

IsLoadInstruction(instr: InstructionName): Bool
IsOutputInstruction(instr: InstructionName): Bool

IsUsed(ref : String, networks: List(Network)): Bool

