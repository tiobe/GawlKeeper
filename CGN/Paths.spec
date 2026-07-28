spec unit Paths

use

SetPrelude

typedef

// Path consists of a label and a set of initialized variables. The label indicates that
// the path is inactive until its label occurs in the code, e.g. if JU CONTINUE occurs,
// the label is set to CONTINUE because the next lines don't hold for this path. If label
// is "" the path is active.                                                                            
Path = {
  label : String
  vars : Set(Ident)
}

global

// List of all paths in the program
PATHS : List(Path)

functions

// Filter path on label
/ (paths : List(Path), label : String): Path|NIL

// Filter paths on complement of label
/~ (paths : List(Path), label : String): List(Path)

// Take the intersection of the paths of label1 and label2
// Put the intersection in label1 and remove label2
Intersect(label1 : Ident, label2 : Ident)

// Set label from l1 to l2
SetLabel(label1: String, label2 : String)

// Return the variables from a path
GetVars(p : Path|NIL): Set(Ident)
