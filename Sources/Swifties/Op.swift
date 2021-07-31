import Foundation

protocol Op {
    func eval() throws -> Pc
}
