import Foundation

open class Drop: Op {
    public init(env: Env, pos: Pos, pc: Pc, offset: Int = 0, count: Int = 1) {
        _env = env
        _pos = pos
        _pc = pc
        _offset = offset
        _count = count
    }

    open func eval() throws -> Pc {
        try _env.drop(pos: _pos, offset: _offset, count: _count)
        return _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _offset, _count: Int
}
