import Foundation

public protocol Definition {
    var pos: Pos {get}
    var name: String {get}
    var slot: Slot {get}
}

public class Lib {
    public var env: Env { _env }
    public var pos: Pos { _pos }
 
    public init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    public func define(_ ds: Definition...) { define(ds) }
    
    public func define(_ ds: [Definition]) {
        for d in ds {
            _bindings[d.name] = d.slot
        }
    }

    public func define<T>(_ id: String, _ type: Type<T>, _ value: T) {
        _bindings[id] = Slot(type, value)
    }
    
    public func bind(pos: Pos, _ names: String...) throws { try bind(pos: pos, names) }

    public func bind(pos: Pos, _ names: [String]) throws {
        for n in names {
            if let s = _bindings[n] {
                try env.scope!.bind(pos: pos, id: n, s)
            } else {
                throw UnknownId(pos: pos, id: n)
            }
        }
    }

    private let _env: Env
    private let _pos: Pos
    private var _bindings: [String: Slot] = [:]
}
