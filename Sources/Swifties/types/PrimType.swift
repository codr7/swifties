import Foundation

open class PrimType: Type<Prim> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in (v as! Macro).dump()}
        equalValues = {lhs, rhs in lhs as! Prim === rhs as! Prim}
    }
}
