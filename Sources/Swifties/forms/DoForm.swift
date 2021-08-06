import Foundation

public class DoForm: Form {
    public init(env: Env, pos: Pos, body: [Form]) {
        _body = body
        super.init(env: env, pos: pos)
    }
    
    public override func expand() throws -> Form {
        let newBody = try _body.map {a in try a.expand()}
        if newBody != _body { return try DoForm(env: env, pos: pos, body: newBody).expand() }
        return self
    }

    public override func emit() throws {
        for f in _body{ try f.emit() }
    }
    
    private let _body: [Form]
}
