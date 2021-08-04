import Foundation

public struct Pos {
    public init(_ source: String, line: Int = 0, column: Int = 0) {
        _source = source
        self._line = line
        self._column = column
    }
    
    mutating public func next() {
        self._column += 1
    }
    
    mutating public func newline() {
        self._line += 1
        self._column = 0
    }
    
    private let _source: String
    public var _line, _column: Int
}
