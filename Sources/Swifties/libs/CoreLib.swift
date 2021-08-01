import Foundation

class CoreLib: Lib {
    lazy var anyType = AnyType(self, pos: pos, name: "Any", parentTypes: [])

    lazy var funcType = FuncType(self, pos: pos, name: "Func", parentTypes: [anyType])
    lazy var intType = IntType(self, pos: pos, name: "Int", parentTypes: [anyType])
    lazy var macroType = MacroType(self, pos: pos, name: "Meta", parentTypes: [anyType])
    lazy var metaType = MetaType(self, pos: pos, name: "Meta", parentTypes: [anyType])
    lazy var primType = PrimType(self, pos: pos, name: "Prim", parentTypes: [anyType])
    lazy var registerType = RegisterType(self, pos: pos, name: "Register", parentTypes: [anyType])
    lazy var stackType = StackType(self, pos: pos, name: "Stack", parentTypes: [anyType])

    func stack(pos: Pos) -> Pc? {
        env.push(env.coreLib!.stackType, env.stack)
        return nil
    }
    
    override func bind(pos: Pos, _ names: [String]) throws {
        define(Func(env: env, pos: self.pos, name: "stack", args: [], rets: [stackType], self.stack))
        try super.bind(pos: pos, names)
    }
}
