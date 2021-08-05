import Foundation

public class Func: Definition, Equatable {
    public typealias Body = (_ pos: Pos, _ self: Func, _ retPc: Pc) throws -> Pc

    public static func == (lhs: Func, rhs: Func) -> Bool { lhs === rhs }

    public static func compile(env: Env, body: Form) throws -> Body {
        let startPc = env.pc
        let skip = env.emit(STOP)
        try body.emit()
        env.emit(Goto(pc: env.pc), index: skip)
        
        return {p, f, retPc in
            env.beginCall(pos: p, _func: f, retPc: retPc)
            return startPc
        }
    }
    
    public var env: Env { _env }
    public var pos: Pos { _pos }
    public var name: String { _name }
    public var args: [AnyType] { _args }
    public var rets: [AnyType] { _rets }
    public var slot: Slot { Slot(_env.coreLib!.funcType, self) }
    
    public init(env: Env, pos: Pos, name: String, args: [AnyType], rets: [AnyType], _ body: @escaping Body) {
        _env = env
        _pos = pos
        _name = name
        _args = args
        _rets = rets
        _body = body
    }

    convenience public init(env: Env, pos: Pos, name: String, args: [AnyType], rets: [AnyType], _ body: Form) throws {
        self.init(env: env, pos: pos, name: name, args: args, rets: rets, try Func.compile(env: env, body: body))
    }

    public func isApplicable() -> Bool {
        for i in 0..<_args.count {
            let v = _env.peek(offset: _args.count - i - 1)
            if v == nil || !v!.type.isa(_args[i]) { return false }
        }
        
        return true
    }

    public func call(pos: Pos, retPc: Pc) throws -> Pc? { try _body(pos, self, retPc) }
        
    private let _pos: Pos
    private let _env: Env
    private let _name: String
    private let _args, _rets: [AnyType]
    private let _body: Body
}
