public protocol GPIOController {
    var headers: [GPIOHeader] { get }

    func set(gpioId: UInt, direction: GPIOPinDirection) throws 
    
    func set(gpioId: UInt, value: GPIOPinValue) throws

    func getDirection(gpioId: UInt) -> GPIOPinDirection

    func getValue(gpioId: UInt) -> GPIOPinValue

    func getPinState(gpioId: UInt) -> GPIOPinState

    func getPinStates() -> [UInt: GPIOPinState]
}