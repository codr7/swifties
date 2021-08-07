import Foundation

public struct Store: Op {
    public init(env: Env, pos: Pos, pc: Pc, index: Register) {
        _env = env
        _pos = pos
        _pc = pc
        _index = index
    }
        
    public func eval() throws -> Pc {
        let v = _env.pop()
        if v == nil { throw EvalError(_pos, "Missing value to store") }
        _env.store(index: _index, slot: v!)
        return _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _index: Register
}
