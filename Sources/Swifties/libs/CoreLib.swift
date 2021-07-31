import Foundation

class CoreLib: Lib {
    lazy var funcType: FuncType = FuncType(env: env, pos: pos, name: "Func")
    lazy var intType: IntType = IntType(env: env, pos: pos, name: "Int")
    lazy var metaType: MetaType = MetaType(env: env, pos: pos, name: "Meta")
    lazy var registerType: RegisterType = RegisterType(env: env, pos: pos, name: "Register")
}
