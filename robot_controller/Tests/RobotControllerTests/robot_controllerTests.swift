import XCTest
@testable import robot_controller

final class robot_controllerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(robot_controller().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
