import Foundation

public class MathLib: Lib {
    public override init(env: Env, pos: Pos) { super.init(env: env, pos: pos) }

    public func minusOne(pos: Pos, self: Func, ret: Op) throws {
        env.poke(env.coreLib!.intType, (env.peek()!.value as! Int)-1, offset: 0)
        try ret.eval()
    }

    public func minusTwo(pos: Pos, self: Func, ret: Op) throws {
        env.poke(env.coreLib!.intType, (env.peek()!.value as! Int)-2, offset: 0)
        try ret.eval()
    }

    public func plusInt(pos: Pos, self: Func, ret: Op) throws {
        let y = env.pop()!
        let x = env.peek()!
        env.poke(env.coreLib!.intType, (x.value as! Int) + (y.value as! Int), offset: 0)
        try ret.eval()
    }
    
    public func minusInt(pos: Pos, self: Func, ret: Op) throws {
        let y = env.pop()!
        let x = env.peek()!
        env.poke(env.coreLib!.intType, (x.value as! Int) - (y.value as! Int), offset: 0)
        try ret.eval()
    }

    public func ltInt(pos: Pos, self: Func, ret: Op) throws {
        let y = env.pop()!
        let x = env.peek()!
        env.poke(env.coreLib!.boolType, (x.value as! Int) < (y.value as! Int), offset: 0)
        try ret.eval()
    }

    public func gtInt(pos: Pos, self: Func, ret: Op) throws {
        let y = env.pop()!
        let x = env.peek()!
        env.poke(env.coreLib!.boolType, (x.value as! Int) > (y.value as! Int), offset: 0)
        try ret.eval()
    }

    public override func bind(pos: Pos, _ names: [String]) throws {
        define(Func(env: env, pos: self.pos, name: "-1", args: [env.coreLib!.intType], rets: [env.coreLib!.intType], self.minusOne))
        define(Func(env: env, pos: self.pos, name: "-2", args: [env.coreLib!.intType], rets: [env.coreLib!.intType], self.minusTwo))

        define(Func(env: env, pos: self.pos, name: "+", args: [env.coreLib!.intType, env.coreLib!.intType], rets: [env.coreLib!.intType], self.plusInt))
        define(Func(env: env, pos: self.pos, name: "-", args: [env.coreLib!.intType, env.coreLib!.intType], rets: [env.coreLib!.intType], self.minusInt))

        define(Func(env: env, pos: self.pos, name: "<", args: [env.coreLib!.intType, env.coreLib!.intType], rets: [env.coreLib!.boolType], self.ltInt))
        define(Func(env: env, pos: self.pos, name: ">", args: [env.coreLib!.intType, env.coreLib!.intType], rets: [env.coreLib!.boolType], self.gtInt))

        try super.bind(pos: pos, names)
    }
}
