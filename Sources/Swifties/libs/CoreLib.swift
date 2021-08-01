import Foundation

public class CoreLib: Lib {
    public let anyType: AnyType

    public let funcType: FuncType
    public let intType: IntType
    public let macroType: MacroType
    public let metaType: MetaType
    public let primType: PrimType
    public let registerType: RegisterType
    public let stackType: StackType

    public override init(env: Env, pos: Pos) {
        anyType = AnyType(env, pos: pos, name: "Any", parentTypes: [])

        funcType = FuncType(env, pos: pos, name: "Func", parentTypes: [anyType])
        intType = IntType(env, pos: pos, name: "Int", parentTypes: [anyType])
        macroType = MacroType(env, pos: pos, name: "Meta", parentTypes: [anyType])
        metaType = MetaType(env, pos: pos, name: "Meta", parentTypes: [anyType])
        primType = PrimType(env, pos: pos, name: "Prim", parentTypes: [anyType])
        registerType = RegisterType(env, pos: pos, name: "Register", parentTypes: [anyType])
        stackType = StackType(env, pos: pos, name: "Stack", parentTypes: [anyType])

        super.init(env: env, pos: pos)
    }
    
    public func stack(pos: Pos) -> Pc? {
        env.push(env.coreLib!.stackType, env.stack)
        return nil
    }
    
    public override func bind(pos: Pos, _ names: [String]) throws {
        define(anyType, funcType, intType, macroType, metaType, primType, registerType, stackType)
        
        define(Func(env: env, pos: self.pos, name: "stack", args: [], rets: [stackType], self.stack))
        
        try super.bind(pos: pos, names)
    }
}
