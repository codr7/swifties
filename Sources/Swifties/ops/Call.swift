import Foundation

struct Call: Op {
    init(env: Env, pos: Pos, pc: Pc, target: Slot?, check: Bool) {
        _env = env
        _pos = pos
        _pc = pc
        _target = target
        _check = check
    }
        
    func eval() throws -> Pc {
        let t = _target ?? _env.pop()
        return try t!.type.callValue!(t!.value, _pos, _check) ?? _pc+1
    }
    
    let _env: Env
    let _pos: Pos
    let _pc: Pc
    let _target: Slot?
    let _check: Bool
}
