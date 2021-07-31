import XCTest
@testable import Swifties

final class Tests: XCTestCase {
    func testPush() throws {
        let p = Pos(source: "testPush", line: -1, column: -1)
        let c = Env()
        
        try c.initCoreLib(p)
        XCTAssertEqual("Int", c.coreLib!.intType.name)
        
        c.emit(Push(pc: c.pc, slot: Slot(c.coreLib!.intType, 42)))
        c.emit(STOP)
        c.eval(pc: 0)
        let s = c.pop()!
        XCTAssertEqual(c.coreLib!.intType, s.type)
        XCTAssertEqual(42, s.value as! Int)
    }

    static var allTests = [
        ("testPush", testPush),
    ]
}
