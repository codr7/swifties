import Atomics
import Foundation

typealias Pc = Int

let STOP_PC: Pc = -1

class Env: Hashable {
    static let nextId = ManagedAtomic<Int>(1)

    static func == (lhs: Env, rhs: Env) -> Bool {
        return lhs._id == rhs._id
    }
    
    public var coreLib: CoreLib? { _coreLib }
    var pc: Pc { _ops.count }
    public var scope: Scope? { _scope }
    
    let _id = nextId.loadThenWrappingIncrement(ordering: AtomicUpdateOrdering.relaxed)
    var _nextTypeId = 1
    var _coreLib: CoreLib?
    var _ops: [Op] = []
    var _scope: Scope?
    var _stack: [Slot] = []
    var _registers: [Slot?] = []
    
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
    
    func getNextTypeId() -> Int {
        let id = _nextTypeId
        _nextTypeId += 1
        return id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
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

    func eval(pc: Pc) {
        var nextPc = pc
        
        while nextPc != STOP_PC {
            nextPc = _ops[nextPc].eval()
        }
    }
}
