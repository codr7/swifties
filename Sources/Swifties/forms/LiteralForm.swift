import Foundation

public class LiteralForm: Form {
    public override var slot: Slot? { _slot }

    public init<T>(env: Env, pos: Pos, _ type: Type<T>, _ value: T) {
        _slot = Slot(type, value)
        super.init(env: env, pos: pos)
    }
    
    public override func emit() throws {
        env.emit(Push(pc: env.pc, _slot))
    }
        
    private let _slot: Slot
}
