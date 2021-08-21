import Foundation

open class UnquoteForm: Form {
    public init(env: Env, pos: Pos, form: Form) {
        _form = form
        super.init(env: env, pos: pos)
    }
    
    open override func dump() -> String { ",\(_form.dump())" }

    open override func expand() throws -> Form {
        let newForm = try _form.expand()
        if newForm != _form { return try UnquoteForm(env: env, pos: pos, form: newForm).expand() }
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
            try env.eval(_startPc!)
            return LiteralForm(env: env, pos: pos, try env.pop(pos: pos))
        } else {
            _form = try _form.quote2(depth: depth-1)
        }

        return self
    }

    open override func quote3(depth: Int) throws -> Slot {
        try env.eval(_startPc!)
        return try env.pop(pos: pos)
    }

    private var _form: Form
    private var _startPc: Pc?
}
