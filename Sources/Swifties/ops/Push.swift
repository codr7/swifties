import Foundation

struct Push: Op {
    let _pc: Pc
    let _slot: Slot

    var env: Env { _slot.type.env }

    init(pc: Pc, slot: Slot) {
        _pc = pc
        _slot = slot
    }
        
    func eval() throws -> Pc {
        env.push(_slot)
        return _pc+1
    }
}
