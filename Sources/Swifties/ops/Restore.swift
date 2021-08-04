import Foundation

public struct Restore: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    public func eval() throws -> Pc {
        let s = _env.pop()
        if s == nil { throw EvalError(_pos, "Missing coroutine") }
        let c = s!.value as! Cont
        _env.restore(cont: c)
        return c.pc
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
}
