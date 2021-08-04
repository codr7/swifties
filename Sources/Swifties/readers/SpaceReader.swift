import Foundation

public let spaceReader = SpaceReader()

public class SpaceReader: Reader {
    public func readForm(_ p: Parser) throws -> Form? {
        while let c = p.getc() {
            switch c {
            case " ", "\t":
                p.nextColumn()
            case "\n":
                p.newLine()
            default:
                return nil
            }
        }
        
        return nil
    }
}
