import Foundation

public class Branch: Op {
    public init(env: Env, pos: Pos, truePc: Pc, falsePc: Pc, pop: Bool = true) {
        _env = env
        _pos = pos
        _truePc = truePc
        _falsePc = falsePc
        _pop = pop
    }

    public func prepare() {
        _trueOp = _env.ops[_truePc]
        _falseOp = _env.ops[_falsePc]
    }
    
    public func eval() throws {
        let v = _pop ? _env.pop() : _env.peek()
        if v == nil { throw EvalError(_pos, "Missing branch condition") }
        try (v!.type.valueIsTrue(v!.value) ? _trueOp : _falseOp)!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _truePc, _falsePc: Pc
    private var _trueOp, _falseOp: Op?
    private let _pop: Bool
}
