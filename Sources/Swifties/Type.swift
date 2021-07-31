import Foundation

typealias CallValue = (_ target: Any, _ pos: Pos, _ check: Bool) throws -> Pc?
typealias EqualValues = (_ lhs: Any, _ rhs: Any) -> Bool

class AnyType: Equatable {
    static func == (lhs: AnyType, rhs: AnyType) -> Bool {
        return lhs === rhs
    }

    var env: Env { _env }
    var pos: Pos { _pos }
    var name: String { _name }

    init(env: Env, pos: Pos, name: String) {
        _env = env
        _pos = pos
        _id = env.nextTypeId()
        _name = name
    }

    var callValue: CallValue?
    var equalValues: EqualValues?

    let _env: Env
    let _pos: Pos
    let _id: TypeId
    let _name: String
    let _parentTypes: Set<TypeId> = []
}

class Type<T: Equatable>: AnyType {
    override init(env: Env, pos: Pos, name: String) {
        super.init(env: env, pos: pos, name: name)
        
        equalValues = {(lhs: Any, rhs: Any) -> Bool in
            return lhs as! T == rhs as! T
        }
    }
}
