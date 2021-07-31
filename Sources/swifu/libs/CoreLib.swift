import Foundation

class CoreLib: Lib {
    lazy var intType: IntType = def(IntType(env: env, pos: pos, name: "Int"))
    lazy var metaType: MetaType = def(MetaType(env: env, pos: pos, name: "Meta"))
}
