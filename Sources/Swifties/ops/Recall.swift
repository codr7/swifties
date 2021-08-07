import Foundation

public struct Recall: Op {
    public init(env: Env, pos: Pos, check: Bool) {
        _env = env
        _pos = pos
        _check = check
    }
        
    public func eval() throws -> Pc {
        let f = _env.peekFrame()
        if f == nil { throw EvalError(_pos, "No calls in progress") }
        return try f!.recall(pos: _pos, check: _check)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _check: Bool
}
