# Swifties
### a Swift language construction kit 

### intro
[Swifties](https://github.com/codr7/swifties) aims to provide a flexible toolkit for creating custom languages in Swift.

### functions
Functions have a name, an argument list, a result list and a body.
`pos` indicates the call site; if a `Pc`is returned, execution continues from there.

```swift
let pos = Pos(source: "test", line: -1, column: -1)

let f = Func(env: env, pos: pos, name: "foo", args: [], rets: [env.coreLib!.intType], {(pos: Pos) -> Pc? in
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
- add reset/drop prims
- add stack type/func
- add repl
- add parser
    - id parser
    - (foo x y z) for calls
    - [x y z] for lists
- add branch op
    - add AnyType.valueIsTrue
        - default true
        - override for Int/Bool/String
- add multi
