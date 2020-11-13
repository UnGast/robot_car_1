import XCTest

import remote_clientTests

var tests = [XCTestCaseEntry]()
tests += remote_clientTests.allTests()
XCTMain(tests)
