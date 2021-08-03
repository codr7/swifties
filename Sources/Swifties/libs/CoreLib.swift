import Foundation

public class CoreLib: Lib {
    public let anyType: AnyType

    public let boolType: BoolType
    public let funcType: FuncType
    public let intType: IntType
    public let macroType: MacroType
    public let metaType: MetaType
    public let primType: PrimType
    public let registerType: RegisterType
    public let stackType: StackType

    public override init(env: Env, pos: Pos) {
        anyType = AnyType(env, pos: pos, name: "Any", parentTypes: [])

        boolType = BoolType(env, pos: pos, name: "Bool", parentTypes: [anyType])
        funcType = FuncType(env, pos: pos, name: "Func", parentTypes: [anyType])
        intType = IntType(env, pos: pos, name: "Int", parentTypes: [anyType])
        macroType = MacroType(env, pos: pos, name: "Meta", parentTypes: [anyType])
        metaType = MetaType(env, pos: pos, name: "Meta", parentTypes: [anyType])
        primType = PrimType(env, pos: pos, name: "Prim", parentTypes: [anyType])
        registerType = RegisterType(env, pos: pos, name: "Register", parentTypes: [anyType])
        stackType = StackType(env, pos: pos, name: "Stack", parentTypes: [anyType])

        super.init(env: env, pos: pos)
    }
    
    public func drop(pos: Pos) throws -> Pc? {
        env.pop()
        return nil
    }

    public func _let(pos: Pos, args: [Form]) throws {
        let scope = env.beginScope()
        defer { env.endScope() }
        
        let bindings = (args[0] as! StackForm).items
        var i = 0
        
        while i+1 < bindings.count {
            let (id, v) = (bindings[i] as! IdForm, bindings[i+1])
            try v.emit()
            let register = try scope.nextRegister(pos: pos, id: id.name)
            env.emit(Store(env: env, pc: env.pc, index: register))
            i += 2
        }
        
        for a in args[1...] {
            try a.emit()
        }
    }

    public func reset(pos: Pos, args: [Form]) {
        env.emit(Reset(env: env, pc: env.pc))
    }
    
    public func stack(pos: Pos) -> Pc? {
        env.push(env.coreLib!.stackType, env.stack)
        return nil
    }
    
    public override func bind(pos: Pos, _ names: [String]) throws {
        define(anyType, funcType, intType, macroType, metaType, primType, registerType, stackType)
        
        define("t", boolType, true)
        define("f", boolType, false)
        
        define(Func(env: env, pos: self.pos, name: "drop", args: [anyType], rets: [], self.drop))
        define(Prim(env: env, pos: self.pos, name: "let", (1, -1), self._let))
        define(Prim(env: env, pos: self.pos, name: "reset", (0, 0), self.reset))
        define(Func(env: env, pos: self.pos, name: "stack", args: [], rets: [stackType], self.stack))
        
        try super.bind(pos: pos, names)
    }
}
