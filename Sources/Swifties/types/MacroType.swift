import Foundation

public class MacroType: Type<Macro> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in (v as! Macro).dump()}
        equalValues = {lhs, rhs in lhs as! Macro === rhs as! Macro}
    }
}
