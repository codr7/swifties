import Foundation

public func idReader (stops: Set<Character>) -> Reader {
    {p in
        let fpos = p.pos
        var out = ""
        
        while let c = p.getc() {
            if c.isWhitespace || stops.contains(c) {
                p.ungetc(c)
                break
            }
            
            out.append(c)
            p.nextColumn()
        }
        
        return (out.count == 0) ? nil : IdForm(env: p.env, pos: fpos, name: out)
    }
}
