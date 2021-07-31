import XCTest
@testable import Swifties

final class Tests: XCTestCase {
    func testPush() throws {
        let p = Pos(source: "testPush", line: -1, column: -1)
        let e = Env()
        
        try e.initCoreLib(p)
        XCTAssertEqual("Int", e.coreLib!.intType.name)
        
        e.emit(Push(pc: e.pc, slot: Slot(e.coreLib!.intType, 42)))
        e.emit(STOP)
        e.eval(pc: 0)
        let s = e.pop()!
        XCTAssertEqual(e.coreLib!.intType, s.type)
        XCTAssertEqual(42, s.value as! Int)
    }

    func testStaticBinding() throws {
        let p = Pos(source: "testBinding", line: -1, column: -1)
        let e = Env()
        try e.initCoreLib(p)
        try e.beginScope().bind(pos: p, id: "foo", type: e._coreLib!.intType, value: 42)
        Id(env: e, pos: p, name: "foo").emit()
        e.emit(STOP)
        e.eval(pc: 0)
        let s = e.pop()!
        XCTAssertEqual(e.coreLib!.intType, s.type)
        XCTAssertEqual(42, s.value as! Int)
    }
    
    static var allTests = [
        ("testPush", testPush),
    ]
}
