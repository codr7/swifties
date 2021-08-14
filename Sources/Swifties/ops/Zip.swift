import Foundation

open class Zip: Op {
    public init(env: Env, pos: Pos, pc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
    }

    open func eval() throws -> Pc {
        let l = try _env.pop(pos: _pos)
        let r = try _env.peek(pos: _pos)
        try _env.poke(pos: _pos, _env.coreLib!.pairType, (l, r))
        return _pc+1
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc: Pc
}
