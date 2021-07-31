import Foundation

typealias Pc = Int

let STOP_PC: Pc = -1

typealias Register = Int
typealias TypeId = UInt

typealias Stack = [Slot]

class Env {
    static func == (lhs: Env, rhs: Env) -> Bool {
        return lhs === rhs
    }
    
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
    
    func pop() -> Slot? {
        return _stack.popLast()
    }

    func load(index i: Register) -> Slot? {
        return _registers[i]
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
    
    var _nextTypeId: TypeId = 1
    var _coreLib: CoreLib?
    var _ops: [Op] = []
    var _scope: Scope?
    var _stack: Stack = []
    var _registers: [Slot?] = []
}
