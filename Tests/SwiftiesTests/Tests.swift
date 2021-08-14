import XCTest
@testable import Swifties

final class Tests: XCTestCase {
    func testPush() throws {
        let p = Pos("testPush", line: -1, column: -1)
        let env = Env()
        
        try env.initCoreLib(pos: p)
        XCTAssertEqual("Int", env.coreLib!.intType.name)
        
        let v = Slot(env.coreLib!.intType, 42)
        env.emit(Push(pc: env.pc, v))
        env.emit(STOP)
        try env.eval(0)
        XCTAssertEqual(v, try env.pop(pos: p))
    }

    func testStaticBinding() throws {
        let p = Pos("testStaticBinding", line: -1, column: -1)
        let env = Env()
        try env.initCoreLib(pos: p)
        let v = Slot(env.coreLib!.intType, 42)
        try env.begin().bind(pos: p, id: "foo", v)
        try IdForm(env: env, pos: p, name: "foo").emit()
        env.emit(STOP)
        try env.eval(0)
        XCTAssertEqual(v, try env.pop(pos: p))
    }
    
    func testDynamicBinding() throws {
        let pos = Pos("testDynamicBinding", line: -1, column: -1)
        let env = Env()
        try env.initCoreLib(pos: pos)
        let scope = env.begin()
        let v = Slot(env.coreLib!.intType, 42)
        let i = try scope.nextRegister(pos: pos, id: "foo")
        env.emit(Push(pc: env.pc, v))
        env.emit(Store(env: env, pos: pos, pc: env.pc, index: i))
        env.emit(Load(env: env, pos: pos, pc: env.pc, index: i))
        env.emit(STOP)
        env.end()
        try env.eval(0)
        XCTAssertEqual(v, try env.pop(pos: pos))
    }
    
    func testFunc() throws {
        let p = Pos("testFunc", line: -1, column: -1)
        let env = Env()
        try env.initCoreLib(pos: p)
        env.begin()

        let f = Func(env: env, pos: p, name: "foo", args: [(nil, env.coreLib!.intType)], rets: [env.coreLib!.intType],
                     {(pos: Pos, self: Func, ret: Op) in
                        env.push(env.coreLib!.intType, try env.pop(pos: p).value as! Int + 7)
            try ret.eval()
        })
        
        env.emit(Push(pc: env.pc, env.coreLib!.intType, 35))
        env.emit(Call(env: env, pos: p, pc: env.pc, target: Slot(env.coreLib!.funcType, f), check: true))
        env.emit(STOP)
        try env.eval(0)
        XCTAssertEqual(Slot(env.coreLib!.intType, 42), try env.pop(pos: p))
    }
    
    func testCompileFunc() throws {
        let p = Pos("testCompileFunc", line: -1, column: -1)
        let env = Env()
        try env.initCoreLib(pos: p)
        env.begin()

        let f = Func(env: env, pos: p, name: "foo", args: [("bar", env.coreLib!.intType)], rets: [env.coreLib!.intType])
        try f.compileBody(IdForm(env: env, pos: p, name: "bar"))
        
        env.push(env.coreLib!.intType, 42)
        env.emit(Call(env: env, pos: p, pc: env.pc, target: Slot(env.coreLib!.funcType, f), check: true))
        env.emit(STOP)
        try env.eval(0)
        
        XCTAssertEqual(Slot(env.coreLib!.intType, 42), try env.pop(pos: p))
        XCTAssertEqual(nil, env.tryPeek())
    }
    
    func testIf() throws {
        let pos = Pos("testIf", line: -1, column: -1)
        let env = Env()
        env.begin()
        try env.initCoreLib(pos: pos).bind(pos: pos)

        try CallForm(env: env, pos: pos, target: IdForm(env: env, pos: pos, name: "if"), args: [
            IdForm(env: env, pos: pos, name: "t"),
            LiteralForm(env: env, pos: pos, env.coreLib!.intType, 1),
            LiteralForm(env: env, pos: pos, env.coreLib!.intType, 2)
        ]).emit()
        
        env.emit(STOP)
        env.push(env.coreLib!.intType, 42)
        try env.eval(0)
        XCTAssertEqual(Slot(env.coreLib!.intType, 1), try env.pop(pos: pos))
        XCTAssertEqual(Slot(env.coreLib!.intType, 42), try env.pop(pos: pos))
        XCTAssertEqual(nil, env.tryPeek())
    }
}
