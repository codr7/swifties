import Foundation

open class Store: Op {
    public init(env: Env, pos: Pos, pc: Pc, index: Register, offset: Int = 0) {
        _env = env
        _pos = pos
        _pc = pc
        _index = index
        _offset = offset
    }
    
    open func prepare() { _nextOp = _env.ops[_pc+1] }
    
    open func eval() throws {
        try _env.store(pos: _pos, index: _index, offset: _offset)
        try _nextOp!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _index: Register
    private let _offset: Int
    private var _nextOp: Op?
}
