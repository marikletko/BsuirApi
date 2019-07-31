import XCTest
@testable import BsuirApi

final class BsuirApiTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(BsuirApi().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
