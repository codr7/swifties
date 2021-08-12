import Foundation

open class Recall: Op {
    public init(env: Env, pos: Pos, check: Bool) {
        _env = env
        _pos = pos
        _check = check
    }
        
    open func prepare() {}

    open func eval() throws {
        let f = _env.peekFrame()
        if f == nil { throw EvalError(_pos, "No calls in progress") }
        try f!.recall(pos: _pos, check: _check)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _check: Bool
}
