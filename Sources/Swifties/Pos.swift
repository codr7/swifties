import Foundation

public struct Pos: Equatable {
    public static func == (lhs: Pos, rhs: Pos) -> Bool {
        lhs._source == rhs._source && lhs._line == rhs._line && lhs._column == rhs._column
    }
    
    public var source: String { _source }

    public init(_ source: String, line: Int = 0, column: Int = 0) {
        _source = source
        self._line = line
        self._column = column
    }
    
    public mutating func nextColumn() {
        self._column += 1
    }
    
    public mutating func newLine() {
        self._line += 1
        self._column = 0
    }
    
    private let _source: String
    private var _line, _column: Int
}
