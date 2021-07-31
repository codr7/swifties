# Swifties
### a Swift scripting language construction kit 

### intro
[Swifties](https://github.com/codr7/swifties) aims to provide a flexible toolkit for creating custom scripting languages in Swift.

### functions
Functions have a name, an argument list, a result list and a body.
`pos` indicates the call site; if a `Pc`is returned, execution continues from there.

```swift
let f = Func(env: env, name: "foo", args: [], rets: [env.coreLib!.intType], body: {(pos: Pos) -> Pc? in
    env.push(type: env.coreLib!.intType, 42)
    return nil
})

env.beginScope().bind(pos: pos, id: "foo", type: env.coreLib!.funcType, f)
```

### todo
- add Multi
- add Literal form
