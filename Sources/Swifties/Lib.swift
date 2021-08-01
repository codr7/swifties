import Foundation

protocol Definition {
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

    func define(_ d: Definition) {
        _definitions[d.name] = d
    }
    
    func bind(pos: Pos, _ names: [String]) throws {
        for n in names {
            if let d = _definitions[n] {
                try env.scope!.bind(pos: d.pos, id: n, d.slot)
            } else {
                throw UnknownId(pos: pos, id: n)
            }
        }
    }

    private let _env: Env
    private let _pos: Pos
    private var _definitions: [String: Definition] = [:]
}
