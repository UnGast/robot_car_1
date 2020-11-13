import XCTest
@testable import remote_client

final class remote_clientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(remote_client().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
