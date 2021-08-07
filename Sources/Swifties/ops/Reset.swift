import Foundation

public class Reset: Op {
    public init(env: Env, pc: Pc) {
        _env = env
        _pc = pc
    }

    public func prepare() { _nextOp = _env.ops[_pc+1] }

    public func eval() throws {
        _env.reset()
        try _nextOp!.eval()
    }
    
    private let _env: Env
    private let _pc: Pc
    private var _nextOp: Op?
}
