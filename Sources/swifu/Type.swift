import Foundation

class AnyType: Hashable {
    static func == (lhs: AnyType, rhs: AnyType) -> Bool {
        return lhs._id == rhs._id
    }

    let _context: Context
    let _pos: Pos
    let _id: Int
    let _name: String
    let _parentTypes: [AnyType: AnyType] = [:]

    init(context: Context, pos: Pos, name: String) {
        _context = context
        _pos = pos
        _id = context.getNextTypeId()
        _name = name
    }

    func bind() throws {
        try context.scope!.bind(pos: _pos, id: _name, slot: Slot(_context.coreLib!.metaType, self))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_context)
        hasher.combine(_id)
     }
    
    var context: Context { get { _context } }
    var name: String { get { _name } }
}

class Type<T>: AnyType {
}
