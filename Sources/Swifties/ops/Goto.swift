import Foundation

public struct Goto: Op {
    public init(pc: Pc) { _pc = pc }
    public func eval() throws -> Pc { _pc }
    private let _pc: Pc
}
