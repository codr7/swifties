import Foundation

func isSpace(_ c: Character) -> Bool {
    return c == " " || c == "\n" || c == "\t"
}

class IdParser: Parser {
    func readForm(_ input: inout String, root: RootParser) throws -> Form? {
        var out: String = ""
        input = String(input.reversed())
        defer { input = String(input.reversed()) }
        
        while let c = input.popLast() {
            if isSpace(c) || c == "(" || c == ")" {
                input.append(c)
                break
            }
            
            out.append(c)
        }
        
        return out.count == 0 ? nil : IdForm(env: root.env, pos: root.pos, name: out)
    }
}
