# Swifties
### a custom language construction kit 

### intro
[Swifties](https://github.com/codr7/swifties) aims to provide a flexible toolkit for creating custom languages in Swift.

### demo
A custom Lisp with REPL is [provided](https://github.com/codr7/swifties-repl) for demonstration purposes.

### primitives
Primitives are called at compile time and may take any number (min/max are specified in the constructor) of forms as arguments and emit operations. 

```swift
let pos = Pos(source: "test", line: -1, column: -1)

let p = Prim(env: env, pos: self.pos, name: "do", (0, -1), { 
pos, args in
    for a in args { try a.emit() }
})

env.openScope().bind(pos: pos, id: "do", env.coreLib!.primType, p)
```

### functions
Functions may take any number of arguments and return any number of results; `pos` indicates the call site; evaluation resumes from the returned `Pc`.

```swift
let pos = Pos(source: "test", line: -1, column: -1)

let f = Func(env: env, pos: pos, name: "foo", args: [], rets: [env.coreLib!.intType], {
pos, self, ret in
    env.push(env.coreLib!.intType, 42)
    return ret
})

env.openScope().bind(pos: pos, id: "foo", env.coreLib!.funcType, f)
```

Functions may alternatively be instantiated with `Form`-bodies, which emits operations behind the scenes and generates a function containing the code required to evaluate them.

```swift
let f = Func(env: env, pos: pos, name: "foo", args: [], rets: [env.coreLib!.intType])
try f.compileBody(LiteralForm(env: env, pos: pos, env.coreLib!.intType, 42))
```

### multimethods
Multimethods are sets of functions sharing the same name sorted from most specific to least that delegate to the most specific applicable function when called.

```swift
let m = Multi(env: env, pos: pos, name: "foo")
f.addFunc(f)
```

### types
Two levels of types are used, `ÀnyType`, and it's direct parameterized subclass `Type<T>` from which all other types inherit.

- Any - Any kind of value
- Bool - Boolean values
- Char - Character values
- Cont - Continuations as values
- Func - Functions as values
- Int - Integer values
- Macro - Macros as values
- Meta - Types as values
- Multi - Multimethods as values
- Pair - Pairs of values
- Prim - Primitives as values
- Register - Register references as values
- Stack - Stack values
- String - String values

### parsing
`Parser` may be used to simplify the process of turning code into forms.

```swift
let pos = Pos("test", line: -1, column: -1)
let env = Env()
try env.initCoreLib(pos: pos)

let parser = Parser(env: env, source: "test",
                    prefix: [spaceReader, intReader],
                    suffix: [])
                    
try parser.slurp("1 2 3")
for f in parser.forms { try f.emit() }
env.emit(STOP)
try env.eval(0)

XCTAssertEqual(Slot(env.coreLib!.intType, 3), env.pop(pos: pos)) 
XCTAssertEqual(Slot(env.coreLib!.intType, 2), env.pop(pos: pos)) 
XCTAssertEqual(Slot(env.coreLib!.intType, 1), env.pop(pos: pos)) 
```

#### readers
Readers specialize in parsing a specific kind of form.

- Char - Reads character literals with specified prefix
- Id - Reads identifiers
- Int - Reads integer literals
- Space - Skips whitespace
- Stack - Reads stack literals with specified delimiters
- String - Reads string literals with specified quotes

It's trivial to extend the framework with custom readers. 
Just make sure to return `nil` if you can't find what you're looking for, since each reader is tried in sequence for every new position.

```swift
func intReader(_ p: Parser) throws -> Form? {
    let fpos = p.pos
    var v = 0
        
    while let c = p.getc() {
        if !c.isNumber {
            p.ungetc(c)
            break
        }
            
        v *= 10
        v += c.hexDigitValue!
        p.nextColumn()
    }
        
    return (p.pos == fpos) ? nil : LiteralForm(env: p.env, pos: p.pos, p.env.coreLib!.intType, v)
}
```

### forms
Code is parsed into forms, which is what primitives and macros operate on.

- Call - Emits code to call specified target with args
- Do - Emits args in sequence
- Id - Emits the value of specified binding and calls it if possible
- Literal - Emits code to push specified value
- Pair - Emits code to push specified pair
- Stack - Emits code to push a stack with specified items

### operations
Forms emit operations, which are the basic building blocks that are eventually evaluated in sequence to get the desired result.

- Bench - Repeats body specified number of times and pushes elapsed time in milliseconds
- Branch - Branches conditionally
- Call - Calls specified value
- Drop - Drops specified number of items from stack
- For - Repeats code for each value in sequence on top of stack
- Goto - Resumes evaluation from specified `Pc`
- Load - Loads value from specified register
- Push - Pushes specified value on stack
- PushDown - Pushes top of stack onto next item
- Recall - Restarts current function without pushing frame
- Reset - Clears stack
- Restore - Restores continuation
- Return - Pops frame from call stack and resumes evaluation from it's return pc
- Splat - Replaces top of stack with it's items
- Stop - Stops evaluation without error
- Store - Stores value in specified register
- Suspend - Pushes continuation
- Zip - Replaces top two stack items with pair

Operations may be manually emitted at any point using `Env.emit(Op)`.

```swift
let pos = Pos("test", line: -1, column: -1)
let env = Env()
try env.initCoreLib(pos: pos)
let v = Slot(env.coreLib!.intType, 42)
env.emit(Push(pc: env.pc, v))
env.emit(STOP)
try env.eval(0)
XCTAssertEqual(v, env.pop(pos: pos))
```

### todo
- add filter like map
- add lambdas
    - extract subclass from Func
    - add type
    - trap stack target in call form
        - push lambda
        - ([x y z] [] ...)
- finish macros
- add support for \n & \t to char/stringReader
- add string interpolation
    - swift syntax
- add unsafe prim
    - add Env.safetyLevel = 0
    - add Unsafe op
        - copy Bench
        - dec/defer inc safetyLevel
    - add Env.unsafe { safetyLevel > 0 }
    - skip Func.IsApplicable if env.unsafe
    - skip result check in Frame.restore if env.unsafe
- add return prim
    - emit args & Return
- make suggestions based on edit distance for missing ids
    - recursive like find
- add parse func String -> [Form]
- add compile func Seq -> Bin
    - track pc & cut
    - (compile (parse "42"))
    - add (asm Bin) func
    - add Op.dump
