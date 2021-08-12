import Foundation

public protocol Reader {
    func readForm(_ p: Parser) throws -> Form?
}

public class Parser {
    public var env: Env { _env }
    public var input: String { _input }
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
    public func ungetc(_ c: Character) { _input.append(c) }
    
    public func readForm() throws -> Bool {
        for r in _readers {
            if let f = try r.readForm(self) {
                _forms.append(f)
                return true
            }
        }
  
        return false
    }

    public func popForm() -> Form? { _forms.popLast() }
    
    public func slurp(_ input: String) throws {
        _input = String(input.reversed()) + _input
        let (inputCopy, posCopy, formsCopy) = (_input, _pos, _forms)

        do {
            while try readForm() {}
        } catch let e {
            _input = inputCopy
            _pos = posCopy
            _forms = formsCopy
            throw e
        }
    }
    
    public func nextColumn() { _pos.nextColumn() }
    public func newLine() { _pos.newLine() }
        
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
