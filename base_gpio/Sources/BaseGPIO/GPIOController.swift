public protocol GPIOController {
    var headers: [GPIOHeader] { get }

    func getPinState(gpioId: UInt) -> GPIOPinState
}