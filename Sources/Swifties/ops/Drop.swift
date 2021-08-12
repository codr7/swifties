import Foundation

open class Drop: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    open func prepare() { _nextOp = _env.ops[_pc+1] }

    open func eval() throws {
        try _env.pop(pos: _pos)
        try _nextOp!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private var _nextOp: Op?
}
