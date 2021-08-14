import Foundation

open class Goto: Op {
    public init(pc: Pc) { _pc = pc }
    
    open func eval() throws -> Pc { _pc }
    
    private let _pc: Pc
}
