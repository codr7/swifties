import Foundation

class AnyType: Def, Hashable {
    static func == (lhs: AnyType, rhs: AnyType) -> Bool {
        return lhs._id == rhs._id
    }

    var env: Env { _env }
    var pos: Pos { _pos }
    var name: String { _name }
    var slot: Slot { Slot(_env.coreLib!.metaType, self) }

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

    let _env: Env
    let _pos: Pos
    let _id: Int
    let _name: String
    let _parentTypes: [AnyType: AnyType] = [:]
}

class Type<T>: AnyType {
}
