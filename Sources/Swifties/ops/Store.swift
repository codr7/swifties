import Foundation

public struct Store: Op {
    public init(env: Env, pos: Pos, pc: Pc, index: Register) {
        _env = env
        _pos = pos
        _pc = pc
        _index = index
    }
        
    public func eval() throws {
        try _env.store(pos: _pos, index: _index)
        try _env.eval(_pc+1)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _index: Register
}
