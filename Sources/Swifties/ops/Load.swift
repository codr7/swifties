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
        
    func eval() throws -> Pc {
        _env.push(_env.load(index: _index)!)
        return _pc+1
    }
}
