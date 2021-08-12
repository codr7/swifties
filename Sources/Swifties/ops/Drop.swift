import Foundation

open class Drop: Op {
    public init(env: Env, pos: Pos, pc: Pc, count: Int = 1) {
        _env = env
        _pos = pos
        _pc = pc
        _count = count
    }

    open func prepare() { _nextOp = _env.ops[_pc+1] }

    open func eval() throws {
        try _env.drop(pos: _pos, count: _count)
        try _nextOp!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _count: Int
    private var _nextOp: Op?
}
