import Foundation

public class Macro {
    public typealias Body = (_ pos: Pos, _ args: [Form]) throws -> Form

    public var name: String { _name }
    
    public init(env: Env, name: String, _ body: @escaping Body) {
        _env = env
        _name = name
        _body = body
    }
    
    public func expand(pos: Pos, args: [Form]) throws -> Form {
        try _body(pos, args)
    }
    
    public func dump() -> String { "Macro\(_name)" }
    
    private let _env: Env
    private let _name: String
    private let _body: Body
}
