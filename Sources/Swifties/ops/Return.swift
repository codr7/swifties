import Foundation

public class Return: Op {
    public init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    public func prepare() {}

    public func eval() throws { try _env.eval(try _env.popFrame(pos: _pos), prepare: false) }
    
    private let _env: Env
    private let _pos: Pos
}
