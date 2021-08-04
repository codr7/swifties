import Foundation

public class CallForm: Form {
    public init(env: Env, pos: Pos, target: Form, args: [Form]) {
        _target = target
        _args = args
        super.init(env: env, pos: pos)
    }
    
    public override func expand() throws -> Form {
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

    public override func emit() throws {
        var t = env.scope!.find((_target as! IdForm).name)
        
        if t == nil {
            throw EmitError(pos, "Unknown target: \(_target)")
        }

        if t!.type == env.coreLib!.primType {
            try (t!.value as! Prim).emit(pos: pos, args: _args)
        } else if t!.type == env.coreLib!.registerType {
            env.emit(Load(env: env, pc: env.pc, index: t!.value as! Register))
            t = nil
        }

        for a in _args { try a.emit() }
        env.emit(Call(env: env, pos: pos, pc: env.pc, target: t, check: true))
    }

    private let _target: Form
    private let _args: [Form]
}
