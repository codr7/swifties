import Foundation

public func idReader (_ cs: Character...) -> Reader {
    let stops = Set<Character>(cs)
    
    return {p in
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
