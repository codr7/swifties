import Foundation

class CoreLib: Lib {
    lazy var anyType = AnyType(env: env, pos: pos, name: "Any", parentTypes: [])

    lazy var funcType: FuncType = FuncType(env: env, pos: pos, name: "Func", parentTypes: [anyType])
    lazy var intType: IntType = IntType(env: env, pos: pos, name: "Int", parentTypes: [anyType])
    lazy var macroType: MacroType = MacroType(env: env, pos: pos, name: "Meta", parentTypes: [anyType])
    lazy var metaType: MetaType = MetaType(env: env, pos: pos, name: "Meta", parentTypes: [anyType])
    lazy var primType: PrimType = PrimType(env: env, pos: pos, name: "Prim", parentTypes: [anyType])
    lazy var registerType: RegisterType = RegisterType(env: env, pos: pos, name: "Register", parentTypes: [anyType])
}
