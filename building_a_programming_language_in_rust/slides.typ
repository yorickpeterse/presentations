#let font = "Noto Sans"
#let font_size = 24pt
#let code_font = "IosevkaCustom Nerd Font"
#let grey = rgb("#5e5e5e")

#set page(paper: "presentation-16-9", fill: rgb("#f2f2f2"))

// Text
#set text(font: font, size: font_size)
#set par(spacing: 1.5em, leading: 0.7em)
#show link: set text(fill: rgb("#0c52bb"), weight: 500)

// Headings
#show heading: set block(below: 1em, above: 1.5em)
#show heading.where(level: 1): set text(size: 48pt)

// Footnotes
#show footnote.entry: set text(size: 16pt, fill: grey)
#set footnote.entry(
  separator: line(length: 100%, stroke: 0.5pt + grey),
  indent: 0em
)
#set page(header: counter(footnote).update(0))

// Code blocks
#show raw: set text(font: code_font, size: 16pt)
#show raw.where(block: true): set par(leading: 0.5em)
#show raw.where(block: false): it => [
  #set text(size: font_size)
  #box(
    fill: rgb("#fbfbfb"),
    inset: (left: 5pt, right: 5pt),
    outset: (top: 5pt, bottom: 5pt),
    stroke: 0.5pt + rgb("#ddd"),
    radius: 5pt,
  )[#it]]
#show raw: set raw(theme: "grey.tmTheme")
#show raw.where(lang: "inko"): set raw(syntaxes: "inko.sublime-syntax")

#align(center + horizon)[
  = Building a programming language in Rust
]

#pagebreak() // ---------------------------------------------------------------

== Sections

- Context/backstory
- History
- Design/implementation
- Testing
- Challenges and tips
- Questions
  - Please wait until the end so we don't run out of time

#pagebreak() // ---------------------------------------------------------------

== The language: Inko

- Development started in 2015
- Compiles to machine code using LLVM
- Compiler written in Rust
- Small runtime library written in Rust
- Standard library written in Inko itself
- 86 000 lines of Rust (including tests)
- 47 000 lines of Inko (excluding tests)

#pagebreak() // ---------------------------------------------------------------

== Features

- Statically typed with local type inference
- Type safe concurrency, shared nothing
- No data races and explicit locking
- Lightweight processes (think Erlang)
- Single ownership and move semantics
- No compile-time borrow checker

#pagebreak() // ---------------------------------------------------------------

== Why Inko instead of Rust?

- Concurrency built into the language, no async/await mess
- Batteries included standard library
- Emphasis on accessibility/ease of use
- Faster compile times (in theory)
- No package build/post-install hooks
- Decentralized package manager
- No macros

#pagebreak() // ---------------------------------------------------------------

== Why not Inko?

- Tiny community
- Tiny ecosystem
- May not exist ten years from now
- Not as fast as Rust
- Not as low-level as Rust (by design)
- Embedded devices aren't a priority
- No borrow checker
- No macros

#pagebreak() // ---------------------------------------------------------------

#align(center + horizon)[
  = What does Inko look like?
]

#pagebreak() // ---------------------------------------------------------------

== Hello world

```inko
import std.stdio (Stdout)

type async Main {
  fn async main {
    Stdout.new.print('Hello, world!')
  }
}

# Main.main is the entry point (main() in Rust)
```

#pagebreak() // ---------------------------------------------------------------

== Hello HTTP

```inko
import std.net.http.server (Handle, Request, Response, Server)

type async Main {
  fn async main {
    Server.new(fn { recover App() }).start(8_000).or_panic
  }
}

type App {}

impl Handle for App {
  fn pub mut handle(request: mut Request) -> Response {
    Response.new.string('Hello, world!')
  }
}
```

#pagebreak() // ---------------------------------------------------------------

== Self-referential types

```inko
# A doubly linked list
type Node[T] {
  let @value: T             # The value of the node
  let @next:  Option[T]     # The next node, owned
  let @prev:  Option[mut T] # A mutable borrow of the previous node
}

let a = Node(value: 10, next: Option.None, prev: Option.None)
let b = Node(value: 20, next: Option.None, prev: Option.None)

b.prev = Option.Some(mut a)
a.next = Option.Some(b)

# This is perfectly valid in Inko
move_somewhere(a)
```

#pagebreak() // ---------------------------------------------------------------

#align(center + horizon)[

  = But why?

  "Why not just use Python?"
]

#pagebreak() // ---------------------------------------------------------------

== Why another programming language?

- Using Ruby in 2015
- Difficult to work with in large projects (GitLab)
- Poor concurrency support
- Existing languages didn't meet what I was looking for
- I had experience with similar projects
  - ruby-lint: the only static analysis tool for Ruby that actually worked
    somewhat (at the time)
- Experimenting with new ideas is easier when you start from scratch

#pagebreak() // ---------------------------------------------------------------

== What language to write it in?

- *Ruby*: too slow, too high-level
- *C/C++*: too painful, every line is a security vulnerability
- *D*: has a GC, shrinking community
- *Go*: has a GC, poor error handling, no generics
- *Rust*: new but looks promising

#pagebreak() // ---------------------------------------------------------------

== Why Rust (at the time)?

- Package manager integrated into the compiler
- Generally well designed (e.g. sensible error handling)
- Good performance (e.g. no GC getting in the way)
- Good cross-platform support
- Fewer footguns
- I actually felt comfortable/confident using it

#pagebreak() // ---------------------------------------------------------------

== Rust in 2015

- Frequent breaking changes
- More borrow types compared to today, such as `@T`, `~T`, `T~`
- Nightly builds often required
- Poor standard library support for raw memory allocations
- rust-analyzer was not a thing, RLS ate all your memory
- no rustfmt until somewhere between 2016 and 2017

#pagebreak() // ---------------------------------------------------------------

== Rust today

- Excellent tooling (cargo, rust-analyzer, rustfmt, etc)
- Large ecosystem of crates, guides, etc
- Used in a lot of places, probably runs on a dildo somewhere
  #footnote[https://github.com/buttplugio/buttplug:  Rust Implementation of the Buttplug Sex Toy Control Protocol]
- Probably the best systems language that I can think of today

#pagebreak() // ---------------------------------------------------------------

== Inko at first

- Interpreted
- Gradually typed
- Garbage collected
- Strong influence from Smalltalk
- Lightweight processes, deep copying
- Compiler written in Ruby, interpreter written in Rust

#pagebreak() // ---------------------------------------------------------------

== Inko today

- Compiler written in Rust
- Compiles to machine code instead of bytecode
- Single ownership and move semantics #footnote[Ownership You Can Count On, Adam
  Dingle, 2007]
- Type safe concurrency #footnote[Uniqueness and Reference Immutability for Safe
  Parallelism, Colin S. Gordon, 2012] without copying
- Smalltalk influence mostly gone

#pagebreak() // ---------------------------------------------------------------

#align(center + horizon)[
  = Inko's compiler

  "I have no idea what I'm doing"
]

#pagebreak() // ---------------------------------------------------------------

== Compilation stages

+ Parse source code into a token stream
+ Convert token stream into a tree structure for type checking
+ Convert tree structure into a graph for data flow analysis
+ Convert graph into LLVM code
+ Convert LLVM to machine code
+ Wait forever for LLVM to compile the code
+ Profit!

#pagebreak() // ---------------------------------------------------------------

== Intermediate representations

+ Source
+ Tokens
+ AST: Abstract Syntax Tree
+ HIR: #strong("H")igh-level #strong("I")ntermediate #strong("R")epresentation
+ MIR: #strong("M")id-level #strong("I")ntermediate #strong("R")epresentation
+ LLVM
+ Machine code

#pagebreak() // ---------------------------------------------------------------

== Tokens

#columns(2)[
```rust
struct Token {
    kind: TokenKind,
    value: String,
    location: Location,
}

enum TokenKind {
    Add,
    AddAssign,
    And,
    Arrow,
    As,
    ...
}
```

#colbreak()

```rust
struct Location {
    line_start: u32,
    line_end: u32,
    column_start: u32,
    column_end: u32,
}
```
]

#pagebreak() // ---------------------------------------------------------------

== AST

Used by the code formatter and to produce the next IR.

```rust
struct DefineMethod {
    inline: Inline,
    public: bool,
    kind: MethodKind,
    operator: bool,
    name: Identifier,
    type_parameters: Option<TypeParameters>,
    arguments: Option<MethodArguments>,
    return_type: Option<Type>,
    body: Option<Expressions>,
    location: Location,
}
```

#pagebreak() // ---------------------------------------------------------------

== HIR

Less noisy than the AST, used by the type checker.

```rust
struct DefineInstanceMethod {
    documentation: String,
    public: bool,
    inline: Inline,
    kind: MethodKind,
    name: Identifier,
    type_parameters: Vec<TypeParameter>,
    arguments: Vec<MethodArgument>,
    return_type: Option<Type>,
    body: Vec<Expression>,
    location: Location,
    method_id: Option<types::MethodId>, // Added by the type checker
}
```

#pagebreak() // ---------------------------------------------------------------

== HIR

```rust
struct ConstantRef {
    resolved_type: types::TypeRef, // Added by the type checker
    kind: types::ConstantKind,
    source: Option<Identifier>,
    name: String,
    usage: Usage,
    location: Location,
}
```

#pagebreak() // ---------------------------------------------------------------

== Type references

- Sprinkled across different structures
- Data storing them is moved around a lot
- Can't use borrows for this, use IDs instead
- IDs are just typed indexes into a `Vec`
- All type data stored in a `Database` type
- Type information isn't deleted, so don't need to worry about IDs being
  invalidated

#pagebreak() // ---------------------------------------------------------------

== Type references

#columns(2)[
  ```rust
  enum TypeRef {
      Owned(TypeEnum),
      Ref(TypeEnum),
      ...
  }
  ```

  #colbreak()

  ```rust
  enum TypeEnum {
      TypeInstance(TypeInstance),
      TraitInstance(TraitInstance),
      ...
  }
  ```
]

#columns(2)[
  ```rust
  struct TypeInstance {
      instance_of: TypeId,
      type_arguments: TypeArgumentsId,
  }
  ```

  #colbreak()

  ```rust
  struct TypeId(u32);
  ```
]

Essentially "pointers" with the storage of pointees being explicit and passed
around.

#pagebreak() // ---------------------------------------------------------------

== MIR

Graph of "basic blocks". Used for optimisations, verifying single ownership,
etc.

#columns(2)[
  ```rust
  struct Block {
      instructions: Vec<Instruction>,
      successors: Vec<BlockId>,
      predecessors: Vec<BlockId>,
  }

  struct Graph {
      blocks: Vec<Block>,
      start_id: BlockId,
  }
  ```

  #colbreak()

  ```rust
  struct BlockId(usize);
  ```
]

#pagebreak() // ---------------------------------------------------------------

== MIR: insertions and removals

Requires shifting of IDs (e.g. when inlining methods).

```rust
for ins in &mut block.instructions {
    match ins {
        Instruction::Branch(ins) => {
            ins.condition += reg_start;
            ins.if_true += blk_start;
            ins.if_false += blk_start;
        }
        ...
    }
}
```

#pagebreak() // ---------------------------------------------------------------

== MIR: parallel optimizations

Certain method-local optimizations are done in parallel.

```rust
thread::scope(|s| {
    for _ in 0..threads {
        s.spawn(|| loop {
            let Some(m) = queue.lock().unwrap().pop() else { break };

            m.apply_local_optimizations(consts);
        });
    }
});
```

#pagebreak() // ---------------------------------------------------------------

== MIR: parallel optimizations

```rust
fn apply_local_optimizations(&mut self, ...) {
    self.merge_switch_blocks();
    self.merge_goto_blocks();
    self.compact_switch();

    self.remove_unreachable_blocks();
    self.remove_unused_instructions();
    self.inline_constants(...);
    self.merge_redundant_moves();
}
```

Most of these are quite simple, some focus on just making the IR more readable.

#pagebreak() // ---------------------------------------------------------------

== MIR: other optimizations

- Splitting larger modules into smaller ones
- Function inlining across modules
  - Crucial because LLVM can't inline across modules
- Inter-procedural (= whole program) escape analysis
  - Eliminates about 50% of heap allocations on average
- Removal of unused symbols (methods, constants, etc)
- These are done sequentially

#pagebreak() // ---------------------------------------------------------------

== Single ownership without borrow checking

- Heap allocated values store a borrow count
- Borrows increment the count, dropping the borrows decrements the count
- Borrow counts don't use atomics, cost is minor
- When the heap value is dropped, check the count first and panic if non-zero

#pagebreak() // ---------------------------------------------------------------

== Single ownership without borrow checking

- May sound bad/slow, but works surprisingly well
- Easy to debug in the rare cases that it occurs
- Moving owned values incurs no increments
- Moving while borrowing a heap value is fine because it resides in a stable
  location
- Can still build compile-time analysis on top (e.g. optimizations)
- This is _not_ `Rc<RefCell<T>>` as Inko doesn't enforce XOR mutability
- End goal: 80% of the benefits of Rust, at a fraction of the cost

#pagebreak() // ---------------------------------------------------------------

== Single ownership without borrow checking

- Inko also supports stack allocated types, these are copied upon borrowing them
  (similar to Swift structs)
- There are also atomically reference counted types, used for strings, processes
  and certain user-defined types

#pagebreak() // ---------------------------------------------------------------

== MIR: single ownership analysis

- Analysis done using the MIR
- If the availability of a register changes it's stored in the current _basic
  block_
- The state of the register when referred to is based on the state of all
  predecessor blocks

#pagebreak() // ---------------------------------------------------------------

#align(center)[
  ```
                                                C
                                    true    ╭───────╮
        A               B        ╭────────> │ b = a │ ──╮        E
  ╭──────────╮     ╭─────────╮   │          ╰───────╯   │    ╭───────╮
  │ a = [10] │ ──> │ if cond │ ──┤                      ├──> │ after │
  ╰──────────╯     ╰─────────╯   │          ╭───────╮   │    ╰───────╯
                                 ╰────────> │  bar  │ ──╯
                                    false   ╰───────╯
                                                D
  ```
]

State of `a` in:

- C: moved
- D: available
- E: moved OR available → maybe moved

#pagebreak() // ---------------------------------------------------------------

== Generating LLVM

- Done using Inkwell #footnote[https://github.com/TheDan64/inkwell]
- Inkwell offers little safety on top of LLVM, LLVM crashes easily
- Initially tried using Cranelift, but it was sorely lacking
- Incrementally and parallel
- 80% of Inko's compile times are spent in LLVM
- Remaining 20% is everything else, inlining takes up a decent chunk

#pagebreak() // ---------------------------------------------------------------

== Generating LLVM

```rust
fn instruction(&mut self, all_blocks: &[BasicBlock], ins: &Instruction) {
    match ins {
        Instruction::CallBuiltin(ins) => {
            ...
        }

        // ... 1500+ lines of code ...
    }
}
```

Most happens in a single giant `match` that lowers each MIR instruction.

#pagebreak() // ---------------------------------------------------------------

== Generating LLVM

Integer division:

```rust
let reg_var = self.variables[&ins.register];
let lhs_var = self.variables[&ins.arguments[0]];
let rhs_var = self.variables[&ins.arguments[1]];
let lhs = self.builder.load_int(lhs_var);
let rhs = self.builder.load_int(rhs_var);
let res = self.builder.int_div(lhs, rhs);

self.builder.store(reg_var, res);
```

#pagebreak() // ---------------------------------------------------------------

== Linking

- Probably the most boring part
- Done using the appropriate system linker/driver (e.g. clang)
- Has to shell out since there's no portable linker library similar to LLVM
- Has some special handling to automatically select a fast linker (lld, mold,
  etc)
- Usually only takes up a tiny percentage of time

#pagebreak() // ---------------------------------------------------------------

#align(center + horizon)[
  = Testing

  "But it works on my laptop!"
]

#pagebreak() // ---------------------------------------------------------------

== Testing

Rust unit tests:

```rust
#[test]
fn test_check_return() {
    let mut db = Database::new();
    let thing = new_type(&mut db, "Thing");
    let owned_var = TypePlaceholder::alloc(&mut db, None).as_owned();
    let uni_var = TypePlaceholder::alloc(&mut db, None).as_uni();
    let ref_var = TypePlaceholder::alloc(&mut db, None).as_ref();
    let mut_var = TypePlaceholder::alloc(&mut db, None).as_mut();

    check_err_return(&db, owned(instance(thing)), any(instance(thing)));
    check_err_return(&db, uni(instance(thing)), any(instance(thing)));
    ...
}
```

#pagebreak() // ---------------------------------------------------------------

== Integration tests vs unit tests

- Writing unit tests for a compiler gets very tedious
- Lots of boilerplate to set things up
- Small internal change may require updating many unit tests
- High-level integration tests are a lot easier to work with
- Allows for much faster testing/development cycle
- Various low-level type system tests are still written in Rust

#pagebreak() // ---------------------------------------------------------------

== Integration tests

- Compiler diagnostics
- Escape analysis
- Code formatting

#pagebreak() // ---------------------------------------------------------------

== Integration tests: diagnostics

```inko
type A {}

type A {}

# duplicate.inko:3:6 error(duplicate-symbol): the symbol 'A' is already defined
```

A file that contains some Inko code and a list of expected diagnostics at the
end.

#pagebreak() // ---------------------------------------------------------------

== Integration tests: escape analysis

```inko
type A {}

type async Main {
  fn async main {
    A()
  }
}

# 5:5 A stack
```

Same idea: regular Inko code and a list of allocation sites and their location
(stack or the heap).

#pagebreak() // ---------------------------------------------------------------

== Integration tests: formatting

- Two files in a directory: `input.inko` and `output.inko`
- Compiler runs `inko fmt input.inko`, asserts the output equals `output.inko`
- Can't fit them on a single slide :(

#pagebreak() // ---------------------------------------------------------------

== Inko standard library tests

```inko
import std.test (Tests)

fn pub tests(t: mut Tests) {
  t.test('StringBuffer.into_string', fn (t) {
    let buf = StringBuffer.new

    buf.push('a')
    buf.push('😃')
    buf.push('b')
    t.equal(buf.into_string, 'a😃b')
  })
}
```

#pagebreak() // ---------------------------------------------------------------

== Inko standard library tests

- Standard library is very "algorithmic" heavy
- Most of the code requires little to no setup code
- Unit tests make more sense here than coarse integration tests
- Lots of table driven tests

#pagebreak() // ---------------------------------------------------------------

== Table driven test

```inko
t.test('PullParser.string', fn (t) {
  let tests = [
    # (INPUT, EXPECTED)
    ('"foo"', Result.Ok('foo')),
    ...
  ]

  for (inp, res) in tests {
    t.equal(PullParser.new(Buffer.new(inp)).string, res)
  }
})
```

One test essentially expands into 100 tests/asserts.

#pagebreak() // ---------------------------------------------------------------

== Test statistics

- 767 Rust unit tests, most contain 5-10 asserts at minimum
- 2277 Inko tests, similar number of asserts per test
- Actual number higher due to integration and table tests
- `cargo test` takes 125 milliseconds to run
- `inko test` takes 3.1 seconds to run
- CI takes 11-12 minutes tests across Linux, macOS and FreeBSD
- Could be half that if GitHub Actions supported FreeBSD

#pagebreak() // ---------------------------------------------------------------

#align(center + horizon)[
  = Challenges and tips

  Or what you can learn from all this.
]

#pagebreak() // ---------------------------------------------------------------

== Challenge: the borrow checker

Code such as this is quite common when writing compilers:

```rust
for value in &mut self.values {
  self.update_something_in_self(value);
}
```

#pagebreak() // ---------------------------------------------------------------

== Challenge: the borrow checker

Deep nesting when borrowing multiple fields in `self`:

```rust
fn mark_escaping(&mut self) {
    for block in &self.method.body.blocks {
        for ins in &block.instructions {
            match ins {
                Instruction::CallStatic(i) => {
                    ...
                }
                ...
            }
        }
    }
}
```

#pagebreak() // ---------------------------------------------------------------

== Challenge: the borrow checker

- Some recent methods (e.g. `slice::get_disjoint_mut`) can help, but often come with
  a runtime cost
- Using IDs instead of borrows can work
- There are some creative solutions (e.g. GhostCell) but they usually come with
  big caveats
- Often there's no good solution other than to just accept it

#pagebreak() // ---------------------------------------------------------------

== Challenge: enums can be too rigid

Using an `enum` for `TypeRef` makes it too rigid, can't easily add fields
without large changes. Better to use something like this:

#columns(2)[
  ```rust
  struct TypeRef {
      ownership: Ownership,
      type_enum: TypeEnum,
  }
  ```

  #colbreak()

  ```rust
  enum Ownership {
      Owned,
      Ref,
      ...
  }
  ```
]

#pagebreak() // ---------------------------------------------------------------

#columns(2)[
  == Tip: pattern matching

  Writing a compiler without good pattern matching support would be _much_
  harder.

  Pattern matching is often better than complex Java-style dispatch chains (e.g.
  the visitor pattern).

  #colbreak()

  #image("images/pmatch.jpg")
]

== Tip: reduce unsafe code

This is what peak Rust looks like:

```
$ rg 'unsafe \{' compiler/ inko/ types/ ast/ rt/ | wc -l
160
```

- LLVM is one giant unsafe library
- Writing a good thread scheduler in safe Rust is impossible
- Runtime exposes a bunch of functions using the system ABI

#pagebreak() // ---------------------------------------------------------------

== Tip: reduce unsafe code

- Less `unsafe` doesn't necessarily make your code more safe, but it definitely
  makes it less unsafe.
- Sometimes the decision to mark something as `unsafe` can feel a bit arbitrary
- Can't always work around it and that's OK, just be mindful of it

#pagebreak() // ---------------------------------------------------------------

== Tip: reduce the use of macros

- They _can_ be useful, but often figuring out what they actually do is
  difficult
- Even more so with proc macros
- rust-analyzer, rustfmt, etc just give up inside macro bodies
- Fewer macros = better compile times

#pagebreak() // ---------------------------------------------------------------

== Tip: reduce third-party dependencies

- The compiler has 5 direct dependencies
- The runtime has 10 direct dependencies, and a vendored version of
  rustls-platform-modifier #footnote[https://github.com/rustls/rustls/issues/850]
- Inko first used a custom setup for IO, then moved to the polling crate
  #footnote[https://github.com/smol-rs/polling], then back to a custom setup #footnote[https://github.com/inko-lang/inko/issues/344]
- Allows greater control over your program

#pagebreak() // ---------------------------------------------------------------

== Tip: keep compile times under control

- Fewer dependencies really helps
- crates being the compilation unit hurts compile times, splitting necessary
- `cargo check`: 5 seconds
- `cargo build`: 8 seconds
- `cargo build --release`: 15 seconds
- These are full builds, with all dependencies already downloaded
- This is difficult for large projects with many developers

#pagebreak() // ---------------------------------------------------------------

#align(center + horizon)[
  = Conclusion
]

#pagebreak() // ---------------------------------------------------------------

== Conclusion

- Rust does have its challenges when writing a compiler
- Without Rust I probably couldn't have built Inko
- Not sure what alternative I'd pick (self-hosting too much work)
- Works best when you're aggressive about keeping control
- Not sure Rust makes much sense for higher level applications
- I'd use Inko 😉, Gleam #footnote[https://gleam.run/], or Go

#pagebreak() // ---------------------------------------------------------------

#grid(
columns: (2fr, 1fr),
[
  == Learn more

  - #link("https://yorickpeterse.com")
  - #link("https://inko-lang.org")
  - #link("https://github.com/inko-lang/inko")
],
[
  #align(right)[
    #image("images/qr.svg", width: 100%)
  ]
]
)
