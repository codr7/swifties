import Foundation

open class Form: Equatable {
    public static func == (lhs: Form, rhs: Form) -> Bool { lhs === rhs }
    
    public var env: Env { _env }
    public var pos: Pos { _pos }
    public var slot: Slot? { nil }
    
    public init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    public func expand() throws -> Form { self }
    public func emit() throws {}

    private let _env: Env
    private let _pos: Pos
}
