import Foundation

public class Reset: Op {
    public init(env: Env, pc: Pc) {
        _env = env
        _pc = pc
    }

    public func prepare() {}

    public func eval() throws {
        _env.reset()
        try _env.eval(_pc+1, prepare: false)
    }
    
    private let _env: Env
    private let _pc: Pc
}
