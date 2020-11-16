import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(remote_protocolTests.allTests),
    ]
}
#endif
