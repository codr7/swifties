import Foundation

class Type<T: Equatable>: AnyType {
    override init(_ lib: Lib, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(lib, pos: pos, name: name, parentTypes: parentTypes)
        equalValues = {lhs, rhs -> Bool in lhs as! T == rhs as! T}
    }
}
