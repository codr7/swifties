import Foundation

open class Quote: Op {
    public init(env: Env, pc: Pc, form: Form) throws {
        _env = env
        _pc = pc
        _form = try form.unquote()
    }

    open func eval() throws -> Pc {
        _env.push(try _form.quote())
        return _pc+1
    }
    
    private let _env: Env
    private let _pc: Pc
    private let _form: Form
}
