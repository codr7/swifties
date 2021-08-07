import Foundation

public struct Push: Op {
    public var env: Env { _slot.type.env }

    public init(pc: Pc, _ slot: Slot) {
        _pc = pc
        _slot = slot
    }

    public init<T>(pc: Pc, _ type: Type<T>, _ value: T) {
        self.init(pc: pc, Slot(type, value))
    }

    public func eval() throws {
        env.push(_slot)
        try env.eval(_pc+1)
    }
    
    private let _pc: Pc
    private let _slot: Slot
}
