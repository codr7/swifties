import Foundation

public struct Slot: Equatable {
    public static func == (lhs: Slot, rhs: Slot) -> Bool {
        if (lhs._type !== rhs._type) { return false }
        precondition(lhs._type.equalValues != nil, "Equality not supported for type \(lhs._type.name)")
        return lhs._type.equalValues!(lhs.value, rhs.value)
    }
    
    public var type: AnyType { get { _type } }
    public var value: Any { get { _value } }

    public init<T>(_ type: Type<T>, _ value: T) {
        self._type = type
        self._value = value
    }
    
    public func dump() -> String { _type.dumpValue!(_value) }
    
    private let _type: AnyType
    private let _value: Any
}
