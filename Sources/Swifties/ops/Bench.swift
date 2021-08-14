import Foundation

open class Bench: Op {
    public init(env: Env, reps: Int, startPc: Pc, endPc: Pc) {
        _env = env
        _reps = reps
        _startPc = startPc
        _endPc = endPc
    }

    open func eval() throws -> Pc {
        let stack = _env._stack
        _env._stack = []
        let t1 = DispatchTime.now()
        for _ in 0..<_reps { try _env.eval(_startPc) }
        let t2 = DispatchTime.now()
        _env._stack = stack
        _env.push(_env.coreLib!.intType, Int((t2.uptimeNanoseconds-t1.uptimeNanoseconds) / 1000000))
        return _endPc
    }
    
    private let _env: Env
    private let _reps: Int
    private let _startPc, _endPc: Pc
}
