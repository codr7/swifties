import Foundation

typealias ParentTypes = Set<TypeId>

typealias CallValue = (_ target: Any, _ pos: Pos, _ check: Bool) throws -> Pc?
typealias EqualValues = (_ lhs: Any, _ rhs: Any) -> Bool

class AnyType: Equatable {
    static func == (lhs: AnyType, rhs: AnyType) -> Bool {
        return lhs === rhs
    }

    var env: Env { _env }
    var pos: Pos { _pos }
    var name: String { _name }

    var callValue: CallValue?
    var equalValues: EqualValues?

    init(env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        _env = env
        _pos = pos
        _id = env.nextTypeId()
        _name = name
        var pts: ParentTypes = []
        
        for pt in parentTypes {
            pts.insert(pt._id)
            
            for ppid in pt._parentTypes {
                pts.insert(ppid)
            }
        }
        
        _parentTypes = pts
    }

    func isa(_ other: AnyType) -> Bool {
        return other == self || _parentTypes.contains(other._id)
    }
    
    let _env: Env
    let _pos: Pos
    let _id: TypeId
    let _name: String
    let _parentTypes: ParentTypes
}
