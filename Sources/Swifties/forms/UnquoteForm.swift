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
    
    open override func quote() throws -> Slot {
        try env.eval(_startPc)
        return try env.pop(pos: pos)
    }
    
    open override func unquote() throws -> Form {
        let skipPc = env.emit(STOP)
        _startPc = env.pc
        try _form.emit()
        env.emit(STOP)
        env.emit(Goto(pc: env.pc), pc: skipPc)
        return self
    }

    private let _form: Form
    private var _startPc: Pc = -1
}