import Foundation

public typealias Frames = [Frame]
public typealias Ops = [Op]
public typealias Pc = Int
public typealias Register = Int
public typealias Registers = [Slot?]
public typealias Stack = [Slot]
public typealias TypeId = UInt

public let STOP_PC: Pc = -1
public let SWIFTIES_VERSION = 3

open class Env {
    open var coreLib: CoreLib? { _coreLib }
    open var ops: Ops { _ops }
    open var pc: Pc { _ops.count }
    open var scope: Scope? { _scope }
    open var stack: Stack { _stack }
    open var registers: Registers { _registers }
    
    public init() {}
    
    @discardableResult
    open func begin() -> Scope {
        _scope = Scope(env: self, outer: _scope)
        return _scope!
    }
    
    open func end() {
        precondition(_scope != nil, "No open scopes")
        
        let s = _scope!
        _scope = s.outer
    }

    @discardableResult
    open func pushFrame(pos: Pos, _func: Func, scope: Scope, startPc: Pc, ret: Pc) -> Frame {
        let f = Frame(env: self, pos: pos, _func: _func, scope: scope, startPc: startPc, ret: ret)
        _frames.append(f)
        return f
    }

    open func peekFrame() -> Frame? { _frames.last }
    
    open func popFrame(pos: Pos) throws -> Pc {
        if _frames.count == 0 { throw EvalError(pos, "No calls in progress") }
        return try _frames.popLast()!.restore()
    }

    @discardableResult
    open func initCoreLib(pos: Pos) throws -> CoreLib {
        if _coreLib == nil {
            _coreLib = CoreLib(env: self, pos: pos)
        }
        
        return _coreLib!
    }

    open func nextTypeId() -> TypeId {
        let id = _nextTypeId
        _nextTypeId += 1
        return id
    }
    
    @discardableResult
    open func emit(_ op: Op, pc: Int? = nil) -> Pc {
        if let i = pc {
            _ops[i] = op
            return i
        }

        _ops.append(op)
        return _ops.count-1
    }

    open func push(_ slots: Slot...) { push(slots) }

    open func push(_ slots: [Slot]) {
        for s in slots { _stack.append(s) }
    }

    open func push<T>(_ type: Type<T>, _ value: T) { push(Slot(type, value)) }

    open func peek(pos: Pos, offset: Int = 0) throws -> Slot {
        let v = tryPeek(offset: offset)
        if v == nil { throw EvalError(pos, "Stack is empty") }
        return v!
    }
    
    open func tryPeek(offset: Int = 0) -> Slot? {
        if offset >= _stack.count { return nil }
        return _stack[_stack.count - offset - 1]
    }
    
    open func poke<T>(pos: Pos, _ type: Type<T>, _ value: T, offset: Int = 0) throws {
        if offset >= _stack.count { throw EvalError(pos, "Stack is empty") }
        _stack[_stack.count - offset - 1] = Slot(type, value)
    }
    
    @discardableResult
    open func pop(pos: Pos, offset: Int = 0) throws -> Slot {
        if offset >= _stack.count { throw EvalError(pos, "Stack is empty") }
        let v = (offset == 0) ? _stack.popLast() : _stack.remove(at: _stack.count-offset-1)
        return v!
    }

    open func drop(pos: Pos, offset: Int = 0, count: Int = 1) throws {
        if _stack.count < count { throw EvalError(pos, "Stack is empty") }
        if offset == 0 {
            _stack = _stack.dropLast(count)
        } else {
            for _ in 0..<count { _stack.remove(at: offset) }
        }
    }
    
    open func reset() { _stack.removeAll() }
    
    open func load(pos: Pos, index i: Register) throws {
        let v = _registers[i]
        if v == nil { throw EvalError(pos, "Missing value for register: \(i)") }
        push(v!)
    }
    
    open func store(pos: Pos, index i: Register, offset: Int) throws {
        if (_registers.count <= i) { _registers += Array(repeating: nil, count: i-_registers.count+1) }
        _registers[i] = try pop(pos: pos, offset: offset)
    }
    
    open func eval(_ startPc: Pc) throws {
        var pc = startPc
        repeat { try pc = _ops[pc].eval() } while pc != STOP_PC
    }
    
    open func suspend(_ restorePc: Pc) -> Cont { Cont(env: self, restorePc: restorePc) }
        
    open func getType(pos: Pos, _ name: String) throws -> AnyType {
        let found = _scope!.find(name)
        if found == nil { throw EmitError(pos, "Invalid type: \(name)") }
        if found!.type != _coreLib!.metaType { throw EmitError(pos, "Invalid type: \(found!)") }
        return found!.value as! AnyType
    }

    var _scope: Scope?
    var _stack: Stack = []
    var _registers: Registers = []
    var _frames: Frames = []
    
    private var _nextTypeId: TypeId = 1
    private var _coreLib: CoreLib?
    private var _ops: Ops = []
}
