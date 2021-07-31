import XCTest
@testable import Swifties

final class Tests: XCTestCase {
    func testPush() throws {
        let p = Pos(source: "testPush", line: -1, column: -1)
        let e = Env()
        
        try e.initCoreLib(p)
        XCTAssertEqual("Int", e.coreLib!.intType.name)
        
        let s = Slot(e._coreLib!.intType, 42)
        e.emit(Push(pc: e.pc, slot: s))
        e.emit(STOP)
        e.eval(pc: 0)
        XCTAssertEqual(s, e.pop()!)
    }

    func testStaticBinding() throws {
        let p = Pos(source: "testStaticBinding", line: -1, column: -1)
        let e = Env()
        try e.initCoreLib(p)
        let s = Slot(e._coreLib!.intType, 42)
        try e.beginScope().bind(pos: p, id: "foo", slot: s)
        Id(env: e, pos: p, name: "foo").emit()
        e.emit(STOP)
        e.eval(pc: 0)
        XCTAssertEqual(s, e.pop()!)
    }
    
    static var allTests = [
        ("testPush", testPush),
    ]
}
