import Foundation

public class ContType: Type<Cont> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = { v in (v as! Cont).dump() }
        equalValues = {lhs, rhs in lhs as! Cont === rhs as! Cont}
    }
}
