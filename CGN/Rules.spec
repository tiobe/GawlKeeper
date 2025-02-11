//
// $Id: Rules.spec 49446 2023-08-22 17:03:35Z jansen $
//
// (c) 2003-2016  Tiobe Software BV -- All rights reserved
//

spec unit Rules

functions

Check(rule : String, loc : Int, me : GawlKeeper)
Check(rule : String, loc : Int, me : List(Comment))
Check(rule : String, loc : Int, me : Network)
Check(rule : String, loc : Int)
