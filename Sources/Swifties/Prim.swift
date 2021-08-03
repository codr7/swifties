import Foundation

public class Prim: Definition, Equatable {
    public typealias Body = (_ pos: Pos, _ args: [Form]) throws -> Void

    public static func == (lhs: Prim, rhs: Prim) -> Bool { lhs === rhs }

    public var env: Env { _env }
    public var pos: Pos { _pos }
    public var name: String { _name }
    public var slot: Slot { Slot(_env.coreLib!.primType, self) }
    
    public init(env: Env, pos: Pos, name: String, _ args: (Int, Int), _ body: @escaping Body) {
        _env = env
        _pos = pos
        _name = name
        _args = args
        _body = body
    }
    
    public func emit(pos: Pos, args: [Form]) throws {
        if args.count < _args.0 || (_args.1 != -1 && args.count > _args.1) {
            throw CompileError(pos, "Wrong number of arguments: \(_name)")
        }
            
        try _body(pos, args)
    }
        
    private let _env: Env
    private let _name: String
    private let _args: (Int, Int)
    private let _pos: Pos
    private let _body: Body
}
