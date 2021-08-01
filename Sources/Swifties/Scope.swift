import Foundation

class Scope: Equatable {
    static func == (lhs: Scope, rhs: Scope) -> Bool {
        return lhs === rhs
    }

    public var outer: Scope? { _outer }
    public var registerCount: Int { _nextRegister }

    init(env: Env, outer: Scope?) {
        _env = env
        _outer = outer
    }
    
    func bind(pos: Pos, id: String, _ slot: Slot) throws {
        if _bindings.keys.contains(id) {
            throw DupBinding(pos: pos, id: id)
        }
        
        _bindings[id] = slot
    }

    func bind<T>(pos: Pos, id: String, _ type: Type<T>, _ value: T) throws {
        try bind(pos: pos, id: id, Slot(type, value))
    }
    
    func find(_ id: String) -> Slot? {
            return _bindings[id]
    }
    
    func nextRegister(pos: Pos, id: String) throws -> Register {
        let i = _nextRegister
        try bind(pos: pos, id: id, _env.coreLib!.registerType, i)
        _nextRegister += 1
        return i
    }
    
    let _env: Env
    let _outer: Scope?
    var _bindings: [String: Slot] = [:]
    var _nextRegister = 0
}

