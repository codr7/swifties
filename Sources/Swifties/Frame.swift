import Foundation

public struct Frame {
    public init(env: Env, pos: Pos, _func: Func, scope: Scope, startPc: Pc, ret: Pc) {
        _env = env
        _pos = pos
        self._func = _func
        let s = env._stack
        _env._stack = Stack(s.dropFirst(s.count-_func.args.count))
        _stack = s.dropLast(_func.args.count)
        _registers = _env._registers
        _startPc = startPc
        (_scope, _env._scope) = (_env._scope!, scope)
        _ret = ret
    }
 
    public func restore() throws -> Pc {
        let n = _env._stack.count
        if n < _func.rets.count { throw EvalError(_pos, "Missing results: \(_func.name) \(_env._stack)")}
        let rstack = _env._stack.dropFirst(n-_func.rets.count)
        _env._stack = _stack

        for i in 0..<_func.rets.count {
            let v = rstack[i]
            if !v.type.isa(_func.rets[i]) { throw EvalError(_pos, "Invalid result: \(_func.name) \(v)") }
        }
        
        _env._stack.append(contentsOf: rstack)
        _env._registers = _registers
        _env._scope = _scope
        return _ret
    }
    
    public func recall(pos: Pos, check: Bool) throws -> Pc {
        if check && !_func.isApplicable() { throw FuncNotApplicable(pos: pos, target: _func, stack: _env._stack) }
        return _startPc
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _func: Func
    private let _scope: Scope
    private let _stack: Stack
    private let _registers: Registers
    private let _startPc, _ret: Pc
}
