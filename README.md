# Swifties
### a Swift language construction kit 

### intro
[Swifties](https://github.com/codr7/swifties) aims to provide a flexible toolkit for creating custom languages in Swift.

### functions
Functions have a name, an argument list, a result list and a body.
`pos` indicates the call site; if a `Pc`is returned, execution continues from there.

```swift
let f = Func(env: env, name: "foo", args: [], rets: [env.coreLib!.intType], {(pos: Pos) -> Pc? in
    env.push(env.coreLib!.intType, 42)
    return nil
})

let pos = Pos(source: "test", line: -1, column: -1)
env.beginScope().bind(pos: pos, id: "foo", env.coreLib!.funcType, f)
```

### todo
- add Form.slot(Scope) -> Slot? = nil
    - implement for Literal/Id
- add macros
    - inout forms
    - add reset/d macros/ops
- add repl
- add parser
    - id parser
    - (foo x y z) for calls
        - add call form
    - [x y z] for lists
- add branch op
- add multi
