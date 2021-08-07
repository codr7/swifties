import Foundation

public protocol Op {
    func prepare()
    func eval() throws
}
