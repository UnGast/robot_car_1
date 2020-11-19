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

  private var gpioPinStates: [UInt: GPIOPinState]

  private var gpioIdHeaderIdMap: [UInt: UInt]

  public init() {
    self.gpioIdHeaderIdMap = headers.flatMap { $0.pinRoles }.reduce(into: [UInt: UInt]()) { result, element in
      for role in element.value {
        if case let .gpio(gpioId) = role {
          result[gpioId] = element.key
          break
        }
      }
    }
    self.gpioPinStates = gpioIdHeaderIdMap.keys.reduce(into: [UInt: GPIOPinState]()) {
      $0[$1] = GPIOPinState(id: $1, direction: .input, value: .low)
    }
  }

  public func set(gpioId: UInt, direction: GPIOPinDirection) throws {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    gpioPinStates[gpioId]!.direction = direction
  }
    
  public func set(gpioId: UInt, value: GPIOPinValue) throws {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    if getDirection(gpioId: gpioId) == .output {
      gpioPinStates[gpioId]!.value = value
    } else {
      fatalError("tried to set value for a gpio pin which is not configured as output")
    }
  }

  public func getDirection(gpioId: UInt) -> GPIOPinDirection {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    return gpioPinStates[gpioId]!.direction
  }

  public func getValue(gpioId: UInt) -> GPIOPinValue {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    return gpioPinStates[gpioId]!.value
  }

  public func getPinState(gpioId: UInt) -> GPIOPinState {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    return gpioPinStates[gpioId]!
  }

  public func getPinStates() -> [UInt: GPIOPinState] {
    gpioPinStates
  }
}