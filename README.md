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

env.beginScope().bind(pos: pos, id: "do", env.coreLib!.primType, p)
```

### functions
Functions may take any number of arguments and return any number of results; `pos` indicates the call site; evaluation resumes from the returned `Pc`.

```swift
let pos = Pos(source: "test", line: -1, column: -1)

let f = Func(env: env, pos: pos, name: "foo", args: [], rets: [env.coreLib!.intType], {
pos, self, retPc -> Pc in
    env.push(env.coreLib!.intType, 42)
    return retPc
})

env.beginScope().bind(pos: pos, id: "foo", env.coreLib!.funcType, f)
```

Functions may alternatively be instantiated with `Form`-bodies, which emits operations behind the scenes and generates a function containing the code required to evaluate them.

```swift
let f = try Func(env: env, pos: p, name: "foo",
                 args: [],
                 rets: [env.coreLib!.intType],
                 LiteralForm(env: env, pos: p, env.coreLib!.intType, 42))
```
### operations
Operations are the basic building blocks that are eventually evaluated in sequence to get the desired result.

- Call - Call specified value
- Goto - Goto specified `Pc`
- Load - Load value from specified register
- Push - Push specified value on stack
- PushDown - Push top of stack onto next item
- Reset - Clear stack
- Restore - Restore continuation
- Return - Pop frame from call stack and goto return pc
- Splat - Replace top item with it's items
- Stop - Stop evaluation
- Store - Store value in specified register
- Suspend - Push continuation

Operations may be manually emitted at any point using `Env.emit(Op)`.

```
let pos = Pos("test", line: -1, column: -1)
let env = Env()
try env.initCoreLib(pos: pos)
let v = Slot(env.coreLib!.intType, 42)
env.emit(Push(pc: env.pc, v))
env.emit(STOP)
try env.eval(pc: 0)
XCTAssertEqual(v, env.pop()!)
```

### types
Two kinds of types are used, `ÀnyType`, and it's direct subclass `Type<T>` which all other types inherit.

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

### demo
A custom Lisp with REPL is [provided](https://github.com/codr7/swifties-repl) for demonstration purposes.

### todo
- add if prim
    - add branch op
        - add AnyType.valueIsTrue
            - default true
            - override for Int/Bool/String/Stack
- add stack reader
- fib!
- add parser to readme
- add Nil type/Maybe type
- add types to readme
- add multi
- add suspend prim
    - (suspend ...)
    - emit jump
        - add Jump(pc:)
        - add Nop(pc:)
    - add env.pokeOp(pc: , Op)
    - push cont
    - emit args
    - emit stop
- implement callValue for Cont
    - env.restore
- add syntax for func arg names
