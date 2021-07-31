import Foundation

protocol Form {
    var env: Env { get }
    var pos: Pos { get }
    
    func emit()
    func slot() -> Slot?
}

class BaseForm {
    var env: Env { _env }
    var pos: Pos { _pos }
    
    init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    func slot() -> Slot? { nil }

    let _env: Env
    let _pos: Pos
}
