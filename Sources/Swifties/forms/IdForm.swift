import Foundation

class IdForm: Form {
    var name: String { _name }
    
    override var slot: Slot? {
        get {
            if let found = env.scope!.find(self._name) {
                if found.type != env.coreLib!.registerType {
                    return found
                }
            }

            return nil
        }
    }
    
    init(env: Env, pos: Pos, name: String) {
        _name = name
        super.init(env: env, pos: pos)
    }
  
    override func expand() throws -> Form {
        if let found = env.scope!.find(self._name) {
            if found.type == env.coreLib!.macroType {
                return try (found.value as! Macro).expand(pos: pos, args: [])
            }
        }
            
        return self
    }
        
    override func emit() throws {
        if let found = env.scope!.find(self._name) {
            if found.type == env.coreLib!.registerType {
                env.emit(Load(env: env, pc: env.pc, index: found.value as! Int))
            } else if found.type == env.coreLib!.primType {
                try (found.value as! Prim).emit(pos: pos, args: [])
            } else {
                env.emit(Push(pc: env.pc, found))
            }
        }
    }

    let _name: String
}
