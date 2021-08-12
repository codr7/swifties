import Foundation

open class Goto: Op {
    public init(env: Env, pc: Pc) {
        _env = env
        _pc = pc
    }
    
    open func prepare() { _op = _env.ops[_pc] }
    open func eval() throws { try _op!.eval() }
    
    private let _env: Env
    private let _pc: Pc
    private var _op: Op?
}
