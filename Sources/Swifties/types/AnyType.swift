import Foundation

open class AnyType: Definition, Equatable {
    public typealias CallValue = (_ target: Any, _ pos: Pos, _ ret: Pc, _ check: Bool) throws -> Pc
    public typealias DumpValue = (_ value: Any) -> String
    public typealias EqualValues = (_ lhs: Any, _ rhs: Any) -> Bool
    public typealias IterValue = (_ value: Any) -> Iter
    public typealias ValueIsTrue = (_ value: Any) -> Bool
    
    public typealias ParentTypes = Set<TypeId>
    
    public static func == (lhs: AnyType, rhs: AnyType) -> Bool {
        return lhs === rhs
    }

    open var env: Env { _env }
    open var pos: Pos { _pos }
    open var id: TypeId { _id }
    open var name: String { _name }
    open var slot: Slot { Slot(_env.coreLib!.metaType, self) }
    
    open var callValue: CallValue?
    open var dumpValue: DumpValue?
    open var equalValues: EqualValues?
    open var iterValue: IterValue?
    open var valueIsTrue: ValueIsTrue
    
    public init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
        _env = env
        _pos = pos
        _id = env.nextTypeId()
        _name = name
        valueIsTrue = {_ in true}
        for pt in parentTypes { addParent(pt) }
    }

    open func addParent(_ parent: AnyType) {
        _parentTypes.insert(parent._id)
        for pid in parent._parentTypes { _parentTypes.insert(pid) }
    }
    
    open func isa(_ parent: AnyType) -> Bool {
        return parent == self || _parentTypes.contains(parent._id)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _id: TypeId
    private let _name: String
    private var _parentTypes: ParentTypes = []
}
