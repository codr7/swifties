import Foundation

public struct Load: Op {
    public init(env: Env, pc: Pc, index: Register) {
        _env = env
        _pc = pc
        _index = index
    }
        
    public func eval() throws -> Pc {
        _env.push(_env.load(index: _index)!)
        return _pc+1
    }
    
    private let _env: Env
    private let _pc: Pc
    private let _index: Register
}
