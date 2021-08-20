import Foundation

public typealias Stack = [Slot]

extension Stack {
    public func dump() -> String {
        var out = "["
        let ss = self.map {s in s.type.dumpValue!(s.value)}

        for i in 0..<ss.count {
            if i > 0 { out += " " }
            out += ss[i]
        }
    
        out += "]"
        return out
    }
}
