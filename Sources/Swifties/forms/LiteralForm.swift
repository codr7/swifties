import Foundation

class LiteralForm: Form {
    override var slot: Slot? { get { _slot } }

    init<T>(env: Env, pos: Pos, _ type: Type<T>, _ value: T) {
        _slot = Slot(type, value)
        super.init(env: env, pos: pos)
    }
    
    override func emit() throws {
        env.emit(Push(pc: env.pc, _slot))
    }
        
    let _slot: Slot
}
