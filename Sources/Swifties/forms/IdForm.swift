import Foundation

open class IdForm: Form {
    open var name: String { _name }
    
    open override var slot: Slot? {
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
  
    open override func expand() throws -> Form {
        if let found = env.scope!.find(self._name) {
            if found.type == env.coreLib!.macroType {
                return try (found.value as! Macro).expand(pos: pos, args: [])
            }
        }
            
        return self
    }
        
    open func emit(name: String) throws {
        if let found = env.scope!.find(name) {
            if found.type == env.coreLib!.registerType {
                env.emit(Load(env: env, pos: pos, pc: env.pc, index: found.value as! Int))
            } else {
                env.emit(Push(pc: env.pc, found))
            }
        } else {
            throw EmitError(pos, "Unknown identifier: \(name)")
        }
    }
    
    open override func emit() throws {
        try emit(name: _name)
    }

    private let _name: String
}
