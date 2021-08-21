import Foundation

open class PairForm: Form {
    open var left: Form { _values.0 }
    open var right: Form { _values.1 }

    open override var slot: Slot? { _slot }

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
    
    open override func dump() -> String { "\(left.dump()):\(right.dump())" }
    
    open override func emit() throws {
        if _slot == nil {
            try _values.0.emit()
            try _values.1.emit()
            env.emit(Zip(env: env, pos: pos, pc: env.pc))
        } else {
            env.emit(Push(pc: env.pc, _slot!))
        }
    }
        
    open override func quote1() throws -> Form {
        _values = (try left.quote1(), try right.quote1())
        return self
    }

    open override func quote2(depth: Int) throws -> Form {
        _values = (try left.quote2(depth: depth), try right.quote2(depth: depth))
        return self
    }
    
    private var _values: (Form, Form)
    private let _slot: Slot?
}
