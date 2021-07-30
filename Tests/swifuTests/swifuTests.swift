import XCTest
@testable import swifu

final class swifuTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swifu().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
