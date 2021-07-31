import Foundation

struct Load: Op {
    let _env: Env
    let _pc: Pc
    let _index: Register
    
    init(env: Env, pc: Pc, index: Register) {
        _env = env
        _pc = pc
        _index = index
    }
        
    func eval() -> Pc {
        _env.push(_env.load(register: _index)!)
        return _pc+1
    }
}
