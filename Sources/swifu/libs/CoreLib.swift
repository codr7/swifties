import Foundation

class CoreLib {
    let intType: IntType
    let metaType: MetaType

    init(context: Context, pos: Pos) {
        intType = IntType(context: context, pos: pos, name: "Int")
        metaType = MetaType(context: context, pos: pos, name: "Meta")
    }
}
