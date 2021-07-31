import Foundation

struct Stop: Op {
    func eval() -> Pc {
        return STOP_PC
    }
}

let STOP = Stop()
