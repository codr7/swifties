import XCTest
@testable import Swifties

final class Tests: XCTestCase {
    func testPush() throws {
        let p = Pos(source: "testPush", line: -1, column: -1)
        let env = Env()
        
        try env.initCoreLib(p)
        XCTAssertEqual("Int", env.coreLib!.intType.name)
        
        let v = Slot(env._coreLib!.intType, 42)
        env.emit(Push(pc: env.pc, slot: v))
        env.emit(STOP)
        env.eval(pc: 0)
        XCTAssertEqual(v, env.pop()!)
    }

    func testStaticBinding() throws {
        let p = Pos(source: "testStaticBinding", line: -1, column: -1)
        let env = Env()
        try env.initCoreLib(p)
        let v = Slot(env._coreLib!.intType, 42)
        try env.beginScope().bind(pos: p, id: "foo", slot: v)
        Id(env: env, pos: p, name: "foo").emit()
        env.emit(STOP)
        env.eval(pc: 0)
        XCTAssertEqual(v, env.pop()!)
    }
    
    func testDynamicBinding() throws {
        let p = Pos(source: "testDynamicBinding", line: -1, column: -1)
        let env = Env()
        try env.initCoreLib(p)
        let scope = env.beginScope()
        let v = Slot(env._coreLib!.intType, 42)
        let i = scope.getNextRegister()
        env.emit(Push(pc: env.pc, slot: v))
        env.emit(Store(env: env, pc: env.pc, index: i))
        env.emit(Load(env: env, pc: env.pc, index: i))
        env.emit(STOP)
        XCTAssertEqual(scope, try env.endScope(pos: p))
        env.eval(pc: 0)
        XCTAssertEqual(v, env.pop()!)
    }
    
    static var allTests = [
        ("testPush", testPush),
    ]
}
