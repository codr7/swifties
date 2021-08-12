import Foundation

open class RegisterType: Type<Register> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in "Register\(v as! Register)"}
        equalValues = {lhs, rhs in lhs as! Register == rhs as! Register}
    }
}
