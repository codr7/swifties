import Foundation

struct Stop: Op {
    func eval() throws -> Pc {
        return STOP_PC
    }
}

let STOP = Stop()
