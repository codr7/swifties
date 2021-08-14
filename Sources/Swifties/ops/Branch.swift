import Foundation

open class Branch: Op {
    public init(env: Env, pos: Pos, truePc: Pc, falsePc: Pc, pop: Bool = true) {
        _env = env
        _pos = pos
        _truePc = truePc
        _falsePc = falsePc
        _pop = pop
    }
    
    open func eval() throws -> Pc {
        let v = _pop ? try _env.pop(pos: _pos) : try _env.peek(pos: _pos)
        return v.type.valueIsTrue(v.value) ? _truePc : _falsePc
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _truePc, _falsePc: Pc
    private let _pop: Bool
}
