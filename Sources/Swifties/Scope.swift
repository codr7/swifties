import Foundation

public class Scope {
    public var outer: Scope? { _outer }
    public var registerCount: Int { _nextRegister }

    public init(env: Env, outer: Scope?) {
        _env = env
        _outer = outer
    }
    
    public func bind(pos: Pos, id: String, _ slot: Slot) throws {
        if _bindings.keys.contains(id) { throw DupBinding(pos: pos, id: id) }
        _bindings[id] = slot
    }

    public func bind<T>(pos: Pos, id: String, _ type: Type<T>, _ value: T) throws {
        try bind(pos: pos, id: id, Slot(type, value))
    }
    
    public func unbind(pos: Pos, _ id: String) throws {
        let s = _bindings.removeValue(forKey: id)
        if s == nil { throw EmitError(pos, "Failed unbinding: \(id)") }
        precondition(s!.type == _env.coreLib!.registerType, "Unbinding non register slot: \(s!.type.name)")
        _nextRegister = min(_nextRegister, s!.value as! Register)
    }
    
    public func find(_ id: String) -> Slot? {
        var found = _bindings[id]
        
        if found == nil && _outer != nil {
            found = _outer!.find(id)
            if found != nil && found!.type == _env.coreLib!.registerType { found = nil }
        }
        
        return found
    }
    
    public func nextRegister(pos: Pos, id: String) throws -> Register {
        let i = _nextRegister
        try bind(pos: pos, id: id, _env.coreLib!.registerType, i)
        _nextRegister += 1
        return i
    }
    
    private let _env: Env
    private let _outer: Scope?
    private var _bindings: [String: Slot] = [:]
    private var _nextRegister = 0
}

