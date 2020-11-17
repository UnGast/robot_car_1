public class MockGPIOController: GPIOController {
  public var layout: GPIOPinLayout {
    .column([
      .pin(PinId.Pin1)
    ])
  }

  public init() {
  }

  public subscript(pinId: PinId) -> GPIOPinState {
    return MockGPIOPinState(id: pinId, direction: .Input)
  }

  public enum PinId: String, GPIOPinId {
    case Pin1, Pin2

    public init(_ rawValue: String) {
      self = Self(rawValue: rawValue)!
    }

    public var description: String {
      rawValue  
    }
  }
}