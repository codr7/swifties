import Foundation

class Literal: BaseForm, Form {
    init<T>(env: Env, pos: Pos, _ type: Type<T>, _ value: T) {
        _slot = Slot(type, value)
        super.init(env: env, pos: pos)
    }
    
    func emit() {
        env.emit(Push(pc: env.pc, _slot))
    }
    
    override func slot() -> Slot? {
        return _slot
    }
    
    let _slot: Slot
}
