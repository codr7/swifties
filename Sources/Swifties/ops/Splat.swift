import Foundation

public class Splat: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    public func prepare() { _nextOp = _env.ops[_pc+1] }

    public func eval() throws {
        _env.reset()
        let ss = try _env.pop(pos: _pos)
        if ss.type != _env.coreLib!.stackType { throw EvalError(_pos, "Invalid stack: \(ss.type.name)") }
        _env.push(ss.value as! Stack)
        try _nextOp!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private var _nextOp: Op?
}
