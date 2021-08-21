import Foundation

public func quoteReader(_ p: Parser) throws -> Form? {
    let fpos = p.pos
    
    if let c = p.getc() {
        if c == "'" {
            p.nextColumn()
            
            if try p.readForm() {
                if let f = p.popForm() {
                    return QuoteForm(env: p.env, pos: fpos, form: f)
                }
            }
        }
        
        p.ungetc(c)
    }

    return nil
}
