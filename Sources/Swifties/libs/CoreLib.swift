import Foundation

open class CoreLib: Lib {
    public let anyType: AnyType

    public let boolType: BoolType
    public let contType: ContType
    public let funcType: FuncType
    public let intType: IntType
    public let iterType: IterType
    public let macroType: MacroType
    public let metaType: MetaType
    public let pairType: PairType
    public let primType: PrimType
    public let registerType: RegisterType
    public let stackType: StackType

    public override init(env: Env, pos: Pos) {
        anyType = AnyType(env, pos: pos, name: "Any", parentTypes: [])

        boolType = BoolType(env, pos: pos, name: "Bool", parentTypes: [anyType])
        contType = ContType(env, pos: pos, name: "Cont", parentTypes: [anyType])
        funcType = FuncType(env, pos: pos, name: "Func", parentTypes: [anyType])
        iterType = IterType(env, pos: pos, name: "Iter", parentTypes: [anyType])
        intType = IntType(env, pos: pos, name: "Int", parentTypes: [anyType, iterType])
        macroType = MacroType(env, pos: pos, name: "Meta", parentTypes: [anyType])
        metaType = MetaType(env, pos: pos, name: "Meta", parentTypes: [anyType])
        pairType = PairType(env, pos: pos, name: "Pair", parentTypes: [anyType])
        primType = PrimType(env, pos: pos, name: "Prim", parentTypes: [anyType])
        registerType = RegisterType(env, pos: pos, name: "Register", parentTypes: [anyType])
        stackType = StackType(env, pos: pos, name: "Stack", parentTypes: [anyType])

        super.init(env: env, pos: pos)
    }

    open func nop(pos: Pos, args: [Form]) {}

    open func equals(pos: Pos, self: Func, ret: Op) throws {
        let y = try env.pop(pos: pos)
        let x = try env.peek(pos: pos)
        try env.poke(pos: pos, env.coreLib!.boolType, (x.type == y.type) && x.type.equalValues!(x.value, y.value))
        try ret.eval()
    }

    open func equalsZero(pos: Pos, self: Func, ret: Op) throws {
        try env.poke(pos: pos, env.coreLib!.boolType, env.peek(pos: pos).value as! Int == 0)
        try ret.eval()
    }

    open func equalsOne(pos: Pos, self: Func, ret: Op) throws {
        try env.poke(pos: pos, env.coreLib!.boolType, env.peek(pos: pos).value as! Int == 1)
        try ret.eval()
    }

    open func and(pos: Pos, args: [Form]) throws {
        try args[0].emit()
        let branchPc = env.emit(STOP)
        env.emit(Drop(env: env, pos: pos, pc: env.pc))
        try args[1].emit()
        env.emit(Branch(env: env, pos: pos, truePc: branchPc+1, falsePc: env.pc, pop: false), pc: branchPc)
    }

    open func bench(pos: Pos, args: [Form]) throws {
        let reps = (args[0] as! LiteralForm).slot!.value as! Int
        let i = env.emit(STOP)
        let startPc = env.pc
        for f in args[1...] { try f.emit() }
        env.emit(Bench(env: env, reps: reps, startPc: startPc, endPc: env.pc), pc: i)
    }
    
    open func _do(pos: Pos, args: [Form]) throws {
        for a in args { try a.emit() }
    }
    
    open func drop(pos: Pos, self: Func, ret: Op) throws {
        try env.pop(pos: pos)
        try ret.eval()
    }
 
    open func _for(pos: Pos, args: [Form]) throws {
        var src = args[0]
        var bindId: String?
        var bindReg: Register = -1
        
        if src is PairForm {
            let p = src as! PairForm
            bindId = (p.left as! IdForm).name
            bindReg = try env.scope!.nextRegister(pos: pos, id: bindId!)
            src = p.right
        }
        
        try src.emit()
        let forPc = env.emit(STOP)
        if bindId != nil { env.emit(Store(env: env, pos: pos, pc: env.pc, index: bindReg)) }
        for a in args[1...] { try a.emit() }
        env.emit(STOP)
        env.emit(For(env: env, pos: pos, pc: forPc, nextPc: env.pc), pc: forPc)
        if bindId != nil { try env.scope!.unbind(pos: pos, bindId!) }
    }
    
    open func _func(pos: Pos, args: [Form]) throws {
        let name = (args[0] as! IdForm).name
        let ats = try (args[1] as! StackForm).items.map(getType)
        let rts = try (args[2] as! StackForm).items.map(getType)
        let f = Func(env: env, pos: pos, name: name, args: ats, rets: rts)
        try env.scope!.bind(pos: pos, id: name, env.coreLib!.funcType, f)
        try f.compileBody(DoForm(env: env, pos: pos, body: Array(args[3...])))
    }
  
    open func _if(pos: Pos, args: [Form]) throws {
        let cond = args[0]
        try cond.emit()
        let trueBranch = args[1]
        let falseBranch = args[2]
        let branchPc = env.emit(STOP)
        try falseBranch.emit()
        let skipTrue = env.emit(STOP)
        let truePc = env.pc
        try trueBranch.emit()
        env.emit(Goto(env: env, pc: env.pc), pc: skipTrue)
        env.emit(Branch(env: env, pos: pos, truePc: truePc, falsePc: branchPc+1), pc: branchPc)
    }
    
    open func _let(pos: Pos, args: [Form]) throws {
        let bindings = Array((args[0] as! StackForm).items.reversed())
        let scope = env.scope!
        var ids: [String] = []
        var i = 0
        
        while i+1 < bindings.count {
            let (v, id) = (bindings[i], bindings[i+1] as! IdForm)
            try v.emit()
            let register = try scope.nextRegister(pos: pos, id: id.name)
            env.emit(Store(env: env, pos: pos, pc: env.pc, index: register))
            ids.append(id.name)
            i += 2
        }
        
        for a in args[1...] { try a.emit() }
        for id in ids { try scope.unbind(pos: pos, id) }
    }

    open func not(pos: Pos, self: Func, ret: Op) throws {
        let s = try env.peek(pos: pos)
        try env.poke(pos: pos, env.coreLib!.boolType, !s.type.valueIsTrue(s.value))
        try ret.eval()
    }
    
    open func or(pos: Pos, args: [Form]) throws {
        try args[0].emit()
        let branchPc = env.emit(STOP)
        env.emit(Drop(env: env, pos: pos, pc: env.pc))
        try args[1].emit()
        env.emit(Branch(env: env, pos: pos, truePc: env.pc, falsePc: branchPc+1, pop: false), pc: branchPc)
    }
    
    open func recall(pos: Pos, args: [Form]) throws {
        for a in args { try a.emit() }
        env.emit(Recall(env: env, pos: pos, check: true))
    }

    open func reset(pos: Pos, args: [Form]) {
        env.emit(Reset(env: env, pc: env.pc))
    }
    
    open func stash(pos: Pos, self: Func, ret: Op) throws {
        let tmp = env.stack
        env.reset()
        env.push(env.coreLib!.stackType, tmp)
        try ret.eval()
    }
    
    open func splat(pos: Pos, args: [Form]) throws {
        for a in args {
            try a.emit()
            env.emit(Splat(env: env, pos: pos, pc: env.pc))
        }
    }
    
    open override func bind(pos: Pos, _ names: [String]) throws {
        define(anyType,
               boolType,
               contType,
               funcType,
               intType, iterType,
               macroType, metaType,
               pairType, primType,
               registerType,
               stackType)
        
        define("t", boolType, true)
        define("f", boolType, false)
        
        define(Prim(env: env, pos: self.pos, name: "_", (0, 0), self.nop))
        define(Func(env: env, pos: self.pos, name: "=", args: [anyType, anyType], rets: [boolType], self.equals))
        define(Func(env: env, pos: self.pos, name: "=0", args: [intType], rets: [boolType], self.equalsZero))
        define(Func(env: env, pos: self.pos, name: "=1", args: [intType], rets: [boolType], self.equalsOne))
        define(Prim(env: env, pos: self.pos, name: "and", (2, 2), self.and))
        define(Prim(env: env, pos: self.pos, name: "bench", (1, -1), self.bench))
        define(Prim(env: env, pos: self.pos, name: "do", (0, -1), self._do))
        define(Func(env: env, pos: self.pos, name: "drop", args: [anyType], rets: [], self.drop))
        define(Prim(env: env, pos: self.pos, name: "for", (1, -1), self._for))
        define(Prim(env: env, pos: self.pos, name: "func", (3, -1), self._func))
        define(Prim(env: env, pos: self.pos, name: "if", (3, 3), self._if))
        define(Prim(env: env, pos: self.pos, name: "let", (1, -1), self._let))
        define(Func(env: env, pos: self.pos, name: "not", args: [anyType], rets: [boolType], self.not))
        define(Prim(env: env, pos: self.pos, name: "or", (2, 2), self.or))
        define(Prim(env: env, pos: self.pos, name: "recall", (0, -1), self.recall))
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
