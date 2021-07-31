import Foundation

struct Push: Operation {
    let _pc: Pc
    let _pos: Pos
    let _slot: Slot
    
    init(pc: Pc, pos: Pos, slot: Slot) {
        _pc = pc
        _pos = pos
        _slot = slot
    }
    
    var context: Context { _slot.type.context }
    var pos: Pos { _pos }
    
    func eval() -> Pc {
        context.push(_slot)
        return _pc+1
    }
}
