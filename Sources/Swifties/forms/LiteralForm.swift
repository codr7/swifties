import Foundation

open class LiteralForm: Form {
    open override var slot: Slot? { _slot }

    public convenience init<T>(env: Env, pos: Pos, _ type: Type<T>, _ value: T) {
        self.init(env: env, pos: pos, Slot(type, value))
    }
    
    public init(env: Env, pos: Pos, _ slot: Slot) {
        _slot = slot
        super.init(env: env, pos: pos)
    }
    
    open override func emit() throws {
        env.emit(Push(pc: env.pc, _slot))
    }
       
    open override func quote() -> Slot { _slot }

    private let _slot: Slot
}
