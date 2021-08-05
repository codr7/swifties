import Foundation

public class Cont: Equatable {
    public static func == (lhs: Cont, rhs: Cont) -> Bool { lhs === rhs }
    
    init(env: Env, pc: Pc) {
        _env = env
        _scope = env._scope
        _stack = env._stack
        _registers = env._registers
        _frames = env._frames
        _pc = pc
    }
    
    func dump() -> String { "Cont(\(_pc))" }
    
    func restore() -> Pc {
        _env._scope = _scope
        _env._stack = _stack
        _env._registers = _registers
        _env._frames = _frames
        return _pc
    }
    
    private let _env: Env
    private let _scope: Scope?
    private let _stack: Stack
    private let _registers: Registers
    private let _frames: Frames
    private let _pc: Pc
}
