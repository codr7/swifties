import Foundation

class CoreLib: Lib {
    lazy var intType: IntType = IntType(env: env, pos: pos, name: "Int")
    lazy var metaType: MetaType = MetaType(env: env, pos: pos, name: "Meta")
}
