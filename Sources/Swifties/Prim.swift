import Foundation

public class Prim: Definition {
    public typealias Body = (_ pos: Pos, _ args: [Form]) throws -> Void

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
            throw EmitError(pos, "Wrong number of arguments: \(_name)")
        }
            
        try _body(pos, args)
    }
        
    public func dump() -> String { "Prim\(_name)" }
    
    private let _env: Env
    private let _name: String
    private let _args: (Int, Int)
    private let _pos: Pos
    private let _body: Body
}
