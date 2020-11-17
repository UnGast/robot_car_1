import BaseGPIO

public class MockController: GPIOController {
  public var layout: GPIOPinLayout {
    .Column([
      .Pin(self[pin: 0])
    ])
  }

  public subscript(pin pin: UInt) -> MockPin {
    if pin <= 10 {
      return MockPin(id: pin)
    } else {
      fatalError("Tried to access non available pin.")
    }
  }
}