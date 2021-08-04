import Foundation

public typealias Pc = Int
public typealias Register = Int
public typealias Registers = [Slot?]
public typealias TypeId = UInt
public typealias Stack = [Slot]

public let STOP_PC: Pc = -1
public let SWIFTIES_VERSION = 1

public class Env {
    public static func == (lhs: Env, rhs: Env) -> Bool { lhs === rhs }
    
    public var coreLib: CoreLib? { _coreLib }
    public var pc: Pc { _ops.count }
    public var scope: Scope? { _scope }
    public var stack: Stack { _stack }
    public var registers: Registers { _registers }
    
    public init() {}
    
    @discardableResult
    public func beginScope() -> Scope {
        _scope = Scope(env: self, outer: _scope)
        return _scope!
    }
    
    @discardableResult
    public func endScope() -> Scope {
        precondition(_scope != nil, "No open scopes")
        
        let s = _scope!
        _scope = s.outer
        
        if (_registers.count < s.registerCount) {
            _registers += Array(repeating: nil, count: s.registerCount - _registers.count)
        }
        
        return s
    }

    public func initCoreLib(pos: Pos) throws {
        if _coreLib == nil {
            _coreLib = CoreLib(env: self, pos: pos)
        }
    }

    public func nextTypeId() -> TypeId {
        let id = _nextTypeId
        _nextTypeId += 1
        return id
    }
    
    @discardableResult
    public func emit(_ op: Op) -> Op {
        _ops.append(op)
        return op
    }

    public func push(_ slots: Slot...) { push(slots) }

    public func push(_ slots: [Slot]) {
        for s in slots { _stack.append(s) }
    }

    public func push<T>(_ type: Type<T>, _ value: T) {
        push(Slot(type, value))
    }

    public func peek(offset: Int = 0) -> Slot? {
        if offset >= _stack.count {
            return nil
        }
        
        return _stack[_stack.count - offset - 1]
    }
    
    @discardableResult
    public func poke<T>(offset: Int, _ type: Type<T>, _ value: T) -> Bool {
        if offset >= _stack.count {
            return false
        }
        
        _stack[_stack.count - offset - 1] = Slot(type, value)
        return true
    }
    
    @discardableResult
    public func pop() -> Slot? {
        _stack.popLast()
    }

    public func reset() {
        _stack.removeAll()
    }
    
    public func load(index i: Register) -> Slot? {
        _registers[i]
    }
    
    public func store(index i: Register, slot: Slot) {
        _registers[i] = slot
    }
    
    public func eval(pc: Pc) throws {
        var nextPc = pc
        
        while nextPc != STOP_PC {
            nextPc = try _ops[nextPc].eval()
        }
    }
    
    public func suspend(pc: Pc) -> Cont {
        Cont(scope: _scope, stack: _stack, registers: _registers, pc: pc)
    }
    
    public func restore(cont: Cont) {
        _scope = cont.scope
        _stack = cont.stack
        _registers = cont.registers
    }
    
    private var _nextTypeId: TypeId = 1
    private var _coreLib: CoreLib?
    private var _ops: [Op] = []
    private var _scope: Scope?
    private var _stack: Stack = []
    private var _registers: Registers = []
}
