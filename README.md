# Swifties
### a custom language construction kit 

### intro
[Swifties](https://github.com/codr7/swifties) aims to provide a flexible toolkit for creating custom languages in Swift.

### primitives
Primitives are called at compile time and may take any number (min/max are specified in the constructor) of forms as arguments and emit operations. 

```swift
let pos = Pos(source: "test", line: -1, column: -1)

let p = Prim(env: env, pos: self.pos, name: "do", (0, -1), { pos, args in
    for a in args { try a.emit() }
})

env.beginScope().bind(pos: pos, id: "do", env.coreLib!.primType, p)
```

### functions
Functions may take any number of arguments and return any number of results; `pos` indicates the call site; if a `Pc`is returned, execution continues from there.

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

### types
Two kinds of types are used, `ÀnyType`, and it's direct subclass `Type<T>` which all types inherit.

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
