import Foundation

public func pairReader(_ p: Parser) throws -> Form? {
    let c = p.getc()
        
    if c != ":" {
        if c != nil { p.ungetc(c!) }
        return nil
    }
        
    p.nextColumn()
    let left = p.popForm()
    if left == nil { throw ReadError(p.pos, "Missing left value"); }
    if !(try p.readForm()) { throw ReadError(p.pos, "Missing right value")}
    let right = p.popForm()
    
    return PairForm(env: p.env, pos: left!.pos, (left!, right!))
}
