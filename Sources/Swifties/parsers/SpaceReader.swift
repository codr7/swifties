import Foundation

public let spaceReader = SpaceReader()

public class SpaceReader: Reader {
    public func readForm(_ input: inout String, root: Parser) throws -> Form? {
        input = String(input.reversed())
        defer { input = String(input.reversed()) }
        
        while let c = input.popLast() {
            switch c {
            case " ", "\t":
                root.pos.next()
            case "\n":
                root.pos.newline()
            default:
                return nil
            }
        }
        
        return nil
    }
}
