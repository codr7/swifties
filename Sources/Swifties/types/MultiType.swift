import Foundation

open class MultiType: Type<Multi> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        callValue = {target, pos, ret, check throws in try (target as! Multi).call(pos: pos, ret: ret) }
        dumpValue = { v in (v as! Multi).dump() }
        equalValues = {lhs, rhs in lhs as! Multi === rhs as! Multi}
    }
}
