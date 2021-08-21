import Foundation

public func spliceReader(_ p: Parser) throws -> Form? {
    let fpos = p.pos
    
    if let c = p.getc() {
        if c == "," {
            p.nextColumn()
            
            if try p.readForm() {
                if let f = p.popForm() {
                    return SpliceForm(env: p.env, pos: fpos, form: f)
                }
            }
        }
        
        p.ungetc(c)
    }

    return nil
}
