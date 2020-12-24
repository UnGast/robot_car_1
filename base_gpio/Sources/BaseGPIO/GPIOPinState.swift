public protocol GPIOPinStateProtocol {
  var id: Int { get }
  var direction: GPIOPinDirection { get set }
  var value: GPIOPinValue { get set }
}

public struct GPIOPinState: GPIOPinStateProtocol, Codable {
  public var id: Int
  public var direction: GPIOPinDirection
  public var value: GPIOPinValue

  public init(id: Int, direction: GPIOPinDirection, value: GPIOPinValue) {
    self.id = id
    self.direction = direction
    self.value = value
  }
}