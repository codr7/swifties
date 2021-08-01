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
        
    private let _env: Env
    private let _name: String
    private let _body: Body
}
