import XCTest
@testable import swifu

final class swifuTests: XCTestCase {
    func testPush() {
        let p = Pos(source: "testPush", line: -1, column: -1)
        let c = Context()
        
        c.initCoreLib(p)
        XCTAssertEqual("Int", c.coreLib!.intType.name)
        
        c.emit(Push(pc: c.pc, pos: p, slot: Slot(c.coreLib!.intType, 42)))
        c.eval(pc: 0)
        let s = c.pop()!
        XCTAssertEqual(c.coreLib!.intType, s.type)
        XCTAssertEqual(42, s.value as! Int)
    }

    static var allTests = [
        ("testPush", testPush),
    ]
}
