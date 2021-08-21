import Foundation

open class IdForm: Form {
    open var name: String { _name }
    open var isCopy: Bool { _name.allSatisfy({c in c == "c"}) }
    open var isDrop: Bool { _name.allSatisfy({c in c == "d"}) }
    open var isRef: Bool { _name.first == "&" }
    open var isSwap: Bool { _name.allSatisfy({c in c == "s"}) }

    open override var slot: Slot? {
        get {
            if isDrop { return nil }
            
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
  
    open override func dump() -> String { _name }

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
            } else if isCopy {
                env.emit(Copy(env: env, pos: pos, pc: env.pc, count: name.count))
            } else if isDrop {
                env.emit(Drop(env: env, pos: pos, pc: env.pc, count: name.count))
            } else if isSwap {
                env.emit(Swap(env: env, pos: pos, pc: env.pc, count: name.count))
            } else {
                env.emit(Push(pc: env.pc, found))
            }
        } else {
            throw EmitError(pos, "Unknown identifier: \(name)")
        }
    }
    
    open override func emit() throws {
        if let found = env.scope!.find(name) {
            if found.type == env.coreLib!.primType {
                try (found.value as! Prim).emit(pos: pos, args: [])
            } else if let _ = found.type.callValue {
                env.emit(Call(env: env, pos: pos, pc: env.pc, target: found, check: true))
            } else if isRef {
                try emit(name: String(name.dropFirst()))
            } else {
                try emit(name: _name)
            }
        } else {
            throw EmitError(pos, "Unknown identifier: \(name)")
        }
    }
    
    open override func quote3(depth: Int) -> Slot { Slot(env.coreLib!.idType, _name) }

    private let _name: String
}
