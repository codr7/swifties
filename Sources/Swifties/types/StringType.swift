import Foundation

open class StringType: Type<String> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in "\"(v as! String)\""}
 
        equalValues = {lhs, rhs in lhs as! String == rhs as! String}

        iterValue = {v in
            var s = (v as! String).makeIterator()
            
            return {
                if let c = s.next() { return Slot(env.coreLib!.charType, c) }
                return nil
            }
        }
        
        valueIsTrue = {v in (v as! String).count > 0}
    }
}
