import Foundation

public struct EmitError: Error {
    public init(_ pos: Pos, _ message: String) {
        _pos = pos
        _message = message
    }
    
    private let _pos: Pos
    private let _message: String
}
