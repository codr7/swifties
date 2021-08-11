import Foundation

public class AnyType: Definition, Equatable {
    public typealias CallValue = (_ target: Any, _ pos: Pos, _ ret: Op, _ check: Bool) throws -> Void
    public typealias DumpValue = (_ value: Any) -> String
    public typealias EqualValues = (_ lhs: Any, _ rhs: Any) -> Bool
    public typealias IterValue = (_ value: Any) -> Slot
    public typealias ValueIsTrue = (_ value: Any) -> Bool
    
    typealias ParentTypes = Set<TypeId>

    public static func == (lhs: AnyType, rhs: AnyType) -> Bool {
        return lhs === rhs
    }

    public var env: Env { _env }
    public var pos: Pos { _pos }
    public var name: String { _name }
    public var slot: Slot { Slot(_env.coreLib!.metaType, self) }
    
    public var callValue: CallValue?
    public var dumpValue: DumpValue?
    public var equalValues: EqualValues?
    public var iterValue: IterValue?
    public var valueIsTrue: ValueIsTrue
    
    public init(_ env: Env, pos: Pos, name: String, parentTypes: [AnyType]) {
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
        valueIsTrue = {_ in true}
    }

    public func isa(_ other: AnyType) -> Bool {
        return other == self || _parentTypes.contains(other._id)
    }
    
    private let _env: Env
    private let _pos: Pos
    private let _id: TypeId
    private let _name: String
    private let _parentTypes: ParentTypes
}
