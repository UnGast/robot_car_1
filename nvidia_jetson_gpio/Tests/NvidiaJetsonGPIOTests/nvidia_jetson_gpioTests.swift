import XCTest
@testable import nvidia_jetson_gpio

final class nvidia_jetson_gpioTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(nvidia_jetson_gpio().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
