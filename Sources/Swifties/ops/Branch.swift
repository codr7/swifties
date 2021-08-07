import Foundation

public class Branch: Op {
    public init(env: Env, pos: Pos, pc: Pc, truePc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
        _truePc = truePc
    }

    public func prepare() {
        _trueOp = _env.ops[_truePc]
        _falseOp = _env.ops[_pc+1]
    }
    
    public func eval() throws {
        let v = _env.pop()
        if v == nil { throw EvalError(_pos, "Missing branch condition") }
        try (v!.type.valueIsTrue(v!.value) ? _trueOp : _falseOp)!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc, _truePc: Pc
    private var _trueOp, _falseOp: Op?
}
