import Foundation

struct Stop: Op {
    func eval() throws -> Pc { STOP_PC }
}

let STOP = Stop()
