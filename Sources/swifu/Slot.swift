import Foundation

struct Slot {
    let _type: AnyType
    let _value: Any
    
    init<T>(_ type: Type<T>, _ value: T) {
        self._type = type
        self._value = value
    }
    
    var type: AnyType {
        get { _type }
    }
    
    var value: Any {
        get { _value }
    }
}
