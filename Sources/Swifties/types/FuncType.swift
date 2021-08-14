import Foundation

open class FuncType: Type<Func> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        
        callValue = {target, pos, ret, check throws in
            let f = target as! Func
            
            if check && !f.isApplicable() {
                throw NotApplicable(pos: pos, target: f, stack: self.env.stack)
            }
            
            return try f.call(pos: pos, ret: ret)
        }

        dumpValue = { v in (v as! Func).dump() }        
        equalValues = {lhs, rhs in lhs as! Func === rhs as! Func}
    }
}

