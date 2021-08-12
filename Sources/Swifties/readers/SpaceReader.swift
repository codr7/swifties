import Foundation

public let spaceReader = SpaceReader()

open class SpaceReader: Reader {
    @discardableResult
    open func readForm(_ p: Parser) throws -> Form? {
        while let c = p.getc() {
            if c.isNewline {
                p.newLine()
            } else if c.isWhitespace {
                p.nextColumn()
            } else {
                p.ungetc(c)
                break
            }
        }
        
        return nil
    }
}
