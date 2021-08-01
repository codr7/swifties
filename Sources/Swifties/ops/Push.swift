import Foundation

struct Push: Op {
    var env: Env { _slot.type.env }

    init(pc: Pc, _ slot: Slot) {
        _pc = pc
        _slot = slot
    }

    init<T>(pc: Pc, _ type: Type<T>, _ value: T) {
        self.init(pc: pc, Slot(type, value))
    }

    func eval() throws -> Pc {
        env.push(_slot)
        return _pc+1
    }
    
    private let _pc: Pc
    private let _slot: Slot
}
