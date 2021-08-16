import Foundation

open class Cont {
    init(env: Env, restorePc: Pc) {
        _env = env
        _scope = env._scope
        _stack = env._stack
        _registers = env._registers
        _frames = env._frames
        _restorePc = restorePc
    }
    
    func dump() -> String { "Cont(\(_restorePc))" }
    
    func restore() -> Pc {
        _env._scope = _scope
        _env._stack = _stack
        _env._registers = _registers
        _env._frames = _frames
        return _restorePc
    }
    
    private let _env: Env
    private let _scope: Scope?
    private let _stack: Stack
    private let _registers: Registers
    private let _frames: Frames
    private let _restorePc: Pc
}
