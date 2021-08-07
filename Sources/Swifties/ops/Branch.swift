import Foundation

public struct Branch: Op {
    public init(env: Env, pos: Pos, pc: Pc, falsePc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
        _falsePc = falsePc
    }

    public func eval() throws -> Pc {
        let v = _env.pop()
        if v == nil { throw EvalError(_pos, "Missing branch condition") }
        return v!.type.valueIsTrue(v!.value) ? _pc+1 : _falsePc
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc, _falsePc: Pc
}
