import Foundation

class Func: Equatable {
    typealias Body = (_ pos: Pos) -> Pc?

    static func == (lhs: Func, rhs: Func) -> Bool {
        return lhs === rhs
    }

    init(env: Env, name: String, args: [AnyType], rets: [AnyType], _ body: @escaping Body) {
        _env = env
        _name = name
        _args = args
        _rets = rets
        _body = body
    }
    
    func isApplicable() -> Bool {
        for i in 0..<_args.count {
            if !_env.peek(offset: _args.count - i - 1)!.type.isa(_args[i]) {
                return false
            }
        }
        
        return true
    }

    func call(pos: Pos) -> Pc? {
        return _body(pos)
    }
        
    let _env: Env
    let _name: String
    let _args, _rets: [AnyType]
    let _body: Body
}
