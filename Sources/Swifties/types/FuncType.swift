import Foundation

public class FuncType: Type<Func> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        
        callValue = {target, pos, check -> Pc? in
            let f = target as! Func
            
            if check && !f.isApplicable() {
                throw NotApplicable(pos: pos, target: f, stack: self.env.stack)
            }
            
            return f.call(pos: pos)
        }
    }
}

