import Foundation

open class Suspend: Op {
    public init(env: Env, pc: Pc, retPc: @escaping () -> Pc) {
        _env = env
        _pc = pc
        _retPc = retPc
    }

    open func prepare() {}

    open func eval() throws {
        _env.push(_env.coreLib!.contType, _env.suspend(pc: _pc+1))
        try _env.eval(_retPc(), prepare: false)
    }
    
    private let _env: Env
    private let _pc: Pc
    private let _retPc: () -> Pc
}
