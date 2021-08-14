import Foundation

open class Restore: Op {
    public init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    open func eval() throws -> Pc {
        let s = try _env.pop(pos: _pos)
        let c = s.value as! Cont
        return c.restore()
    }
    
    private let _env: Env
    private let _pos: Pos
}
