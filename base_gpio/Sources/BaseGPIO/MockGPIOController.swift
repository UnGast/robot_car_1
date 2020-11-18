public class MockGPIOController: GPIOController {
  public let headers: [GPIOHeader] = [
    GPIOHeader(pinRoles: [
      1: [.voltage(3)],
      2: [.gpio(1)]
    ], layout: .row([
      .pin(1),
      .pin(2)
    ]))
  ]

  public init() {
  }

  public func getPinState(gpioId: UInt) -> GPIOPinState {
    GPIOPinState(id: gpioId, direction: .input, value: .low)
  }

  /*public enum GPIO: String, GPIOPinId {
    case Pin1, Pin2

    public init(_ rawValue: String) {
      self = Self(rawValue: rawValue)!
    }

    public var description: String {
      rawValue  
    }
  }*/
}