import Foundation

class Macro: Equatable {
    typealias Body = (_ pos: Pos, _ args: [Form]) throws -> Form

    static func == (lhs: Macro, rhs: Macro) -> Bool { lhs === rhs }
    
    init(env: Env, name: String, _ body: @escaping Body) {
        _env = env
        _name = name
        _body = body
    }
    
    func expand(pos: Pos, args: [Form]) throws -> Form {
        try _body(pos, args)
    }
    
    let _env: Env
    let _name: String
    let _body: Body
}
