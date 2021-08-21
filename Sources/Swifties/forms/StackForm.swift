import Foundation

open class StackForm: Form {
    open var items: Forms { _items }
    
    public init(env: Env, pos: Pos, items: Forms) {
        _items = items
        super.init(env: env, pos: pos)
    }
    
    open override func dump() -> String { "[\(_items.dump())]" }

    open override func expand() throws -> Form {
        let newItems = try _items.map {it in try it.expand()}
        if newItems != _items { return try StackForm(env: env, pos: pos, items: newItems).expand() }
        return self
    }

    open override func emit() throws {
        env.emit(Push(pc: env.pc, env.coreLib!.stackType, Stack()))
        
        for it in _items {
            try it.emit()
            env.emit(PushDown(env: env, pos: pos, pc: env.pc))
        }
    }

    open override func quote2() throws -> Slot {
        var v: Stack = []
        for f in _items { v.append(try f.quote2()) }
        return Slot(env.coreLib!.stackType, v)
    }
    
    open override func quote1() throws -> Form {
        for i in 0..<_items.count { _items[i] = try _items[i].quote1() }
        return self
    }
    
    private var _items: Forms
}
