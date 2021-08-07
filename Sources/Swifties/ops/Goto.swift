import Foundation

public struct Goto: Op {
    public init(env: Env, pc: Pc) {
        _env = env
        _pc = pc
    }
    
    public func eval() throws { try _env.eval(_pc) }
    
    private let _env: Env
    private let _pc: Pc
}
