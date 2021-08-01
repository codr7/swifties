import Foundation

typealias Pc = Int

let STOP_PC: Pc = -1

typealias Register = Int
typealias TypeId = UInt

typealias Stack = [Slot]

class Env {
    static func == (lhs: Env, rhs: Env) -> Bool { lhs === rhs }
    
    var coreLib: CoreLib? { _coreLib }
    var pc: Pc { _ops.count }
    var scope: Scope? { _scope }
    var stack: Stack { _stack }
    
    @discardableResult
    func beginScope() -> Scope {
        _scope = Scope(env: self, outer: _scope)
        return _scope!
    }
    
    func endScope(pos: Pos) throws -> Scope {
        if _scope == nil {
            throw CompileError(pos, "No open scopes")
        }
        
        let s = _scope!
        _scope = s.outer
        
        if (_registers.count < s.registerCount) {
            _registers += Array(repeating: nil, count: s.registerCount - _registers.count)
        }
        
        return s
    }

    func initCoreLib(_ pos: Pos) throws {
        if _coreLib == nil {
            _coreLib = CoreLib(env: self, pos: pos)
        }
    }

    func nextTypeId() -> TypeId {
        let id = _nextTypeId
        _nextTypeId += 1
        return id
    }
    
    func emit(_ op: Op) {
        _ops.append(op)
    }
        
    func push(_ slot: Slot) {
        _stack.append(slot)
    }

    func push<T>(_ type: Type<T>, _ value: T) {
        push(Slot(type, value))
    }

    func peek(offset: Int = 0) -> Slot? {
        if offset >= _stack.count {
            return nil
        }
        
        if offset == 0 {
            return _stack.last
        }
        
        return _stack[_stack.count - offset - 1]
    }
    
    func pop() -> Slot? {
        _stack.popLast()
    }

    func load(index i: Register) -> Slot? {
        _registers[i]
    }
    
    func store(index i: Register, slot: Slot) {
        _registers[i] = slot
    }
    
    func eval(pc: Pc) throws {
        var nextPc = pc
        
        while nextPc != STOP_PC {
            nextPc = try _ops[nextPc].eval()
        }
    }
    
    private var _nextTypeId: TypeId = 1
    private var _coreLib: CoreLib?
    private var _ops: [Op] = []
    private var _scope: Scope?
    private var _stack: Stack = []
    private var _registers: [Slot?] = []
}
