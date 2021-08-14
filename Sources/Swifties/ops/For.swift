import Foundation

open class For: Op {
    public init(env: Env, pos: Pos, pc: Pc, nextPc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
        _nextPc = nextPc
    }
    
    open func eval() throws -> Pc {
        let src = try _env.pop(pos: _pos)        
        if src.type.iterValue == nil { throw EvalError(_pos, "Value is not iterable: \(src.type.name)")}
        let iter = src.type.iterValue!(src.value)
        
        while true {
            let v = iter()
            if v == nil { break }
            _env.push(v!)
            try _env.eval(_pc+1)
        }
            
        return _nextPc
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc, _nextPc: Pc
}
