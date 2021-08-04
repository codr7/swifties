import Foundation

public class MacroType: Type<Macro> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
 
        dumpValue = {v in
            let f = v as! Macro
            return "Macro\(f.name)"
        }
    }
}
