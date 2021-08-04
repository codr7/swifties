import Foundation

public class StackType: Type<Stack> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        
        dumpValue = {v in
            var out = "["
            let ss = (v as! Stack).map {s in s.type.dumpValue!(s.value)}

            for i in 0..<ss.count {
                if i > 0 { out += " " }
                out += ss[i]
            }
            
            out += "]"
            return out
        }
    }
}
