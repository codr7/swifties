import Foundation

public class Coro: Equatable {
    public static func == (lhs: Coro, rhs: Coro) -> Bool { lhs === rhs }

    public var scope: Scope? { _scope }
    public var stack: Stack { _stack }
    public var registers: Registers { _registers }
    public var pc: Pc { _pc }
    
    init(scope: Scope?, stack: Stack, registers: Registers, pc: Pc) {
        _scope = scope
        _stack = stack
        _registers = registers
        _pc = pc
    }
    
    private let _scope: Scope?
    private let _stack: Stack
    private let _registers: Registers
    private let _pc: Pc
}
