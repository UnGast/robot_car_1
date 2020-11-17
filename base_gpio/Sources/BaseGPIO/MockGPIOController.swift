public class MockGPIOController: GPIOController {
  public var layout: GPIOPinLayout<GPIOPinId> {
    .column([
      .pin(.Pin1)
    ])
  }

  public init() {}

  public subscript(pinId: GPIOPinId) -> AnyGPIOPinState {
    return AnyGPIOPinState(id: pinId.description, direction: .Input)
  }

  public enum GPIOPinId: String, GPIOPinIdProtocol {
    case Pin1, Pin2

    public init(_ rawValue: String) {
      self = Self(rawValue: rawValue)!
    }

    public var description: String {
      rawValue
    }
  }
}