import Foundation

open class Func: Definition {
    public typealias Body = (_ pos: Pos, _ self: Func, _ ret: Op) throws -> Void
    
    open var env: Env { _env }
    open var pos: Pos { _pos }
    open var name: String { _name }
    open var args: [AnyType] { _args }
    open var rets: [AnyType] { _rets }
    open var slot: Slot { Slot(_env.coreLib!.funcType, self) }
    
    public init(env: Env, pos: Pos, name: String, args: [AnyType], rets: [AnyType], _ body: Body? = nil) {
        _env = env
        _pos = pos
        _name = name
        _args = args
        _rets = rets
        _body = body
    }

    open func compileBody(_ form: Form) throws {
        let skip = _env.emit(STOP)
        let startPc = _env.pc
        let scope = _env.begin()

        do {
            defer { _env.end() }
            try form.emit()
        }

        _env.emit(Return(env: env, pos: form.pos))
        _env.emit(Goto(env: env, pc: env.pc), pc: skip)
        let startOp = _env.ops[startPc]
        
        _body = {p, f, ret in
            self._env.pushFrame(pos: p, _func: f, scope: scope, startOp: startOp, ret: ret)
            try startOp.eval()
        }
    }
    
    open func isApplicable() -> Bool {
        for i in 0..<_args.count {
            let v = _env.tryPeek(offset: _args.count - i - 1)
            if v == nil || !v!.type.isa(_args[i]) { return false }
        }

        return true
    }

    open func call(pos: Pos, ret: Op) throws { try _body!(pos, self, ret) }
        
    open func dump() -> String { "Func\(_name)" }
    
    private let _pos: Pos
    private let _env: Env
    private let _name: String
    private let _args, _rets: [AnyType]
    private var _body: Body?
}
