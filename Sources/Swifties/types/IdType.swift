import Foundation

open class IdType: StringType {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        dumpValue = {v in "'\(v as! String)"}
        valueIsTrue = {_ in true}
    }
}
