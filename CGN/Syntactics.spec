spec unit Syntactics

use
Comments. Comment


functions

IndexOf(str : String, char : Char): Int
IsComment(s : String): Bool
IsNewline(s : String): Bool
IsCommentWellFormatted(s: String): Bool

// Filter only comment entries from a list.
// The scanner treats whitespace and comments similarly, so getting the comments
// attached to a symbol yields a list with multiple entries, some of which only
// contain whitespaces. This function returns a list without those, and with just
// the actual comments.
// It also returns the offset between the reported line and the actual one, i.e.
// the number of line breaks contained in the incoming list of "comments" (again,
// not just comments, but also whitespaces and newlines).
FilterComments(lines: [Comment], var offset: Int): [String]

// Remove quotes (single and double) at either ends of a string.
TrimQuotes(s : String) : String

// Check morphological correction of a network title
IsNetwTitleWellFormed(title: String): Bool

// Network stubs are empty and have names which don't follow the rules, but they
// are to be exempted from checks.
IsExceptionNetwork(netw: Network): Bool

// Check if a jump label has the right structure (characters and digits are in
// the expected places and in the right case).
IsLabelWellFormed(label: String): Bool
// Check morphological correction of a jump label (like the former function),
// and in relation with the prefix of the network it belongs to.
IsLabelWellFormed(label: String, net_prefix: String): Bool

// Extracts and returns (as a string) the numberical index of a jump label.
// If no digits are found where expected, an empty string is returned.
GetLabelNumber(label: String): String


// Returns the file name out of a path (i.e., the part behind the last directory
// separator)
GetAwlBaseFileName(file : String): String

// Returns TRUE if s starts with a capital letter or a digit, or if s is empty.
StartsWithCap(s: String): Bool

// Does this instruction modify its argument?
IsOperandChanging(instruction: Instruction): Bool

// Strip all spaces from a string
StripSpaces(s : String): String

// Convert all characters in a string to lower case
ToLower(s : String): String

// String contains a substring
ContainsSubString(str : String, sub : String): Bool

