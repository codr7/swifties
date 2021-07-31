import Foundation

struct Pos {
    let _source: String
    var _line, _column: Int
    
    init(source: String, line: Int, column: Int) {
        _source = source
        self._line = line
        self._column = column
    }
}
