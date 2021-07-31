import Foundation

struct CompileError: Error {
    let _pos: Pos
    let _message: String
    
    init(_ pos: Pos, _ message: String) {
        _pos = pos
        _message = message
    }
}
