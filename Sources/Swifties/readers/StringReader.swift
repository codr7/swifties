import Foundation

public func stringReader(_ p: Parser) throws -> Form? {
    let fpos = p.pos
    var c = p.getc()
        
    if c != "\"" {
        if c != nil { p.ungetc(c!) }
        return nil
    }
        
    p.nextColumn()
    var chars: [Character] = []

    while true {
        try spaceReader(p)
        c = p.getc()
        if c == nil || c == "\"" { break }
        chars.append(c!)
    }

    if c != "\"" { throw ReadError(p.pos, "Open string: \((c == nil) ? "nil" : String(c!))") }
    p.nextColumn()
    
    return LiteralForm(env: p.env, pos: fpos, p.env.coreLib!.stringType, String(chars))
}
