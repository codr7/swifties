import Foundation

struct UnknownId: Error {
    init(pos: Pos, id: String) {
        _pos = pos
        _id = id
    }
    
    private let _pos: Pos
    private let _id: String
}
