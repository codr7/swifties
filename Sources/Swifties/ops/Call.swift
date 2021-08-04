import Foundation

public struct Call: Op {
    public init(env: Env, pos: Pos, pc: Pc, target: Slot?, check: Bool) {
        _env = env
        _pos = pos
        _pc = pc
        _target = target
        _check = check
    }
        
    public func eval() throws -> Pc {
        let t = _target ?? _env.pop()
        if t == nil { throw EvalError(_pos, "Missing target") }
        return try t!.type.callValue!(t!.value, _pos, _check) ?? _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _target: Slot?
    private let _check: Bool
}
