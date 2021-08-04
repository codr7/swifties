import Foundation

public class FuncType: Type<Func> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        
        callValue = {target, pos, check throws -> Pc? in
            let f = target as! Func
            
            if check && !f.isApplicable() {
                throw NotApplicable(pos: pos, target: f, stack: self.env.stack)
            }
            
            return try f.call(pos: pos)
        }
 
        dumpValue = {v in
            let f = v as! Func
            return "Func\(f.name)"
        }
    }
}

