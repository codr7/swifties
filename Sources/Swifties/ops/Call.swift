import Foundation

public class Call: Op {
    public init(env: Env, pos: Pos, pc: Pc, target: Slot?, check: Bool) {
        _env = env
        _pos = pos
        _pc = pc
        _target = target
        _check = check
    }
        
    public func prepare() {}

    public func eval() throws {
        let t = _target ?? _env.pop()
        if t == nil { throw EvalError(_pos, "Missing target") }
        if t!.type.callValue == nil { throw EvalError(_pos, "Invalid target: \(t!)") }
        try _env.eval(try t!.type.callValue!(t!.value, _pos, _pc+1, _check), prepare: false)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _target: Slot?
    private let _check: Bool
}
