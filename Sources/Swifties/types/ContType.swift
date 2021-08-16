import Foundation

open class ContType: Type<Cont> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        callValue = {target, pos, ret, check throws in try (env.pop(pos: pos).value as! Cont).restore()}
        dumpValue = {v in (v as! Cont).dump()}
        equalValues = {lhs, rhs in lhs as! Cont === rhs as! Cont}
    }
}
