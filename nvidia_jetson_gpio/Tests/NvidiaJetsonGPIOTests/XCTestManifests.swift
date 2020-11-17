import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(nvidia_jetson_gpioTests.allTests),
    ]
}
#endif
