import Foundation

protocol Form {
    var env: Env { get }
    var pos: Pos { get }
    func emit()
}

class BaseForm {
    var env: Env { _env }
    var pos: Pos { _pos }
    
    init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }
    
    let _env: Env
    let _pos: Pos
}
