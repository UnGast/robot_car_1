public protocol GPIOController {
    var headers: [GPIOHeader] { get }

    func set(gpioId: Int, direction: GPIOPinDirection) throws 
    
    func set(gpioId: Int, value: GPIOPinValue) throws

    func getDirection(gpioId: Int) -> GPIOPinDirection

    func getValue(gpioId: Int) -> GPIOPinValue

    func getPinState(gpioId: Int) -> GPIOPinState

    func getPinStates() -> [Int: GPIOPinState]
}