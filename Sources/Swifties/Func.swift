import Foundation

class Func: Equatable {
    typealias Body = (_ pos: Pos) -> Pc?

    static func == (lhs: Func, rhs: Func) -> Bool {
        return lhs._id == rhs._id
    }

    init(env: Env, name: String, args: [AnyType], rets: [AnyType], body: @escaping Body) {
        _env = env
        _id = env.nextFuncId()
        _name = name
        _args = args
        _rets = rets
        _body = body
    }
    
    func isApplicable() -> Bool {
        return true
    }

    func call(pos: Pos) -> Pc? {
        return _body(pos)
    }
        
    let _env: Env
    let _id: FuncId
    let _name: String
    let _args, _rets: [AnyType]
    let _body: Body
}
