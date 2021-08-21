import Foundation

open class Swap: Op {
    public init(env: Env, pos: Pos, pc: Pc, count: Int = 1) {
        _env = env
        _pos = pos
        _pc = pc
        _count = count
    }

    open func eval() throws -> Pc {
        try _env.swap(pos: _pos, count: _count)
        return _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _count: Int
}
