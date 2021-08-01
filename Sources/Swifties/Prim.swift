import Foundation

class Prim: Equatable {
    typealias Body = (_ pos: Pos, _ args: [Form]) throws -> Void

    static func == (lhs: Prim, rhs: Prim) -> Bool { lhs === rhs }

    init(env: Env, name: String, _ body: @escaping Body) {
        _env = env
        _name = name
        _body = body
    }
    
    func emit(pos: Pos, args: [Form]) throws {
        try _body(pos, args)
    }
        
    let _env: Env
    let _name: String
    let _body: Body
}
