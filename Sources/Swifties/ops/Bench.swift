import Foundation

public struct Bench: Op {
    public init(env: Env, reps: Int, startPc: Pc, endPc: Pc) {
        _env = env
        _reps = reps
        _startPc = startPc
        _endPc = endPc
    }

    public func eval() throws -> Pc {
        let t1 = DispatchTime.now()
        for _ in 0..<_reps { try _env.eval(pc: _startPc)}
        let t2 = DispatchTime.now()
        _env.push(_env.coreLib!.intType, Int((t2.uptimeNanoseconds-t1.uptimeNanoseconds) / 1000000))
        return _endPc
    }
    
    private let _env: Env
    private let _reps: Int
    private let _startPc, _endPc: Pc
}
