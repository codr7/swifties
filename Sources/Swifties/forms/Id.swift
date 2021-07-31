//
//  File.swift
//  
//
//  Created by Andreas Nilsson on 2021-07-31.
//

import Foundation

class Id: BaseForm, Form {
    init(env: Env, pos: Pos, name: String) {
        _name = name
        super.init(env: env, pos: pos)
    }
    
    func emit() {
        if let found = env.scope!.find(self._name) {
            env.emit(Push(pc: env.pc, slot: found))
        }
    }
    
    let _name: String
}
