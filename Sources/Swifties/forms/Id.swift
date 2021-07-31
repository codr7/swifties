import Foundation

class Id: BaseForm, Form {
    init(env: Env, pos: Pos, name: String) {
        _name = name
        super.init(env: env, pos: pos)
    }
    
    func emit() {
        if let found = env.scope!.find(self._name) {
            if found.type == env.coreLib!.registerType {
                env.emit(Load(env: env, pc: env.pc, index: found.value as! Int))
            } else {
                env.emit(Push(pc: env.pc, found))
            }
        }
    }
    
    let _name: String
}
