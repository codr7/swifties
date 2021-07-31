import Foundation

class FuncType: Type<Func> {
    override init(env: Env, pos: Pos, name: String) {
        super.init(env: env, pos: pos, name: name)
        
        callValue = {(target: Any, pos: Pos, check: Bool) -> Pc? in
            let f = target as! Func
            if check && !f.isApplicable() {
                throw NotApplicable(pos: pos, target: f, stack: env.stack)
            }
            return f.call(pos: pos)
        }
    }
}

