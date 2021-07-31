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

    let _env: Env
    let _outer: Scope?
    var _bindings: [String: Slot] = [:]
    var _registerCount = 0
}

