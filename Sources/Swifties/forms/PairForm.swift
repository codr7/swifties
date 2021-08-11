import Foundation

public class PairForm: Form {
    public override var slot: Slot? { _slot }

    public init(env: Env, pos: Pos, _ values: (Form, Form)) {
        _values = values
        let (l, r) = (values.0.slot, values.1.slot)
        
        if l != nil && r != nil {
            _slot = Slot(env.coreLib!.pairType, (l!, r!))
        } else {
            _slot = nil
        }
        
        super.init(env: env, pos: pos)
    }
    
    public override func emit() throws {
        if _slot == nil {
            try _values.0.emit()
            try _values.1.emit()
            env.emit(Zip(env: env, pos: pos, pc: env.pc))
        } else {
            env.emit(Push(pc: env.pc, _slot!))
        }
    }
        
    private let _values: (Form, Form)
    private let _slot: Slot?
}
