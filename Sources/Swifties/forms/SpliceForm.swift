import Foundation

open class SpliceForm: Form {
    public init(env: Env, pos: Pos, form: Form) {
        _form = form
        super.init(env: env, pos: pos)
    }
    
    open override func dump() -> String { ",\(_form.dump())" }

    open override func expand() throws -> Form {
        let newForm = try _form.expand()
        if newForm != _form { return try SpliceForm(env: env, pos: pos, form: newForm).expand() }
        return self
    }

    open override func emit() throws {
        throw EmitError(pos, "Unquote outside of quoted context")
    }
    
    open override func quote1() throws -> Form {
        let skipPc = env.emit(STOP)
        _startPc = env.pc
        try _form.quote1().emit()
        env.emit(STOP)
        env.emit(Goto(pc: env.pc), pc: skipPc)
        return self
    }
    
    open override func quote2(depth: Int) throws -> Form {
        if depth == 1 {
            let prevCount = env._stack.count
            try env.eval(_startPc!)
            var fs: Forms = []
            let n = env._stack.count-prevCount
            for _ in 0..<n { fs.append(LiteralForm(env: env, pos: pos, try env.pop(pos: pos))) }
            return (fs.count == 1) ? fs.first! : DoForm(env: env, pos: pos, body: fs)
        } else {
            _form = try _form.quote2(depth: depth-1)
        }

        return self
    }

    private var _form: Form
    private var _startPc: Pc?
}
