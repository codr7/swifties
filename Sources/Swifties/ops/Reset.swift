import Foundation

open class Reset: Op {
    public init(env: Env, pc: Pc) {
        _env = env
        _pc = pc
    }

    open func eval() throws -> Pc {
        _env.reset()
        return _pc+1
    }
    
    private let _env: Env
    private let _pc: Pc
}
