import Foundation

open class Restore: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    open func prepare() {}

    open func eval() throws {
        let s = try _env.pop(pos: _pos)
        let c = s.value as! Cont
        try _env.eval(c.restore(), prepare: false)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
}
