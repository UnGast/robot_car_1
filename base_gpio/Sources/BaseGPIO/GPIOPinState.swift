public protocol GPIOPinState {
  var id: GPIOPinId { get }
  var direction: GPIODirection { get }
}