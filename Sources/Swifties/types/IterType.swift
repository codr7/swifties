import Foundation

open class IterType: Type<Iter> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {_ in "Iter"}
        iterValue = {v in v as! Iter}
    }
}
