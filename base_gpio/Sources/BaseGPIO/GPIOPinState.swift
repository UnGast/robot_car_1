public protocol GPIOPinStateProtocol {
  var id: GPIOHeaderPinId { get }
  var direction: GPIOPinDirection { get set }
  var value: GPIOPinValue { get set }
}

public struct GPIOPinState: GPIOPinStateProtocol {
  public var id: GPIOHeaderPinId
  public var direction: GPIOPinDirection
  public var value: GPIOPinValue

  public init(id: GPIOHeaderPinId, direction: GPIOPinDirection, value: GPIOPinValue) {
    self.id = id
    self.direction = direction
    self.value = value
  }
}