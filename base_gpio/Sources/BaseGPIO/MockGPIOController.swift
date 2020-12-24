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

  private var gpioPinStates: [Int: GPIOPinState]

  private var gpioIdHeaderIdMap: [Int: Int]

  public init() {
    self.gpioIdHeaderIdMap = headers.flatMap { $0.pinRoles }.reduce(into: [Int: Int]()) { result, element in
      for role in element.value {
        if case let .gpio(gpioId) = role {
          result[gpioId] = element.key
          break
        }
      }
    }
    self.gpioPinStates = gpioIdHeaderIdMap.keys.reduce(into: [Int: GPIOPinState]()) {
      $0[$1] = GPIOPinState(id: $1, direction: .input, value: .low)
    }
  }

  public func set(gpioId: Int, direction: GPIOPinDirection) throws {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    gpioPinStates[gpioId]!.direction = direction
  }
    
  public func set(gpioId: Int, value: GPIOPinValue) throws {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    if getDirection(gpioId: gpioId) == .output {
      gpioPinStates[gpioId]!.value = value
    } else {
      fatalError("tried to set value for a gpio pin which is not configured as output")
    }
  }

  public func getDirection(gpioId: Int) -> GPIOPinDirection {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    return gpioPinStates[gpioId]!.direction
  }

  public func getValue(gpioId: Int) -> GPIOPinValue {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    return gpioPinStates[gpioId]!.value
  }

  public func getPinState(gpioId: Int) -> GPIOPinState {
    guard let _ = gpioIdHeaderIdMap[gpioId] else {
      fatalError("tried to access non-existent gpio pin")
    }

    return gpioPinStates[gpioId]!
  }

  public func getPinStates() -> [Int: GPIOPinState] {
    gpioPinStates
  }
}