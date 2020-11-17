public struct AnyGPIOPinState: GPIOPinStateProtocol {
  public typealias Id = String
  public var id: Id
  public var direction: GPIODirection

  public init<T: GPIOPinStateProtocol>(_ wrapped: T) {
    self.id = wrapped.id.description
    self.direction = wrapped.direction
  }

  public init(id: Id, direction: GPIODirection) {
    self.id = id
    self.direction = direction
  }
}