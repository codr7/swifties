import Foundation

public class Branch: Op {
    public init(env: Env, pos: Pos, pc: Pc, falsePc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
        _falsePc = falsePc
    }

    public func prepare() {
        _trueOp = _env.ops[_pc+1]
        _falseOp = _env.ops[_falsePc]
    }
    
    public func eval() throws {
        let v = _env.pop()
        if v == nil { throw EvalError(_pos, "Missing branch condition") }
        try (v!.type.valueIsTrue(v!.value) ? _trueOp : _falseOp)!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc, _falsePc: Pc
    private var _trueOp, _falseOp: Op?
}
