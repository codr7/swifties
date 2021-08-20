import Foundation

open class IterType: Type<Iter> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        
        dumpValue = {v in
            var c = v
            return withUnsafePointer(to: &c) {p in "Iter(\(p))"}
        }
        
        iterValue = {v in v as! Iter}
    }
}
