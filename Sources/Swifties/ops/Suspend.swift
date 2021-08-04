import Foundation

public struct Suspend: Op {
    public init(env: Env, pc: Pc, returnPc: Int) {
        _env = env
        _pc = pc
        _returnPc = returnPc
    }

    public func eval() throws -> Pc {
        let c = Coro(scope: _env.scope, stack: _env.stack, registers: _env.registers, pc: _pc+1)
        _env.push(_env.coreLib!.coroType, c)
        return _returnPc
    }
    
    private let _env: Env
    private let _pc, _returnPc: Pc
}
