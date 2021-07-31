import Foundation

struct NotApplicable: Error {
    let _pos: Pos
    let _target: Func
    let _stack: Stack
    
    init(pos: Pos, target: Func, stack: Stack) {
        _pos = pos
        _target = target
        _stack = stack
    }
}
