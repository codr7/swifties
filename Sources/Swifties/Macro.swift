import Foundation

open class Macro {
    public typealias Body = (_ pos: Pos, _ args: [Form]) throws -> Form

    open var name: String { _name }
    
    public init(env: Env, name: String, _ body: @escaping Body) {
        _env = env
        _name = name
        _body = body
    }
    
    open func expand(pos: Pos, args: [Form]) throws -> Form {
        try _body(pos, args)
    }
    
    open func dump() -> String { "Macro\(_name)" }
    
    private let _env: Env
    private let _name: String
    private let _body: Body
}
