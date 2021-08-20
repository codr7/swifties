import Foundation

public struct FuncNotApplicable: Error {
    public var errorDescription: String? { "Func not applicable: \(_target.name) \(_stack.dump())" }
    
    public init(pos: Pos, target: Func, stack: Stack) {
        _pos = pos
        _target = target
        _stack = stack
    }
    
    private let _pos: Pos
    private let _target: Func
    private let _stack: Stack
}
