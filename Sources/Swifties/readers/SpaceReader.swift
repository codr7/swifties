import Foundation

public let spaceReader = SpaceReader()

public class SpaceReader: Reader {
    @discardableResult
    public func readForm(_ p: Parser) throws -> Form? {
        while let c = p.getc() {
            if c.isNewline {
                p.newLine()
            } else if c.isWhitespace {
                p.nextColumn()
            } else {
                return nil
            }
        }
        
        return nil
    }
}
