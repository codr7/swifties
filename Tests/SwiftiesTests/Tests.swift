import XCTest
@testable import Swifties

final class Tests: XCTestCase {
    func testPush() throws {
        let p = Pos("testPush")
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
        let p = Pos("testStaticBinding")
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
        let pos = Pos("testDynamicBinding")
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
        let p = Pos("testFunc")
        let env = Env()
        try env.initCoreLib(pos: p)
        env.begin()

        let f = Func(env: env, pos: p, name: "foo", args: [(nil, env.coreLib!.intType)], rets: [env.coreLib!.intType],
                     {(pos, self, ret) in
                        env.push(env.coreLib!.intType, try env.pop(pos: p).value as! Int + 7)
                        return ret
                     })
        
        env.emit(Push(pc: env.pc, env.coreLib!.intType, 35))
        env.emit(Call(env: env, pos: p, pc: env.pc, target: Slot(env.coreLib!.funcType, f), check: true))
        env.emit(STOP)
        try env.eval(0)
        XCTAssertEqual(Slot(env.coreLib!.intType, 42), try env.pop(pos: p))
    }
    
    func testCompileFunc() throws {
        let p = Pos("testCompileFunc")
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
    
    func testMulti() throws {
        let p = Pos("testMulti")
        let env = Env()
        try env.initCoreLib(pos: p)
        env.begin()

        let f1 = Func(env: env, pos: p, name: "foo", args: [(nil, env.coreLib!.anyType)], rets: [],
                     {(pos, self, ret) in
                        try env.pop(pos: pos)
                        return ret
                     })
        
        let f2 = Func(env: env, pos: p, name: "foo", args: [(nil, env.coreLib!.intType)], rets: [],
                     {(pos, self, ret) in
                        return ret
                     })
        
        let m = Multi(env: env, name: "foo")
        m.addFunc(f1)
        m.addFunc(f2)
        
        env.emit(Push(pc: env.pc, env.coreLib!.intType, 42))
        env.emit(Call(env: env, pos: p, pc: env.pc, target: Slot(env.coreLib!.multiType, m), check: true))
        env.emit(STOP)
        try env.eval(0)
        XCTAssertEqual(Slot(env.coreLib!.intType, 42), try env.pop(pos: p))
    }
    
    func testIf() throws {
        let pos = Pos("testIf")
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
    
    func testMap() throws {
        let pos = Pos("testMap")
        let env = Env()
        env.begin()
        try env.initCoreLib(pos: pos).bind(pos: pos)
        let m = MathLib(env: env, pos: pos)
        try m.bind(pos: pos)
        env.push(env.scope!.find("++")!)
        env.push(env.coreLib!.stackType, [Slot(env.coreLib!.intType, 1), Slot(env.coreLib!.intType, 2), Slot(env.coreLib!.intType, 3)])
        let map = env.scope!.find("map")
        XCTAssertEqual(-1, try map!.type.callValue!(map!.value, pos, -1, true))
        let out = try env.pop(pos: pos)
        let it = out.value as! Iter
        XCTAssertEqual(Slot(env.coreLib!.intType, 2), try it(pos))
        XCTAssertEqual(Slot(env.coreLib!.intType, 3), try it(pos))
        XCTAssertEqual(Slot(env.coreLib!.intType, 4), try it(pos))
    }
}
