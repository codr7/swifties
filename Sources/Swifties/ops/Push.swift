import Foundation

public class Push: Op {
    public var env: Env { _slot.type.env }

    public init(pc: Pc, _ slot: Slot) {
        _pc = pc
        _slot = slot
    }

    public convenience init<T>(pc: Pc, _ type: Type<T>, _ value: T) { self.init(pc: pc, Slot(type, value)) }

    public func prepare() { _nextOp = env.ops[_pc+1] }
    
    public func eval() throws {
        env.push(_slot)
        try _nextOp!.eval()
    }
    
    private let _pc: Pc
    private let _slot: Slot
    private var _nextOp: Op?
}
