import Foundation

typealias EqualValues = (_ lhs: Any, _ rhs: Any) -> Bool

class AnyType: Hashable {
    static func == (lhs: AnyType, rhs: AnyType) -> Bool {
        return lhs._id == rhs._id
    }

    var env: Env { _env }
    var pos: Pos { _pos }
    var name: String { _name }

    init(env: Env, pos: Pos, name: String) {
        _env = env
        _pos = pos
        _id = env.getNextTypeId()
        _name = name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_env)
        hasher.combine(_id)
     }

    var equalValues: EqualValues? = nil

    let _env: Env
    let _pos: Pos
    let _id: Int
    let _name: String
    let _parentTypes: Set<AnyType> = []
}

class Type<T: Equatable>: AnyType {
    override init(env: Env, pos: Pos, name: String) {
        super.init(env: env, pos: pos, name: name)
        
        equalValues = {(lhs: Any, rhs: Any) -> Bool in
            return lhs as! T == rhs as! T
        }
    }
}
