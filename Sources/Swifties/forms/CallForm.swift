import Foundation

open class CallForm: Form {
    public init(env: Env, pos: Pos, target: Form, args: [Form]) {
        _target = target
        _args = args
        super.init(env: env, pos: pos)
    }
    
    open override func dump() -> String { "(\(_target.dump()) \(_args.dump()))" }

    open override func expand() throws -> Form {
        let newTarget = try _target.expand()
        let newArgs = try _args.map {a in try a.expand()}
        
        if let found = env.scope!.find((newTarget as! IdForm).name) {
            if found.type == env.coreLib!.macroType {
                let m = (found.value as! Macro)
                return try m.expand(pos: pos, args: newArgs)
            }
        }
        
        if newTarget != _target || newArgs != _args {
            return try CallForm(env: env, pos: pos, target: _target, args: newArgs).expand()
        }
        
        return self
    }

    open override func emit() throws {
        var t = env.scope!.find((_target as! IdForm).name)
        if t == nil { throw EmitError(pos, "Unknown target: \(_target)") }

        if t!.type == env.coreLib!.primType {
            try (t!.value as! Prim).emit(pos: pos, args: _args)
        } else {
            for a in _args { try a.emit() }
            
            if t!.type == env.coreLib!.registerType {
                env.emit(Load(env: env, pos: pos, pc: env.pc, index: t!.value as! Register))
                t = nil
            }

            env.emit(Call(env: env, pos: pos, pc: env.pc, target: t, check: true))
        }
    }

    open override func quote1() throws -> Form {
        _target = try _target.quote1()
        for i in 0..<_args.count { _args[i] = try _args[i].quote1() }
        return self
    }
    
    open override func quote2() throws -> Slot {
        _target = LiteralForm(env: env, pos: pos, try _target.quote2())
        for i in 0..<_args.count { _args[i] = LiteralForm(env: env, pos: pos, try _args[i].quote2()) }
        return Slot(env.coreLib!.formType, self)
    }
    
    private var _target: Form
    private var _args: Forms
}
