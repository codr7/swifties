import Foundation

public class Frame {
    public init(env: Env, pos: Pos, _func: Func, returnPc: Pc) {
        _env = env
        _pos = pos
        self._func = _func
        _stack = _env._stack
        _registers = _env._registers
        _returnPc = returnPc
        _env.reset()
    }
 
    public func restore() throws {
        let n = _env._stack.count
        if n < _func.rets.count { throw EvalError(_pos, "Missing results: \(_func.name) \(_env._stack)")}
        let rstack = _env._stack[(n-_func.rets.count)...]
        
        for i in 0..<_func.rets.count {
            let v = rstack[i]
            if !v.type.isa(_func.rets[i]) { throw EvalError(_pos, "Invalid result: \(_func.name) \(v)") }
        }
        
        _env._stack.append(contentsOf: rstack)
        _env._registers = _registers
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _func: Func
    private let _stack: Stack
    private let _registers: Registers
    private let _returnPc: Pc
    
}