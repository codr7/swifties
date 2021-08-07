import Foundation

public let STOP = Stop()

public struct Stop: Op {
    public func eval() throws {}
}
