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
    
    open override func unquote() throws -> Form {
        let startPc = env.pc
        try _form.emit()
        env.emit(STOP)
        try env.eval(startPc)
        env._bin = env._bin.dropLast(env.pc-startPc)
        return LiteralForm(env: env, pos: pos, try env.pop(pos: pos))
    }

    private let _form: Form
}
