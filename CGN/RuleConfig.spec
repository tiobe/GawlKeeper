//
// $Id: RuleConfig.spec 28823 2015-03-30 09:25:16Z stappers $
//
// (c) 2000-2013  Tiobe Software BV -- All rights reserved
//

spec unit RuleConfig

functions

InitRules()
IsRule(id : String): Bool
IsRuleEnabled(id : String): Bool
GetRuleMessage(id : String): List(String)
GetRuleSynopsis(id : String): String
ShowRules()

