# Swifties
### a custom language construction kit 

### intro
[Swifties](https://github.com/codr7/swifties) aims to provide a flexible toolkit for creating custom languages in Swift.

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
    try ret.eval()
})

env.openScope().bind(pos: pos, id: "foo", env.coreLib!.funcType, f)
```

Functions may alternatively be instantiated with `Form`-bodies, which emits operations behind the scenes and generates a function containing the code required to evaluate them.

```swift
let f = try Func(env: env, pos: p, name: "foo", args: [], rets: [env.coreLib!.intType])
try f.compileBody(LiteralForm(env: env, pos: p, env.coreLib!.intType, 42))
```

### types
Two levels of types are used, `ÀnyType`, and it's direct parameterized subclass `Type<T>` from which all other types inherit.

- Any - Any kind of value
- Bool - Boolean values
- Cont - Continuations as values
- Func - Functions as values
- Int - Integer values
- Macro - Macros as values
- Meta - Types as values
- Prim - Primitives as values
- Register - Register references as values
- Stack - Stack values

### parsing
`Parser` may be used to simplify the process of turning code into forms.

```swift
let pos = Pos("test", line: -1, column: -1)
let env = Env()
try env.initCoreLib(pos: pos)

let parser = Parser(env: env, source: "test",
                    spaceReader, intReader)
                    
try parser.slurp("1 2 3")
for f in parser.forms { try f.emit() }
env.emit(STOP)
try env.eval(0)

XCTAssertEqual(Slot(env.coreLib!.intType, 3), env.pop()!) 
XCTAssertEqual(Slot(env.coreLib!.intType, 2), env.pop()!) 
XCTAssertEqual(Slot(env.coreLib!.intType, 1), env.pop()!) 
```

#### readers
Readers specialize in parsing a specific kind of form.

- Int - Reads Int forms
- Space - Skips whitespace

It's trivial to extend the framework with custom readers. 
Just make sure to return `nil` if you can't find what you're looking for, since each reader is tried in sequence for every new position.

```swift
public class IdReader: Reader {
    public func readForm(_ p: Parser) throws -> Form? {
        let fpos = p.pos
        var out = ""
        
        while let c = p.getc() {
            if c.isWhitespace || c == "(" || c == ")" {
                p.ungetc(c)
                break
            }
            
            out.append(c)
            p.nextColumn()
        }
        
        return (out.count == 0) ? nil : IdForm(env: p.env, pos: fpos, name: out)
    }
}
```

### forms
Code is parsed into forms, which is what primitives and macros operate on.

- Call - Emits code to call specified target with args
- Do - Emits args in sequence
- Id - Emits the value of specified binding and calls it if possible
- Literal - Emits code to push specified value
- Stack - Emits code to push a stack with specified items

### operations
Forms emit operations, which are the basic building blocks that are eventually evaluated in sequence to get the desired result.

- Bench - Repeats body specified number of times and pushes elapsed time in milliseconds
- Branch - Conditional Goto
- Call - Call specified value
- Goto - Goto specified `Pc`
- Load - Load value from specified register
- Push - Push specified value on stack
- PushDown - Push top of stack onto next item
- Recall - Optimized tail call
- Reset - Clear stack
- Restore - Restore continuation
- Return - Pop frame from call stack and goto return pc
- Splat - Replace top item with it's items
- Stop - Stop evaluation
- Store - Store value in specified register
- Suspend - Push continuation

Operations may be manually emitted at any point using `Env.emit(Op)`.

```swift
let pos = Pos("test", line: -1, column: -1)
let env = Env()
try env.initCoreLib(pos: pos)
let v = Slot(env.coreLib!.intType, 42)
env.emit(Push(pc: env.pc, v))
env.emit(STOP)
try env.eval(0)
XCTAssertEqual(v, env.pop()!)
```

### demo
A custom Lisp with REPL is [provided](https://github.com/codr7/swifties-repl) for demonstration purposes.

### todo
- add sub scope for func
- add return prim
    - emit args & Return
- add Nil type/Maybe type
- add multi
- add suspend prim
    - (suspend ...)
    - emit jump
        - add Jump(pc:)
        - add Nop(pc:)
    - push cont
    - emit args
    - emit stop
- implement callValue for Cont
    - env.restore
- make suggestions based on edit distance for missing ids
    - recursive like find
- add unsafe prim
    - add Env.safetyLevel = 0
    - add Unsafe op
        - copy Bench
        - dec/inc safetyLevel
    - add Env.isUnsafe { safetyLevel > 0 }
    - skip Func.IsApplicable if env.isUnsafe
    - skip result check in Frame.restore if env.isUnsafe
