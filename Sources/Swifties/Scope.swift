import Foundation

class Scope: Equatable {
    static func == (lhs: Scope, rhs: Scope) -> Bool {
        return lhs._id == rhs._id
    }

    public var outer: Scope? { _outer }
    public var registerCount: Int { _nextRegister }

    init(env: Env, outer: Scope?) {
        _env = env
        _outer = outer
        _id = env.getNextScopeId()
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
    
    func getNextRegister() -> Register {
        let i = _nextRegister
        _nextRegister += 1
        return i
    }
    
    let _env: Env
    let _outer: Scope?
    let _id: Int
    var _bindings: [String: Slot] = [:]
    var _nextRegister = 0
}

