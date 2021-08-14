import Foundation

open class PushDown: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    open func eval() throws -> Pc {
        let v = try _env.pop(pos: _pos)
        let s = try _env.peek(pos: _pos)
        if s.type != _env.coreLib!.stackType { throw EvalError(_pos, "Invalid stack: \(s.type.name)") }
        var dst = s.value as! Stack
        dst.append(v)
        try _env.poke(pos: _pos, _env.coreLib!.stackType, dst, offset: 0)
        return _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
}
