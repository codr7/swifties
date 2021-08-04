import Foundation

public protocol Reader {
    func readForm(_ input: inout String, root: Parser) throws -> Form?
}

public class Parser: Reader {
    public var pos: Pos { _pos }
    public var forms: [Form] { _forms }
    
    public convenience init(env: Env, source: String, _ readers: Reader...) {
        self.init(env: env, source: source, readers: readers)
    }
    
    public init(env: Env, source: String, readers: [Reader]) {
        _env = env
        _pos = Pos(source)
        _readers = readers
    }

    public func readForm(_ input: inout String, root: Parser) throws -> Form? {
        for r in _readers {
            if let f = try r.readForm(&input, root: self) { return f }
        }
        
        return nil
    }

    public func read(_ input: inout String) throws {
        input = String(input.reversed())
        defer { input = String(input.reversed()) }

        while let f = try readForm(&input, root: self) {
            _forms.append(f)
        }
    }
    
    public func nextColumn() {
        _pos.nextColumn()
    }
    
    public func newLine() {
        _pos.newLine()
    }
        
    public func reset() {
        _forms = []
        _pos = Pos(pos.source)
    }
    
    private let _env: Env
    private var _pos: Pos
    private var _readers: [Reader]
    private var _forms: [Form] = []
}
