import Foundation

public class CoreLib: Lib {
    public let anyType: AnyType

    public let boolType: BoolType
    public let contType: ContType
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
        contType = ContType(env, pos: pos, name: "Cont", parentTypes: [anyType])
        funcType = FuncType(env, pos: pos, name: "Func", parentTypes: [anyType])
        intType = IntType(env, pos: pos, name: "Int", parentTypes: [anyType])
        macroType = MacroType(env, pos: pos, name: "Meta", parentTypes: [anyType])
        metaType = MetaType(env, pos: pos, name: "Meta", parentTypes: [anyType])
        primType = PrimType(env, pos: pos, name: "Prim", parentTypes: [anyType])
        registerType = RegisterType(env, pos: pos, name: "Register", parentTypes: [anyType])
        stackType = StackType(env, pos: pos, name: "Stack", parentTypes: [anyType])

        super.init(env: env, pos: pos)
    }
    
    public func missing(pos: Pos, args: [Form]) {}

    public func _do(pos: Pos, args: [Form]) throws {
        for a in args { try a.emit() }
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
    
    public func stash(pos: Pos) -> Pc? {
        let tmp = env.stack
        env.reset()
        env.push(env.coreLib!.stackType, tmp)
        return nil
    }
    
    public func splat(pos: Pos, args: [Form]) throws {
        for a in args {
            try a.emit()
            env.emit(Splat(env: env, pos: pos, pc: env.pc))
        }
    }
    
    public override func bind(pos: Pos, _ names: [String]) throws {
        define(anyType, boolType, contType, funcType, intType, macroType, metaType, primType, registerType, stackType)
        
        define("t", boolType, true)
        define("f", boolType, false)
        
        define(Prim(env: env, pos: self.pos, name: "_", (0, 0), self.missing))
        define(Prim(env: env, pos: self.pos, name: "do", (0, -1), self._do))
        define(Func(env: env, pos: self.pos, name: "drop", args: [anyType], rets: [], self.drop))
        define(Prim(env: env, pos: self.pos, name: "let", (1, -1), self._let))
        define(Prim(env: env, pos: self.pos, name: "reset", (0, 0), self.reset))
        define(Prim(env: env, pos: self.pos, name: "splat", (1, -1), self.splat))
        define(Func(env: env, pos: self.pos, name: "stash", args: [], rets: [stackType], self.stash))
        
        try super.bind(pos: pos, names)
    }
}
