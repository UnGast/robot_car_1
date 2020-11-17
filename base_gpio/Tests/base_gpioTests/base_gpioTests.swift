import XCTest
@testable import base_gpio

final class base_gpioTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(base_gpio().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
