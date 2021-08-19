import Foundation

open class Scope {
    open var outer: Scope? { _outer }
    open var registerCount: Int { _nextRegister }

    public init(env: Env, outer: Scope?) {
        _env = env
        _outer = outer
    }
    
    open func bind(pos: Pos, id: String, _ slot: Slot, force: Bool = false) throws {
        if !force && _bindings.keys.contains(id) { throw DupBinding(pos: pos, id: id) }
        _bindings[id] = slot
    }

    open func bind<T>(pos: Pos, id: String, _ type: Type<T>, _ value: T, force: Bool = false) throws {
        try bind(pos: pos, id: id, Slot(type, value), force: force)
    }
        
    open func unbind(pos: Pos, _ id: String) throws {
        let s = _bindings.removeValue(forKey: id)
        if s == nil { throw EmitError(pos, "Failed unbinding: \(id)") }
        precondition(s!.type == _env.coreLib!.registerType, "Unbinding non register slot: \(s!.type.name)")
        _nextRegister = min(_nextRegister, s!.value as! Register)
    }
    
    open func find(_ id: String) -> Slot? {
        var found = _bindings[id]
        
        if found == nil && _outer != nil {
            found = _outer!.find(id)
            if found != nil && found!.type == _env.coreLib!.registerType { found = nil }
        }
        
        return found
    }
    
    open func nextRegister(pos: Pos, id: String) throws -> Register {
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

