import Foundation

public class Scope: Equatable {
    public static func == (lhs: Scope, rhs: Scope) -> Bool { lhs === rhs }

    public var outer: Scope? { _outer }
    public var registerCount: Int { _nextRegister }

    public init(env: Env, outer: Scope?) {
        _env = env
        _outer = outer
    }
    
    public func bind(pos: Pos, id: String, _ slot: Slot) throws {
        if _bindings.keys.contains(id) { throw DupBinding(pos: pos, id: id) }
        _bindings[id] = slot
    }

    public func bind<T>(pos: Pos, id: String, _ type: Type<T>, _ value: T) throws {
        try bind(pos: pos, id: id, Slot(type, value))
    }
    
    public func find(_ id: String) -> Slot? { _bindings[id] }
    
    public func nextRegister(pos: Pos, id: String) throws -> Register {
        let i = _nextRegister
        try bind(pos: pos, id: id, _env.coreLib!.registerType, i)
        _nextRegister += 1
        return i
    }
    
    private let _env: Env
    private let _outer: Scope?
    private var _bindings: [String: Slot] = [:]
    private var _nextRegister = 0
}

