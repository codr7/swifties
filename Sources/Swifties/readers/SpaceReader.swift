import Foundation

public let spaceReader = SpaceReader()

public class SpaceReader: Reader {
    public func readForm(_ input: inout String, root: Parser) throws -> Form? {        
        while let c = input.popLast() {
            switch c {
            case " ", "\t":
                root.nextColumn()
            case "\n":
                root.newLine()
            default:
                return nil
            }
        }
        
        return nil
    }
}
