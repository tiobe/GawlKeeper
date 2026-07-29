# GawlKeeper

GawlKeeper is a static code analyzer for the programming language AWL. 

## Repository layout

| Directory | Contents |
|---|---|
| `CGN/` | Elegant sources for the checker itself (parsing, rule checking) |
| `Grammar/` | AWL grammar definition (Elegant `.front` format) |
| `Domains/` | Supporting C libraries linked into the generated tool |
| `test/` | Rule-violation regression tests, run via `test/all.sh` |

## Building

GawlKeeper is built with the Elegant toolkit, so a checkout of
[`elegant-sdk`](https://github.com/tiobe/elegant-sdk) (the Elegant
compiler/SDK) and [`elegant-common`](https://github.com/tiobe/elegant-common)
(shared `common`/`version`/`resources` libraries) is required alongside
this repository. The makefile autodiscovers both as siblings of this
checkout, i.e. a layout like:

```
workspace/
├── elegant-sdk/
├── elegant-common/
└── GawlKeeper/          <- run `make` from here
```

needs no extra arguments. Both paths can also be overridden explicitly:

```sh
make ARCH=linux64 \
  ELEGANTROOT=/path/to/elegant-sdk \
  ELEGANTCOMMON=/path/to/elegant-common
```

`ARCH` selects the target platform (`linux64`, `linux`, `win64`, `win32`,
`macos64`, `macos`, `sunos`). The build produces a `GawlKeeper.$(ARCH)`
binary in the repository root.

Use `BUILDCFG` to select a build configuration (`optimize` by default,
or `debug`/`profile`). `SEMVER` is normally supplied by CI (from
GitVersion); local builds with nothing set fall back to a
`git describe`-based approximation (see the makefile), and is baked
into the binary, reported by `-version`.

## Testing

```sh
make test
```

Runs `test/all.sh`, which exercises every rule (`GawlKeeper -showrules`)
against its sample inputs under `test/` and diffs the result against
each directory's `expected_output`.

## Packaging

```sh
make package
```

Builds a clean release, generates `info.json` (version/date metadata),
and produces a `GawlKeeper-<semver>-<ARCH>.zip` archive.

## Continuous integration

`.github/workflows/build.yml` builds GawlKeeper on `linux64`/`win64` for
every push and pull request against `main`, running a smoke test and
the full test suite (`linux64` only) against `elegant-sdk`'s `main`
branch and `elegant-common` at the version pinned in this repo's own
`.elegant-common-version` file.

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

## Rules

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
| **C041** | The DEC (Decrement) and INC (Increment) instructions may only be used on variables of data type BYTE. |
| **C042** | All arrays must start from zero. |
| **C048** | Reading global data from global DBs must be done in the first network (`AA`). |
| **C049** | Writing global data into global DBs must be done in the last network (`ZA`). |
| **C052** | Outputs should only be written once and preferably in the last network of a block. An exception can be made if the condition is very simple. |
| **C066** | Temporary modifications to a standard block due to an approved Problem Report or Change Request, prior to the next release, must be indicated as a **Q-Version**. |
| **C076** | A temporary variable shall always be assigned a value before it is read. |
| **C077** | An output variable of a Function (FC) shall always have a value assigned. |
| **C078** | Flank instructions shall always be executed unconditionally. |
| **G003** | Block name is filename. |
| **G012** | An explanation of the variables and/or parameters must be given in the comment area of the Variable Declaration list. |
| **G021** | Comments for declarations. |
| **G022** | Multi-instance block calls. |
| **G028** | Comment line. |
| **G040** | All unused variables are removed. |
| **G041** | No empty networks in the block. |
| **G043** | Every network has network comments. |
