import Foundation

public typealias Frames = [Frame]
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
    public func openScope() -> Scope {
        _scope = Scope(env: self, outer: _scope)
        return _scope!
    }
    
    public func closeScope() {
        precondition(_scope != nil, "No open scopes")
        
        let s = _scope!
        _scope = s.outer
        
        if (_registers.count < s.registerCount) {
            _registers += Array(repeating: nil, count: s.registerCount - _registers.count)
        }
    }

    @discardableResult
    public func pushFrame(pos: Pos, _func: Func, startPc: Pc, retPc: Pc) -> Frame {
        let f = Frame(env: self, pos: pos, _func: _func, startPc: startPc, retPc: retPc)
        _frames.append(f)
        return f
    }

    public func peekFrame() -> Frame? {
        return (_frames.count == 0) ? nil : _frames.last
    }
    
    public func popFrame(pos: Pos) throws -> Pc {
        if _frames.count == 0 { throw EvalError(pos, "No calls in progress") }
        return try _frames.popLast()!.restore()
    }

    @discardableResult
    public func initCoreLib(pos: Pos) throws -> CoreLib {
        if _coreLib == nil {
            _coreLib = CoreLib(env: self, pos: pos)
        }
        
        return _coreLib!
    }

    public func nextTypeId() -> TypeId {
        let id = _nextTypeId
        _nextTypeId += 1
        return id
    }
    
    @discardableResult
    public func emit(_ op: Op, index: Int? = nil) -> Pc {
        if let i = index {
            _ops[i] = op
            return i
        }

        _ops.append(op)
        return _ops.count-1
    }

    public func push(_ slots: Slot...) { push(slots) }

    public func push(_ slots: [Slot]) {
        for s in slots { _stack.append(s) }
    }

    public func push<T>(_ type: Type<T>, _ value: T) { push(Slot(type, value)) }

    public func peek(offset: Int = 0) -> Slot? {
        if offset >= _stack.count { return nil }
        return _stack[_stack.count - offset - 1]
    }
    
    @discardableResult
    public func poke<T>(_ type: Type<T>, _ value: T, offset: Int = 0) -> Bool {
        if offset >= _stack.count {
            return false
        }
        
        _stack[_stack.count - offset - 1] = Slot(type, value)
        return true
    }
    
    @discardableResult
    public func pop() -> Slot? { _stack.popLast() }

    public func reset() { _stack.removeAll() }
    
    public func load(pos: Pos, index i: Register) throws {
        let v = _registers[i]
        if v == nil { throw EvalError(pos, "Missing value for register: \(i)") }
        push(v!)
    }
    
    public func store(pos: Pos, index i: Register) throws {
        let v = pop()
        if v == nil { throw EvalError(pos, "Missing value to store: \(i)") }
        _registers[i] = v!
    }
    
    public func eval(pc: Pc) throws {
        var nextPc = pc
        while nextPc != STOP_PC { nextPc = try _ops[nextPc].eval() }
    }
    
    public func suspend(pc: Pc) -> Cont { Cont(env: self, pc: pc) }
        
    var _scope: Scope?
    var _stack: Stack = []
    var _registers: Registers = []
    var _frames: Frames = []
    
    private var _nextTypeId: TypeId = 1
    private var _coreLib: CoreLib?
    private var _ops: [Op] = []
}
