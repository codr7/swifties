import Foundation

public struct MultiNotApplicable: Error {
    public init(pos: Pos, target: Multi, stack: Stack) {
        _pos = pos
        _target = target
        _stack = stack
    }
    
    private let _pos: Pos
    private let _target: Multi
    private let _stack: Stack
}
