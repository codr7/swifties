import Foundation

public let STOP = Stop()

open class Stop: Op {
    open func prepare() {}
    open func eval() {}
}
