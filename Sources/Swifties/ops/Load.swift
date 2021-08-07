import Foundation

public class Load: Op {
    public init(env: Env, pos: Pos, pc: Pc, index: Register) {
        _env = env
        _pos = pos
        _pc = pc
        _index = index
    }
        
    public func prepare() { _nextOp = _env.ops[_pc+1] }
    
    public func eval() throws {
        try _env.load(pos: _pos, index: _index)
        try _nextOp!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
    private let _index: Register
    private var _nextOp: Op?
}
