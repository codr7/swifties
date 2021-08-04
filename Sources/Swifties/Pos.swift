import Foundation

public struct Pos {
    public init(_ source: String, line: Int = 0, column: Int = 0) {
        _source = source
        self._line = line
        self._column = column
    }
    
    private let _source: String
    private var _line, _column: Int
}
