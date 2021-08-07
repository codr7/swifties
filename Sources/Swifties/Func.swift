import Foundation

public class Func: Definition, Equatable {
    public typealias Body = (_ pos: Pos, _ self: Func, _ ret: Op) throws -> Void

    public static func == (lhs: Func, rhs: Func) -> Bool { lhs === rhs }
    
    public var env: Env { _env }
    public var pos: Pos { _pos }
    public var name: String { _name }
    public var args: [AnyType] { _args }
    public var rets: [AnyType] { _rets }
    public var slot: Slot { Slot(_env.coreLib!.funcType, self) }
    
    public init(env: Env, pos: Pos, name: String, args: [AnyType], rets: [AnyType], _ body: Body? = nil) {
        _env = env
        _pos = pos
        _name = name
        _args = args
        _rets = rets
        _body = body
    }

    public func compileBody(_ form: Form) throws {
        let skip = _env.emit(STOP)
        let startPc = _env.pc
        try form.emit()
        _env.emit(Return(env: env, pos: form.pos))
        _env.emit(Goto(env: env, pc: env.pc), index: skip)
        let startOp = _env.ops[startPc]
        
        _body = {p, f, ret in
            self._env.pushFrame(pos: p, _func: f, startOp: startOp, retOp: ret)
            try startOp.eval()
        }
    }
    
    public func isApplicable() -> Bool {
        /*
        for i in 0..<_args.count {
            let v = _env.peek(offset: _args.count - i - 1)
            if v == nil || !v!.type.isa(_args[i]) { return false }
        }
         */

        return true
    }

    public func call(pos: Pos, ret: Op) throws { try _body!(pos, self, ret) }
        
    private let _pos: Pos
    private let _env: Env
    private let _name: String
    private let _args, _rets: [AnyType]
    private var _body: Body?
}
