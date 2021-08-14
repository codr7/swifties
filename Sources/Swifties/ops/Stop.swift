import Foundation

public let STOP = Stop()

open class Stop: Op {
    open func eval() -> Pc { STOP_PC }
}
