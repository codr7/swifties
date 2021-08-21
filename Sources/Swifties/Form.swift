import Foundation

open class Form: Equatable {
    public static func == (lhs: Form, rhs: Form) -> Bool { lhs === rhs }
    
    open var env: Env { _env }
    open var pos: Pos { _pos }
    open var slot: Slot? { nil }
    
    public init(env: Env, pos: Pos) {
        _env = env
        _pos = pos
    }

    open func dump() -> String { "*?*" }
    open func expand() throws -> Form { self }
    open func emit() throws {}
    open func quote1() throws -> Form { self }
    open func quote2(depth: Int) throws -> Form { return self }
    open func quote3(depth: Int) throws -> Slot { Slot(env.coreLib!.formType, try quote2(depth: depth)) }
    
    private let _env: Env
    private let _pos: Pos
}

public typealias Forms = [Form]

public extension Forms {
    func dump() -> String {
        var out = ""
        
        for i in 0..<self.count {
            if i > 0 { out += " " }
            out += self[i].dump()
        }
    
        return out
    }
}
