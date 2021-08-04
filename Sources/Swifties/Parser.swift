import Foundation

public protocol Reader {
    func readForm(_ p: Parser) throws -> Form?
}

public class Parser: Reader {
    public var env: Env { _env }
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

    public func getc() -> Character? { _input.popLast() }
    
    public func ungetc(_ c: Character) {
        _input.append(c)
    }
    
    public func readForm(_ p: Parser) throws -> Form? {
        for r in _readers {
            if let f = try r.readForm(self) { return f }
        }
        
        return nil
    }

    public func slurp(_ input: String) throws {
        _input = String(input.reversed()) + _input

        while let f = try readForm(self) {
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
    private var _input: String = ""
    private var _pos: Pos
    private var _readers: [Reader]
    private var _forms: [Form] = []
}
