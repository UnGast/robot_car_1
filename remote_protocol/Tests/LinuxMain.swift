import XCTest

import remote_protocolTests

var tests = [XCTestCaseEntry]()
tests += remote_protocolTests.allTests()
XCTMain(tests)
