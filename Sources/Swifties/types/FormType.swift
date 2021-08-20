import Foundation

open class FormType: Type<Form> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in "'\((v as! Form).dump())"}
        equalValues = {lhs, rhs in lhs as! Form === rhs as! Form}
    }
}
