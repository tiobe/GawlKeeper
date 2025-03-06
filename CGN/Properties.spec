spec unit Properties

use
Comments. Comment

functions

GetTitle(network : Network): (String)
GetTitle(block : Block): String

GetNetwPrefix(network: Network): String

GetName(ref: Reference): String
GetName(fld: Field): String

// Returns the file line "encoded" into the LOC value.
GetLocLine(loc: Int): Int

GetComments(me : Instruction): List(Comment)
GetComments(me : Field): List(Comment)

// Does this instruction modify its argument?
IsOperandChanging(instruction: Instruction): Bool

IsGlobalVar(arg: InstrExpression): GlobalVariable|NIL
