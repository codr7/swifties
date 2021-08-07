import Foundation

public struct Reset: Op {
    public init(env: Env, pc: Pc) {
        _env = env
        _pc = pc
    }

    public func eval() throws {
        _env.reset()
        try _env.eval(_pc+1)
    }
    
    private let _env: Env
    private let _pc: Pc
}
