import Foundation

struct DupBinding: Error {
    let _pos: Pos
    let _id: String
    
    init(pos: Pos, id: String) {
        _pos = pos
        _id = id
    }
}
