import Foundation

public struct Suspend: Op {
    public init(env: Env, pc: Pc, retPc: @escaping () -> Pc) {
        _env = env
        _pc = pc
        _retPc = retPc
    }

    public func eval() throws -> Pc {
        _env.push(_env.coreLib!.contType, _env.suspend(pc: _pc+1))
        return _retPc()
    }
    
    private let _env: Env
    private let _pc: Pc
    private let _retPc: () -> Pc
}
