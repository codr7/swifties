import Foundation

let ID_STOPS: Set<Character> = ["(", ")", "[", "]", ":", ".", "'", ","]

public func idReader(p: Parser) -> Form? {
    let fpos = p.pos
    var out = ""
        
    while let c = p.getc() {
        if c.isWhitespace || ID_STOPS.contains(c) {
            p.ungetc(c)
            break
        }
            
        out.append(c)
        p.nextColumn()
    }
        
    return (out.count == 0) ? nil : IdForm(env: p.env, pos: fpos, name: out)
}
