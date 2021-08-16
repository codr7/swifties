import Foundation

open class Suspend: Op {
    public init(env: Env, pc: Pc, restorePc: Pc) {
        _env = env
        _pc = pc
        _restorePc = restorePc
    }

    open func prepare() {}

    open func eval() throws -> Pc {
        _env.push(_env.coreLib!.contType, _env.suspend(_restorePc))
        return _pc+1
    }
    
    private let _env: Env
    private let _pc, _restorePc: Pc
}
