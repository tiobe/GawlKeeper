//
// $Id: RuleViolation.spec 28823 2015-03-30 09:25:16Z stappers $
//
// (c) 2000-2013  Tiobe Software BV -- All rights reserved
//

spec unit RuleViolation

functions

SetOutputFile(file : String)
GetOutputFile(): String
SetOutputFormat(format : Int)
AddViolation(id : String, loc : Int, args : List(String))
AddViolation(id : String, loc : Int, args : List(String), offset : Int)
ShowViolations()
'(n : Int): String

