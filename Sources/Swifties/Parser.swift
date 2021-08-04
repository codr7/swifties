import Foundation

public protocol Parser {
    func readForm(_ input: inout String, root: RootParser) throws -> Form?
}

public class RootParser: Parser {
    public var env: Env { _env }
    public var pos: Pos
    
    public var forms: [Form] { _forms }
    
    convenience init(env: Env, source: String, links: Parser...) {
        self.init(env: env, source: source, links: links)
    }
    
    init(env: Env, source: String, links: [Parser]) {
        _env = env
        pos = Pos(source)
        _links = links
    }

    public func readForm(_ input: inout String, root: RootParser) throws -> Form? {
        for p in _links {
            if let f = try p.readForm(&input, root: self) { return f }
        }
        
        return nil
    }

    public func read(_ input: inout String) throws {
        while let f = try readForm(&input, root: self) {
            _forms.append(f)
        }
    }
    
    private let _env: Env
    private var _links: [Parser]
    private var _forms: [Form] = []
}
