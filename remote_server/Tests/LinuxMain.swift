import XCTest

import remote_serverTests

var tests = [XCTestCaseEntry]()
tests += remote_serverTests.allTests()
XCTMain(tests)
