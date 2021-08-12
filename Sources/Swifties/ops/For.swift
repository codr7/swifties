import Foundation

public class For: Op {
    public init(env: Env, pos: Pos, pc: Pc, nextPc: Pc) {
        _env = env
        _pos = pos
        _pc = pc
        _nextPc = nextPc
    }

    public func prepare() {
        _firstOp = _env.ops[_pc+1]
        _nextOp = _env.ops[_nextPc]
    }
    
    public func eval() throws {
        let src = try _env.pop(pos: _pos)        
        if src.type.iterValue == nil { throw EvalError(_pos, "Value is not iterable: \(src.type.name)")}
        let iter = src.type.iterValue!(src.value)
        
        while true {
            let v = iter()
            if v == nil { break }
            _env.push(v!)
            try _firstOp!.eval()
        }
            
        try _nextOp!.eval()
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _pc, _nextPc: Pc
    private var _firstOp, _nextOp: Op?
}
