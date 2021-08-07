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

    public func nop(pos: Pos, args: [Form]) {}

    public func _do(pos: Pos, args: [Form]) throws {
        for a in args { try a.emit() }
    }

    public func drop(pos: Pos, self: Func, retPc: Pc) throws -> Pc {
        env.pop()
        return retPc
    }
    
    public func _func(pos: Pos, args: [Form]) throws {
        let name = (args[0] as! IdForm).name
        let ats = try (args[1] as! StackForm).items.map(getType)
        let rts = try (args[2] as! StackForm).items.map(getType)
        let f = Func(env: env, pos: pos, name: name, args: ats, rets: rts)
        try f.compileBody(DoForm(env: env, pos: pos, body: Array(args[3...])))
        try env.scope!.bind(pos: pos, id: name, env.coreLib!.funcType, f)
    }
  
    public func _if(pos: Pos, args: [Form]) throws {
        let cond = args[0]
        try cond.emit()
        let trueBranch = args[1]
        let falseBranch = args[2]
        let branchPc = env.pc
        let branch = env.emit(STOP)
        try trueBranch.emit()
        let skipFalse = env.emit(STOP)
        let falsePc = env.pc
        try falseBranch.emit()
        env.emit(Goto(pc: env.pc), index: skipFalse)
        env.emit(Branch(env: env, pos: pos, pc: branchPc, falsePc: falsePc), index: branch)
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
            env.emit(Store(env: env, pos: pos, pc: env.pc, index: register))
            i += 2
        }
        
        for a in args[1...] { try a.emit() }
    }

    public func reset(pos: Pos, args: [Form]) {
        env.emit(Reset(env: env, pc: env.pc))
    }
    
    public func stash(pos: Pos, self: Func, retPc: Pc) -> Pc {
        let tmp = env.stack
        env.reset()
        env.push(env.coreLib!.stackType, tmp)
        return retPc
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
        
        define(Prim(env: env, pos: self.pos, name: "_", (0, 0), self.nop))
        define(Prim(env: env, pos: self.pos, name: "do", (0, -1), self._do))
        define(Func(env: env, pos: self.pos, name: "drop", args: [anyType], rets: [], self.drop))
        define(Prim(env: env, pos: self.pos, name: "func", (3, -1), self._func))
        define(Prim(env: env, pos: self.pos, name: "if", (3, 3), self._if))
        define(Prim(env: env, pos: self.pos, name: "let", (1, -1), self._let))
        define(Prim(env: env, pos: self.pos, name: "reset", (0, 0), self.reset))
        define(Prim(env: env, pos: self.pos, name: "splat", (1, -1), self.splat))
        define(Func(env: env, pos: self.pos, name: "stash", args: [], rets: [stackType], self.stash))
        
        try super.bind(pos: pos, names)
    }
    
    private func getType(f: Form) throws -> AnyType {
        let name = (f as! IdForm).name
        let found = env.scope!.find(name)
        if found == nil { throw EmitError(f.pos, "Invalid type: \(name)") }
        if found!.type != env.coreLib!.metaType { throw EmitError(f.pos, "Invalid type: \(found!)") }
        return found!.value as! AnyType
    }
}
