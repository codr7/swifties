import Foundation

open class Load: Op {
    public init(env: Env, pos: Pos, pc: Pc, index: Register) {
        _env = env
        _pos = pos
        _pc = pc
        _index = index
    }
        
    open func eval() throws -> Pc {
        try _env.load(pos: _pos, index: _index)
        return _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _index: Register
}
