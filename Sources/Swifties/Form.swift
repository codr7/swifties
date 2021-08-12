import Foundation

open class Form: Equatable {
    public static func == (lhs: Form, rhs: Form) -> Bool { lhs === rhs }
    
    open var env: Env { _env }
    open var pos: Pos { _pos }
    open var slot: Slot? { nil }
    
    public init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    open func expand() throws -> Form { self }
    open func emit() throws {}

    private let _env: Env
    private let _pos: Pos
}
