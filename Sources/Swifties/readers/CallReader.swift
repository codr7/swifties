import Foundation

public func callReader(_ p: Parser) throws -> Form? {
    let fpos = p.pos
    var c = p.getc()
        
    if c != "(" {
        if c != nil { p.ungetc(c!) }
        return nil
    }
        
    p.nextColumn()
    if !(try p.readForm()) { throw ReadError(p.pos, "Missing target") }
    var target = p.popForm()!
    var args: [Form] = []

    c = p.getc()
    
    if c == "." {
        args.append(target)
        if !(try p.readForm()) { throw ReadError(p.pos, "Missing target") }
        target = p.popForm()!
    } else if c != nil {
        p.ungetc(c!)
    }
    
    while true {
        try spaceReader(p)
        c = p.getc()
        if c == nil || c == ")" { break }
        p.ungetc(c!)
        if !(try p.readForm()) { break }
        args.append(p.popForm()!)
    }

    if c != ")" { throw ReadError(p.pos, "Open call form: \((c == nil) ? "nil" : String(c!))") }
    p.nextColumn()
    
    return CallForm(env: p.env, pos: fpos, target: target, args: args)
}
