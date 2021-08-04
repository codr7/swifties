import Foundation

public class CoroType: Type<Coro> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
 
        dumpValue = {v in
            let c = v as! Coro
            return "Coro\(c.pc)"
        }
    }
}
