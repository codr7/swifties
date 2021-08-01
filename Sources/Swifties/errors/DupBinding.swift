import Foundation

public struct DupBinding: Error {
    public init(pos: Pos, id: String) {
        _pos = pos
        _id = id
    }
    
    private let _pos: Pos
    private let _id: String
}
