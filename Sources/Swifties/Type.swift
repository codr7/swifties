import Foundation

public class Type<T: Equatable>: AnyType {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        equalValues = {lhs, rhs -> Bool in lhs as! T == rhs as! T}
    }
}
