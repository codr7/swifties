import Foundation

public class Restore: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    public func prepare() {}

    public func eval() throws {
        let s = _env.pop()
        if s == nil { throw EvalError(_pos, "Missing continuation") }
        let c = s!.value as! Cont
        try _env.eval(c.restore(), prepare: false)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
}
