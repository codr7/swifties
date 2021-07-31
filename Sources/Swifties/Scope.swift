import Foundation

class Scope {
    public var outer: Scope? { _outer }
    public var registerCount: Int { _registerCount }

    init(env: Env, outer: Scope?) {
        _env = env
        _outer = outer
    }
    
    func bind(pos: Pos, id: String, slot: Slot) throws {
        if _bindings.keys.contains(id) {
            throw DupBinding(pos: pos, id: id)
        }
        
        _bindings[id] = slot
    }

    func bind<T>(pos: Pos, id: String, type: Type<T>, value: T) throws {
        try bind(pos: pos, id: id, slot: Slot(type, value))
    }
    
    func find(_ id: String) -> Slot? {
            return _bindings[id]
    }
    
    let _env: Env
    let _outer: Scope?
    var _bindings: [String: Slot] = [:]
    var _registerCount = 0
}

