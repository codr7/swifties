import Foundation

open class IntType: Type<Int> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in String(v as! Int)}
 
        equalValues = {lhs, rhs in lhs as! Int == rhs as! Int}

        iterValue = {v in
            let max = v as! Int
            var i = 0
            
            return {
                if i < max {
                    let out = Slot(env.coreLib!.intType, i)
                    i += 1
                    return out
                }
                
                return nil
            }
        }
        
        valueIsTrue = {v in (v as! Int) != 0}
    }
}
