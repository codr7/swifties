import Foundation

class Func: Definition, Equatable {
    typealias Body = (_ pos: Pos) -> Pc?

    static func == (lhs: Func, rhs: Func) -> Bool {
        return lhs === rhs
    }

    var env: Env { _env }
    var pos: Pos { _pos }
    var name: String { _name }
    var slot: Slot { Slot(_env.coreLib!.funcType, self) }
    
    init(env: Env, pos: Pos, name: String, args: [AnyType], rets: [AnyType], _ body: @escaping Body) {
        _env = env
        _pos = pos
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
        
    let _pos: Pos
    let _env: Env
    let _name: String
    let _args, _rets: [AnyType]
    let _body: Body
}
