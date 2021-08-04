import Foundation

func isSpace(_ c: Character) -> Bool {
    return c == " " || c == "\n" || c == "\t"
}

public class SpaceParser: Parser {
    public func readForm(_ input: inout String, root: RootParser) throws -> Form? {
        input = String(input.reversed())
        defer { input = String(input.reversed()) }
        
        while let c = input.popLast() {
            switch c {
            case " ", "\t":
                root.pos.next()
            case "\n":
                root.pos.newline()
            default:
                return nil
            }
        }
        
        return nil
    }
}
