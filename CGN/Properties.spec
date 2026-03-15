spec unit Properties

use
Comments. Comment

functions

GetTitle(network : Network): (String)
GetTitle(block : Block): String

GetNetwPrefix(network: Network): String

// Get all declared variables
GetReferences(fb: FunctionBody): List(Reference)

GetName(ref: Reference): String
GetName(fld: Field): String

// Returns the file line "encoded" into the LOC value.
GetLocLine(loc: Int): Int

GetComments(me : Instruction): List(Comment)
GetComments(me : Field): List(Comment)

// Returns the jump label attached to an instruction, if any, or else an
// empty string.
GetLabel(inst: Instruction): String

GetGlobalVar(arg: InstrExpression): GlobalVariable|NIL

IsUsed(ref : String, networks: List(Network)): Bool
