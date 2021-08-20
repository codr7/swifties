import Foundation

public func intReader(_ p: Parser) throws -> Form? {
    let fpos = p.pos
    var v = 0
    var neg = false
    
    let c = p.getc()
    if c == nil { return nil }
    
    if c == "-" {
        if let c = p.getc() {
            if c.isNumber {
                neg = true
            } else {
                p.ungetc(c)
                p.ungetc("-")
            }
        }
    } else {
        p.ungetc(c!)
    }
    
    while let c = p.getc() {
        if !c.isNumber {
            p.ungetc(c)
            break
        }
            
        v *= 10
        v += c.hexDigitValue!
        p.nextColumn()
    }
        
    return (p.pos == fpos) ? nil : LiteralForm(env: p.env, pos: p.pos, p.env.coreLib!.intType, neg ? -v : v)
}
