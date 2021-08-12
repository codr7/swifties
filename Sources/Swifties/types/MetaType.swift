import Foundation

open class MetaType: Type<AnyType> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in (v as! AnyType).name}
        equalValues = {lhs, rhs in lhs as! AnyType === rhs as! AnyType}
    }
}
