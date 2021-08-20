import Foundation

open class MathLib: Lib {
    public override init(env: Env, pos: Pos) { super.init(env: env, pos: pos) }

    open func plusOne(pos: Pos, self: Func, ret: Pc) throws -> Pc {
        try env.poke(pos: pos, env.coreLib!.intType, (env.peek(pos: pos).value as! Int)+1, offset: 0)
        return ret
    }
    
    open func minusOne(pos: Pos, self: Func, ret: Pc) throws -> Pc {
        try env.poke(pos: pos, env.coreLib!.intType, (env.peek(pos: pos).value as! Int)-1, offset: 0)
        return ret
    }

    open func plusInt(pos: Pos, self: Func, ret: Pc) throws -> Pc {
        let y = try env.pop(pos: pos)
        let x = try env.peek(pos: pos)
        try env.poke(pos: pos, env.coreLib!.intType, (x.value as! Int) + (y.value as! Int), offset: 0)
        return ret
    }
    
    open func minusInt(pos: Pos, self: Func, ret: Pc) throws -> Pc {
        let y = try env.pop(pos: pos)
        let x = try env.peek(pos: pos)
        try env.poke(pos: pos, env.coreLib!.intType, (x.value as! Int) - (y.value as! Int), offset: 0)
        return ret
    }

    open func ltInt(pos: Pos, self: Func, ret: Pc) throws -> Pc {
        let y = try env.pop(pos: pos)
        let x = try env.peek(pos: pos)
        try env.poke(pos: pos, env.coreLib!.boolType, (x.value as! Int) < (y.value as! Int), offset: 0)
        return ret
    }

    open func gtInt(pos: Pos, self: Func, ret: Pc) throws -> Pc {
        let y = try env.pop(pos: pos)
        let x = try env.peek(pos: pos)
        try env.poke(pos: pos, env.coreLib!.boolType, (x.value as! Int) > (y.value as! Int), offset: 0)
        return ret
    }

    open override func bind(pos: Pos, _ names: [String]) throws {
        define(Func(env: env, pos: self.pos, name: "++", args: [("val", env.coreLib!.intType)], rets: [env.coreLib!.intType], self.plusOne))
        define(Func(env: env, pos: self.pos, name: "--", args: [("val", env.coreLib!.intType)], rets: [env.coreLib!.intType], self.minusOne))

        define(Func(env: env, pos: self.pos, name: "+",
                    args: [("lhs", env.coreLib!.intType), ("rhs", env.coreLib!.intType)],
                    rets: [env.coreLib!.intType],
                    self.plusInt))
        
        define(Func(env: env, pos: self.pos, name: "-",
                    args: [("lhs", env.coreLib!.intType), ("rhs", env.coreLib!.intType)],
                    rets: [env.coreLib!.intType],
                    self.minusInt))

        define(Func(env: env, pos: self.pos, name: "<",
                    args: [("lhs", env.coreLib!.intType), ("rhs", env.coreLib!.intType)],
                    rets: [env.coreLib!.boolType],
                    self.ltInt))
        
        define(Func(env: env, pos: self.pos, name: ">",
                    args: [("lhs", env.coreLib!.intType), ("rhs", env.coreLib!.intType)],
                    rets: [env.coreLib!.boolType],
                    self.gtInt))

        try super.bind(pos: pos, names)
    }
}
