import Foundation

public class Splat: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    public func prepare() {}

    public func eval() throws {
        _env.reset()
        let ss = _env.pop()
        if ss == nil { throw EvalError(_pos, "Missing stack") }
        if ss!.type != _env.coreLib!.stackType { throw EvalError(_pos, "Invalid stack: \(ss!.type.name)") }
        _env.push(ss!.value as! Stack)
        try _env.eval(_pc+1, prepare: false)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
}
