import Foundation

protocol Def {
    var pos: Pos {get}
    var name: String {get}
    var slot: Slot {get}
}

class Lib {
    var env: Env { _env }
    var pos: Pos { _pos }
 
    init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    func def<T: Def>(_ d: T) -> T {
        assert(!_defs.keys.contains(d.name), "Duplicate definition: " + d.name)
        _defs[d.name] = d
        return d
    }
    
    func bind() throws {
        for (n, d) in _defs {
            try _env.scope!.bind(pos: d.pos, id: n, slot: d.slot)
        }
    }
    
    let _env: Env
    let _pos: Pos
    var _defs: [String: Def] = [:]
}
