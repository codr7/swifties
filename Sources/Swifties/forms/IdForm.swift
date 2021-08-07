import Foundation

public class IdForm: Form {
    public var name: String { _name }
    
    public override var slot: Slot? {
        get {
            if let found = env.scope!.find(self._name) {
                if found.type != env.coreLib!.registerType {
                    return found
                }
            }

            return nil
        }
    }
    
    public init(env: Env, pos: Pos, name: String) {
        _name = name
        super.init(env: env, pos: pos)
    }
  
    public override func expand() throws -> Form {
        if let found = env.scope!.find(self._name) {
            if found.type == env.coreLib!.macroType {
                return try (found.value as! Macro).expand(pos: pos, args: [])
            }
        }
            
        return self
    }
        
    public override func emit() throws {
        if let found = env.scope!.find(_name) {
            if found.type == env.coreLib!.registerType {
                env.emit(Load(env: env, pos: pos, pc: env.pc, index: found.value as! Int))
            } else if found.type == env.coreLib!.primType {
                try (found.value as! Prim).emit(pos: pos, args: [])
            } else if let _ = found.type.callValue {
                env.emit(Call(env: env, pos: pos, pc: env.pc, target: found, check: true))
            } else {
                env.emit(Push(pc: env.pc, found))
            }
        } else {
            throw EmitError(pos, "Unknown identifier: \(_name)")
        }
    }

    private let _name: String
}
