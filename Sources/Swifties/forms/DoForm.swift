import Foundation

open class DoForm: Form {
    public init(env: Env, pos: Pos, body: Forms) {
        _body = body
        super.init(env: env, pos: pos)
    }
    
    open override func dump() -> String { "(do \(_body.dump()))" }

    open override func expand() throws -> Form {
        let newBody = try _body.map {a in try a.expand()}
        if newBody != _body { return try DoForm(env: env, pos: pos, body: newBody).expand() }
        return self
    }

    open override func emit() throws {
        for f in _body{ try f.emit() }
    }
    
    open override func quote1() throws -> Form {
        for i in 0..<_body.count { _body[i] = try _body[i].quote1() }
        return self
    }

    open override func quote2(depth: Int) throws -> Form {
        for i in 0..<_body.count { _body[i] = try _body[i].quote2(depth: depth) }
        return self
    }

    private var _body: Forms
}
