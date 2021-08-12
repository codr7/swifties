import Foundation

open class BoolType: Type<Bool> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in (v as! Bool) ? "t" : "f"}
        equalValues = {lhs, rhs in lhs as! Bool == rhs as! Bool}
        valueIsTrue = {v in v as! Bool}
    }
}
