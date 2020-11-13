import XCTest
@testable import remote_server

final class remote_serverTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(remote_server().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
