import Foundation

class FuncType: Type<Func> {
    override init(_ lib: Lib, pos: Pos, name: String, parentTypes: [AnyType]) {
        super.init(lib, pos: pos, name: name, parentTypes: parentTypes)
        
        callValue = {target, pos, check -> Pc? in
            let f = target as! Func
            
            if check && !f.isApplicable() {
                throw NotApplicable(pos: pos, target: f, stack: self.env.stack)
            }
            
            return f.call(pos: pos)
        }
    }
}

