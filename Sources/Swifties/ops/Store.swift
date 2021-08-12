import Foundation

open class Store: Op {
    public init(env: Env, pos: Pos, pc: Pc, index: Register) {
        _env = env
        _pos = pos
        _pc = pc
        _index = index
    }
    
    open func prepare() { _nextOp = _env.ops[_pc+1] }
    
    open func eval() throws {
        try _env.store(pos: _pos, index: _index)
        try _nextOp!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _index: Register
    private var _nextOp: Op?
}
