import Foundation

public class PrimType: Type<Prim> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
 
        dumpValue = {v in
            let f = v as! Prim
            return "Prim\(f.name)"
        }
    }
}
