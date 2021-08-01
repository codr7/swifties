import Foundation

public class Prim: Equatable {
    public typealias Body = (_ pos: Pos, _ args: [Form]) throws -> Void

    public static func == (lhs: Prim, rhs: Prim) -> Bool { lhs === rhs }

    public init(env: Env, name: String, _ body: @escaping Body) {
        _env = env
        _name = name
        _body = body
    }
    
    public func emit(pos: Pos, args: [Form]) throws {
        try _body(pos, args)
    }
        
    private let _env: Env
    private let _name: String
    private let _body: Body
}
