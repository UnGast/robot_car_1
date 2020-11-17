public protocol GPIOPinStateProtocol {
  associatedtype Id: GPIOPinIdProtocol
  var id: Id { get }
  var direction: GPIODirection { get }
}