import Foundation

class Macro: Equatable {
    typealias Body = (_ pos: Pos, _ args: [Form]) throws -> Form

    static func == (lhs: Macro, rhs: Macro) -> Bool {
        return lhs === rhs
    }
    
    init(env: Env, name: String, argCount: Int, _ body: @escaping Body) {
        _env = env
        _name = name
        _argCount = argCount
        _body = body
    }
    
    func expand(pos: Pos, args: [Form]) throws -> Form {
        try _body(pos, args)
    }
    
    let _env: Env
    let _name: String
    let _argCount: Int
    let _body: Body
}
