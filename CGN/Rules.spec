//
// $Id: Rules.spec 49446 2023-08-22 17:03:35Z jansen $
//
// (c) 2003-2016  Tiobe Software BV -- All rights reserved
//

spec unit Rules

functions

Check(rule : String, loc : Int, me : Block)
Check(rule : String, loc : Int, me : Expression)
Check(rule : String, loc : Int, me : Field)
Check(rule : String, loc : Int, me : FunctionBody)
Check(rule : String, loc : Int, me : GawlKeeper)
Check(rule : String, loc : Int, me : HeaderBlock)
Check(rule : String, loc : Int, me : Instruction)
Check(rule : String, loc : Int, me : Network)
