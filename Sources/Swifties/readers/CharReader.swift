import Foundation

public func charReader(_ pc: Character) -> Reader {
    {p in
        let fpos = p.pos
        var c = p.getc()
        
        if c != pc {
            if c != nil { p.ungetc(c!) }
            return nil
        }
        
        p.nextColumn()
        c = p.getc()
        if c == nil { throw ReadError(p.pos, "Invalid char literal") }
        p.nextColumn()
    
        return LiteralForm(env: p.env, pos: fpos, p.env.coreLib!.charType, c!)
    }
}
