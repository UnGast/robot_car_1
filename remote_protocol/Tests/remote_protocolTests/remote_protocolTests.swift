import XCTest
@testable import remote_protocol

final class remote_protocolTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(remote_protocol().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
