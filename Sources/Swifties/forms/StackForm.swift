import Foundation

public class StackForm: Form {
    public var items: [Form] { _items }
    
    public init(env: Env, pos: Pos, items: [Form]) {
        _items = items
        super.init(env: env, pos: pos)
    }
    
    public override func expand() throws -> Form {
        let newItems = try _items.map {it in try it.expand()}
        if newItems != _items { return try StackForm(env: env, pos: pos, items: newItems).expand() }
        return self
    }

    public override func emit() throws {
        env.emit(Push(pc: env.pc, env.coreLib!.stackType, Stack()))
        
        for it in _items {
            try it.emit()
            env.emit(PushDown(env: env, pos: pos, pc: env.pc))
        }
    }

    private let _items: [Form]
}