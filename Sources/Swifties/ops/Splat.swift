import Foundation

open class Splat: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    open func eval() throws -> Pc {
        _env.reset()
        let ss = try _env.pop(pos: _pos)
        if ss.type != _env.coreLib!.stackType { throw EvalError(_pos, "Invalid stack: \(ss.type.name)") }
        _env.push(ss.value as! Stack)
        return _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
}
