public protocol GPIOController {
    var headers: [GPIOHeader] { get }

    subscript(gpio gpioId: UInt) -> GPIOPinState { get set }
}