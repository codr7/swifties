import Foundation

public typealias Pair = (Slot, Slot)

public class PairType: Type<Pair> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        
        dumpValue = {v in
            let p = v as! Pair
            return p.0.type.dumpValue!(p.0.value) + ":" + p.1.type.dumpValue!(p.1.value)
        }
 
        equalValues = {lhs, rhs in
            let (l, r) = (lhs as! Pair, rhs as! Pair)
            return l.0.type == r.0.type &&
                l.1.type == r.1.type &&
                l.0.type.equalValues!(l.0, r.0) &&
                l.1.type.equalValues!(l.1, r.1)
        }
        
        valueIsTrue = {v in
            let p = v as! Pair
            return p.0.type.valueIsTrue(p.0) && p.1.type.valueIsTrue(p.1)
        }
    }
}
