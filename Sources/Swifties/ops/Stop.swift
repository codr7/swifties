import Foundation

public struct Stop: Op {
    public func eval() throws -> Pc { STOP_PC }
}

let STOP = Stop()
