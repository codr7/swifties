import Foundation

open class Func: Definition {
    public typealias Arg = (String?, AnyType)
    public typealias Ret = AnyType
    public typealias Body = (_ pos: Pos, _ self: Func, _ ret: Op) throws -> Void
    
    public static func getArg(env: Env, pos: Pos, _ f: Form) throws -> Arg {
        var l: String?
        var r: String
        
        switch f {
        case let f as IdForm:
            r = f.name
        case let f as PairForm:
            l = (f.left as! IdForm).name
            r = (f.right as! IdForm).name
        default:
            throw EmitError(pos, "Invalid func argument: #\(f)")
        }
        
        return (l, try env.getType(pos: pos, r))
    }

    public static func getRet(env: Env, pos: Pos, _ f: Form) throws -> Ret {
        if !(f is IdForm) { throw EmitError(pos, "Invalid func result: #\(f)") }
        return try env.getType(pos: pos, (f as! IdForm).name)
    }

    open var env: Env { _env }
    open var pos: Pos { _pos }
    open var name: String { _name }
    open var args: [Arg] { _args }
    open var rets: [Ret] { _rets }
    open var slot: Slot { Slot(_env.coreLib!.funcType, self) }
    
    public init(env: Env, pos: Pos, name: String, args: [Arg], rets: [Ret], _ body: Body? = nil) {
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
            var offset = 0
            
            for (n, _) in args.reversed() {
                if n != nil {
                    let i = try scope.nextRegister(pos: pos, id: n!)
                    env.emit(Store(env: _env, pos: _pos, pc: env.pc, index: i, offset: offset))
                } else {
                    offset += 1
                }
            }
            
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
            if v == nil || !v!.type.isa(_args[i].1) { return false }
        }

        return true
    }

    open func call(pos: Pos, ret: Op) throws { try _body!(pos, self, ret) }
        
    open func dump() -> String { "Func\(_name)" }
    
    private let _pos: Pos
    private let _env: Env
    private let _name: String
    private let _args: [Arg]
    private let _rets: [Ret]
    private var _body: Body?
}
