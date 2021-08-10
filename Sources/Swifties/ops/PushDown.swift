import Foundation

public class PushDown: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    public func prepare() { _nextOp = _env.ops[_pc+1] }

    public func eval() throws {
        let v = try _env.pop(pos: _pos)
        let s = _env.peek()
        if s == nil { throw EvalError(_pos, "Missing stack") }
        if s!.type != _env.coreLib!.stackType { throw EvalError(_pos, "Invalid stack: \(s!.type.name)") }
        var dst = s!.value as! Stack
        dst.append(v)
        try _env.poke(pos: _pos, _env.coreLib!.stackType, dst, offset: 0)
        try _nextOp!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private var _nextOp: Op?
}
