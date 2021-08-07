import Foundation

public class Goto: Op {
    public init(env: Env, pc: Pc) {
        _env = env
        _pc = pc
    }
    
    public func prepare() { _op = _env.ops[_pc] }
    public func eval() throws { try _op!.eval() }
    
    private let _env: Env
    private let _pc: Pc
    private var _op: Op?
}
