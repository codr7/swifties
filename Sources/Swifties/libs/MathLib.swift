import Foundation

public class MathLib: Lib {
    public override init(env: Env, pos: Pos) {
        super.init(env: env, pos: pos)
    }
    
    public func plusInt(pos: Pos, self: Func, retPc: Pc) throws -> Pc {
        let y = env.pop()!
        let x = env.peek()!
        env.poke(offset: 0, env.coreLib!.intType, (x.value as! Int) + (y.value as! Int))
        return retPc
    }
    
    public func minusInt(pos: Pos, self: Func, retPc: Pc) throws -> Pc {
        let y = env.pop()!
        let x = env.peek()!
        env.poke(offset: 0, env.coreLib!.intType, (x.value as! Int) - (y.value as! Int))
        return retPc
    }

    public func ltInt(pos: Pos, self: Func, retPc: Pc) throws -> Pc {
        let y = env.pop()!
        let x = env.peek()!
        env.poke(offset: 0, env.coreLib!.boolType, (x.value as! Int) < (y.value as! Int))
        return retPc
    }

    public func gtInt(pos: Pos, self: Func, retPc: Pc) throws -> Pc {
        let y = env.pop()!
        let x = env.peek()!
        env.poke(offset: 0, env.coreLib!.boolType, (x.value as! Int) > (y.value as! Int))
        return retPc
    }

    public override func bind(pos: Pos, _ names: [String]) throws {
        define(Func(env: env, pos: self.pos, name: "+", args: [env.coreLib!.intType, env.coreLib!.intType], rets: [env.coreLib!.intType], self.plusInt))
        define(Func(env: env, pos: self.pos, name: "-", args: [env.coreLib!.intType, env.coreLib!.intType], rets: [env.coreLib!.intType], self.minusInt))

        define(Func(env: env, pos: self.pos, name: "<", args: [env.coreLib!.intType, env.coreLib!.intType], rets: [env.coreLib!.boolType], self.ltInt))
        define(Func(env: env, pos: self.pos, name: ">", args: [env.coreLib!.intType, env.coreLib!.intType], rets: [env.coreLib!.boolType], self.gtInt))

        try super.bind(pos: pos, names)
    }
}
