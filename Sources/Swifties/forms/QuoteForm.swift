import Foundation

open class QuoteForm: Form {
    public init(env: Env, pos: Pos, form: Form) {
        _form = form
        super.init(env: env, pos: pos)
    }
    
    open override func dump() -> String { "'\(_form.dump())" }

    open override func expand() throws -> Form {
        let newForm = try _form.expand()
        if newForm != _form { return try QuoteForm(env: env, pos: pos, form: newForm).expand() }
        return self
    }

    open override func emit() throws {
        env.emit(try Quote(env: env, pc: env.pc, form: _form))
    }
    
    private let _form: Form
}
