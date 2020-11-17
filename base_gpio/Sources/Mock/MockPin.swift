import BaseGPIO

public class MockPin: GPIOPin {
  public let id: UInt
  public var direction: GPIODirection = .Input

  public init(id: UInt) {
    self.id = id
  }
}