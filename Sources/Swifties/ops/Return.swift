import Foundation

open class Return: Op {
    public init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    open func eval() throws -> Pc { try _env.popFrame(pos: _pos) }
    
    private let _env: Env
    private let _pos: Pos
}
