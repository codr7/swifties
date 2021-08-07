import Foundation

public struct PushDown: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    public func eval() throws {
        let v = _env.pop()
        if v == nil { throw EvalError(_pos, "Missing item") }
        let s = _env.peek()
        if s == nil { throw EvalError(_pos, "Missing stack") }
        
        if s!.type != _env.coreLib!.stackType {
            throw EvalError(_pos, "Invalid stack: \(s!.type.name)")
        }
        var dst = s!.value as! Stack
        dst.append(v!)
        _env.poke(_env.coreLib!.stackType, dst, offset: 0)
        try _env.eval(_pc+1)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
}
