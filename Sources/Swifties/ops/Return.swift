import Foundation

public struct Return: Op {
    public init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    public func eval() throws -> Pc { try _env.popFrame() }
    
    private let _env: Env
    private let _pos: Pos
}
