import Foundation

public class RegisterType: Type<Register> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in "Register\(v as! Register)"}
    }
}
