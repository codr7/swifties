import Foundation

open class Multi {
    open var name: String { _name }
    
    public init(env: Env, name: String) {
        _env = env
        _name = name
    }
    
    open func addFunc(_ f: Func) {
        precondition(f.name == _name, "Wrong func name: \(f.name)")
        let i = _funcs.firstIndex(where: {g in f.weight < g.weight})
        _funcs.insert(f, at: i ?? 0)
    }
    
    open func dump() -> String { "Multi\(_name)" }
    
    open func call(pos: Pos, ret: Pc) throws -> Pc {
        for f in _funcs {
            if f.isApplicable() { return try f.call(pos: pos, ret: ret) }
        }
        
        throw MultiNotApplicable(pos: pos, target: self, stack: _env._stack)
    }
    
    private let _env: Env
    private let _name: String
    private var _funcs: [Func] = []
}
