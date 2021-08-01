import Foundation

struct Pos {
    init(source: String, line: Int, column: Int) {
        _source = source
        self._line = line
        self._column = column
    }
    
    private let _source: String
    private var _line, _column: Int
}
