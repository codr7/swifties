import XCTest
@testable import Swifties

final class Tests: XCTestCase {
    func testPush() throws {
        let p = Pos(source: "testPush", line: -1, column: -1)
        let env = Env()
        
        try env.initCoreLib(p)
        XCTAssertEqual("Int", env.coreLib!.intType.name)
        
        let v = Slot(env.coreLib!.intType, 42)
        env.emit(Push(pc: env.pc, v))
        env.emit(STOP)
        try env.eval(pc: 0)
        XCTAssertEqual(v, env.pop()!)
    }

    func testStaticBinding() throws {
        let p = Pos(source: "testStaticBinding", line: -1, column: -1)
        let env = Env()
        try env.initCoreLib(p)
        let v = Slot(env.coreLib!.intType, 42)
        try env.beginScope().bind(pos: p, id: "foo", v)
        try IdForm(env: env, pos: p, name: "foo").emit()
        env.emit(STOP)
        try env.eval(pc: 0)
        XCTAssertEqual(v, env.pop()!)
    }
    
    func testDynamicBinding() throws {
        let p = Pos(source: "testDynamicBinding", line: -1, column: -1)
        let env = Env()
        try env.initCoreLib(p)
        let scope = env.beginScope()
        let v = Slot(env.coreLib!.intType, 42)
        let i = try scope.nextRegister(pos: p, id: "foo")
        env.emit(Push(pc: env.pc, v))
        env.emit(Store(env: env, pc: env.pc, index: i))
        env.emit(Load(env: env, pc: env.pc, index: i))
        env.emit(STOP)
        XCTAssertEqual(scope, env.endScope())
        try env.eval(pc: 0)
        XCTAssertEqual(v, env.pop()!)
    }
    
    func testSwiftFunc() throws {
        let p = Pos(source: "testSwiftFunc", line: -1, column: -1)
        let env = Env()
        try env.initCoreLib(p)
        env.beginScope()

        let f = Func(env: env, pos: p, name: "foo", args: [env.coreLib!.intType], rets: [env.coreLib!.intType], {(pos: Pos) -> Pc? in
            env.push(env.coreLib!.intType, env.pop()!.value as! Int + 7)
            return nil
        })
        
        env.emit(Push(pc: env.pc, env.coreLib!.intType, 35))
        env.emit(Call(env: env, pos: p, pc: env.pc, target: Slot(env.coreLib!.funcType, f), check: true))
        env.emit(STOP)
        try env.eval(pc: 0)
        XCTAssertEqual(Slot(env.coreLib!.intType, 42), env.pop()!)
    }
    
    static var allTests = [
        ("testPush", testPush),
    ]
}
