import Foundation

open class CharType: Type<Character> {
    public override init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(env, pos: pos, name: name, parentTypes: parentTypes)
        
        dumpValue = {v in
            switch v as! Character {
            case " ":
                return "#\\s"
            case "\n":
                return "#\\n"
            case "\t":
                return "#\\t"
            default:
                return "#\(v as! Character)"
            }
        }
        
        equalValues = {lhs, rhs in lhs as! Character == rhs as! Character}
    }
}
