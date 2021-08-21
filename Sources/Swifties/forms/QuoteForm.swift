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
        let f = try _form.quote1()
        env.emit(Quote(env: env, pc: env.pc, form: f))
    }
    
    open override func quote1() throws -> Form {
        _form = try _form.quote1()
        return self
    }
    
    open override func quote2(depth: Int) throws -> Form {
        _form = try _form.quote2(depth: depth+1)
        return self
    }

    private var _form: Form
}
