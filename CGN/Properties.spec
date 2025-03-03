spec unit Properties

use
Comments. Comment

functions

GetTitle(network : Network): (String)
GetTitle(block : Block): String

GetName(ref: Reference): String
GetName(fld: Field): String

// Returns the file line "encoded" into the LOC value.
GetLocLine(loc: Int): Int

GetComments(me : Instruction): List(Comment)
GetComments(me : Field): List(Comment)

GetLabel(inst: Instruction): String
