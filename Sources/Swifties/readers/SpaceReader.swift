import Foundation

@discardableResult
public func spaceReader(_ p: Parser) throws -> Form? {
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
