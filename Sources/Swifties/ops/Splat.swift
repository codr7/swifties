import Foundation

open class Splat: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    open func eval() throws -> Pc {
        _env.reset()
        let s = try _env.pop(pos: _pos)
        if s.type.iterValue == nil { throw EvalError(_pos, "Not iterable: \(s.type.name)") }
        let it = s.type.iterValue!(s.value)
        while let v = try it(_pos) { _env.push(v) }
        return _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
}
