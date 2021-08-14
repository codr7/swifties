import Foundation

open class Suspend: Op {
    public init(env: Env, pc: Pc, ret: @escaping () -> Pc) {
        _env = env
        _pc = pc
        _ret = ret
    }

    open func prepare() {}

    open func eval() throws -> Pc {
        _env.push(_env.coreLib!.contType, _env.suspend(pc: _pc+1))
        return _ret()
    }
    
    private let _env: Env
    private let _pc: Pc
    private let _ret: () -> Pc
}
