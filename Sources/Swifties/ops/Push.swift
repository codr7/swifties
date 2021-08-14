import Foundation

open class Push: Op {
    open var env: Env { _slot.type.env }

    public init(pc: Pc, _ slot: Slot) {
        _pc = pc
        _slot = slot
    }

    public convenience init<T>(pc: Pc, _ type: Type<T>, _ value: T) { self.init(pc: pc, Slot(type, value)) }

    open func eval() throws -> Pc {
        env.push(_slot)
        return _pc+1
    }
    
    private let _pc: Pc
    private let _slot: Slot
}
