import Foundation

struct Store: Op {
    let _env: Env
    let _pc: Pc
    let _index: Register
    
    init(env: Env, pc: Pc, index: Register) {
        _env = env
        _pc = pc
        _index = index
    }
        
    func eval() -> Pc {
        _env.store(index: _index, slot: _env.pop()!)
        return _pc+1
    }
}
