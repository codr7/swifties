import Foundation

public protocol Reader {
    func readForm(_ p: Parser) throws -> Form?
}

open class Parser {
    open var env: Env { _env }
    open var input: String { _input }
    open var pos: Pos { _pos }
    open var forms: [Form] { _forms }
    
    public init(env: Env, source: String, prefix: [Reader], suffix: [Reader]) {
        _env = env
        _pos = Pos(source)
        _prefix = prefix
        _suffix = suffix
    }

    open func getc() -> Character? { _input.popLast() }
    open func ungetc(_ c: Character) { _input.append(c) }
    
    open func readForm() throws -> Bool {
        for r in _prefix {
            if let f = try r.readForm(self) {
                _forms.append(f)
                try readSuffix()
                return true
            }
        }
  
        return false
    }

    @discardableResult
    open func readSuffix() throws -> Bool {
        for r in _suffix {
            if let f = try r.readForm(self) {
                _forms.append(f)
                try readSuffix()
                return true
            }
        }
  
        return false
    }

    open func popForm() -> Form? { _forms.popLast() }
    
    open func slurp(_ input: String) throws {
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
    
    open func nextColumn() { _pos.nextColumn() }
    open func newLine() { _pos.newLine() }
        
    open func reset() {
        _forms = []
        _pos = Pos(pos.source)
    }
    
    private let _env: Env
    private var _input: String = ""
    private var _pos: Pos
    private var _prefix, _suffix: [Reader]
    private var _forms: [Form] = []
}
