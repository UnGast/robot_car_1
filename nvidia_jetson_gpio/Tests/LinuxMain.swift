import XCTest

import nvidia_jetson_gpioTests

var tests = [XCTestCaseEntry]()
tests += nvidia_jetson_gpioTests.allTests()
XCTMain(tests)
