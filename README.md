# GawlKeeper

GawlKeeper is a static code analyzer for the programming language AWL. 

## Usage

```text
GawlKeeper [<option>|<rule>]... <file>
```

- `--<rule_nr>` &mdash; Enables rule number `<rule_nr>`.
  - **Example:** `--C007`
- `-cyclox` &mdash; Calculate the cyclomatic complexity of a file.
- `-help` &mdash; Show all available options.
- `-showrules` &mdash; Display a table of rules.
- `-version` &mdash; Print version information and terminate.

`<file>` is an AWL file.

# Rules

| Rule | Description |
|------|-------------|
| **C001** | Name (Header) and Author are not used and must be empty. |
| **C006** | Each network must have a Network Title, which must indicate its functionality, and it must begin with 2 uppercase letters, a colon, and a space. |
| **C007** | The 2 capital letters at the start of network titles must reflect the order in which they are defined. |
| **C011** | Jump labels. |
| **C014** | All Symbolic Operand Names are a concatenation of nouns, each starting with a capital letter and connected by underscores. |
| **C015** | The length of a block title has a maximum of 20 characters. |
| **C020** | The names of local variables (other than the preset local variables of OBs) shall start with a lowercase prefix character according to their type. |
| **C023** | Using an IO as an interface is not allowed. |
| **C030** | If a global variable is changed more than once in a block, the changes should be made within the same network. |
| **C034** | When using AR1, make sure that after loading and before use no other blocks are called and no higher data types are accessed. |
| **C035** | When using AR2 in an FB, first save the contents and then restore them after use. In the meantime, no symbolic access to the instance is allowed. |
| **C039** | Siemens Timers should never be used in relation to physical movements in a conveyor system that can be stopped. |
| **C040** | Writing to instance blocks is, in principle, forbidden. |
| **C042** | All arrays must start from zero. |
| **C048** | Reading global data from global DBs must be done in the first network (`AA`). |
| **C049** | Writing global data into global DBs must be done in the last network (`ZA`). |
| **C052** | Outputs should only be written once and preferably in the last network of a block. An exception can be made if the condition is very simple. |
| **C066** | Temporary modifications to a standard block due to an approved Problem Report or Change Request, prior to the next release, must be indicated as a **Q-Version**. |
| **C076** | A temporary variable shall always be assigned a value before it is read. |
| **C078** | Flank instructions shall always be executed unconditionally. |
| **G003** | Block name is filename. |
| **G012** | An explanation of the variables and/or parameters must be given in the comment area of the Variable Declaration list. |
| **G021** | Comments for declarations. |
| **G022** | Multi-instance block calls. |
| **G028** | Comment line. |
| **G040** | All unused variables are removed. |
| **G041** | No empty networks in the block. |
| **G043** | Every network has network comments. |
