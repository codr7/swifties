import Foundation

class Scope {
    public var outer: Scope? { _outer }
    public var registerCount: Int { _registerCount }

    init(context: Context, outer: Scope?) {
        _context = context
        _outer = outer
    }
    
    func bind(pos: Pos, id: String, slot: Slot) throws {
        if _bindings.keys.contains(id) {
            throw DuplicateBinding(pos: pos, id: id)
        }
        
        _bindings[id] = slot
    }

    let _context: Context
    let _outer: Scope?
    var _bindings: [String: Slot] = [:]
    var _registerCount = 0
}
