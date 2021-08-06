import Foundation

public let intReader = IntReader()

public class IntReader: Reader {
    @discardableResult
    public func readForm(_ p: Parser) throws -> Form? {
        var (v, m) = (0, 1)
        
        while let c = p.getc() {
            if !c.isNumber {
                p.ungetc(c)
                break
            }
            
            v *= m
            v += c.hexDigitValue!
            m *= 10
        }
        
        return LiteralForm(env: p.env, pos: p.pos, p.env.coreLib!.intType, v)
    }
}
