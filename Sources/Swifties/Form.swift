import Foundation

class Form: Equatable {
    static func == (lhs: Form, rhs: Form) -> Bool { lhs === rhs }
    
    var env: Env { _env }
    var pos: Pos { _pos }
    var slot: Slot? { nil }
    
    init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    func emit() throws {}
    func expand() throws -> Form { self }

    let _env: Env
    let _pos: Pos
}
