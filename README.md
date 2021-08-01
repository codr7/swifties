# Swifties
### a Swift language construction kit 

### intro
[Swifties](https://github.com/codr7/swifties) aims to provide a flexible toolkit for creating custom languages in Swift.

### primitives
Primitives are called at compile time and may take any number (min/max are specified in the constructor) of forms as arguments and emit operations. 

```swift
let pos = Pos(source: "test", line: -1, column: -1)

let p = Prim(env: env, pos: pos, name: "reset", (0, 0), {pos, args -> Void in
    env.emit(Reset(env, env.pc))
})

env.beginScope().bind(pos: pos, id: "reset", env.coreLib!.PrimType, p)
```

### functions
Functions may take any number of arguments and return any number of results; `pos` indicates the call site; if a `Pc`is returned, execution continues from there.

```swift
let pos = Pos(source: "test", line: -1, column: -1)

let f = Func(env: env, pos: pos, name: "foo", args: [], rets: [env.coreLib!.intType], {pos -> Pc? in
    env.push(env.coreLib!.intType, 42)
    return nil
})

env.beginScope().bind(pos: pos, id: "foo", env.coreLib!.funcType, f)
```

```
(func fib [n:Int] [Int]
    (if (< n 2) n (+ (fib (- n 1) (fib (- n 2))))))
```

### todo
- add let-prim
    - first arg is bindings second body
    - (x 42 y 33)
    - bind forms with non-nil slots immediatel
- add Nil type/Maybe type
- add types to readme
- add if prim
    - add branch op
        - add AnyType.valueIsTrue
            - default true
            - override for Int/Bool/String
- add repl
    - add parser
        - id parser
        - (foo x y z) for calls
        - [x y z] for stacks
- add func prim
    - add StackForm
        - items []Form
        - emit as push
        - implement slot
- add multi
