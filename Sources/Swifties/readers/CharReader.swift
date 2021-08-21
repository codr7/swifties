import Foundation

public func charReader(p: Parser) throws -> Form? {
    let fpos = p.pos
    var c = p.getc()
        
    if c != "\\" {
        if c != nil { p.ungetc(c!) }
        return nil
    }
    
    p.nextColumn()
    c = p.getc()
    if c == nil { throw ReadError(p.pos, "Invalid char literal") }
    p.nextColumn()
    return LiteralForm(env: p.env, pos: fpos, p.env.coreLib!.charType, c!)
}
