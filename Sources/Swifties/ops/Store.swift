import Foundation

open class Store: Op {
    public init(env: Env, pos: Pos, pc: Pc, index: Register, offset: Int = 0) {
        _env = env
        _pos = pos
        _pc = pc
        _index = index
        _offset = offset
    }
    
    open func eval() throws -> Pc {
        try _env.store(pos: _pos, index: _index, offset: _offset)
        return _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _index: Register
    private let _offset: Int
}
