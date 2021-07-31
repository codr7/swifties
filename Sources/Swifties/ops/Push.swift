import Foundation

struct Push: Op {
    let _pc: Pc
    let _slot: Slot
    
    init(pc: Pc, slot: Slot) {
        _pc = pc
        _slot = slot
    }
    
    var context: Env { _slot.type.env }
    
    func eval() -> Pc {
        context.push(_slot)
        return _pc+1
    }
}
