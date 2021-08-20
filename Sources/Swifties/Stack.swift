import Foundation

public typealias Stack = [Slot]

extension Stack {
    public func dump() -> String {
        var out = "["

        for i in 0..<self.count {
            if i > 0 { out += " " }
            out += self[i].dump()
        }
    
        out += "]"
        return out
    }
}
