import Foundation

public let intReader = IntReader()

public class IntReader: Reader {
    @discardableResult
    public func readForm(_ p: Parser) throws -> Form? {
        let fpos = p.pos
        var v = 0
        
        while let c = p.getc() {
            if !c.isNumber {
                p.ungetc(c)
                break
            }
            
            v *= 10
            v += c.hexDigitValue!
            p.nextColumn()
        }
        
        return (p.pos == fpos) ? nil : LiteralForm(env: p.env, pos: p.pos, p.env.coreLib!.intType, v)
    }
}
